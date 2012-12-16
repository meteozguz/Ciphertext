/*
 *
 * Created by Mete Ozguz on 2012-03
 * Copyright Mete Ozguz 2012
 *
 * http://www.meteozguz.com
 * meteo158@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "GameState.h"

static GameState* sharedGameState = nil;

@implementation GameState
{
    NSUInteger   selectedLevel;
    NSDictionary *levels;
    NSDictionary *difficultyDictionary;
    
    ccTime levelXOldElapsedTime;
    NSUInteger levelXOldMoveCount;
    NSUInteger levelXOldExploredTiles;
        
    BOOL isLevelXElapsedTimeImproved;
    BOOL isLevelXMoveCountImproved;
    BOOL isLevelXExploredTilesImproved;
    
    ccColor4B backgroundColor;
}

@synthesize backgroundColor;

+(id)sharedGameState{
    @synchronized(self)
    {
        if (sharedGameState == nil)
            sharedGameState = [[self alloc] init];
        
        return sharedGameState;
    }    
    return nil;
}

- (id)init 
{
    self = [super init];
    if (self) {
        
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Difficulty"] == nil) {
            CCLOG(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Difficulty"]);
            
            // Initializing Game State AND adding to NSUserDefaults 
            [[NSUserDefaults standardUserDefaults] setObject:@"Normal" forKey:@"Difficulty"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:0] forKey:@"LastUnlockedLevel"];
        }
        
        backgroundColor = ccc4(22, 34, 31, 255); // ORIGINAL
       // backgroundColor = ccc4(234, 245, 244, 255); // X-RAY
        
        // Loading Levels, Game Difficulty details
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        NSString *filename = @"Game.plist";
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
        
        NSAssert(plistPath != nil, @"%@ not found!\n", filename);
        
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
        
        NSAssert(temp, @"Error reading plist: %@, format: %d", errorDesc, format);
        
        levels =  [[NSDictionary alloc] initWithDictionary:[temp objectForKey:@"Levels"]];            
        NSAssert(levels != nil, @"levels is nil!");
        
        difficultyDictionary = [[NSDictionary alloc] initWithDictionary:[temp objectForKey:@"DifficultyDictionary"]];
        NSAssert(difficultyDictionary != nil, @"difficultyDictionary is nil!");  
    }
    return self;
}

-(void)updateLevelDataWithTimeElapsed:(float)timeElapsed withMoveCount:(NSUInteger)moveCount andWithOpenedTilesCount:(NSUInteger)openedTilesCount
{
    levelXOldElapsedTime = [self getElapsedTime];
    levelXOldMoveCount = [self getMoveCount];
    levelXOldExploredTiles = [self getExploredTiles];
        
    isLevelXElapsedTimeImproved = NO;
    isLevelXMoveCountImproved = NO;
    isLevelXExploredTilesImproved = NO;
    
    if (timeElapsed < levelXOldElapsedTime) {
        isLevelXElapsedTimeImproved = YES;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:timeElapsed] forKey:[self getElapsedTimeString]];
    }
    
    if (moveCount < levelXOldMoveCount) {
        isLevelXMoveCountImproved = YES;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithUnsignedInteger:moveCount] forKey:[self getMoveCountString]];
    }
    
    if (openedTilesCount > levelXOldExploredTiles) {
        isLevelXExploredTilesImproved = YES;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithUnsignedInteger:openedTilesCount] forKey:[self getExploredTilesString]];
    }
    [self setDifficulty:[self getDifficulty]];
}

-(NSString *)getLevelString
{
    return [NSString stringWithFormat:@"LEVEL%d_", selectedLevel];
}

-(NSString *)getElapsedTimeString
{
    return [[self getLevelString] stringByAppendingString:@"ElapsedTime"];
}

-(NSString *)getMoveCountString
{
    return [[self getLevelString] stringByAppendingString:@"MoveCount"];
}

-(NSString *)getExploredTilesString
{
    return [[self getLevelString] stringByAppendingString:@"OpenedTilesCount"];
}

- (void)dealloc 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [difficultyDictionary release];
    [levels release];
    [super dealloc];
}

-(ccTime)getElapsedTime
{
    id tmp = [[NSUserDefaults standardUserDefaults] objectForKey:[self getElapsedTimeString]];
    if (tmp == nil) {
        return MAXFLOAT;
    }else{
        return [tmp floatValue];
    }
}

-(NSUInteger)getMoveCount
{
    id tmp = [[NSUserDefaults standardUserDefaults] objectForKey:[self getMoveCountString]];
    if (tmp == nil) {
        return UINT32_MAX;
    }else{
        return [tmp unsignedIntegerValue];
    }
}

-(NSUInteger)getExploredTiles
{    
    id tmp = [[NSUserDefaults standardUserDefaults] objectForKey:[self getExploredTilesString]];
    if (tmp == nil) {
        return 0;
    }else{
        return [tmp unsignedIntegerValue];
    }
}

-(NSString *)getElapsedTimeStringForDisplaying
{
    return [NSString stringWithFormat:@"%.1f", [self getElapsedTime]];
}

-(NSString *)getMoveCountStringForDisplaying
{
    return [NSString stringWithFormat:@"%d", [self getMoveCount]];   
}

-(NSString *)getExploredTilesStringForDisplaying
{
    return [NSString stringWithFormat:@"%d", [self getExploredTiles]];
}

-(NSUInteger)getCurrentLevelID
{
    return selectedLevel;
}

-(ccTime)getTileFadeOutDuration
{
    return [[[difficultyDictionary objectForKey:[self getDifficulty]] objectForKey:@"MINE_COUNT_FADE_OUT_DURATION"] integerValue];
}

-(NSString *)getDifficulty
{
    return ([[NSUserDefaults standardUserDefaults] stringForKey:@"Difficulty"] != nil) ? [[NSUserDefaults standardUserDefaults] stringForKey:@"Difficulty"] : @"Normal";
}

-(void)setDifficulty:(NSString *)difficulty
{
    CCLOG(@"%@", difficulty);
    [[NSUserDefaults standardUserDefaults] setObject:difficulty forKey:@"Difficulty"];
}

-(void)setCurrentLevelID:(NSUInteger)slvl
{
    selectedLevel = slvl;
}

-(NSDictionary *)getLevels
{
    return levels;
}

-(void)setLastUnlockedLevel:(NSUInteger)lastUnlockedLevel
{
   // [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:39] forKey:@"LastUnlockedLevel"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:lastUnlockedLevel] forKey:@"LastUnlockedLevel"];
}

-(NSUInteger)getLastUnlockedLevel
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"LastUnlockedLevel"] unsignedIntegerValue];
}

-(void)updateLastUnlockedLevel
{
    if (selectedLevel + 1 > [self getLastUnlockedLevel]) {
        [self setLastUnlockedLevel:selectedLevel + 1];
    } 
}

-(BOOL)isLevelXElapsedTimeImproved
{
    return isLevelXElapsedTimeImproved;
}

-(BOOL)isLevelXMoveCountImproved
{
    return isLevelXMoveCountImproved;
}

-(BOOL)isLevelXExploredTilesImproved
{
    return isLevelXExploredTilesImproved; 
}
@end

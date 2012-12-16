/*
 *
 * Created by Mete Ozguz on 2012-04
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

#import "Level.h"
#import "GameState.h"

static Level* sharedLevel = nil;

@implementation Level{
    NSDictionary *levelDictionary;
}

+(id)sharedLevel{
    @synchronized(self)
    {
        if (sharedLevel == nil)
            sharedLevel = [[self alloc] init];
        
        return sharedLevel;
    }    
    return nil;
}

-(id)init
{
    CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    self = [super init];
    if (self) {
        
        NSUInteger levelID = [[GameState sharedGameState] getCurrentLevelID];
        
        levelDictionary = [[[[GameState sharedGameState] getLevels] objectForKey:[NSString stringWithFormat:@"%d", levelID]] retain];
        
        return self;
    }
    return nil;
}

-(CGSize)getSizeInTiles
{
    CGSize sizeInTiles;
    switch ([self getMap].length) {
        case 24:
            sizeInTiles = CGSizeMake(6, 4);
            break;
        case 40:
            sizeInTiles = CGSizeMake(8, 5);
            break;
        default:
            [NSException exceptionWithName:@"Dimension Exception" reason:@"Wrong Number of dimension for game tiles!" userInfo:nil];
            break;
    }
    return sizeInTiles;
}

-(NSUInteger)getNumberOfTiles
{
    CGSize sizeInTiles = [self getSizeInTiles];
    
    NSAssert(sizeInTiles.width * sizeInTiles.height == [self getMap].length, @"Map length and numberOfTiles aren't equal!");
    
    return sizeInTiles.width * sizeInTiles.height;
}

-(NSUInteger)getFinishIndex
{
    NSRange rng = [[self getMap] rangeOfString:@"2"];
    return rng.location;
}

-(NSUInteger)getStartIndex
{    
    NSRange rng = [[self getMap] rangeOfString:@"3"];
    return (rng.location == NSNotFound) ? 0 : rng.location;
}

-(NSUInteger)getID
{
    return [[GameState sharedGameState] getCurrentLevelID];
}

-(NSString *)getMap
{
    return (NSString *)[levelDictionary objectForKey:@"Map"];
}

-(NSString *)getAbilities
{
    return (NSString *)[levelDictionary objectForKey:@"Abilities"];
}

-(NSString *)getMeditation
{
    return (NSString *)[levelDictionary objectForKey:@"MeditationString"];
}

-(NSString *)getTitle
{
    return (NSString *)[levelDictionary objectForKey:@"Title"];
}

-(BOOL)hasAbility
{
    return ([self getAbilities] != nil) ? YES : NO;
}

-(void) reset
{
  	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    @synchronized(self)
    {
        if (sharedLevel != nil)
            sharedLevel = nil;
    }   
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [levelDictionary release];
    sharedLevel = nil;
	[super dealloc];
}
@end

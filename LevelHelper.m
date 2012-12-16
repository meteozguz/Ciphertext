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

#import "LevelHelper.h"
#import "Level.h"
#import "GameController.h"
#import "GameState.h"

@implementation LevelHelper
{
}

+ (id)levelHelper
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *)getNumberOfMinesAroundTileAtIndex:(NSUInteger)index withSelector:(SEL)sel
{
    switch ([[[Level sharedLevel] getMap] characterAtIndex:index]) {
        case 'x':
            return @"x";
        case '2':
            return @"blackCursor";
        case 'a':
        case 'c':
            return @"a";
        case 'e':
        case 'g':
            return @"b";
        case 'i':
        case 'k':
            return @"c";
        case 'm':
        case 'o':
            return @"d";
        default:
        {
            NSNumber *result = (NSNumber *)[self performSelector:sel withObject:[NSNumber numberWithUnsignedInteger:index]];
            return [NSString stringWithFormat:@"%d",[result unsignedIntegerValue]];
        }
    }
}

-(NSNumber *)getMineCountFor4NeighbourAtIndex:(NSNumber *)indx
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    NSUInteger index = [indx unsignedIntegerValue];
    NSUInteger mineCount = 0;
    
    NSInteger widthInIndex = (NSInteger)[[Level sharedLevel] getSizeInTiles].width;
    NSInteger heightInIndex = (NSInteger)[[Level sharedLevel] getSizeInTiles].height;
    
    NSString *map = [[Level sharedLevel] getMap];
    
    NSInteger indexX = index % widthInIndex;
    NSInteger indexY = index / widthInIndex;
    
    // CHECKING UP
    if (indexY + 1 < heightInIndex) {
        NSRange range = NSMakeRange(index + widthInIndex, 1);
        char mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING DOWN
    if (indexY - 1 >= 0) {
        NSRange range = NSMakeRange(index - widthInIndex, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING LEFT
    if (indexX - 1 >= 0) {
        NSRange range = NSMakeRange(index - 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING RIGHT
    if (indexX + 1 < widthInIndex) {
        NSRange range = NSMakeRange(index + 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    return [NSNumber numberWithUnsignedInteger:mineCount];
}

-(NSNumber *)getMineCountFor8NeighbourAtIndex:(NSNumber *)indx
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    NSUInteger index = [indx unsignedIntegerValue];
    NSNumber *mineCnt = [self getMineCountFor4NeighbourAtIndex:indx];
    NSUInteger mineCount = [mineCnt unsignedIntegerValue];
    
    NSInteger widthInIndex = (NSInteger)[[Level sharedLevel] getSizeInTiles].width;
    NSInteger heightInIndex = (NSInteger)[[Level sharedLevel] getSizeInTiles].height;
    
    NSString *map = [[Level sharedLevel] getMap];
    
    NSInteger indexX = index % widthInIndex;
    NSInteger indexY = index / widthInIndex;
    
    // CHECKING UPPER LEFT
    if (indexX - 1 >= 0 && indexY + 1 < heightInIndex) {
        NSRange range = NSMakeRange(index + widthInIndex - 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING UPPER RIGHT
    if (indexX + 1 < widthInIndex && indexY + 1 < heightInIndex) {
        NSRange range = NSMakeRange(index + widthInIndex + 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING BOTTOM LEFT
    if (indexX - 1 >= 0 && indexY - 1 >= 0) {
        NSRange range = NSMakeRange(index - widthInIndex - 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    
    // CHECKING BOTTOM RIGHT
    if (indexX + 1 < widthInIndex && indexY - 1 >= 0) {
        NSRange range = NSMakeRange(index - widthInIndex + 1, 1);
        NSInteger mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
        if (mapValueAtIndex == 'x') {
            mineCount++;
        }
    }
    return [NSNumber numberWithUnsignedInteger:mineCount];
}

-(NSString *)getNumberOfMinesAsSpriteFileName:(NSString *)name
{
    return [name stringByAppendingString:@".png"];
}

-(CGFloat)getTileWidthInCCP
{
    switch ([[Level sharedLevel] getNumberOfTiles]) {
        case 24:
            return [[CCDirector sharedDirector] winSize].width / 6;
            break;
        case 40:
            return [[CCDirector sharedDirector] winSize].width / 8;
            break;
        default:
            [NSException exceptionWithName:@"Number Of Tiles Exception" reason:@"Wrong Number of Tiles for the game!" userInfo:nil];
            break;
    }
    exit(1);
}

-(CGFloat)getTileHeightInCCP
{
    switch ([[Level sharedLevel] getNumberOfTiles]) {
        case 24:
            return [[CCDirector sharedDirector] winSize].height / 4;
        case 40:
            return [[CCDirector sharedDirector] winSize].height / 5;
        default:
            [NSException exceptionWithName:@"Number Of Tiles Exception" reason:@"Wrong Number of Tiles for the game!" userInfo:nil];
            break;
    }   
    exit(1);
}

-(NSUInteger)convertCCPtoIndex:(CGPoint)location
{
    //CCLOG(@"location.x %f   [self getTileWidthInCCP] %f", location.x, [self getTileWidthInCCP]);
    NSUInteger x = (NSUInteger)(location.x / [self getTileWidthInCCP]);
    NSUInteger y = (NSUInteger)(location.y  / [self getTileHeightInCCP]);
    return y * (NSInteger)[[Level sharedLevel] getSizeInTiles].width + x;
}

-(NSUInteger)getMineCountForMeditationAtIndex:(NSUInteger)index
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    NSInteger mineCount = 0;
    
    NSString *meditationString = [[Level sharedLevel] getMeditation];
    NSString *map = [[Level sharedLevel] getMap];
    
    NSInteger widthInIndex = (int)[[Level sharedLevel] getSizeInTiles].width;
    NSInteger heightInIndex = (int)[[Level sharedLevel] getSizeInTiles].height;
    
    NSInteger indexX = index % widthInIndex;
    NSInteger indexY = index / widthInIndex;
    
    NSInteger playerAssumedPosX = 1;
    NSInteger playerAssumedPosY = 1;
    
    NSInteger iX, iY, diffX, diffY, realPosX, realPosY, indexIsAboutToChecked;
    NSRange range;
    NSInteger mapValueAtIndex;
    
    for (int i = 0; i < meditationString.length; i++) {
        switch ([meditationString characterAtIndex:i]) {
            case '1':
            {                
                iX = i % 3; // 3 is width of meditation cube
                iY = i / 3;
                
                diffX = iX - playerAssumedPosX ;
                diffY = iY - playerAssumedPosY;
                
                realPosX = indexX + diffX;
                realPosY = indexY + diffY;
                
                if (realPosX >= 0 && realPosX < widthInIndex && realPosY >= 0 && realPosY < heightInIndex) {
                    indexIsAboutToChecked = realPosY * widthInIndex + realPosX;
                    range = NSMakeRange(indexIsAboutToChecked, 1);
                    mapValueAtIndex = [[map substringWithRange:range] characterAtIndex:0];
                    if (mapValueAtIndex == 'x') {
                        mineCount++;
                    }
                }
                break;  
            }
            default:
                break;
        }
    }
    return mineCount;
}

-(NSArray *)createMinePngArrayAtIndex:(NSUInteger)index
{
    if ([[Level sharedLevel] getID] == 33) {
        NSString *minePng = [self getNumberOfMinesAsSpriteFileName:[self getNumberOfMinesAroundTileAtIndex:index withSelector:@selector(getMineCountFor8NeighbourAtIndex:)]];
        
        NSString *minePng2 = [self getNumberOfMinesAsSpriteFileName:[self getNumberOfMinesAroundTileAtIndex:index withSelector:@selector(getMineCountFor4NeighbourAtIndex:)]];
        return[NSArray arrayWithObjects:minePng, minePng2, nil];
        
    }else if([[Level sharedLevel] getID] > 33) {
        
        NSString *minePng = [self getNumberOfMinesAsSpriteFileName:[self getNumberOfMinesAroundTileAtIndex:index withSelector:@selector(getMineCountFor8NeighbourAtIndex:)]];
        return [NSArray arrayWithObject:minePng];
        
    }else {
        
        NSString *minePng = [self getNumberOfMinesAsSpriteFileName:[self getNumberOfMinesAroundTileAtIndex:index withSelector:@selector(getMineCountFor4NeighbourAtIndex:)]];
        return [NSArray arrayWithObject:minePng];
    }
}
@end

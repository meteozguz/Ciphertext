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

#import "Tile.h"
#import "Tags.h"
#import "Level.h"
#import "LevelScene.h"
#import "Player.h"
#import "GameState.h"

@interface Tile(){
    BOOL isVisitedByPlayer;
    BOOL isDiscoveredByPlayer;
    char tileType;
    CGRect rect;
    BOOL meditationUsed;
    NSString *startingSpriteFrameName;
    NSArray *spriteArray;
}

@end

@implementation Tile

+(id) tileWithSpriteFrameNameArray:(NSArray *)spriteFrameNameArray andType:(char)type
{
	return [[[self alloc] initWithSpriteFrameNameArray:spriteFrameNameArray andType:type] autorelease];
}

-(id) initWithSpriteFrameNameArray:(NSArray *)spriteFrameNameArray andType:(char)type
{
    self = [super initWithSpriteFrameName:[spriteFrameNameArray objectAtIndex:0]];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        startingSpriteFrameName = [[NSString stringWithString:[spriteFrameNameArray objectAtIndex:0]] copy];
        spriteArray = [spriteFrameNameArray copy];
        isVisitedByPlayer = NO;
        isDiscoveredByPlayer = NO;
        tileType = type;
        [self scheduleUpdate];
    }
    return self;
}

-(CGRect) getBoundingBox
{
    return rect;
}

- (BOOL)isDiscoveredByPlayer
{
    return isDiscoveredByPlayer;
}

-(void) setBoundingBox:(CGRect)rct
{
    rect = rct;
}

-(CGSize)getSize
{
    return CGSizeMake([self getBoundingBox].size.width, [self getBoundingBox].size.height);
}

- (void)update:(ccTime)delta
{
    //  CCLOG(@"%f %f %f %f",self.position.x,self.position.y,[[self parent] getChildByTag:TAG_PLAYER].position.x, [[self parent] getChildByTag:TAG_PLAYER].position.y);    
     if ([[Level sharedLevel] getID] == 33) {
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[spriteArray objectAtIndex:[(Player *)[[self parent] getChildByTag:TAG_PLAYER] getBlinkCount]%2]]];
     }
    if (CGPointEqualToPoint(self.position, [[self parent] getChildByTag:TAG_PLAYER].position)) {
        // Player is on ME!
        switch ([self getType]) {
            case 'x':
                // PLAYER DIED!
                // 5 refers to Level named 'IMAGINE'
                // Imagine there is no mines!
                if ([[Level sharedLevel] getID] != 5) { //Ugly isn't it? well.....
                    [(Player *)[[self parent] getChildByTag:TAG_PLAYER] dies];
                    self.opacity = 255;
                    [self runAction:[CCFadeIn actionWithDuration:0.5]];
                    [self unscheduleUpdate];
                    LevelScene *tmp = (LevelScene *)[self parent];
                    [tmp updateUIforOpenedMenu];
                }else {
                    self.opacity = 255;
                }
                break;
            case '2':
                // PLAYER WINS!
                [(Player *)[[self parent] getChildByTag:TAG_PLAYER] wins];
                [self unscheduleUpdate];
                break;
                /* 
                 *  PORTAL LAYOUT
                 *
                 *  A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P
                 *  |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
                 *  |___|___|   |   |___|___|   |   |___|___|   |   |___|___|   |
                 *  |   |       |   |   |       |   |   |       |   |   |       |
                 *  A entrance  |   B entrance  |   C entrance  |   D entrance  |
                 *      |_______|       |_______|       |_______|       |_______|
                 *      |               |               |               |
                 *      A exit          B exit          C exit          D exit
                 */
            case 'a':
            case 'c':
            case 'e':
            case 'g':
            case 'i':
            case 'k':
            case 'm':
            case 'o':
                self.opacity = 255;
                [self startJumping];
                [self unscheduleUpdate];
                [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:[(Player *)[[self parent] getChildByTag:TAG_PLAYER] getPlayerMoveDuration]*2],[CCCallBlock actionWithBlock:^(void){[self scheduleUpdate];}],nil]];
                break;
            default:
                // PLAYER IS ALIVE!
                self.opacity = 255;
                break;
        }
        isVisitedByPlayer = YES;
    }else {
        //Player isn't on ME!
        if (isVisitedByPlayer) {
            isVisitedByPlayer = NO;
            
            if (meditationUsed) {
                // Player is leaving and we have to convert to the old value
                meditationUsed = NO;
                [self stopAllActions];
                CCLOG(@"%@",startingSpriteFrameName);
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:startingSpriteFrameName]];
            }
            switch ([self getType]) {
                case 'a':
                case 'c':
                case 'e':
                case 'g':
                case 'i':
                case 'k':
                case 'm':
                case 'o':
                    self.opacity = 255;
                    break;
                default:
                    [self runAction:[CCFadeOut actionWithDuration:[[GameState sharedGameState] getTileFadeOutDuration]]];
                    break;
            }
        }
    }
    if (self.opacity == 255) {
        isDiscoveredByPlayer = YES;
    }
}

-(void)startJumping
{
    NSString *otherEntrance = @"";
    LevelScene *prnt = (LevelScene *)self.parent;
    switch ([self getType]) {
            /* 
             *  PORTAL LAYOUT
             *
             *  A   B   C   D   E   F   G   H   I   J   K   L   M   N   O   P
             *  |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
             *  |___|___|   |   |___|___|   |   |___|___|   |   |___|___|   |
             *  |   |       |   |   |       |   |   |       |   |   |       |
             *  A entrance  |   B entrance  |   C entrance  |   D entrance  |
             *      |_______|       |_______|       |_______|       |_______|
             *      |               |               |               |
             *      A exit          B exit          C exit          D exit
             */
        case 'a':
            otherEntrance = @"c";
            break;
        case 'c':
            otherEntrance = @"a";
            break;
        case 'e':
            otherEntrance = @"g";
            break;
        case 'g':
            otherEntrance = @"e";
            break;
        case 'i':
            otherEntrance = @"k";
            break;
        case 'k':
            otherEntrance = @"i";
            break;
        case 'm':
            otherEntrance = @"o";
            break;
        case 'o':
            otherEntrance = @"m";
            break;
        default:
            break;
    }
    
    NSDictionary *portals = [prnt getPortals];
    Tile *tmp =  [portals objectForKey:otherEntrance];
    tmp.opacity = 255;
    
    [tmp unscheduleUpdate];
    [tmp runAction:[CCSequence actions:[CCDelayTime actionWithDuration:[(Player *)[[self parent] getChildByTag:TAG_PLAYER] getPlayerMoveDuration]*2],[CCCallBlock actionWithBlock:^(void){[tmp scheduleUpdate];}],nil]];
    
    [(Player *)[[self parent] getChildByTag:TAG_PLAYER] jumpsToCCP:tmp.position];
    
    NSString *portalExit = [NSString stringWithFormat:@"%c", [self getType]+1];
    tmp = [[prnt getPortals] objectForKey:portalExit];
    [(Player *)[[self parent] getChildByTag:TAG_PLAYER] movesToCCP:tmp.position];
}

-(char)getType
{
    return tileType;
}

-(void)useMeditationWithSpriteFrameName:(NSString *)spriteFrameName
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]];
    meditationUsed = YES;
}

- (void)dealloc
{
    [spriteArray release];
    [startingSpriteFrameName release];
    [super dealloc];
}
@end

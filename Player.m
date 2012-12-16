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

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Tags.h"
#import "LevelScene.h"
#import "LevelHelper.h"

@class GameController;

@interface Player()
{
    ccTime BLINK_TIME;
    BOOL moved;
    BOOL jumped;
    BOOL died;
    BOOL won;
    BOOL crossPassIsAvailable; 
    BOOL crossIsUsed;
    BOOL isMoving;
    CGSize playerSizeAsTile;
    NSUInteger numberOfMoves;
    NSUInteger blinkCount;
}

@property (readwrite, assign) NSUInteger numberOfMoves;
@property (readwrite, assign) ccTime BLINK_TIME;

-(void)blink:(ccTime)delta;
-(void)playerAnimationCompleted;
-(void)playerAnimationStarted;
@end

const ccTime PLAYER_CCMoveTo_actionWithDuration = 0.3;

@implementation Player

@synthesize numberOfMoves, BLINK_TIME;

+(id) playerWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease]; 
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super initWithSpriteFrameName:@"cursor.png"];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        self.BLINK_TIME = 1.0;
        self.numberOfMoves = 0;
        blinkCount = 0;
        
        moved = NO;
        jumped = NO;
        died = NO;
        won = NO;
        crossPassIsAvailable = NO; 
        crossIsUsed = NO;
        isMoving = NO;
        
        [parentNode addChild:self z:Z_ORDER_PLAYER tag:TAG_PLAYER];
        
        self.opacity = 0;
        [self schedule:@selector(blink:) interval:self.BLINK_TIME];
    }
    return self;
}

-(void) blink:(ccTime)delta
{
   self.opacity = 255 - self.opacity;
    if (self.opacity == 0) {
        blinkCount++;
    }
}

-(void)scheduleBlink
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [self schedule:@selector(blink:) interval:self.BLINK_TIME];
}

-(void)makeInvisible
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self.opacity = 0;
}

-(void)dies
{ 
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    self.BLINK_TIME = 0.5;
    self.opacity = 255;
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"x.png"]];
    
    died = YES;
}

-(void)jumpsToCCP:(CGPoint)pos
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    self.opacity = 0;
    
    self.position = pos;
    jumped = YES;
}

-(void)playerWon
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    LevelScene *tmp = (LevelScene *)self.parent;
    [tmp playerWon];
}

-(void)playerAnimationCompleted
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCLayer *tmp = (CCLayer *)self.parent;
    tmp.isTouchEnabled = YES;
}

-(void)playerAnimationStarted
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCLayer *tmp = (CCLayer *)self.parent;
    tmp.isTouchEnabled = NO;
}

- (void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

- (BOOL)moved
{
    BOOL tmpValue = moved;
    moved = NO;
    
    return tmpValue;
}

- (BOOL)died
{    
    return died;
}

- (BOOL)won
{    
    return won;
}

- (BOOL)jumped
{
    BOOL tmpValue = jumped;
    jumped = NO;
    
    return tmpValue;
}

-(void)wins
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [self unscheduleAllSelectors];
    self.opacity = 255;
    
    won = YES;
}

-(void)iMoved
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    isMoving = NO;
    moved = YES;
}

-(void)movesToCCP:(CGPoint)pos
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    crossPassIsAvailable = NO;
    isMoving = YES;
    
    [self unscheduleAllSelectors];
    self.opacity = 255;
    
    self.numberOfMoves++;
    
    id act1 = [CCMoveTo actionWithDuration:PLAYER_CCMoveTo_actionWithDuration  position:pos];
    id callFn0 = [CCCallFunc actionWithTarget:self selector:@selector(makeInvisible)]; 
    id callFn1 = [CCCallFunc actionWithTarget:self selector:@selector(scheduleBlink)];
    id callFn2 = [CCCallFunc actionWithTarget:self selector:@selector(iMoved)];
    
    // levelScene's touches must disabled for the name of animation's sequence sake!
    // If you want to observe what is happening, comment out the following two lines
    // and when you start to move your cursor touch immediatly next 4 neighbour
    id callFn3 = [CCCallFunc actionWithTarget:self selector:@selector(playerAnimationCompleted)];
    
    [self playerAnimationStarted]; 
    
    [self runAction:[CCSequence actions:act1, callFn0, callFn1, callFn2, callFn3, nil]];
    //[CCSequence action
}

-(CGRect)CGRectAsATile
{
    return CGRectMake([self position].x-playerSizeAsTile.width/2, [self position].y-playerSizeAsTile.height/2, playerSizeAsTile.width, playerSizeAsTile.height);   
}

-(BOOL)tryToMoveToCCP:(CGPoint)location
{
    CGRect tileRect = [self CGRectAsATile];

    CCLOG(@"Player rectAsATile: %f %f %f %f", tileRect.origin.x, tileRect.origin.y, tileRect.size.width, tileRect.size.height);
    
    //UP
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, playerSizeAsTile.height);
    if (CGRectContainsPoint(CGRectApplyAffineTransform(tileRect, translation), location)) {
        [self movesToCCP:CGPointMake([self position].x, [self position].y+playerSizeAsTile.height)];
        return YES;
    }
    
    //DOWN
    translation = CGAffineTransformMakeTranslation(0, -playerSizeAsTile.height);
    if (CGRectContainsPoint(CGRectApplyAffineTransform(tileRect, translation), location)) {
        [self movesToCCP:CGPointMake([self position].x, [self position].y-playerSizeAsTile.height)];
        return YES;
    }    
    
    //LEFT
    translation = CGAffineTransformMakeTranslation(-playerSizeAsTile.width, 0);
    if (CGRectContainsPoint(CGRectApplyAffineTransform(tileRect, translation), location)) {
        [self movesToCCP:CGPointMake([self position].x - playerSizeAsTile.width, [self position].y)];
        return YES;
    }    
    
    //RIGHT
    translation = CGAffineTransformMakeTranslation(playerSizeAsTile.width, 0);
    if (CGRectContainsPoint(CGRectApplyAffineTransform(tileRect, translation), location)) {
        [self movesToCCP:CGPointMake([self position].x + playerSizeAsTile.width, [self position].y)];
        return YES;
    }    
    
    [self checkForCrossPass:location];

    return NO;
}

-(BOOL)checkForCrossPass:(CGPoint)location
{
    if (crossPassIsAvailable) {
        crossPassIsAvailable = NO;
        CGRect rectAsATile = [self CGRectAsATile];
        
        //UPPER LEFT
        CGAffineTransform translation = CGAffineTransformMakeTranslation(-playerSizeAsTile.width, playerSizeAsTile.height);
        if (CGRectContainsPoint(CGRectApplyAffineTransform(rectAsATile, translation), location)) {
            [self movesToCCP:CGPointMake([self position].x-playerSizeAsTile.width, [self position].y+playerSizeAsTile.height)];
            crossIsUsed = YES;
            return YES;
        }
        
        //UPPER RIGHT
        translation = CGAffineTransformMakeTranslation(playerSizeAsTile.width, playerSizeAsTile.height);
        if (CGRectContainsPoint(CGRectApplyAffineTransform(rectAsATile, translation), location)) {
            [self movesToCCP:CGPointMake([self position].x+playerSizeAsTile.width, [self position].y+playerSizeAsTile.height)];
            crossIsUsed = YES;
            return YES;
        }
        
        //LOWER LEFT
        translation = CGAffineTransformMakeTranslation(-playerSizeAsTile.width, -playerSizeAsTile.height);
        if (CGRectContainsPoint(CGRectApplyAffineTransform(rectAsATile, translation), location)) {
            [self movesToCCP:CGPointMake([self position].x-playerSizeAsTile.width, [self position].y-playerSizeAsTile.height)];
            crossIsUsed = YES;
            return YES;
        }
        
        //LOWER RIGHT
        translation = CGAffineTransformMakeTranslation(playerSizeAsTile.width, -playerSizeAsTile.height);
        if (CGRectContainsPoint(CGRectApplyAffineTransform(rectAsATile, translation), location)) {
            [self movesToCCP:CGPointMake([self position].x+playerSizeAsTile.width, [self position].y-playerSizeAsTile.height)];
            crossIsUsed = YES;
            return YES;
        }
        
    }
    return NO;
}

-(void)setTileSize:(CGSize)size
{
    playerSizeAsTile = size;
}

-(ccTime)getPlayerMoveDuration
{
    return PLAYER_CCMoveTo_actionWithDuration;
}

-(void)tryToUseCrossPass
{
    crossPassIsAvailable = YES;
}

-(BOOL)usedCrossPass
{
    BOOL tmp = crossIsUsed;
    crossIsUsed = NO;
    return tmp;
}

-(BOOL)isMoving
{
    return isMoving;
}

-(NSUInteger)getBlinkCount
{
    return blinkCount;
}

@end
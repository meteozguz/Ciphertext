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

#import "Lvl0.h"
#import "Tags.h"
#import "GameController.h"
#import "LevelScene.h"
#import "Tile.h"
#import "Player.h"

@interface Lvl0()
{
    BOOL isAlreadyOpened;
    LevelScene *parent;
}
@end

@implementation Lvl0

+(id) Lvl0WithParentNode:(CCNode*)parentNode
{
    CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    return [[[self alloc] initWithParentNode:parentNode] autorelease]; 
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        parent = (LevelScene *)parentNode;
        
        [self addTapToMoves];
        
        [self schedule:@selector(firstStep:)];
        
        [parentNode addChild:self z:Z_ORDER_HELPER_TEXT];
    }
    return self;
}

-(void)firstStep:(ccTime)delta
{
    Tile *tile = (Tile *)[[parent getTiles] objectAtIndex:0];
    
    if (!CGPointEqualToPoint([parent getPlayer].position,tile.position)) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self fadeOutAndRemoveActiveNodes];
        
        CCLabelBMFont *tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"YOU CAN MOVE\nHORIZONTALLY AND\nVERTICALLY\n1 BY 1", nil) fntFile:[GameController sharedGameController].fontFile];
        tmp.position = ccp(winSize.width/2,winSize.height/1.5);
        tmp.scale = 0.5;      
        [self addChild:tmp z:0];
        [activeNodes addObject:tmp];
        
        [self unschedule:@selector(firstStep:)];
        [self schedule:@selector(secondStep:)];
    }
}

-(void)secondStep:(ccTime)delta
{
    if (![[parent getPlayer] isMoving]) {
        Tile *tile = (Tile *)[[parent getTiles] objectAtIndex:1];
        Tile *tile1 = (Tile *)[[parent getTiles] objectAtIndex:6];
        
        if (!CGPointEqualToPoint([parent getPlayer].position,tile.position) &&
            !CGPointEqualToPoint([parent getPlayer].position,tile1.position)) {
            
            [self fadeOutAndRemoveActiveNodes];
            
            Tile *tmpTile = (Tile *)[[parent getTiles] objectAtIndex:[parent getPlayerPositionAsIndex]];
            CGRect tile = [tmpTile getBoundingBox];
            
            CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
            arrow.position = ccp(tile.origin.x + tile.size.width, tile.origin.y + tile.size.height);
            [self addChild:arrow z:0];
            [activeNodes addObject:arrow];
            
            CCLabelBMFont *tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"TAP ON IT\nTO OPEN MENU", nil) fntFile:[GameController sharedGameController].fontFile];
            tmp.scale = 0.5;   
            tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
            
            [self addChild:tmp z:0]; 
            [activeNodes addObject:tmp];
            
            [self unschedule:@selector(secondStep:)];
            [self schedule:@selector(thirdStep:)];
        }
        
    }
}

-(void)thirdStep:(ccTime)delta
{  
    if ([[parent getPlayer] numberOfMoves] == 3) {
        
        [self fadeOutAndRemoveActiveNodes];
        
        
        Tile *tmpTile = (Tile *)[[parent getTiles] objectAtIndex:23];
        CGRect tile = [tmpTile getBoundingBox];
        
        CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        arrow.position = ccp(tile.origin.x, tile.origin.y);
        arrow.rotation = 180;
        [self addChild:arrow z:0];
        [activeNodes addObject:arrow];
        
        CCLabelBMFont *tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"GO HERE TO COMPLETE", nil) fntFile:[GameController sharedGameController].fontFile];
        tmp.scale = 0.5;   
        tmp.position = ccp(arrow.boundingBox.origin.x - tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y - arrow.boundingBox.size.height/2);
        [self addChild:tmp z:0];
        [activeNodes addObject:tmp];
        
        [self unschedule:@selector(thirdStep:)];
        [self schedule:@selector(fourthStep:)];
    }
}

-(void)fourthStep:(ccTime)delta
{
    if (![[parent getPlayer] isMoving]) {
        if ([[parent getPlayer] numberOfMoves] == 4) {
            
            [self fadeOutAndRemoveActiveNodes]; 
            
            [self unschedule:@selector(fourthStep:)];
            [self scheduleUpdate];
        }
    }
}

-(void)addTapToMoves
{
    GameController *gc = [GameController sharedGameController];
    
    Tile *tmpTile = (Tile *)[[parent getTiles] objectAtIndex:1];
    CGRect tile = [tmpTile getBoundingBox];
    
    CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
    arrow.position = ccp(tile.origin.x + tile.size.width/2,tile.origin.y + tile.size.height/2);
    [self addChild:arrow z:0];
    [activeNodes addObject:arrow];
    
    CCLabelBMFont* tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"TAP TO MOVE", nil) fntFile:gc.fontFile];
    tmp.scale = 0.5;  
    tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
    [self addChild:tmp z:0]; 
    [activeNodes addObject:tmp];
    
    tmpTile = (Tile *)[[parent getTiles] objectAtIndex:6];
    tile = [tmpTile getBoundingBox];
    
    arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
    arrow.position = ccp(tile.origin.x + tile.size.width/2,tile.origin.y + tile.size.height/2);
    [self addChild:arrow z:0];
    [activeNodes addObject:arrow];
    
    tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"TAP TO MOVE", nil) fntFile:gc.fontFile];
    tmp.scale = 0.5;  
    tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);    
    [self addChild:tmp z:0]; 
    [activeNodes addObject:tmp];
}

-(void)update:(ccTime)dt
{
    
}
- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [super dealloc];
}
@end

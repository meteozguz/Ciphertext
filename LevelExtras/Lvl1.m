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

#import "Lvl1.h"
#import "Tags.h"
#import "GameController.h"
#import "LevelScene.h"
#import "Tile.h"

@interface Lvl1() {
    CCMenu *nextButtonMenu;
    LevelScene *parent;
    NSUInteger numOfNextTab;
    BOOL isNearCompleted;
}
@end

@implementation Lvl1

+(id) Lvl1WithParentNode:(CCNode*)parentNode
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
                
        isNearCompleted = NO;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        GameController *gc = [GameController sharedGameController];
        
        Tile *tTile = [[parent getTiles] objectAtIndex:14];
        
        CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        arrow.position = tTile.boundingBox.origin;

        [self addChild:arrow z:0];
        [activeNodes addObject:arrow];
        
        CCLabelBMFont* tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"THIS NUMBER GIVES\nNUMBER OF MINES\nAROUND YOUR...", nil) fntFile:gc.fontFile];
        tmp.scale = 0.5;  
        tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
        [self addChild:tmp z:0]; 
        [activeNodes addObject:tmp];
        
        CCLabelBMFont *labelNext = [CCLabelBMFont labelWithString:NSLocalizedString(@"NEXT", nil) fntFile:gc.fontFile];
        CCMenuItemFont *menuItemNext = [CCMenuItemFont itemWithLabel:labelNext target:self selector:@selector(switchToNext)];
        nextButtonMenu = [CCMenu menuWithItems:menuItemNext, nil];
        nextButtonMenu.position = ccp(winSize.width - labelNext.boundingBox.size.width - labelNext.boundingBox.size.height/2, labelNext.boundingBox.size.height);
        [self addChild:nextButtonMenu z:0];
        
        for (Tile *tile in [parent getMines]) {
            tile.opacity = 255;
            tile.visible = YES;
        }
        
        [parentNode addChild:self z:Z_ORDER_HELPER_TEXT];
    }
    return self;
}

-(void)switchToNext
{
    GameController *gc = [GameController sharedGameController];
    
    numOfNextTab++;
    switch (numOfNextTab) {
        case 1: {
            [self fadeOutAndRemoveActiveNodes];
            
            Tile *tTile = [[parent getTiles] objectAtIndex:14];
            CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
            arrow.position = tTile.boundingBox.origin;

            [self addChild:arrow z:0];
            [activeNodes addObject:arrow];
            
            CCLabelBMFont* tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"4 NEIGHBOR\nUP DOWN\nLEFT RIGHT", nil) fntFile:gc.fontFile];
            tmp.scale = 0.5;
            tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
            [self addChild:tmp z:0];
            [activeNodes addObject:tmp];
            [activeNodes addObject:nextButtonMenu];
        }
            break;
        case 2: {
            nextButtonMenu.isTouchEnabled = NO;
            [self fadeOutAndRemoveActiveNodes];
                        
            parent.isTouchEnabled = YES;            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [super dealloc];
}
@end

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

#import "Lvl11.h"
#import "LevelScene.h"
#import "Tags.h"
#import "GameController.h"
#import "Tile.h"
@interface Lvl11() {
    BOOL isUserNotified;
    LevelScene *parent;
    CCLabelBMFont *meditationPassUsage;
    CCSprite *arrowForAbility;
}
@end

@implementation Lvl11

+(id)Lvl11WithParentNode:(CCNode*)parentNode
{
    CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    return [[[self alloc] initWithParentNode:parentNode] autorelease]; 
}

-(id)initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if(self) {
        [parentNode addChild:self z:Z_ORDER_HELPER_TEXT];
        
        parent = (LevelScene *)parentNode;
        
        isUserNotified = NO;
        
        GameController *gc = [GameController sharedGameController];
        
        Tile *tmpTile = (Tile *)[[parent getTiles] objectAtIndex:[parent getPlayerPositionAsIndex]];
        CGRect tile = [tmpTile getBoundingBox];
        
        CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        arrow.position = ccp(tile.origin.x + tile.size.width, tile.origin.y + tile.size.height);
        [self addChild:arrow z:0];
        [activeNodes addObject:arrow];
        
        CCLabelBMFont *tmp  = [CCLabelBMFont labelWithString:NSLocalizedString(@"TAP ON IT\nTO OPEN MENU", nil) fntFile:gc.fontFile];
        tmp.scale = 0.5;   
        tmp.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + tmp.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
        [self addChild:tmp z:0]; 
        [activeNodes addObject:tmp];
        
        
        arrowForAbility = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        arrowForAbility.rotation = 180;
        
        CCMenu *men = [parent getAbilityMenu].menu;
        CCMenuItem *crossPassMenuItem = (CCMenuItem *)[men getChildByTag:TAG_ABILITY_MENU_ABILITY_0];
        arrowForAbility.position = ccp([parent getAbilityMenu].menu.position.x- arrowForAbility.boundingBox.size.width/2- crossPassMenuItem.boundingBox.size.width/2,[parent getAbilityMenu].menu.position.y);
        arrowForAbility.visible = NO;
        [self addChild:arrowForAbility z:0];
        
        meditationPassUsage  = [CCLabelBMFont labelWithString:NSLocalizedString(@"USE TO SEE HOW MANY\nMINES AROUND YOUR SELECTED NEIGHBORS", nil) fntFile:gc.fontFile];
        meditationPassUsage.scale = 0.25; 
        meditationPassUsage.visible = NO;
        
        meditationPassUsage.position = ccp(arrowForAbility.boundingBox.origin.x - meditationPassUsage.boundingBox.size.width/2 +arrow.boundingBox.size.width, arrowForAbility.boundingBox.origin.y - meditationPassUsage.boundingBox.size.height/2);
        [self addChild:meditationPassUsage z:0]; 
        [self schedule:@selector(control:)];
    }
    return self;
}

-(void)control:(ccTime)dt
{
    if ([parent getPlayerPositionAsIndex] != 1){
        [self fadeOutAndRemoveActiveNodes];
        [self unschedule:@selector(control:)];
    }
}

-(void)pauseMenuOpened:(NSNotification *) notification
{
    if ([parent getPlayerPositionAsIndex] == 1 && isUserNotified == NO) {
        isUserNotified = YES;
        meditationPassUsage.visible = YES;
        arrowForAbility.visible = YES;
    }
    [super pauseMenuOpened:notification];
}

-(void)pauseMenuClosed:(NSNotification *) notification
{
    meditationPassUsage.visible = NO;
    arrowForAbility.visible = NO;
    [self fadeOutAndRemoveActiveNodes];
    [super pauseMenuClosed:notification];
}

- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [super dealloc];
}
@end

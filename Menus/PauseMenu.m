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

#import "PauseMenu.h"
#import "LevelSelectScene.h"
#import "MainScene.h"
#import "Tags.h"
#import "GameController.h"
#import "LevelScene.h"

@implementation PauseMenu

@synthesize menu;
@synthesize menuItemReplay;

+(id) pauseMenuWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        parent = parentNode;
        GameController *gc = [GameController sharedGameController]; 
        
        //CREATING MENU
        CCLabelBMFont *replayLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"REPLAY", nil) fntFile:gc.fontFile];
        CCLabelBMFont *continueLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"CONTINUE", nil) fntFile:gc.fontFile];
        CCLabelBMFont *levelSelectLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"LEVEL SELECT", nil) fntFile:gc.fontFile];
        CCLabelBMFont *mainMenuLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"MAIN MENU", nil) fntFile:gc.fontFile];
        
        menuItemReplay = [CCMenuItemLabel itemWithLabel:replayLabel target:self selector:@selector(replaceWithLevelScene)];
        menuItemContinue = [CCMenuItemLabel itemWithLabel:continueLabel target:self selector:@selector(continueWithCurrentLvl)];
        menuItemContinue.tag = TAG_MENU_ITEM_CONTINUE;
        menuItemLevelSelect = [CCMenuItemLabel itemWithLabel:levelSelectLabel target:self selector:@selector(replaceWithLevelSelectScene)];
        menuItemMainMenu = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(replaceWithMainMenuScene)];
        
        menu = [CCMenu menuWithItems: menuItemContinue, menuItemReplay, menuItemLevelSelect, menuItemMainMenu, nil];
        [menu alignItemsVertically];
        menu.scale = 0.75;
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
            menu.position = ccp(winSize.width / 2, 60);
        }else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
            menu.position = ccp(winSize.width / 2, winSize.height / 4);
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(1);
        }
    
       
        
        [self addChild:menu z:0];
        
        [parentNode addChild:self z:Z_ORDER_MENU];
    }
    return self;
}

-(void) continueWithCurrentLvl
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self.visible = NO;
    LevelScene *ly = (LevelScene *)parent;
    [ly closeMenu];
}

-(void) replaceWithLevelScene
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCTransitionSlideInR* transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) replaceWithLevelSelectScene
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCTransitionSlideInL* transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[LevelSelectScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) replaceWithMainMenuScene
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCTransitionSlideInL* transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[MainScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

// These methods are called when changing scenes.
-(void) onEnter
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super onExit];
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}
@end

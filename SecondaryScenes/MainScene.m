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
#import <StoreKit/StoreKit.h>
#import "MainScene.h"
#import "GameController.h"
#import "Tags.h"
#import "AboutScene.h"
#import "Player.h"
#import "LevelSelectScene.h"
#import "CiphertextScene.h"
#import "GameState.h"
#import "DifficultyMenu.h"
#import "DecryptionKeyScene.h"

@interface MainScene()

-(void)replaceWithLevelSelectScene;
-(void)replaceWithAboutScene;

@end

@implementation MainScene
{
    Player *player;
    CCNode *buyMenu;
}

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	CCScene* scene = [CCScene node];
	MainScene* layer = [MainScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
        
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBanner" object:self];
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        GameController *gc = [GameController sharedGameController]; 
        
        //CREATE TITLE
        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"CIPHERTEXT" fntFile:gc.fontFile];
        CGFloat offset = titleLabel.boundingBox.size.height/4;

        titleLabel.position = ccp(winSize.width - titleLabel.boundingBox.size.width/2 - offset, winSize.height - titleLabel.boundingBox.size.height/2 - offset);

        [self addChild:titleLabel z:0 tag:TAG_GAME_TITLE];
        
        //CREATING MENU
        CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"SELECT LEVEL", nil) fntFile:gc.fontFile];
        CCLabelBMFont *aboutLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"ABOUT", nil) fntFile:gc.fontFile];
        CCLabelBMFont *difficultyLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"DIFFICULTY", nil) fntFile:gc.fontFile];
        
        CCMenuItemLabel *menuItemPlay = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(replaceWithLevelSelectScene)];
        CCMenuItemLabel *memuItemAbout = [CCMenuItemLabel itemWithLabel:aboutLabel target:self selector:@selector(replaceWithAboutScene)];
        CCMenuItemLabel *menuItemDifficulty = [CCMenuItemLabel itemWithLabel:difficultyLabel target:self selector:@selector(showOrHideDifficultyMenu)];
        
        CCMenu *menu;
//        if ([SKPaymentQueue canMakePayments] && [[[NSUserDefaults standardUserDefaults] stringForKey:@"IsRemoveAdPurchased"] isEqualToString:@"NO"])
//        {
//            CCLabelBMFont *removeAdsLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"REMOVE ADS", nil) fntFile:gc.fontFile];
//            CCMenuItemLabel *menuItemRemoveAds = [CCMenuItemLabel itemWithLabel:removeAdsLabel target:self selector:@selector(removeAdsLabel)];
//            menu = [CCMenu menuWithItems:menuItemPlay, memuItemAbout, menuItemDifficulty, menuItemRemoveAds, nil];
//        }else {
//            menu = [CCMenu menuWithItems:menuItemPlay, memuItemAbout, menuItemDifficulty, nil];
//        }
         menu = [CCMenu menuWithItems:menuItemPlay, memuItemAbout, menuItemDifficulty, nil];       
        [menu alignItemsVertically];
        menu.scale = 0.75;
        menu.position = ccp(winSize.width / 4, (titleLabel.position.y - titleLabel.boundingBox.size.height)/2);

        [self addChild:menu z:Z_ORDER_MENU];
        
        player = [Player playerWithParentNode:self];
        player.position = ccp(winSize.width/16, winSize.height/10);
        
        difficultyMenu = [DifficultyMenu difficultyMenuWithParentNode:self];
        difficultyMenu.visible = NO;
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
		self.isTouchEnabled = YES;
	}
	return self;
}

- (void)registerWithTouchDispatcher
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);    
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
        
	if(CGRectContainsPoint(player.boundingBox, location)) {
        CCTransitionSlideInL* transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[DecryptionKeyScene scene]];
        [[CCDirector sharedDirector] replaceScene:transition];
	}
    
    CCLabelBMFont *title = (CCLabelBMFont *)[self getChildByTag:TAG_GAME_TITLE];
    if(CGRectContainsPoint(title.boundingBox, location)) {
        CCTransitionSlideInT* transition = [CCTransitionSlideInT transitionWithDuration:0.5 scene:[CiphertextScene scene]];
        [[CCDirector sharedDirector] replaceScene:transition];
	}
}

-(void)replaceWithLevelSelectScene
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCTransitionSlideInR* transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelSelectScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void)replaceWithAboutScene
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    CCTransitionSlideInB* transition = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[AboutScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void)showOrHideDifficultyMenu
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
   
    if (difficultyMenu.visible) {
        difficultyMenu.visible = NO;
    }else{
        difficultyMenu.visible = YES;
    }
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
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
@end

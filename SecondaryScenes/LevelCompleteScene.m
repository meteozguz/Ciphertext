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

#import "LevelCompleteScene.h"
#import "BackButtonMenu.h"
#import "GameController.h"
#import "Tags.h"
#import "GameState.h"
#import "MainScene.h"
#import "LevelScene.h"
#import "DecryptionKeyScene.h"
#import "BuyMyGameScene.h"

@implementation LevelCompleteScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	LevelCompleteScene* layer = [LevelCompleteScene node];
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
         
        [[GameState sharedGameState] updateLastUnlockedLevel];
        
        // ADD TITLE
        NSString *level = NSLocalizedString(@"LEVEL", nil);
        NSString *completed = NSLocalizedString(@"COMPLETED", nil);
        NSString *completeTitle = [NSString stringWithFormat:@"%@ %d %@", level, [[GameState sharedGameState] getCurrentLevelID], completed];
        CCLabelBMFont *title  = [CCLabelBMFont labelWithString:completeTitle fntFile:gc.fontFile];
        while (title.boundingBox.size.width > winSize.width) {
            title.scale -= 0.1;
        }
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
         
        CCLabelBMFont *repeatLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"REPLAY", nil) fntFile:gc.fontFile];
        CCMenuItemLabel *repeatMenuItem = [CCMenuItemLabel itemWithLabel:repeatLabel target:self selector:@selector(repeatLevel)];
        repeatMenuItem.scale = 0.5;
        
        CCLabelBMFont *rateLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"RATE", nil) fntFile:gc.fontFile];
        CCMenuItemLabel *rateMenuItem = [CCMenuItemLabel itemWithLabel:rateLabel target:self selector:@selector(rate)];
        rateMenuItem.scale = 0.5;
        
        CCLabelBMFont *continueLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"CONTINUE", nil) fntFile:gc.fontFile];
        CCMenuItemLabel *continueMenuItem = [CCMenuItemLabel itemWithLabel:continueLabel target:self selector:@selector(nextLevel)];
        continueMenuItem.scale = 0.5;
        
        
        //ELAPSED TIME
        CCLabelBMFont *elapsedTime  = [CCLabelBMFont labelWithString:NSLocalizedString(@"ELAPSED TIME", nil) fntFile:gc.fontFile];
        elapsedTime.scale = 0.5;
        [self addChild:elapsedTime z:0];
        
        NSString *elapsedTimeString = [[GameState sharedGameState] getElapsedTimeStringForDisplaying];
        CCLabelBMFont *elapsedTimeLabel  = [CCLabelBMFont labelWithString:elapsedTimeString fntFile:gc.fontFile];
        
        
        //MOVE COUNT
        CCLabelBMFont *moveCount  = [CCLabelBMFont labelWithString:NSLocalizedString(@"MOVE COUNT", nil) fntFile:gc.fontFile];
        moveCount.scale = 0.5;
        [self addChild:moveCount z:0];
        
        NSString *moveCountString = [[GameState sharedGameState] getMoveCountStringForDisplaying];
        CCLabelBMFont *moveCountLabel = [CCLabelBMFont labelWithString:moveCountString fntFile:gc.fontFile];
        
        
        //EXPLORED TILES
        CCLabelBMFont *exploredTiles  = [CCLabelBMFont labelWithString:NSLocalizedString(@"EXPLORED TILES", nil) fntFile:gc.fontFile];
        exploredTiles.scale = 0.5;
        [self addChild:exploredTiles z:0];
        
        NSString *exploredTilesString = [[GameState sharedGameState] getExploredTilesStringForDisplaying];
        CCLabelBMFont *exploredTilesLabel  = [CCLabelBMFont labelWithString:exploredTilesString fntFile:gc.fontFile];
        
        
        // POSITIONING
        title.position = ccp(winSize.width / 2, winSize.height / 1.2);
        
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
//            title.position = ccp(winSize.width / 2, winSize.height / 1.2);
            
            exploredTilesLabel.scale = 0.75;
            moveCountLabel.scale = 0.75;
            elapsedTimeLabel.scale = 0.75;

        }else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
//            title.position = ccp(winSize.width / 2, winSize.height / 1.25);
            
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(1);
        }
                
        [self addChild:exploredTilesLabel z:0];
        [self addChild:moveCountLabel z:0];
        [self addChild:elapsedTimeLabel z:0];
        [self addChild:title z:0];
        CCMenu *menu = [CCMenu menuWithItems:repeatMenuItem, rateMenuItem, continueMenuItem, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu z:1];
        
        elapsedTimeLabel.position = ccp(winSize.width/1.75, winSize.height/1.5);
        moveCountLabel.position = ccp(elapsedTimeLabel.position.x, elapsedTimeLabel.position.y - elapsedTimeLabel.boundingBox.size.height);
        exploredTilesLabel.position = ccp(moveCountLabel.position.x,moveCountLabel.position.y - moveCountLabel.boundingBox.size.height);
        
        // POSITIONING BUTTONS @START
        float offset = (winSize.width - repeatMenuItem.boundingBox.size.width - rateMenuItem.boundingBox.size.width - continueMenuItem.boundingBox.size.width) / 4; 
        float posY = exploredTilesLabel.position.y / 2;
        repeatMenuItem.position = ccp(offset + repeatMenuItem.boundingBox.size.width/2, posY);
        rateMenuItem.position = ccp(2*offset + repeatMenuItem.boundingBox.size.width + rateMenuItem.boundingBox.size.width/2, posY);
        continueMenuItem.position = ccp(winSize.width - offset - continueMenuItem.boundingBox.size.width/2, posY);
        // POSITIONING BUTTONS @END
        
        elapsedTime.position = ccp(elapsedTimeLabel.position.x - elapsedTimeLabel.boundingBox.size.width/2 - elapsedTime.boundingBox.size.width/2, elapsedTimeLabel.position.y);
        moveCount.position = ccp(moveCountLabel.position.x - moveCountLabel.boundingBox.size.width/2 - moveCount.boundingBox.size.width/2, moveCountLabel.position.y);
        exploredTiles.position = ccp(exploredTilesLabel.position.x - exploredTilesLabel.boundingBox.size.width/2 - exploredTiles.boundingBox.size.width/2, exploredTilesLabel.position.y);
        
        // ADDING OR NOT ADDING RESULT BADGES
        CCLabelBMFont *resultBadge;
        if ([[GameState sharedGameState] isLevelXElapsedTimeImproved]) {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"IMPROVED RESULT", nil) fntFile:gc.fontFile];
        }else {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"BEST RESULT", nil) fntFile:gc.fontFile];
        }
        resultBadge.scale = 0.25;
        resultBadge.position =  ccp(elapsedTimeLabel.position.x + elapsedTimeLabel.boundingBox.size.width/2 + resultBadge.boundingBox.size.width/2, elapsedTimeLabel.position.y);
        [self addChild:resultBadge z:0];
        
        if ([[GameState sharedGameState] isLevelXMoveCountImproved]) {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"IMPROVED RESULT", nil) fntFile:gc.fontFile];
        }else {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"BEST RESULT", nil) fntFile:gc.fontFile];
        }
        resultBadge.scale = 0.25;
        resultBadge.position =  ccp(moveCountLabel.position.x + moveCountLabel.boundingBox.size.width/2 + resultBadge.boundingBox.size.width/2, moveCountLabel.position.y);
        [self addChild:resultBadge z:0];
        
        if ([[GameState sharedGameState] isLevelXExploredTilesImproved]) {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"IMPROVED RESULT", nil) fntFile:gc.fontFile];
        }else {
            resultBadge = [CCLabelBMFont labelWithString:NSLocalizedString(@"BEST RESULT", nil) fntFile:gc.fontFile];
        }
        resultBadge.scale = 0.25;
        resultBadge.position =  ccp(exploredTilesLabel.position.x + exploredTilesLabel.boundingBox.size.width/2 + resultBadge.boundingBox.size.width/2, exploredTilesLabel.position.y);
        [self addChild:resultBadge z:0];
        
    }
	return self;
}

-(void)rate
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    NSString *urlString = NSLocalizedString(@"BUY_LINK",nil);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)nextLevel
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [[GameState sharedGameState] setCurrentLevelID:[[GameState sharedGameState] getCurrentLevelID] + 1];
    
    CCTransitionSlideInR *transition;
    
    
    if ([[GameState sharedGameState] getCurrentLevelID] == 40) {
        transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[DecryptionKeyScene scene]];
    }else {        
        transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelScene scene]];
    }
    
    [[CCDirector sharedDirector] replaceScene:transition]; 
}

-(void)repeatLevel
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
    CCTransitionSlideInL *transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[LevelScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition]; 
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

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

#import "LevelSelectScene.h"
#import "BackButtonMenu.h"
#import "GameController.h"
#import "Tags.h"
#import "GameState.h"
#import "MainScene.h"
#import "LevelScene.h"

@implementation LevelSelectScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	LevelSelectScene* layer = [LevelSelectScene node];
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
        CGFloat w = winSize.width/8;
        CGFloat h = winSize.height/5;
                
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
          
        lvlTiles = [[CCArray alloc] initWithCapacity:39];
        
        NSInteger lvlID = 0;
        // NSString *chipertext = @"glclocklbukdfibgpcuodygpjukcfibncyizlyz"; 
        BOOL isLevelUnlocked = YES;
        
        for(int i = 0; i < 8; i++) {
            for(int j = 0; j < 5; j++) {
                if(i != 0 || j != 0) { //adds levels
                    if(lvlID <= [[GameState sharedGameState] getLastUnlockedLevel]) {
                        isLevelUnlocked = YES;
                    }else {
                        isLevelUnlocked = NO;
                    }
                    [self addLvlTile:lvlID withType:isLevelUnlocked withLocation:ccp(i * w + w / 2,j * h + h / 2) withTag:
                     lvlID + TAG_LVL0];
                    lvlID++;
                }else {  //adds back button
                    BackButtonMenu* bckBM = [BackButtonMenu backButtonMenuWithParentNode:self];
                    bckBM.position = ccp(w / 2, h / 2);
                }
            }
        }
		self.isTouchEnabled = YES;
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [lvlTiles release];
	[super dealloc];
}

- (void)registerWithTouchDispatcher
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);    
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{	
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    GameState *gs = [GameState sharedGameState] ;
    
    NSInteger counter = 0;
    for (CCLabelBMFont *lvlTile in lvlTiles) {
        if(CGRectContainsPoint(lvlTile.boundingBox, location) && counter <= [[GameState sharedGameState] getLastUnlockedLevel]) {
            CCLOG(@"You touched lvl: %d",counter);
            [self stopAllActions];
            [self unscheduleAllSelectors];
            [gs setCurrentLevelID:counter];
            CCTransitionSlideInR* transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelScene scene]];
            [[CCDirector sharedDirector] replaceScene:transition];
        }  
        counter++;
    }	
}

-(void) addLvlTile:(NSInteger)lvlNo withType:(BOOL)type withLocation:(CGPoint)location withTag:(NSUInteger)tag {
    GameController *gc = [GameController sharedGameController];
    NSString *tmp = [NSString stringWithFormat:@"%d",lvlNo];
    CCLabelBMFont *lvl = [CCLabelBMFont labelWithString:tmp fntFile:gc.fontFile];
    lvl.scale = 0.75;
    lvl.position = location;
    [lvlTiles addObject:lvl];    
    if (type) {
        [lvl runAction:[CCFadeIn actionWithDuration:CCRANDOM_0_1()*2.5]];
    }else {
        lvl.opacity = 0;
        NSInteger t = 0;
        if (CCRANDOM_0_1() < 0.5f) {
            t = 5;
        }else {
            t = 10;
        }
        [lvl runAction:[CCFadeTo actionWithDuration:CCRANDOM_0_1()*t opacity:32]];
    }    
    [self addChild:lvl z:0 tag:tag];
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

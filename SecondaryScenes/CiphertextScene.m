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

#import "CiphertextScene.h"
#import "BackButtonMenu.h"
#import "GameController.h"
#import "Tags.h"
#import "GameState.h"
#import "MainScene.h"
#import "LevelScene.h"

@interface CiphertextScene()
{
    BackButtonMenu* bckBM;
}

-(void) addLvlTile:(NSString *)ch withType:(BOOL)type withLocation:(CGPoint)location withTag:(NSUInteger)tag;

@end

@implementation CiphertextScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	CiphertextScene* layer = [CiphertextScene node];
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
        GameController *gc = [GameController sharedGameController]; 
                
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
        
        lvlTiles = [[CCArray alloc] initWithCapacity:39];
        
        NSInteger lvlID = 0;
        NSString *chipertext = @"glclocklbukdfibgpcuodygpjukcfibncyizlyz"; 
        BOOL isLevelUnlocked = YES;

        NSInteger numOfUnlockedLevels = 0;
        for(int i = 0; i < 8; i++) {
            for(int j = 0; j < 5; j++) {
                if(i != 0 || j != 0) { //adds levels
                    if(lvlID <= [[GameState sharedGameState] getLastUnlockedLevel]) {
                        isLevelUnlocked = YES;
                        numOfUnlockedLevels++;
                    }else {
                        isLevelUnlocked = NO;
                    }
                    NSString *tmp = [NSString stringWithFormat:@"%c" , [chipertext characterAtIndex:lvlID]];
                    [self addLvlTile:tmp withType:isLevelUnlocked withLocation:ccp(i * w + w / 2,j * h + h / 2) withTag:
                     lvlID + TAG_LVL0];

                    
                    lvlID++;
                }else {  //adds back button
                    bckBM = [BackButtonMenu backButtonMenuWithParentNode:self];
                     bckBM.position = ccp(w / 2, h / 2);
                }
            }
        }
        
		self.isTouchEnabled = NO;
        
        CCLabelBMFont *title = [CCLabelBMFont labelWithString:NSLocalizedString(@"YOU FOUND THE CIPHERTEXT", nil) fntFile:gc.fontFile];
        title.position = ccp(winSize.width / 2, winSize.height / 1.25);
        while (title.boundingBox.size.width > winSize.width) {
            title.scale -= 0.1;
        }
        [title runAction:[CCFadeOut actionWithDuration:3]];
        [self addChild:title z:0];
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [lvlTiles release];
	[super dealloc];
}

-(void) addLvlTile:(NSString *)ch withType:(BOOL)type withLocation:(CGPoint)location withTag:(NSUInteger)tag {
    CCSprite *sprite;
    NSString *tmp = [ch stringByAppendingString:@".png"];
    sprite = [CCSprite spriteWithSpriteFrameName:tmp];
    sprite.position = location;
    [lvlTiles addObject:sprite];    
    if (type) {
        [sprite runAction:[CCFadeIn actionWithDuration:CCRANDOM_0_1()*2.5]];
    }else {
        sprite.opacity = 0;
        NSInteger t = 0;
        if (CCRANDOM_0_1() < 0.5f) {
            t = 5;
        }else {
            t = 10;
        }
        [sprite runAction:[CCFadeTo actionWithDuration:CCRANDOM_0_1()*t opacity:32]];
    }    
    [self addChild:sprite z:0 tag:tag];
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

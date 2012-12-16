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

#import "DecryptionKeyScene.h"
#import "BackButtonMenu.h"
#import "GameController.h"
#import "MainScene.h"
#import "RandomChar.h"
#import "GameState.h"
#import "Tags.h"

const CGFloat SWITCH_TIME = 3.0;

@interface DecryptionKeyScene()
{
    CGSize winSize;
}

@end

@implementation DecryptionKeyScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	DecryptionKeyScene* layer = [DecryptionKeyScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBanner" object:self];
        
        GameController *gc = [GameController sharedGameController]; 
        winSize = [[CCDirector sharedDirector] winSize];
        CGFloat w = winSize.width/8;
        CGFloat h = winSize.height/5;
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
        
        decryptionKeyTiles = [[CCArray alloc] initWithCapacity:39];
        
        NSString *decryptionKey = @"lbukdrot14cuolikejukcfibrot13lyzturkish"; 
        NSInteger decryptionKeyCharIndex = 0;
        
        for(int i = 0; i < 8; i++) {
            for(int j = 0; j < 5; j++) {
                if(i != 0 || j != 0) { //adds decryption key characters
                    if([[GameState sharedGameState] getLastUnlockedLevel] == 39 || (decryptionKeyCharIndex < [[GameState sharedGameState] getLastUnlockedLevel] && [[GameState sharedGameState] getLastUnlockedLevel] != 0) ) {
                        NSString *tmp = [NSString stringWithFormat:@"%c.png" , [decryptionKey characterAtIndex:decryptionKeyCharIndex]];
                        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:tmp];
                        sprite.position = ccp(i * w + w / 2,j * h + h / 2);
                        [self addChild:sprite z:0];
                    }else {
                        RandomChar *rndChar = [RandomChar randomCharWithParentNode:self];
                        rndChar.position = ccp(i * w + w / 2,j * h + h / 2);
                    }
                    decryptionKeyCharIndex++;
                }else {  //adds back button
                    BackButtonMenu* bckBM = [BackButtonMenu backButtonMenuWithParentNode:self];
                    bckBM.position = ccp(w / 2, h / 2);
                }
            }
        }
        // ADDING CONGRATULATION
        if ([[GameState sharedGameState] getCurrentLevelID] == 40) {
            CCLabelBMFont *congratulation = [CCLabelBMFont labelWithString:NSLocalizedString(@"CONGRATULATION", nil) fntFile:gc.fontFile];
            CCLabelBMFont *clues = [CCLabelBMFont labelWithString:NSLocalizedString(@"YOU'VE GATHERED ALL THE CLUES", nil) fntFile:gc.fontFile];
            while (clues.boundingBox.size.width > winSize.width) {
                clues.scale -= 0.1;
            }
            congratulation.position = ccp(winSize.width / 2, winSize.height / 1.25);
            
            clues.position = ccp(congratulation.position.x,congratulation.position.y - congratulation.boundingBox.size.height);
            [congratulation runAction:[CCFadeOut actionWithDuration:3]];
            [clues runAction:[CCFadeOut actionWithDuration:3]];
            [self addChild:congratulation z:0];
            [self addChild:clues z:0];
        }
		self.isTouchEnabled = NO;
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [decryptionKeyTiles release];
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

/*
 *
 * Created by Mete Ozguz on 2012-05
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

#import "HeadLines.h"
#import "GameController.h"

@implementation HeadLines

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	HeadLines* layer = [HeadLines node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
//        GameController *gc = [GameController sharedGameController];
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
//
//        
//        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(22, 34, 31, 255)];
//        [self addChild:background z:-10];
        
//        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"40 UNIQUE LEVELS" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/2);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];

//#############
//        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"FIND YOUR WAY" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/2);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];
//        
//        titleLabel = [CCLabelBMFont labelWithString:@"AVOIDING MINES" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/4);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];
        
//#############        
//        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"COLLECT CLUES" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/1.5);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];
//        
//        titleLabel = [CCLabelBMFont labelWithString:@"AND" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/2);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];
//        
//        titleLabel = [CCLabelBMFont labelWithString:@"DECRYPT CIPHERTEXT" fntFile:gc.fontFile];
//        titleLabel.position = ccp(winSize.width/2,winSize.height/4);
//        titleLabel.scale = 0.75;
//        [self addChild:titleLabel];
    }   
    self.isTouchEnabled = NO;
    return self;
}

@end

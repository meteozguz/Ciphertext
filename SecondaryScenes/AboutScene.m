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

#import "AboutScene.h"
#import "BackButtonMenu.h"
#import "GameController.h"
#import "GameState.h"
#import "MainScene.h"
#import "Tags.h"
#import "FollowUsOnMenu.h"
@implementation AboutScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	AboutScene* layer = [AboutScene node];
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
        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"ABOUT", nil) fntFile:gc.fontFile];
        CGFloat offset = titleLabel.boundingBox.size.height/4;
        
        titleLabel.position = ccp(winSize.width - titleLabel.boundingBox.size.width/2 - offset, winSize.height - titleLabel.boundingBox.size.height/2 - offset);
        [self addChild:titleLabel z:0];
        
        //CREATE SUBTITLE
        CCLabelBMFont *subtitleLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"PROGRAMMING AND ARTWORK", nil) fntFile:gc.fontFile];
        subtitleLabel.scale = 0.5;
        subtitleLabel.position = ccp(winSize.width / 2, winSize.height / 1.5);
        [self addChild:subtitleLabel z:0];
        
        //CREATE METE OZGUZ
        CCLabelBMFont *meteozguzLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"METE OZGUZ", nil) fntFile:gc.fontFile];
        meteozguzLabel.scale = 0.5;
        meteozguzLabel.position = ccp(winSize.width / 2, winSize.height / 1.85);
        [self addChild:meteozguzLabel z:0];
                
        //CREATE COCOS2D
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"cocos2d.png"];
        sprite.position = ccp(winSize.width-sprite.boundingBox.size.width/2, sprite.boundingBox.size.height/2);
        [self addChild:sprite z:0];
        
        //FONT
        CCLabelBMFont *fontLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"THIS FONT IS A MODIFIED VERSION OF FREE FONT\nLIQUID CRYSTAL BY UNBOUND DESIGNS", nil) fntFile:gc.fontFile];
        fontLabel.scale = 0.25;
        
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
            fontLabel.position = ccp(fontLabel.boundingBox.size.width/2, winSize.height / 2.5);
        }else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
            fontLabel.position = ccp(sprite.position.x - fontLabel.boundingBox.size.width/2 - sprite.boundingBox.size.width/2, winSize.height / 2.5);
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(1);
        }
        
        [self addChild:fontLabel z:0];
        
        BackButtonMenu* bckBM = [BackButtonMenu backButtonMenuWithParentNode:self];
        bckBM.position = ccp(winSize.width/16, winSize.height/10);
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
        
        FollowUsOnMenu *followUsOnMenu = [FollowUsOnMenu followUsOnMenuWithParentNode:self];
        [followUsOnMenu setPosition:ccp(winSize.width/2, fontLabel.boundingBox.origin.y - followUsOnMenu.facebookSprite.boundingBox.size.height * 0.75)];
        
		self.isTouchEnabled = NO;
	}
	return self;
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

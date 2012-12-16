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

#import "BuyMyGameScene.h"
#import "GameController.h"
#import "Tags.h"
#import "MainScene.h"
#import "GameState.h"
#import "FollowUsOnMenu.h"

@interface BuyMyGameScene()

@end

@implementation BuyMyGameScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	BuyMyGameScene* layer = [BuyMyGameScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        GameController *gc = [GameController sharedGameController]; 
        
        // ADD TITLE
        CCLabelBMFont *title  = [CCLabelBMFont labelWithString:NSLocalizedString(@"FOR MORE...", nil) fntFile:gc.fontFile];
                
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
        
        // BUTTONS
        CCLabelBMFont *buyLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"BUY", nil) fntFile:gc.fontFile];
        CCMenuItemLabel *buyMenuItem = [CCMenuItemLabel itemWithLabel:buyLabel target:self selector:@selector(buy)];
        
        CCLabelBMFont *mainMenuLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"MAIN MENU", nil) fntFile:gc.fontFile];
        CCMenuItemLabel *mainMenuItem = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(mainMenu)];
        mainMenuItem.scale = 0.5;
        
        NSString *deviceType = [UIDevice currentDevice].model;
        if([deviceType isEqualToString:@"iPhone"] || [deviceType isEqualToString:@"iPhone Simulator"]) {
            title.position = ccp(winSize.width / 2, winSize.height / 1.18);
            
            buyMenuItem.position = ccp(winSize.width - buyLabel.boundingBox.size.width/2 - buyLabel.boundingBox.size.height/2 , buyLabel.boundingBox.size.height/2+buyLabel.boundingBox.size.height/8);
            
            mainMenuItem.position = ccp(mainMenuItem.boundingBox.size.width/2 + mainMenuItem.boundingBox.size.height/2, buyMenuItem.position.y);
        }else if([deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPad Simulator"]) {
            title.position = ccp(winSize.width / 2, winSize.height / 1.25);
            
            buyMenuItem.position = ccp(winSize.width - buyLabel.boundingBox.size.width/2 - buyLabel.boundingBox.size.height/2 , buyLabel.boundingBox.size.height);
            
            mainMenuItem.position = ccp(mainMenuItem.boundingBox.size.width/2 + mainMenuItem.boundingBox.size.height/2, buyLabel.boundingBox.size.height);
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(0);
        }
        
        while (title.boundingBox.size.width > winSize.width) {
            title.scale -= 0.1;
        }
        [self addChild:title z:0];
        
        CCMenu *menu = [CCMenu menuWithItems:mainMenuItem, buyMenuItem, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu z:0];
        
        //FEATURES
        CCLabelBMFont *portals  = [CCLabelBMFont labelWithString:NSLocalizedString(@"PORTALS", nil) fntFile:gc.fontFile];
        portals.scale = 0.5;
        portals.position = ccp(winSize.width/2, title.position.y - title.boundingBox.size.height/1.5);
        [self addChild:portals z:0];
        
        CCLabelBMFont *abilities  = [CCLabelBMFont labelWithString:NSLocalizedString(@"ABILITIES", nil) fntFile:gc.fontFile];
        abilities.scale = 0.5;
        abilities.position = ccp(portals.position.x - portals.boundingBox.size.width,portals.position.y - portals.boundingBox.size.height);
        [self addChild:abilities z:0];
        
        CCLabelBMFont *tiles  = [CCLabelBMFont labelWithString:NSLocalizedString(@"8X5 TILES", nil) fntFile:gc.fontFile];
        tiles.scale = 0.5;
        tiles.position =  ccp(abilities.position.x + abilities.boundingBox.size.width, abilities.position.y - abilities.boundingBox.size.height);
        [self addChild:tiles z:0];
        
        CCLabelBMFont *adFree  = [CCLabelBMFont labelWithString:NSLocalizedString(@"AD FREE", nil) fntFile:gc.fontFile];
        adFree.scale = 0.5;
        adFree.position = ccp(tiles.position.x - adFree.boundingBox.size.width,tiles.position.y - tiles.boundingBox.size.height);
        [self addChild:adFree z:0];
        
        FollowUsOnMenu *followUsOnMenu = [FollowUsOnMenu followUsOnMenuWithParentNode:self];
        [followUsOnMenu setPosition:ccp(winSize.width/2,(tiles.position.y+buyMenuItem.position.y)/2)];
	}
	return self;
}

-(void)mainMenu
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    CCTransitionSlideInL *transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[MainScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition]; 
}

-(void)buy
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    NSString *urlString = NSLocalizedString(@"BUY_LINK",nil);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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

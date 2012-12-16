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

#import "FollowUsOnMenu.h"
#import "GameController.h"

@implementation FollowUsOnMenu
@synthesize facebookSprite;
+(id) followUsOnMenuWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
                
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        GameController *gc = [GameController sharedGameController];
        
        parent = (CCLayer *) parentNode;

        //ADDING TWITTER AND FACEBOOK 
        twitterSprite = [CCSprite spriteWithSpriteFrameName:@"twitter_newbird_white.png"];
        CCSprite *twitterSprite2 = [CCSprite spriteWithSpriteFrameName:@"twitter_newbird_white.png"];
        twitterSprite2.scale = 1.1;
        CCMenuItemSprite *twitter = [CCMenuItemSprite itemFromNormalSprite:twitterSprite selectedSprite:twitterSprite2 target:self selector:@selector(twitter)];
        
        facebookSprite = [CCSprite spriteWithSpriteFrameName:@"f_logo.png"];
        CCSprite *facebookSprite2 = [CCSprite spriteWithSpriteFrameName:@"f_logo.png"];
        facebookSprite2.scale = 1.1;
        CCMenuItemSprite *facebook = [CCMenuItemSprite itemFromNormalSprite:facebookSprite selectedSprite:facebookSprite2 target:self selector:@selector(facebook)];
        
        menu = [CCMenu menuWithItems:twitter, facebook, nil];
        [menu alignItemsHorizontally];
        [self addChild:menu z:0];
        
        //ADDING FOLLOW US LABEL
        followUsLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"FOLLOW US ON", nil) fntFile:gc.fontFile];
        followUsLabel.scale = 0.25;
        
        [self addChild:followUsLabel z:0]; 
     
        [parentNode addChild:self z:0];
    }
    return self;
}

-(void)setPosition:(CGPoint)position{
    menu.position = ccp(position.x, position.y);
    followUsLabel.position = ccp(menu.position.x - twitterSprite.boundingBox.size.width - followUsLabel.boundingBox.size.width/2, menu.position.y);
}

-(void)facebook
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	NSString *urlString = @"https://m.facebook.com/ciphertextApp";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)twitter
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	NSString *urlString = @"https://mobile.twitter.com/#!/ciphertextApp";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}
@end

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

#import "BuyMenu.h"
#import "GameController.h"
#import "Tags.h"

@interface BuyMenu() {
    CCNode *parent;
    CCMenu *menu;
}

@end

@implementation BuyMenu

+(id) buyMenuWithParentNode:(CCNode*)parentNode
{
return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        parent = parentNode;
        
        GameController *gc = [GameController sharedGameController];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelBMFont *buyLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"BUY", nil) fntFile:gc.fontFile];
        buyLabel.scale = 0.5;
        CCMenuItemLabel *buyMenuItem = [CCMenuItemLabel itemWithLabel:buyLabel target:self selector:@selector(buy)];
        menu = [CCMenu menuWithItems:buyMenuItem, nil];
        menu.position = ccp(winSize.width - buyMenuItem.boundingBox.size.height/2 , 1.5*buyLabel.boundingBox.size.height);
        [self addChild:menu z:0];

        menu.isTouchEnabled = YES;
        
        [parentNode addChild:self z:Z_ORDER_MENU];
    }
    return self;
}

-(void)buy
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    NSString *urlString = NSLocalizedString(@"BUY_LINK",nil);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end

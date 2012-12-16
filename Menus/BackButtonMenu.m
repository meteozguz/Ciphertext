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

#import "BackButtonMenu.h"
#import "MainScene.h"
#import "LevelSelectScene.h"
#import "CiphertextScene.h"
#import "AboutScene.h"
#import "DecryptionKeyScene.h"
#import "Tags.h"

@implementation BackButtonMenu
+(id) backButtonMenuWithParentNode:(CCNode*)parentNode
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
        
        cursor = [CCSprite spriteWithSpriteFrameName:@"cursor.png"];
        
        CCSprite *backSprite = [CCSprite spriteWithSpriteFrameName:@"smaller.png"];
        
        CCMenuItemSprite *menuItemBack =[CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:nil target:self selector:@selector(goBack:) ];
        
        menu = [CCMenu menuWithItems:menuItemBack, nil];
        menu.position = ccp(0, 0);
        
        menu.isTouchEnabled = YES;
        
        [self addChild:menu z:-1];
        [self addChild:cursor z:0];

        [self schedule:@selector(blink:) interval:1];
        cursor.opacity = 0;
        
        [parentNode addChild:self z:Z_ORDER_MENU];
    
    }
    return self;
}

-(void) blink:(ccTime)delta 
{
    cursor.opacity = 255 - cursor.opacity;
}

-(void)goBack:(CCMenuItem *)item
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    id transition = nil;
    if ([parent isKindOfClass:[LevelSelectScene class]]) {
        transition = [CCTransitionSlideInL transitionWithDuration:0.5 scene:[MainScene scene]];
    }else if ([parent isKindOfClass:[CiphertextScene class]]) {
        transition = [CCTransitionSlideInB transitionWithDuration:0.5 scene:[MainScene scene]];
    }else if ([parent isKindOfClass:[AboutScene class]]) {
        transition = [CCTransitionSlideInT transitionWithDuration:0.5 scene:[MainScene scene]];
    }else if ([parent isKindOfClass:[DecryptionKeyScene class]]) {
        transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[MainScene scene]];        
    }
    NSAssert(transition != nil, @"BackButtonMenu.m goBack: transition value is nil!");
    [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

@end
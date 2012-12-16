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

#import "AbilityMenu.h"
#import "LevelScene.h"
#import "Tags.h"
#import "Level.h"
#import "Player.h"

@implementation AbilityMenu

@synthesize menu, numberOfUsedMeditation;

+(id) abilityMenuWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        numberOfUsedMeditation = 0;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //CREATING MENU
        menu = [CCMenu menuWithItems:nil];
        
        NSString *abilitySpriteName = nil;
        NSString *selectorName;
        CCSprite *abilitySprite = nil;
        CCSprite *pressedAbilitySprite;
        CCMenuItemSprite *menuItem;
        
        for (int i = 0; i < [[[Level sharedLevel] getAbilities] length]; i++) {
            
            switch ([[[Level sharedLevel] getAbilities] characterAtIndex:i]) {
                case '1': // CROSS PASS
                    abilitySpriteName = @"crossPass.png";
                    selectorName = @"useCrossPass:";
                    break;
                    
                case '2': // MEDITATION 
                    // 1 1 0
                    // 1   0
                    // 0 0 0
                    // Using the same logic in tile map this becomes 00010110.
                    abilitySpriteName = [NSString stringWithFormat:@"meditation%@.png",[[Level sharedLevel] getMeditation]];
                    selectorName = @"useMeditation:";
                    break;
                    
                default:
                    break;
            }
            NSAssert(abilitySpriteName != nil, @"AbilityMenu.m init abilitySpriteName is nil");

            abilitySprite = [CCSprite spriteWithSpriteFrameName:abilitySpriteName];
            
            NSAssert(abilitySprite != nil, @"AbilityMenu.m init abilitySprite is nil");
            
            pressedAbilitySprite = [CCSprite spriteWithSpriteFrameName:abilitySpriteName];
            pressedAbilitySprite.opacity = 128; 
            
            menuItem = [CCMenuItemSprite itemFromNormalSprite:abilitySprite selectedSprite:pressedAbilitySprite target:self selector:NSSelectorFromString(selectorName)];
            
            [menu addChild:menuItem z:0 tag:TAG_ABILITY_MENU_ABILITY_0+i];        
        }
        
        NSString *deviceType = [UIDevice currentDevice].model;
       if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
            CGPoint point = ccp(winSize.width / 2, winSize.height - abilitySprite.boundingBox.size.height/1.5);
            
            menu.position = point;
        }else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
            CGPoint point = ccp(winSize.width / 2, winSize.height - abilitySprite.boundingBox.size.height);
            
            menu.position = point;
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(1);
        }
        
        [menu alignItemsHorizontally];
        menu.visible = YES;
        [self addChild:menu];
        
        [parentNode addChild:self z:Z_ORDER_MENU];
    }
    return self;
}

-(void)useCrossPass:(CCMenuItem*)item
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    LevelScene *prnt = (LevelScene *)[self parent];
    [[prnt getPlayer] tryToUseCrossPass];
    menuItemToBeHid = item;
    self.visible = NO;
    [prnt closeMenu];
}

-(void)useMeditation:(CCMenuItem*)item
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    LevelScene *prnt = (LevelScene *)[self parent];
    [prnt useMeditation];
 
    item.visible = NO;
    [menu alignItemsHorizontally];

    self.visible = NO;
    [prnt closeMenu];
}

-(void)removeLastSelectedItem
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    if(menuItemToBeHid) {
        menuItemToBeHid.visible = NO;
        [menu alignItemsHorizontally];
    }
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

@end

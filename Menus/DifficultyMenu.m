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

#import "DifficultyMenu.h"
#import "GameController.h"
#import "Tags.h"
#import "GameState.h"

@implementation DifficultyMenu

+(id) difficultyMenuWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        GameController *gc = [GameController sharedGameController];
        
        //CREATING MENU
        CCLabelBMFont *easyLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"EASY", nil) fntFile:gc.fontFile];
        CCLabelBMFont *normalLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"NORMAL", nil) fntFile:gc.fontFile];
        CCLabelBMFont *hardLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"HARD", nil) fntFile:gc.fontFile];
        CCLabelBMFont *nightmareLabel = [CCLabelBMFont labelWithString:NSLocalizedString(@"NIGHTMARE", nil) fntFile:gc.fontFile];
        
        CCMenuItemLabel *menuItemEasyLabel = [CCMenuItemLabel itemWithLabel:easyLabel target:self selector:@selector(easyDifficulty)];
        
        CCMenuItemLabel *menuItemNormalLabel = [CCMenuItemLabel itemWithLabel:normalLabel target:self selector:@selector(normalDifficulty)];
        
        CCMenuItemLabel *menuItemHardLabel = [CCMenuItemLabel itemWithLabel:hardLabel target:self selector:@selector(hardDifficulty)];
        
        CCMenuItemLabel *menuItemNightmareLabel = [CCMenuItemLabel itemWithLabel:nightmareLabel target:self selector:@selector(nightmareDifficulty)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuItemEasyLabel, menuItemNormalLabel, menuItemHardLabel, menuItemNightmareLabel, nil];
        
        [menu alignItemsVertically];
        menu.scale = 0.5;
        menu.position = ccp(winSize.width / 1.85, 0);
        menu.visible = YES;
        [self addChild:menu];
        
        [parentNode addChild:self z:Z_ORDER_MENU tag:TAG_NODE_DIFFICULTY_MENU];
    }
    return self;
}
-(void)easyDifficulty
{
    [[GameState sharedGameState] setDifficulty:@"Easy"];
    self.visible = NO;
}
-(void)normalDifficulty
{
    [[GameState sharedGameState] setDifficulty:@"Normal"];
    self.visible = NO;
}
-(void)hardDifficulty
{
    [[GameState sharedGameState] setDifficulty:@"Hard"];
    self.visible = NO;
}
-(void)nightmareDifficulty
{
    [[GameState sharedGameState] setDifficulty:@"Nightmare"];
    self.visible = NO;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[super dealloc];
}

@end

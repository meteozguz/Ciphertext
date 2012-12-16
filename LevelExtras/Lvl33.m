//
//  Lvl33.m
//  Ciphertext
//
//  Created by Mete Ozguz on 5/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "LevelScene.h"
#import "GameController.h"
#import "Player.h"
#import "Tile.h"
#import "Tags.h"
#import "Lvl33.h"

@interface Lvl33()
{
    BOOL isAlreadyOpened;
    LevelScene *parent;
    CCLabelBMFont* n4;
    CCLabelBMFont* n8;
}
@end

@implementation Lvl33

+(id) Lvl33WithParentNode:(CCNode*)parentNode
{
    CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    return [[[self alloc] initWithParentNode:parentNode] autorelease]; 
}

-(id) initWithParentNode:(CCNode*)parentNode
{
    self = [super init];
    if (self) {
        parent = (LevelScene *)parentNode;
        GameController *gc = [GameController sharedGameController];
        
        Tile *tmpTile = (Tile *)[[parent getTiles] objectAtIndex:[parent getPlayerPositionAsIndex]];
        CGRect tile = [tmpTile getBoundingBox];
        
        CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        arrow.position = ccp(tile.origin.x + tile.size.width, tile.origin.y + tile.size.height);
        [self addChild:arrow z:0];
        [activeNodes addObject:arrow];
        
        n4  = [CCLabelBMFont labelWithString:NSLocalizedString(@"4N", nil) fntFile:gc.fontFile]; 
        n4.scale = 0.5;
        n4.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + n4.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
        [activeNodes addObject:n4];
        [self addChild:n4 z:0];
    
        
        n8  = [CCLabelBMFont labelWithString:NSLocalizedString(@"8N", nil) fntFile:gc.fontFile];
        n8.scale = 0.5;
        n8.position = ccp(arrow.boundingBox.origin.x + arrow.boundingBox.size.width + n8.boundingBox.size.width/2, arrow.boundingBox.origin.y + arrow.boundingBox.size.height);
        [activeNodes addObject:n8];
                [self addChild:n8 z:0];
        
        [self scheduleUpdate];
        
        [parentNode addChild:self z:Z_ORDER_HELPER_TEXT];
    }
    return self;
}

-(void)update:(ccTime)dt
{
    if ([super isPauseMenuOpened] == NO) {
        if ([parent getPlayerPositionAsIndex] == 0) {
            if ([(Player *)[[self parent] getChildByTag:TAG_PLAYER] getBlinkCount]%2== 0) {
                n4.visible = NO;
                n8.visible = YES;
            }else {
                n8.visible = NO;
                n4.visible = YES;
            }
        }else {
            [super fadeOutAndRemoveActiveNodes];
            [self unscheduleUpdate];
        }
    }
}

- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [super dealloc];
}
@end

//
//  LevelX.m
//  Ciphertext
//
//  Created by Mete Ozguz on 5/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelX.h"

@interface LevelX()
{
    BOOL isPauseMenuOpened;
}
@end

@implementation LevelX

- (id)init
{
    CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self = [super init];
    if (self) {
        
        isPauseMenuOpened = NO;
        
        activeNodes = [[CCArray alloc] initWithCapacity:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseMenuOpened:) 
                                                     name:@"PauseMenuOpened"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseMenuClosed:) 
                                                     name:@"PauseMenuClosed"
                                                   object:nil];
    }
    return self;
}

-(void)pauseMenuOpened:(NSNotification *) notification
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    for (CCNode *node in activeNodes) {
        node.visible = NO;
    }
    isPauseMenuOpened = YES;
}

-(void)pauseMenuClosed:(NSNotification *) notification
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    for (CCNode *node in activeNodes) {
        node.visible = YES;
    }
    isPauseMenuOpened = NO;
}

-(void)fadeOutAndRemoveActiveNodes
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    for (CCNode *node in activeNodes) {
        [node runAction:[CCFadeOut actionWithDuration:0.1]];
    }
    [activeNodes removeAllObjects];
}

- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);	
    [activeNodes release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(BOOL)isPauseMenuOpened
{
    return  isPauseMenuOpened;
}
@end

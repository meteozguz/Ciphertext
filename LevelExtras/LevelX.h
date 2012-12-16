//
//  LevelX.h
//  Ciphertext
//
//  Created by Mete Ozguz on 5/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelX : CCNode {
    CCArray *activeNodes;
}
-(void)pauseMenuOpened:(NSNotification *) notification;
-(void)pauseMenuClosed:(NSNotification *) notification;
-(void)fadeOutAndRemoveActiveNodes;
-(BOOL)isPauseMenuOpened;
@end

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

#import "GameController.h"
#import "cocos2d.h"

/* 
 *iPhone4 iPod (Retina) and iPad must use same FONT (myLQ_HD.fnt) file, implies that they use same SPRITE SHEET files (myLQ_HD.plist myLQ_HD.png)!
 */
@implementation GameController

static GameController *sharedGameController = nil;

@synthesize fontFile, spriteFile, spritePlist;

+(GameController *)sharedGameController{
    @synchronized(self)
    {
        if (sharedGameController == nil) {
            sharedGameController = [[self alloc] init];
        }
        return sharedGameController;
    }    
    return nil;
}

- (id)init 
{
    self = [super init];
    if (self) {
        
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        //Initialize GLOBALS
        NSString *deviceType = [[UIDevice currentDevice] model];
        CCLOG(@"%@",deviceType);
        
        if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
            //                                  POINTS      PIXELS
            //      iPhone 3GS or older [1]     480×320     480×320
            //      iPhone4 in LowRes mode [2]	480×320     480×320
            //      iPhone4 in HighRes mode [2]	480×320     960×640
             
            CCLOG(@"DEVICE TYPE: %@", deviceType);
            if([[CCDirector sharedDirector] enableRetinaDisplay:YES] ) {
                //
                // RETINA DISPLAY
                //
                CCLOG(@"Retina Display supported. Font and sprite sheets are loading accordingly...");
                fontFile = @"myLQ_HD.fnt";  
                spritePlist = @"myLQ_HD.plist";
                spriteFile = @"myLQ_HD.png";
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"levelSpriteSheet_HD.plist"];
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"additionalSpriteSheet_HD.plist"];
                
            }else {
                //
                // NON RETINA DISPLAY
                //
                CCLOG(@"Non Retina Display supported. Font and sprite sheets are loading accordingly...");
                fontFile = @"myLQ.fnt";    
                spritePlist = @"myLQ.plist";
                spriteFile = @"myLQ.png";
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"levelSpriteSheet.plist"];
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"additionalSpriteSheet.plist"];
            }
        }else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
            //                                  POINTS      PIXELS            
            //      iPad                        1024×768	1024×768
            
            CCLOG(@"DEVICE TYPE: %@", deviceType);
            if([[CCDirector sharedDirector] enableRetinaDisplay:YES] ) {
                //
                // RETINA DISPLAY
                //
                CCLOG(@"Retina Display supported. Font and sprite sheets are loading accordingly...");
                fontFile = @"myLQ_IPAD_HD.fnt";  
                spritePlist = @"myLQ_IPAD_HD.plist";
                spriteFile = @"myLQ_IPAD_HD.png";
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"levelSpriteSheet_IPAD_HD.plist"];
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"additionalSpriteSheet_IPAD_HD.plist"];
                
            }else {
                //
                // NON RETINA DISPLAY
                //
                CCLOG(@"Non Retina Display supported. Font and sprite sheets are loading accordingly...");
                fontFile = @"myLQ_HD.fnt";    
                spritePlist = @"myLQ_HD.plist";
                spriteFile = @"myLQ_HD.png";
                
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"levelSpriteSheet_HD.plist"];
                [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"additionalSpriteSheet_HD.plist"];
            }
        }else {
            CCLOG(@"UNRECOGNISED DEVICE NAME");
            exit(1);
        }

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spritePlist];
    }
    return self;
}

- (void)dealloc 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}
@end


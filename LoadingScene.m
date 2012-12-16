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

#import "LoadingScene.h"
#import "GameController.h"
#import "GameState.h"
#import "RandomChar.h"

@implementation LoadingScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	LoadingScene* layer = [LoadingScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:-10];
        
        GameController *gc = [GameController sharedGameController];
        //NSString *tmp = @"xxxxxlxxcxoxtixaxepxdxXhxixtexnxxrxgxxxx";
        //NSString *tmp = @"xxxxxxxxcxxxtixxxepxxxXhxxxtexxxxrxxxxxx";
        NSString *tmp = @"xxxxxxtxcxxrtixxxepxxxXhxxetexxnxrxxxxxx";
        NSInteger num = 0;
        for(int i = 0; i < 8; i++) {
            for(int j = 0; j < 5; j++) {
                switch ([tmp characterAtIndex:num]) {
                    case 'x':{
                        NSString *bok = [NSString stringWithFormat:@"%c.png" , [tmp characterAtIndex:num]];
                        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:bok];
                        sprite.position = ccp(i * gc.TILE_8x5_WIDTH_IN_POINTS + gc.TILE_8x5_WIDTH_IN_POINTS / 2,j * gc.TILE_8x5_HEIGHT_IN_POINTS + gc.TILE_8x5_HEIGHT_IN_POINTS / 2);
                        sprite.opacity = 8;
                        [self addChild:sprite z:0];
                    } 
                        break;
                    case 'X':{
                        NSString *bok = @"x.png";
                        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:bok];
                        sprite.position = ccp(i * gc.TILE_8x5_WIDTH_IN_POINTS + gc.TILE_8x5_WIDTH_IN_POINTS / 2,j * gc.TILE_8x5_HEIGHT_IN_POINTS + gc.TILE_8x5_HEIGHT_IN_POINTS / 2);
                        [self addChild:sprite z:0];
                    } 
                        break;
                        
                    default:
                    {
                        NSString *bok = [NSString stringWithFormat:@"%c.png" , [tmp characterAtIndex:num]];
                        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:bok];
                        sprite.position = ccp(i * gc.TILE_8x5_WIDTH_IN_POINTS + gc.TILE_8x5_WIDTH_IN_POINTS / 2,j * gc.TILE_8x5_HEIGHT_IN_POINTS + gc.TILE_8x5_HEIGHT_IN_POINTS / 2);
                        [self addChild:sprite z:0];
                    }
                        break;
                }
                num++;
            }
        }
    }
    
    self.isTouchEnabled = NO;
    
    return self;
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

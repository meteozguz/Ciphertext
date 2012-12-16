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

#import "RandomChar.h"
#import "GameController.h"

@interface RandomChar() {
    RandomChar *leftChar;
    SEL updateSelector;
    ccTime DURATION_waitingLeftCharForFadeInAction;
}

@end

@implementation RandomChar

@synthesize leftChar;

+(id)randomCharWithParentNode:(CCNode*)parentNode
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}

-(id)initWithParentNode:(CCNode*)parentNode
{
    
    CCLOG(@"===========================================");
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    char letter = 97 + (int)(CCRANDOM_0_1() * 26);
    NSString *tmp = [NSString stringWithFormat:@"%c.png",letter];
    
    DURATION_waitingLeftCharForFadeInAction = 0;
    
    self = [super initWithSpriteFrameName:tmp];
    if (self) {        
        [self schedule:@selector(updateRandom)];
        [parentNode addChild:self z:0];
    }
    return self;
}

+(id)randomCharWithParentNode:(CCNode*)parentNode andWithSelector:(SEL)selector
{
    return [[[self alloc] initWithParentNode:parentNode andWithSelector:selector] autorelease];
}

-(id)initWithParentNode:(CCNode*)parentNode andWithSelector:(SEL)selector
{
    self = [self initWithParentNode:parentNode];
    if (self) {
        CCLOG(@"===========================================");
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        updateSelector = selector;
        [self unscheduleAllSelectors];
        [self schedule:selector];
    }
    return self;
}

-(void)updateRandom
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [self unscheduleAllSelectors];
    
    char letter = 97 + (int)(CCRANDOM_0_1() * 26);
    NSString *tmp = [NSString stringWithFormat:@"%c.png",letter];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                            spriteFrameByName:tmp];
    [self setDisplayFrame:frame];
    
    ccTime fadingInTime = 0.5 + CCRANDOM_0_1() * 3;
    ccTime fadingOutTime =  0.5 + CCRANDOM_0_1() * 3;
    
    time = fadingInTime + fadingOutTime;
    
    CCFiniteTimeAction *act1 = [CCFadeIn actionWithDuration:fadingInTime];
    CCFiniteTimeAction *act2 = [CCFadeOut actionWithDuration:fadingOutTime];
    
    [self runAction:[CCSequence actions:act1, act2, nil]];
    
    [self schedule:@selector(updateRandom) interval:time];
}

-(void)updateRandomForTrailer1
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [self unscheduleAllSelectors];
    
    char letter = 97 + (int)(CCRANDOM_0_1() * 26);
    NSString *tmp = [NSString stringWithFormat:@"%c.png",letter];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                            spriteFrameByName:tmp];
    [self setDisplayFrame:frame];
    self.opacity = 0;
    
    ccTime fadingInTime = 0.5 + CCRANDOM_0_1() * 3;
    ccTime fadingOutTime =  0.5 + CCRANDOM_0_1() * 3;
    
    time = fadingInTime + fadingOutTime;
    
    CCFiniteTimeAction *act1 = [CCFadeTo actionWithDuration:fadingInTime opacity:32]; // MAX OPACITY CONFIG !!!
    CCFiniteTimeAction *act2 = [CCFadeTo actionWithDuration:fadingOutTime opacity:0];
    
    [self runAction:[CCSequence actions:act1, act2, nil]];
    
    [self schedule:@selector(updateRandomForTrailer1) interval:time];
}

-(void)startToWaitLeftCharForFadeInAction:(RandomChar *)rndChar withDuration:(ccTime)duration
{
    self.leftChar = rndChar;
    DURATION_waitingLeftCharForFadeInAction = duration;
    if (self.leftChar == nil) {
        [self runAction:[CCFadeIn actionWithDuration:duration]];
    }else{
        [self schedule:@selector(waitingLeftCharForFadeInAction)];
    }
}

-(void)waitingLeftCharForFadeInAction
{
        if (self.leftChar.opacity == 255) {
        self.opacity = 0;
        [self runAction:[CCFadeIn actionWithDuration:DURATION_waitingLeftCharForFadeInAction]];
        [self unschedule:@selector(waitingLeftCharForFadeInAction)];
    }
}

- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}
@end

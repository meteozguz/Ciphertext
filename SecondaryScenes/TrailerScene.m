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

#import "TrailerScene.h"
#import "GameController.h"
#import "RandomChar.h"
#import "LevelScene.h"
#import "GameState.h"

@interface TrailerScene()
{
    NSUInteger TILE_8x5_WIDTH_IN_POINTS;
    NSUInteger TILE_8x5_HEIGHT_IN_POINTS;
    
    NSUInteger widthSize;
    NSUInteger heightSize;
    
    ccTime MAIN_TIME;
    ccTime STRING_TIME;
    
    CCArray *table;
    CCArray *alteredObjectsInTable;
    
    CCSpriteFrame *frame;

}

@end

@implementation TrailerScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	TrailerScene* layer = [TrailerScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    self = [super init];
	if (self) {
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(22, 34, 31, 255)];
        [self addChild:background z:-10];
        
         TILE_8x5_WIDTH_IN_POINTS = 32;
         TILE_8x5_HEIGHT_IN_POINTS = 48;
        
         widthSize = 32;
         heightSize = 16;
        
        MAIN_TIME = 0;
        STRING_TIME = 0;
        
        table = [[CCArray alloc] initWithCapacity:widthSize * heightSize];
        alteredObjectsInTable = [[CCArray alloc] initWithCapacity:0];
        
        NSInteger counter = 0;
        for(int j = 0; j < heightSize; j++) {
            for(int i = 0; i < widthSize; i++) {
                
                RandomChar *rndChar = [RandomChar randomCharWithParentNode:self andWithSelector:@selector(updateRandomForTrailer1)];
                rndChar.scale = 0.5;
                rndChar.position = ccp(i * TILE_8x5_WIDTH_IN_POINTS + TILE_8x5_WIDTH_IN_POINTS / 2,j * TILE_8x5_HEIGHT_IN_POINTS + TILE_8x5_HEIGHT_IN_POINTS / 2);
                
                [table addObject:rndChar];
                counter++;
            }
        }
    }   
    self.isTouchEnabled = NO;
   [self schedule:@selector(phase1:)]; // SCENE #1
     [self schedule:@selector(phase19:)]; // HAPPY 19TH MAY SCENE #1
       //     [self schedule:@selector(phase20:)]; // HAPPY 19TH MAY SCENE #2
 //   [self schedule:@selector(phase8:)]; // SCENE #2
    return self;
}

-(void)phase19:(ccTime)dt
{
    MAIN_TIME += dt;
    if (MAIN_TIME > 1) {
        // TURK BAYRAGI
        int l = 13;
        //        [self putString:@"    #####          " atLine:l withDuration:0.1];
        //        [self putString:@"  #########        " atLine:l-1 withDuration:0.1];
        //        [self putString:@" #####    #  #     " atLine:l-2 withDuration:0.1];
        //        [self putString:@" ####        ##  ##" atLine:l-3 withDuration:0.1];
        //        [self putString:@"####         ##### " atLine:l-4 withDuration:0.1];
        //        [self putString:@"####        #####  " atLine:l-5 withDuration:0.1];
        //        [self putString:@"####      #######  " atLine:l-6 withDuration:0.1];
        //        [self putString:@"####        ###### " atLine:l-7 withDuration:0.1];
        //        [self putString:@"####         ######" atLine:l-8 withDuration:0.1];
        //        [self putString:@" ####        ##  ##" atLine:l-9 withDuration:0.1];
        //        [self putString:@" #####    #  #     " atLine:l-10 withDuration:0.1];
        //        [self putString:@"  #########        " atLine:l-11 withDuration:0.1];
        //        [self putString:@"    ######          " atLine:l-12 withDuration:0.1];
        
        [self putString:@"    RRRRR          " atLine:l withDuration:0.2];
        [self putString:@"  RRRRRRRRR        " atLine:l-1 withDuration:0.1];
        [self putString:@" RRRRR    R  R     " atLine:l-2 withDuration:0.3];
        [self putString:@" RRRR        RR  RR" atLine:l-3 withDuration:0.1];
        [self putString:@"RRRR         RRRRR " atLine:l-4 withDuration:0.05];
        [self putString:@"RRRR        RRRRR  " atLine:l-5 withDuration:0.1];
        [self putString:@"RRRR      RRRRRRR  " atLine:l-6 withDuration:0.1];
        [self putString:@"RRRR        RRRRRR " atLine:l-7 withDuration:0.05];
        [self putString:@"RRRR         RRRRRR" atLine:l-8 withDuration:0.1];
        [self putString:@" RRRR        RR  RR" atLine:l-9 withDuration:0.05];
        [self putString:@" RRRRR    R  R     " atLine:l-10 withDuration:0.1];
        [self putString:@"  RRRRRRRRR        " atLine:l-11 withDuration:0.2];
        [self putString:@"    RRRRRR          " atLine:l-12 withDuration:0.3];
        
        [self unschedule:@selector(phase19:)];
    }
}  

-(void)phase20:(ccTime)dt
{
        [self putString:@"19 mayis atatUrk'U anma" atLine:12 withDuration:0.2];
    [self putString:@"genClIk ve spor bayramimiz" atLine:10 withDuration:0.2];
    [self putString:@"kutlu olsun" atLine:8 withDuration:0.2];
        [self unschedule:@selector(phase20:)];

}  

-(void)phase1:(ccTime)dt
{
    MAIN_TIME += dt;
    if (MAIN_TIME > 1) {
//        if (MAIN_TIME > 10) { // features scene 
//        [self putString:@"featuring            " atLine:11 withDuration:0.1];
//        [self putString:@"abilities" atLine:9 withDuration:0.1];
//        [self putString:@"difficulty levels" atLine:9 withDuration:0.01];
//        [self putString:@"portals" atLine:9 withDuration:0.1];
//        [self putString:@"40 unique levels" atLine:9 withDuration:0.03];
//        [self putString:@"and lots of lots of mines" atLine:7 withDuration:0.03];
//        [self putString:@"ciphertext" atLine:11 withDuration:0.03];
//        [self putString:@"collect clues" atLine:11 withDuration:0.01];
//        [self putString:@"and" atLine:9 withDuration:0.1];
//        [self putString:@"and decrypt the ciphertext" atLine:7 withDuration:0.01];
//        [self putString:@"ciphertext" atLine:11 withDuration:0.5];
        //        [self putString:@"a brand-new puzzle game" atLine:9 withDuration:0.1];
        //        [self schedule:@selector(phase2:)];
        
        [self unschedule:@selector(phase1:)];
    }
}

-(void)phase2:(ccTime)dt
{
    MAIN_TIME += dt;
    if (MAIN_TIME > 2) {
        [self putString:@"based on" atLine:7 withDuration:0.5];
        [self putString:@"mine...you know the rest)" atLine:5 withDuration:0.1];
        [self unschedule:@selector(phase2:)];
        [self schedule:@selector(phase3:) interval:6];
    }    
}

-(void)phase3:(ccTime)dt
{
    [self clearAltereds];
    
    [self putString:@"i nn  n" atLine:13 withDuration:0.1 andMarkingAsUnaltered:YES];
    [self putString:@"i n n n" atLine:12 withDuration:0.1 andMarkingAsUnaltered:YES];
    [self putString:@"i n  nn" atLine:11 withDuration:0.1 andMarkingAsUnaltered:YES];
    
    [self putString:@"3333333" atLine:8 withDuration:0.05];
    [self putString:@"      3" atLine:7 withDuration:0.25];
    [self putString:@"      3" atLine:6 withDuration:0.25];
    [self putString:@"  33333" atLine:5 withDuration:0.05];
    [self putString:@"      3" atLine:4 withDuration:0.25];
    [self putString:@"      3" atLine:3 withDuration:0.25];
    [self putString:@"3333333" atLine:2 withDuration:0.05];

    
    [self unschedule:@selector(phase3:)];
    [self schedule:@selector(phase4:) interval:1.2];
}

-(void)phase4:(ccTime)dt
{
    [self clearAltereds];
    
    [self putString:@"2222222" atLine:8 withDuration:0.1];
    [self putString:@"      2" atLine:7 withDuration:0.25];
    [self putString:@"      2" atLine:6 withDuration:0.25];
    [self putString:@"2222222" atLine:5 withDuration:0.1];
    [self putString:@"2      " atLine:4 withDuration:0.25];
    [self putString:@"2      " atLine:3 withDuration:0.25];
    [self putString:@"2222222" atLine:2 withDuration:0.1];
    
    [self unschedule:@selector(phase4:)];
    [self schedule:@selector(phase5:) interval:1.2];
}

-(void)phase5:(ccTime)dt
{
    [self clearAltereds];
    
    [self putString:@"  11   " atLine:8 withDuration:0.142];
    [self putString:@"   1   " atLine:7 withDuration:0.25];
    [self putString:@"   1   " atLine:6 withDuration:0.25];
    [self putString:@"   1   " atLine:5 withDuration:0.142];
    [self putString:@"   1   " atLine:4 withDuration:0.25];
    [self putString:@"   1   " atLine:3 withDuration:0.25];
    [self putString:@"1111111" atLine:2 withDuration:0.142];
    
    [self unschedule:@selector(phase5:)];
    [self schedule:@selector(phase6:) interval:1.2];
}

-(void)phase6:(ccTime)dt
{
    [self clearAltereds];
    
    [self putString:@" 00000 " atLine:8 withDuration:0.142];
    [self putString:@"0     0" atLine:7 withDuration:0.25];
    [self putString:@"0     0" atLine:6 withDuration:0.25];
    [self putString:@"0     0" atLine:5 withDuration:0.142];
    [self putString:@"0     0" atLine:4 withDuration:0.25];
    [self putString:@"0     0" atLine:3 withDuration:0.25];
    [self putString:@" 00000 " atLine:2 withDuration:0.142];
    
    [self unschedule:@selector(phase6:)];
    [self schedule:@selector(phase7:) interval:1];
}

-(void)phase7:(ccTime)dt
{
    [[GameState sharedGameState] setCurrentLevelID:5];
    CCTransitionSlideInT* transition = [CCTransitionSlideInT transitionWithDuration:0.5 scene:[LevelScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition];
}

//
//  SCENE #2
//
-(void)phase8:(ccTime)dt
{
    [self putString:@"featuring            " atLine:11 withDuration:0.1];
    [self putString:@"       abilities     " atLine:9 withDuration:0.1];
    //[self putString:@"       portals     " atLine:9 withDuration:0.1];
    //[self putString:@"       portals     " atLine:9 withDuration:0.1];
    [self unschedule:@selector(phase8)];
 //   [self schedule:@selector(phase9:) interval:1];
}

-(void)clearAltereds
{
    for (RandomChar *rndChar in alteredObjectsInTable) {
        [rndChar schedule:@selector(updateRandomForTrailer1)];
    }
    [alteredObjectsInTable removeAllObjects];
}

-(void)putString:(NSString *)string atLine:(NSUInteger)line withDuration:(ccTime)duration andMarkingAsUnaltered:(BOOL)yeah
{
    [self putString:string atLine:line withDuration:duration];
    if (yeah == YES) {
        [alteredObjectsInTable removeAllObjects];
    }
}

/*
 *  Allignment: CENTER
 *
 * LINE ...
 * LINE 4
 * LINE 3
 * LINE 2
 * LINE 1
 * LINE 0
 */
-(void)putString:(NSString *)string atLine:(NSUInteger)line withDuration:(ccTime)duration
{
    NSUInteger startingIndex = [self calculateStartingIndexForCenteredAlignmentUsingString:string andUsingLine:line];
    NSString *tmp;
    NSUInteger leftCharIndex = -1;
    for (int i = 0; i < [string length]; i++) {
        switch ([string characterAtIndex:i]) {
            case ' ':
                break;
            default:
            {                    
                switch ([string characterAtIndex:i]) {
                    case '\'':
                        tmp = @"singleQuote.png";
                        break;
                    case '.':
                        tmp = @"point.png";
                        break;
                    case 'U':
                        tmp = @"uu.png";
                        break;
                    case 'I':
                        tmp = @"ii.png";
                        break;
                    case 'C':
                        tmp = @"cc.png";
                        break;
                    case '#':
                        tmp = @"cursor.png";
                        break; 
                    case 'R': // R for RANDOM
                    {
                        char letter = 97 + (int)(CCRANDOM_0_1() * 26);
                        tmp = [NSString stringWithFormat:@"%c.png",letter];
                        
//                        CCFiniteTimeAction *act1 = [CCFadeTo actionWithDuration:1 opacity:255];
//                        CCFiniteTimeAction *act2 = [CCFadeTo actionWithDuration:1 opacity:128];
//                        id action2 = [CCRepeatForever actionWithAction:
//                                      [CCSequence actions: act1, act2, nil]];
//                        [rndChar runAction:action2];
                    }
                        break; 
                    default:
                        tmp = [NSString stringWithFormat:@"%c.png",[string characterAtIndex:i]];
                        break;
                }
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:tmp];
                
                RandomChar *rndChar = (RandomChar *)[table objectAtIndex:startingIndex+i];
                                
                [rndChar setDisplayFrame:frame];
                
                [rndChar stopAllActions];
                [rndChar unscheduleAllSelectors];
                
                [alteredObjectsInTable addObject:rndChar];
                
                if (i != 0 && leftCharIndex != -1) {
                    [rndChar startToWaitLeftCharForFadeInAction:(RandomChar *)[table objectAtIndex:startingIndex+leftCharIndex] withDuration:duration];
                } else {
                    [rndChar startToWaitLeftCharForFadeInAction:nil withDuration:duration];
                } 
                leftCharIndex = i;
            }
                break;
        }
    }
}

-(NSUInteger)calculateStartingIndexForCenteredAlignmentUsingString:(NSString *)string andUsingLine:(NSUInteger)line
{
    NSUInteger lineOffset = (widthSize - [string length])/2;
    
    return line * widthSize + lineOffset;
}

@end

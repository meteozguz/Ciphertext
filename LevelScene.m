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

#import "LevelScene.h"
#import "DecryptionKeyScene.h"
#import "Tags.h"

#import "LevelCompleteScene.h"
#import "LevelExtras.h"
#import "Tile.h"
#import "Level.h"
#import "LevelHelper.h"

#import "Player.h"
#import "PauseMenu.h"
#import "AbilityMenu.h"
#import "GameState.h"
#import "GameController.h"

const GLubyte TILE_OPACITY_CONSTANT = 4.0;

@interface LevelScene()
{
    Player *player;
    GameController *gc; 
    GameState *gs;
    LevelHelper *levelHelper;
    CCArray *tiles;
    CCArray *mines;
    // CCArray *meditationMineCountDisplays;
    CCLabelBMFont *title;
    CCLabelBMFont *loseTitle;
    PauseMenu *pauseMenu;
    AbilityMenu *abilityMenu;
    ccTime timeElapsed;
    NSDictionary *portalDictionary; // this dictionary is used to move between portals
    
    NSString *fuckingLvl33mineCountDisplaysString;
    NSString *numberOfHolesInTiles;
    CGSize winSize;
    
    ccColor4F lineColor4F;
    BOOL drawLine;
}

-(void)addLevelExtras:(NSInteger)level;

@end

@implementation LevelScene

+(id) scene
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	LevelScene* layer = [LevelScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self = [super init];
	if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showBanner" object:self];
        
        self.isTouchEnabled = YES;
        
        winSize = [[CCDirector sharedDirector] winSize];
        gc = [GameController sharedGameController]; 
        
        timeElapsed = 0.0;
        
        CCLayerColor *background = [CCLayerColor layerWithColor:[GameState sharedGameState].backgroundColor];
        [self addChild:background z:Z_ORDER_BACKGROUND];
        
        [Level sharedLevel];
        [self addLevelTitle];        
        [self addGameOverTitle];        
        [self addAbilityMenu];        
        [self addPauseMenu];
        [self addPlayer];
        [self addTiles];
        [self setPlayerPositionAndSize];
        
        [self addLevelExtras:[[Level sharedLevel] getID]];
        [self setLineColor];
        [self schedule:@selector(checkPlayer:)];
        
       // [self schedule:@selector(updateForBanner:) interval:5];
	}
	return self;
}

//-(void)updateForBanner:(ccTime)dt
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideBanner" object:self];
//    [self unschedule:@selector(updateForBanner:)];
//}

-(void)setLineColor
{
    if ([[[GameState sharedGameState] getDifficulty] isEqualToString:@"Nightmare"]) {
        drawLine = NO;
    }else {
        drawLine = YES;        
    }
    ccColor4B lineColor4B = ccc4(61, 255, 12, 255);
    lineColor4F = ccc4FFromccc4B(lineColor4B);
}

-(void)addPlayer
{
    player = [Player playerWithParentNode:self];
    player.tag = TAG_PLAYER;
    
     NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
        if ([[Level sharedLevel] getID] >= 21) {
            player.scale = 0.8;
        }
        
    }
}

-(void)setPlayerPositionAndSize
{
    Tile *tile = [tiles objectAtIndex:[[Level sharedLevel] getStartIndex]];
    [player setTileSize:[tile getSize]];
    player.position = tile.position;
}

-(void)addTiles
{
    levelHelper = [LevelHelper levelHelper];  
    
    tiles = [[CCArray alloc] initWithCapacity:[[Level sharedLevel] getNumberOfTiles]];
    mines = [[CCArray alloc] initWithCapacity:0];
    
    NSUInteger index = 0;
    Tile *tile;
    
    
    NSUInteger tileWidthInCCP = [levelHelper getTileWidthInCCP];
    NSUInteger tileHeightInCCP = [levelHelper getTileHeightInCCP];
    
    // Temporary arrays for initializing Portal Tiles Dictionary
    NSMutableArray *portalObjects = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *portalKeys = [NSMutableArray arrayWithCapacity:0];
    
    for(int j = 0; j < [[Level sharedLevel] getSizeInTiles].height; j++) {
        for(int i = 0; i < [[Level sharedLevel] getSizeInTiles].width; i++) {
            char type = [[[Level sharedLevel] getMap] characterAtIndex:index];
            
            NSArray *minePngArray = [levelHelper createMinePngArrayAtIndex:index]; 
            
            tile = [Tile tileWithSpriteFrameNameArray:minePngArray andType:type];
            
            // grouping tile 
            if ([tile getType] == 'x') {
                [mines addObject:tile];
            }
            if (type >= 97 && type <= 112) { // ASCII {a,b,...,p}
                [portalObjects addObject:tile];
                [portalKeys addObject:[NSString stringWithFormat:@"%c", type]];
            }
            
            [tile setBoundingBox:CGRectMake(i*tileWidthInCCP, j*tileHeightInCCP, tileWidthInCCP, tileHeightInCCP)];
            
            CCLOG(@"TILE #%d boundingBox: %f %f %f %f",index, [tile getBoundingBox].origin.x,[tile getBoundingBox].origin.y,[tile getBoundingBox].size.width,[tile getBoundingBox].size.height);
            
            tile.position = ccp([tile getBoundingBox].origin.x + tileWidthInCCP / 2, [tile getBoundingBox].origin.y + tileHeightInCCP / 2);
            
            CCLOG(@"TILE #%d position: %f %f ",index, tile.position.x, tile.position.y);
            
            tile.opacity = 0;
            
            if ([tile getType] == '2') {
                if(![[[GameState sharedGameState] getDifficulty] isEqualToString:@"Nightmare"]) {
                    tile.opacity = 255;
                }
            }
            
             NSString *deviceType = [UIDevice currentDevice].model;
            if([deviceType rangeOfString:@"iPhone"].location != NSNotFound || [deviceType rangeOfString:@"iPod"].location != NSNotFound) {
                if ([[Level sharedLevel] getID] >= 21) {
                tile.scale = 0.8;
                }
            }
            
            [tiles addObject:tile];
            [self addChild:tile];
            index++;
        }
    }
    // this dictionary is used to move between portals
    portalDictionary = [[NSDictionary alloc]  initWithObjects:portalObjects forKeys:portalKeys];
}

-(void) addLevelTitle
{
    title  = [CCLabelBMFont labelWithString:NSLocalizedString([[Level sharedLevel] getTitle],nil) fntFile:gc.fontFile];
    title.position = ccp(winSize.width / 2, winSize.height / 1.25);
    while (title.boundingBox.size.width > winSize.width) {
        title.scale -= 0.1;
    }
    [title runAction:[CCFadeOut actionWithDuration:2]];
    [self addChild:title z:Z_ORDER_LEVEL_TITLE];
}

-(void) addGameOverTitle
{
    loseTitle  = [CCLabelBMFont labelWithString:NSLocalizedString(@"YOUR HOPES FADED OUT", nil) fntFile:gc.fontFile];
    loseTitle.position = ccp(winSize.width / 2, winSize.height / 1.25);
    loseTitle.opacity = 0;
    loseTitle.scale = 0.5;
    loseTitle.visible = NO;        
    [self addChild:loseTitle z:Z_ORDER_LEVEL_TITLE];
}

-(void) addAbilityMenu
{
    if ([[Level sharedLevel] hasAbility]) {
        abilityMenu = [AbilityMenu abilityMenuWithParentNode:self];
        abilityMenu.position = ccp(0,0);
        abilityMenu.visible = NO;
    }
}

-(void) addPauseMenu
{
    pauseMenu = [PauseMenu pauseMenuWithParentNode:self];
    pauseMenu.position = ccp(0,0);
    pauseMenu.visible = NO;
}

-(void)addLevelExtras:(NSInteger)level
{ 
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    switch (level) {
        case 0: {   
            [Lvl0 Lvl0WithParentNode:self];
            break;
        }    
        case 1: {   
            [Lvl1 Lvl1WithParentNode:self];
            self.isTouchEnabled = NO;
            break;
        }  
        case 7: {   
            [Lvl7 Lvl7WithParentNode:self];
            break;
        }  
        case 11: {   
            [Lvl11 Lvl11WithParentNode:self];
            break;
        }  
        case 33: {   
            [Lvl33 Lvl33WithParentNode:self];
            break;
        }  
    }
}


-(void) playerDied
{    
    [self unschedule:@selector(checkPlayer:)];
    
    loseTitle.opacity = 255;
    loseTitle.visible = YES;
    id act1 = [CCFadeIn actionWithDuration:1];
    [loseTitle runAction:act1];
    
    self.isTouchEnabled=NO;
    
    CCMenuItemLabel *tmp = (CCMenuItemLabel *)[pauseMenu.menu getChildByTag:TAG_MENU_ITEM_CONTINUE]; // returns CCNode*
    tmp.visible = NO;
    
    [self openMenu]; 
}

-(void)checkPlayer:(ccTime)delta
{
    timeElapsed += delta;
    
    //CHENCKING PLAYER STATUS
    if ([player died]) {
        [self playerDied];
    }
    if ([player won]) {
        [self playerWon];
    }
    if ([player usedCrossPass]) {
        [abilityMenu removeLastSelectedItem];        
    }
}

-(NSUInteger)getNumberOfExploredTiles
{
    NSUInteger numberOfDiscoveredTiles = 0;
    for (Tile *tile in tiles) {
        if ([tile isDiscoveredByPlayer]) {
            numberOfDiscoveredTiles++;
        }
    }
    return numberOfDiscoveredTiles;
}

-(void)playerWon
{  
    [self unschedule:@selector(checkPlayer:)];
    CCTransitionSlideInR* transition;
    [[GameState sharedGameState] updateLevelDataWithTimeElapsed:timeElapsed withMoveCount:[player numberOfMoves] andWithOpenedTilesCount:[self getNumberOfExploredTiles]];

    transition = [CCTransitionSlideInR transitionWithDuration:0.5 scene:[LevelCompleteScene scene]];
    [[CCDirector sharedDirector] replaceScene:transition]; 
}

-(void)closeMenu
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    self.isTouchEnabled = YES;
    
    pauseMenu.menu.isTouchEnabled = NO;
    pauseMenu.visible = NO;
    abilityMenu.menu.isTouchEnabled = NO;
    abilityMenu.visible = NO;
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"PauseMenuClosed" object:nil];
    [self updateUIforClosedMenu];
}

-(void)openMenu
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    self.isTouchEnabled = NO;
    
    pauseMenu.menu.isTouchEnabled = YES;
    pauseMenu.visible = YES;
    
    if (![player died]) {
        abilityMenu.menu.isTouchEnabled = YES;
        abilityMenu.visible = YES;
    }
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"PauseMenuOpened" object:nil];
    [self updateUIforOpenedMenu];
}

-(void)updateUIforClosedMenu
{
    lineColor4F.a = 1.0;
    for (Tile *tile in tiles) {
        tile.opacity = tile.opacity * TILE_OPACITY_CONSTANT;
        [tile resumeSchedulerAndActions];
    }  
}

-(void)updateUIforOpenedMenu
{
    lineColor4F.a = 0.1;
    for (Tile *tile in tiles) {
        [tile pauseSchedulerAndActions];
        tile.opacity = tile.opacity / TILE_OPACITY_CONSTANT;
    } 
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [fuckingLvl33mineCountDisplaysString release];
    [[Level sharedLevel] release];
    [levelHelper release];
    [portalDictionary release];
    [tiles release];
    [mines release];
	[super dealloc];
}

- (void)registerWithTouchDispatcher
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{	
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(CGRectContainsPoint(player.boundingBox, location)) {
        [self openMenu];
	}else {
        [player tryToMoveToCCP:location];
    }	
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

-(void)draw
{    
    if(drawLine){
        glEnable(GL_LINE_SMOOTH);
        // glColor4f(0.0, 0.0, 0.0, 1.0);
        glColor4f(lineColor4F.a * lineColor4F.r, lineColor4F.a * lineColor4F.g, lineColor4F.a * lineColor4F.b, lineColor4F.a);
        
        for(int j = 1; j <  [[Level sharedLevel] getSizeInTiles].height; j++) {
            ccDrawLine( ccp(0, j * [levelHelper getTileHeightInCCP]), ccp(winSize.width, j * [levelHelper getTileHeightInCCP]) );
        }
        for(int i = 1; i < [[Level sharedLevel] getSizeInTiles].width; i++) {
            ccDrawLine( ccp(i*[levelHelper getTileWidthInCCP], 0), ccp(i*[levelHelper getTileWidthInCCP], winSize.height) );
        }
    }
}

-(CCArray *)getTiles
{
    return tiles;
}

-(CCArray *)getMines
{
    return mines;
}

-(NSDictionary *)getPortals
{
    return portalDictionary;
}

-(void)useMeditation
{
    for (Tile *tile in tiles) {
        if (CGPointEqualToPoint(player.position, tile.position)) {
            NSAssert(levelHelper != nil, @"LevelHelper is nil");
            CCLOG(@"TILE index: %d",[levelHelper convertCCPtoIndex:tile.position]);
            NSUInteger mineCount = [levelHelper getMineCountForMeditationAtIndex:[levelHelper convertCCPtoIndex:tile.position]];
            
            [tile useMeditationWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",mineCount]];
            break;
        }
    }
}

-(NSUInteger)getPlayerPositionAsIndex
{
    return [levelHelper convertCCPtoIndex:player.position];
}

-(Player *)getPlayer
{
    return player;
}

-(AbilityMenu *)getAbilityMenu
{
    return abilityMenu;
}
@end

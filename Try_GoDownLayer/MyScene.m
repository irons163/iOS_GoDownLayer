//
//  MyScene.m
//  Try_GoDownLayer
//
//  Created by irons on 2015/5/6.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "MoveableFloor.h"
#import "Player.h"
#import "TextureHelper.h"
#import "MyADView.h"
#import "GameCenterUtil.h"
#import "Enemy.h"

int FOOTBOARD_SPEED = 3;
float DOWNSPEED = 12;

int star_type = 0;
int star_specail_type = 1;

@implementation MyScene {
    bool isGameRun;
    NSMutableArray *floorsTexture;
    NSMutableArray *enemyTexture;
    NSMutableArray *enemyArray;
    NSArray *starsTexture;
    NSMutableArray *starsArray;
    SKLabelNode *starNumLabel;
    SKLabelNode *layerNumLabel;
    MyADView *myAdView;
    SKSpriteNode *rankBtn;
    
    Player *player;
    SKAction *moveAnimation;
    bool isStandOnFootboard;
    NSMutableArray *floorsByLines;
    CGPoint originalPoint;
    bool isFromLeft;
    bool isJumping;
    int floorSpeed;
    bool isBreakFloor;
    int starNum;
    int layerNum;
    int layerIndex;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        isGameRun = YES;
        isFromLeft = YES;
        floorSpeed = FOOTBOARD_SPEED;
        
        floorsTexture = [NSMutableArray array];
        floorsByLines = [NSMutableArray array];
        enemyArray = [NSMutableArray array];
        enemyTexture = [NSMutableArray array];
        starsArray = [NSMutableArray array];
        
        [self initImage];
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        player = [Player spriteNodeWithImageNamed:@"sheep1"];
        
        player.size = CGSizeMake(50, 50);
        player.position = CGPointMake(160, 200);
        originalPoint = player.position;
        player.anchorPoint = CGPointMake(0.5, 0);
        
        SKTexture *sheep1 = [SKTexture textureWithImageNamed:@"sheep1"];
        SKTexture *sheep2 = [SKTexture textureWithImageNamed:@"sheep2"];
        SKTexture *sheep3 = [SKTexture textureWithImageNamed:@"sheep3"];
        moveAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[sheep1,sheep2,sheep3] timePerFrame:0.1]];
        [player runAction:moveAnimation];
        
        [self addChild:player];
        
        starNumLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", starNum]];
        starNumLabel.position  = CGPointMake(self.frame.size.width - 30, 0 + 100);
        starNumLabel.zPosition = 1;
        starNumLabel.name = @"starNumLabel";
        [self addChild:starNumLabel];
        
        layerIndex = 1;
        
        layerNumLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", layerNum]];
        layerNumLabel.position  = CGPointMake(self.frame.size.width - 30, 0 + 165);
        layerNumLabel.zPosition = 1;
        layerNumLabel.name = @"layerNumLabel";
        [self addChild:layerNumLabel];
        
        myAdView = [MyADView spriteNodeWithTexture:nil];
        myAdView.name = @"adView";
        myAdView.size = CGSizeMake(self.frame.size.width, self.frame.size.width / 5.0f);
        myAdView.position = CGPointMake(self.frame.size.width / 2, 0);
        [myAdView startAd];
        myAdView.zPosition = 1;
        myAdView.anchorPoint = CGPointMake(0.5, 0);
        [self addChild:myAdView];
        
        rankBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btnL_GameCenter-hd"];
        rankBtn.name = @"rankBtn";
        rankBtn.size = CGSizeMake(50,50);
        
        rankBtn.position = CGPointMake(rankBtn.size.width / 2.0f, self.frame.size.height - 200);
        rankBtn.zPosition = 1;
        [self addChild:rankBtn];
    }
    return self;
}

- (void)didEvaluateActions {
    float dx = player.position.x - originalPoint.x;
    float dy = player.position.y - originalPoint.y;
    
    for (int i = 0; i < [self children].count; i++) {
        if(dx!=0){
            
        }
        SKNode * n = [self children][i];
        if([n.name isEqualToString:@"starNumLabel"] || [n.name isEqualToString:@"layerNumLabel"] || [n.name isEqualToString:@"adView"] || [n.name isEqualToString:@"rankBtn"])
            continue;
        n.position = CGPointMake(n.position.x - dx, n.position.y - dy);
    }
    player.position = originalPoint;
}

- (void)initImage {
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"bubble_1"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"bubble_2"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"red_point"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"yellow_point"]];
    
    [self initStar];
}

- (void)initStar {
    starsTexture = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"Star"], [SKTexture textureWithImageNamed:@"StarSpecial"], nil];
}

- (void)createStar {
    SKSpriteNode *star;
    int starType = arc4random_uniform(20);
    if (starType == 0) {
        star = [SKSpriteNode spriteNodeWithTexture:(SKTexture*)[starsTexture objectAtIndex:star_specail_type]];
    } else if(star_type <= 10) {
        star = [SKSpriteNode spriteNodeWithTexture:(SKTexture*)[starsTexture objectAtIndex:star_type]];
    }
    
    star.name = @"star";
    
    bool isAlreadyExsitStarInTheSameLine = false;
    
    for (SKSpriteNode *checkStar in starsArray) {
        if (checkStar.position.y == ((MoveableFloor *)[floorsByLines[floorsByLines.count -1] firstObject]).position.y) {
            isAlreadyExsitStarInTheSameLine = true;
            break;
        }
    }
    
    if (!isAlreadyExsitStarInTheSameLine) {
        int randomX = arc4random_uniform(self.frame.size.width);
        star.position = CGPointMake(randomX, ((MoveableFloor*)[floorsByLines[floorsByLines.count -1] firstObject]).position.y);
        
        star.anchorPoint = CGPointMake(0.5, 0);
        [self addChild:star];
        [starsArray addObject:star];
    }
}

- (void)moveStar {
    
    for(int i = 0; i < starsArray.count; i++){
        SKSpriteNode *star = starsArray[i];
        star.position = CGPointMake(star.position.x + floorSpeed, star.position.y);
    }
    
    for(int i = 0; i < starsArray.count; i++){
        SKSpriteNode *star = starsArray[i];
        if(star.position.x < 0 || star.position.x > self.frame.size.width){
            [starsArray removeObject:star];
            [star removeFromParent];
        }
    }
}

- (void)checkAndEatStar {
    
    for(int i = 0; i < starsArray.count; i++){
        SKSpriteNode *star = starsArray[i];
        
        if(CGRectIntersectsRect(star.calculateAccumulatedFrame, player.calculateAccumulatedFrame)){
            [starsArray removeObject:star];
            [star removeFromParent];
            starNum++;
        }
    }
    
    starNumLabel.text = [NSString stringWithFormat:@"%d", starNum];
}

- (void)moveEnemy {
    for(int i = 0; i < enemyArray.count; i++){
        SKSpriteNode *enemy = enemyArray[i];
        enemy.position = CGPointMake(enemy.position.x + floorSpeed, enemy.position.y);
    }
}

- (void)checkAndRemoveEnemy {
    for(int i = 0; i < enemyArray.count; i++){
        SKSpriteNode *enemy = enemyArray[i];
        if(enemy.position.x < 0 || enemy.position.x > self.frame.size.width){
            [enemyArray removeObject:enemy];
            [enemy removeFromParent];
        }
    }
}

- (void)createEnemy {
    int min = 2;
    int max = (int)floorsByLines.count - 1;
    int randomRow = arc4random_uniform(max - min + 1) + min;
    
    float positionY = ((MoveableFloor*)[floorsByLines[randomRow] firstObject]).position.y;
    Enemy *enemy = [Enemy spriteNodeWithTexture:nil];
    [enemy setupWithY:positionY];
    
    [self addChild:enemy];
    [enemyArray addObject:enemy];
}

- (void)breakFloor {
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MySpark" ofType:@"sks"];
    SKEmitterNode *rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    rainEmitter.position = player.position;
    [self addChild:rainEmitter];
    
    NSMutableArray *removeFloors = [NSMutableArray array];
    
    for (int i = 0; i<floorsByLines.count; i++) {
        NSMutableArray* floorArray = floorsByLines[i];
        int index = 0;
        bool isBreak = false;
        for (int j = 0; j < floorArray.count; j++) {
            MoveableFloor* floor = floorArray[j];
            if(CGRectIntersectsRect(floor.calculateAccumulatedFrame, player.calculateAccumulatedFrame)){
                //                [floor removeFromParent];
                
                index = j-1<0 ? 0:j-1;
                isBreak = true;
                break;
            }
        }
        
        if (isBreak) {
            for (int removeIndex = index; removeIndex < index + 4; removeIndex++) {
                if (removeIndex >= floorArray.count)
                    return;
                [floorArray[removeIndex] removeFromParent];
                [removeFloors addObject:floorArray[removeIndex]];
            }
            [floorArray removeObjectsInArray:removeFloors];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (CGRectContainsPoint(myAdView.calculateAccumulatedFrame, location)) {
            [myAdView touchesBegan:touches withEvent:event];
        } else if (CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)) {
            self.showRankView();
        } else if (!isBreakFloor && isStandOnFootboard) {
            isBreakFloor = true;
        }
    }
}

- (void)createFloorAfterCheck:(NSMutableArray*) floorsInLine positionY:(float)y {
    MoveableFloor *floor;
    if (isFromLeft) {
        floor = [floorsInLine lastObject];
    } else {
        floor = [floorsInLine firstObject];
    }
    
    if (floor != nil && [floor isNeedCreateNewInstance]) {
        [self createFloor:floorsInLine positionY:y];
    }
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionY:(float)y {
    [self createFloor:floorsInLine positionX:0 positionY:y isAutoDeterminePositonX:true];
}

- (void)createFloorWitchIsFirstFloor:(NSMutableArray*) floorsInLine positionY:(float)y {
    [self createFloor:floorsInLine positionX:0 positionY:y isAutoDeterminePositonX:false isAutoDeterminePositonXInFirst:true];
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionX:(float)x positionY:(float)y isAutoDeterminePositonX:(BOOL)isAutoDeterminePositonX {
    [self createFloor:floorsInLine positionX:x positionY:y isAutoDeterminePositonX:isAutoDeterminePositonX isAutoDeterminePositonXInFirst:false];
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionX:(float)x positionY:(float)y isAutoDeterminePositonX:(BOOL)isAutoDeterminePositonX isAutoDeterminePositonXInFirst:(BOOL)isAutoDeterminePositonXInFirst {
    int r = arc4random_uniform(4);
    MoveableFloor* newFloor = [MoveableFloor floorWithTexture:floorsTexture[r] withRangeWidth:self.frame.size.width];
    [newFloor setIsCarStartFromLeft:true];
    
    if (isFromLeft) {
        [newFloor setIsCarStartFromLeft:YES];
        [floorsInLine addObject:newFloor];
        newFloor.name = ((MoveableFloor*)[floorsInLine firstObject]).name;
    } else {
        [newFloor setIsCarStartFromLeft:NO];
        [floorsInLine insertObject:newFloor atIndex:0];
        newFloor.name = ((MoveableFloor*)[floorsInLine lastObject]).name;
    }
    
    if (isAutoDeterminePositonX) {
        [newFloor setPositionYAndAutoDeterminePositionX:y];
    } else if(isAutoDeterminePositonXInFirst){
        [newFloor setPositionYAndAutoPositionXForFirstFloorInLine:y];
        layerIndex++;
        newFloor.name = [NSString stringWithFormat:@"%d", layerIndex];
    } else {
        newFloor.position = CGPointMake(x, y);
    }
    
    newFloor.size = CGSizeMake(20, 20);
    [self addChild:newFloor];
}

- (void)moveFloor {
    for (int i = 0; i < floorsByLines.count; i++) {
        NSMutableArray* floorArray = floorsByLines[i];
        for (int j = 0; j < floorArray.count; j++) {
            MoveableFloor* floor = floorArray[j];
            [floor move:floorSpeed];
        }
    }
}

- (void)removeFloor {
    NSMutableArray *removeFloors = [NSMutableArray array];
    for (int i = 0; i < floorsByLines.count; i++) {
        NSMutableArray *floorArray = floorsByLines[i];
        for (int j = 0; j < floorArray.count; j++) {
            MoveableFloor* floor = floorArray[j];
            if ([floor isNeedRemoveInstance]) {
                [floor removeFromParent];
                [removeFloors addObject:floor];
            }
        }
        
        [floorArray removeObjectsInArray:removeFloors];
    }
    
    [self deleteFloorsInLines];
}

- (void)checkPlayerIsOnFloor {
    isStandOnFootboard = false;
    MoveableFloor* standedFootboard = nil;
    
    for (NSMutableArray * footbardsLine in floorsByLines) {
        for (MoveableFloor * footboard in footbardsLine) {
            float SMOOTH_DEVIATION = 1;
            float footboardWidth = footboard.frame.size.width;
            bool b1 = footboard.position.x < player.position.x + player.size.width - SMOOTH_DEVIATION * 4;
            bool b2 = footboard.position.x + footboardWidth > player.position.x + SMOOTH_DEVIATION * 4;
            bool b3 = footboard.position.y <= player.position.y +1;
            bool b4 = footboard.position.y > player.position.y - DOWNSPEED;
            if (b1 && b2 && (b3 && b4)) {
                if (isJumping) {
                    isJumping = false;
                    player.texture = [SKTexture textureWithImageNamed:@"sheep1"];
                    [player runAction:moveAnimation];
                }
                isStandOnFootboard = true;
                standedFootboard = footboard;
                break;
            }
        }
    }
    
    if (isStandOnFootboard) {
        player.position = CGPointMake(player.position.x, standedFootboard.position.y);
        [self checkLayerNum:standedFootboard];
    } else {
        player.position = CGPointMake(player.position.x, player.position.y-DOWNSPEED);
    }
}

- (void)checkLayerNum:(SKSpriteNode*) standedFootboard {
    layerNumLabel.text = standedFootboard.name;
    NSLog(@"%@",standedFootboard.name);
}

- (void)checkEnemyDown {
    for(SKSpriteNode *enemy in enemyArray){
        bool isStandOnFootboard = false;
        MoveableFloor* standedFootboard = nil;
        
        for (NSMutableArray * footbardsLine in floorsByLines) {
            for (MoveableFloor * footboard in footbardsLine) {
                float SMOOTH_DEVIATION = 1;
                float footboardWidth = footboard.frame.size.width;
                bool b1 = footboard.position.x < enemy.position.x + enemy.size.width - SMOOTH_DEVIATION * 20;
                bool b2 = footboard.position.x + footboardWidth > enemy.position.x + SMOOTH_DEVIATION * 8;
                bool b3 = footboard.position.y <= enemy.position.y + 1;
                bool b4 = footboard.position.y > enemy.position.y - DOWNSPEED;
                if (b1 && b2 && (b3 && b4)) {
                    isStandOnFootboard = true;
                    standedFootboard = footboard;
                    break;
                }
            }
        }
        
        if(isStandOnFootboard){
            enemy.position = CGPointMake(enemy.position.x, standedFootboard.position.y);
        }else{
            enemy.position = CGPointMake(enemy.position.x, enemy.position.y-DOWNSPEED);
        }
    }
}

- (void)checkPlayerHitEnemy {
    for (int i = 0; i < enemyArray.count; i++) {
        SKSpriteNode * enemy = enemyArray[i];
        
        if (CGRectIntersectsRect(player.calculateAccumulatedFrame, enemy.calculateAccumulatedFrame)) {
            if (isStandOnFootboard) {
                CGSize size = CGRectIntersection(player.calculateAccumulatedFrame, enemy.calculateAccumulatedFrame).size;
                if (size.width > player.size.width * 2 / 3 && size.height > player.size.height * 2 / 3) {
                    //gameover
                    self.paused = true;
                }
            } else {
                isJumping = true;
                if(player.position.x >= enemy.position.x){
                    isFromLeft = NO;
                } else {
                    isFromLeft = YES;
                }
                
                floorSpeed = FOOTBOARD_SPEED * (isFromLeft ? 1 : -1);
                player.texture = [SKTexture textureWithImageNamed:@"sheep_jump1"];
                player.xScale = (isFromLeft ? 1 : -1);
                
                SKAction* upAction = [SKAction moveByX:0 y:270 duration:0.6];
                upAction.timingMode = SKActionTimingEaseOut;
                
                SKAction* upEnd = [SKAction runBlock:^{
                    player.texture = [SKTexture textureWithImageNamed:@"sheep_jump3"];
                }];
                [player removeAllActions];
                [player runAction:[SKAction sequence:@[upAction, upEnd]]];
                
                [enemy removeFromParent];
                [enemyArray removeObject:enemy];
                
                for (NSMutableArray* footbardsLine in floorsByLines) {
                    for (MoveableFloor * floor in footbardsLine) {
                        [floor setIsCarStartFromLeft:isFromLeft];
                    }
                }
                
                for (Enemy *enemy in enemyArray) {
                    enemy.xScale = player.xScale = (isFromLeft ? 1 : -1);
                }
            }
        }
    }
}

- (void)deleteFloorsInLines {
    NSMutableArray * firstLine = [floorsByLines firstObject];
    MoveableFloor* floor = [firstLine firstObject];
    if(floor.position.y >= self.frame.size.height + floor.size.height){
        for(MoveableFloor* floorsInLine in firstLine){
            [floorsInLine removeFromParent];
        }
        [firstLine removeAllObjects];
        [floorsByLines removeObject:firstLine];
    }
}

- (void)createFoorsInLines {
    NSMutableArray * footbardsLine;
    footbardsLine = [NSMutableArray array];
    
    MoveableFloor* floorIntheLastLine;
    
    if(floorsByLines.count>0){
        floorIntheLastLine = [[floorsByLines lastObject] firstObject];
    }else{
        [self createFloor:footbardsLine positionX:0 positionY:300 isAutoDeterminePositonX:false isAutoDeterminePositonXInFirst:true];
        floorIntheLastLine = [footbardsLine firstObject];
    }
    
    //create col instance
    for(int i = 0; i < floorsByLines.count; i++){
        [self createFloorAfterCheck:floorsByLines[i] positionY:((MoveableFloor*)[floorsByLines[i] firstObject]).position.y];
    }

    //create row instance
    while (floorIntheLastLine.position.y >= -70) {
        if (footbardsLine.count == 0) {
            [self createFloorWitchIsFirstFloor:footbardsLine positionY:floorIntheLastLine.position.y- 70];
        };
        
        MoveableFloor* checkfloor;
        if(isFromLeft){
            checkfloor = [footbardsLine lastObject];
            [checkfloor setIsCarStartFromLeft:YES];
        }else{
            checkfloor = [footbardsLine firstObject];
            [checkfloor setIsCarStartFromLeft:NO];
        }
        //create one row line
        while ([checkfloor isNeedCreateNewInstance]) {
            MoveableFloor* floor= [footbardsLine lastObject];
            [self createFloor:footbardsLine positionY:floor.position.y];
            MoveableFloor* newfloor;
            //            BOOL isFromLeft = true;
            if(isFromLeft){
                int footbardsLineNum = footbardsLine.count;
                newfloor = [footbardsLine lastObject];
                newfloor.position = CGPointMake(self.frame.size.width - (footbardsLineNum-4)*newfloor.size.width, newfloor.position.y);
            }else{
                int footbardsLineNum = footbardsLine.count;
                newfloor = [footbardsLine firstObject];
                newfloor.position = CGPointMake(0 + (footbardsLineNum-2)*newfloor.size.width, newfloor.position.y);
            }
            
            if(isFromLeft){
                checkfloor = [footbardsLine lastObject];
            }else{
                checkfloor = [footbardsLine firstObject];
            }
        }
        
        floorIntheLastLine = [footbardsLine firstObject];
        [floorsByLines addObject:footbardsLine];
        
        footbardsLine = [NSMutableArray array];
    }
}


- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(!isGameRun){
        [self setViewRun:false];
        return;
    }
    
    /* Called before each frame is rendered */
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    self.lastSpawnMoveTimeInterval += timeSinceLast;
    self.lastSpawnCreateFootboardTimeInterval += timeSinceLast;
    
    if (self.lastSpawnMoveTimeInterval > 0.02) {
        self.lastSpawnMoveTimeInterval = 0;
        
        [self checkAndEatStar];
        
        [self createFoorsInLines];
        [self moveFloor];
        
        [self moveStar];
        
        [self moveEnemy];
        [self checkAndRemoveEnemy];
        
        [self checkPlayerIsOnFloor];
        
        [self checkEnemyDown];
        
        [self removeFloor];
        
        [self checkPlayerHitEnemy];
        
        if(isBreakFloor){
            [self breakFloor];
            isBreakFloor = false;
        }
    }
    
    if(self.lastSpawnCreateFootboardTimeInterval > 1.0){
        self.lastSpawnCreateFootboardTimeInterval = 0;
        
        [self createStar];
        [self createEnemy];
    }
}

- (void)setViewRun:(bool)isrun {
    isGameRun = isrun;
    
    for (int i = 0; i < [self children].count; i++) {
        SKNode * n = [self children][i];
        n.paused = !isrun;
    }
}

- (void)reportScore {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:layerNum forCategory:@"com.irons.InfiniteSlotMoney"];
}

@end

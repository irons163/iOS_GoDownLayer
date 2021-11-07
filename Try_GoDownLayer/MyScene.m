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

int FOOTBOARD_SPEED = 3;
float DOWNSPEED = 12;

int star_type = 0;
int star_specail_type = 1;

@implementation MyScene {
    bool isGameRun;
    NSMutableArray *floorsTexture;
    NSMutableArray *enemyTexture;
    NSMutableArray *enemyArray;
    NSArray *rightNsArray;
    NSArray *leftNsArray;
    SKTexture *injureHamster;
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
        rightNsArray = [NSMutableArray array];
        leftNsArray = [NSMutableArray array];
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
        player.position = CGPointMake(100, 200);
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

- (void)didFinishUpdate {

}

- (void)didApplyConstraints {
    
}

- (void)didEvaluateActions {
    //    CGPoint cameraPositionInScene = [player.scene convertPoint:player.position fromNode:player.parent];
    //    cameraPositionInScene.x = 0;
    //    player.parent.position = CGPointMake(player.parent.position.x - cameraPositionInScene.x, player.parent.position.y - cameraPositionInScene.y);
    
    float dx = player.position.x - originalPoint.x;
    float dy = player.position.y - originalPoint.y;
    
    for (int i = 0; i < [self children].count; i++) {
        if(dx!=0){
            
        }
        SKNode * n = [self children][i];
        if ([n.name isEqualToString:@"star"]) {
//            NSLog(@"star");
        }
        
        if([n.name isEqualToString:@"starNumLabel"] || [n.name isEqualToString:@"layerNumLabel"] || [n.name isEqualToString:@"adView"] || [n.name isEqualToString:@"rankBtn"])
            continue;
        n.position = CGPointMake(n.position.x - dx, n.position.y - dy);
    }
    player.position = originalPoint;
}

- (void)didSimulatePhysics {

}

- (void)showScore {
    
}

- (void)initImage {
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"bubble_1"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"bubble_2"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"red_point"]];
    [floorsTexture addObject:[SKTexture textureWithImageNamed:@"yellow_point"]];
    
    [self initTextures];
    [self initStar];
}

- (void)initEnemyTexture {
//    [enemyTexture addObject:<#(id)#>];
}

- (void)initTextures {
    injureHamster = [SKTexture textureWithImageNamed:@"hamster_injure"];
    
    rightNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                    //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                         sequence:@[@4,@5,@4]];
    
    leftNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                   //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                        sequence:@[@4,@5,@4]];
}

- (void)initStar {
    starsTexture = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"Star"], [SKTexture textureWithImageNamed:@"StarSpecial"], nil];
}

- (void)createStar {
    SKSpriteNode* star;
    int starType = arc4random_uniform(20);
    if (starType==0) {
        star = [SKSpriteNode spriteNodeWithTexture:(SKTexture*)[starsTexture objectAtIndex:star_specail_type]];
    }else if(star_type <=10){
        star = [SKSpriteNode spriteNodeWithTexture:(SKTexture*)[starsTexture objectAtIndex:star_type]];
    }
    
    star.name = @"star";
    
    bool isAlreadyExsitStarInTheSameLine = false;
    
    for(SKSpriteNode *checkStar in starsArray){
        if(checkStar.position.y == ((MoveableFloor*)[floorsByLines[floorsByLines.count -1] firstObject]).position.y){
            isAlreadyExsitStarInTheSameLine = true;
            break;
        }
    }

    if(!isAlreadyExsitStarInTheSameLine){
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
    int max = floorsByLines.count -1;
    int randomRow = arc4random_uniform(max-min+1)+min;
    
    int enemyType = arc4random_uniform(2);
    
    SKSpriteNode * enemy = [SKSpriteNode spriteNodeWithTexture:nil];
    enemy.size = CGSizeMake(50, 50);
//    enemy.position = CGPointMake(0, 70);
    enemy.anchorPoint = CGPointMake(0.5, 0);
    
    float positionY = ((MoveableFloor*)[floorsByLines[randomRow] firstObject]).position.y;
    SKAction * moveAction, *animationAction;
    int direction = arc4random_uniform(2);
    if (direction==0) {
        enemy.xScale = -1;
        enemy.position = CGPointMake(0, positionY);
        moveAction = [SKAction moveToX:self.frame.size.width+10 duration:5];
        
        if(enemyType==0){
            enemy.texture = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep1 = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep2 = [SKTexture textureWithImageNamed:@"sheep2"];
            SKTexture *sheep3 = [SKTexture textureWithImageNamed:@"sheep3"];
            animationAction = [SKAction animateWithTextures:@[sheep1,sheep2,sheep3] timePerFrame:0.3f];
        }else{
            enemy.texture = leftNsArray[0];
            animationAction = [SKAction animateWithTextures:leftNsArray timePerFrame:0.2f];
        }
    }else{
        enemy.xScale = 1;
        enemy.position = CGPointMake(self.frame.size.width, positionY);
        moveAction = [SKAction moveToX:-10 duration:5];
        
        if(enemyType==0){
            enemy.texture = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep1 = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep2 = [SKTexture textureWithImageNamed:@"sheep2"];
            SKTexture *sheep3 = [SKTexture textureWithImageNamed:@"sheep3"];
            animationAction = [SKAction animateWithTextures:@[sheep1,sheep2,sheep3] timePerFrame:0.3f];
        }else{
            enemy.texture = rightNsArray[0];
            animationAction = [SKAction animateWithTextures:rightNsArray timePerFrame:0.2f];//
        }
    }
//    SKAction * moveAction = [SKAction moveToX:self.frame.size.width duration:5];
    [enemy runAction:[SKAction group:@[moveAction, [SKAction repeatActionForever:animationAction]]]];
    
    [self addChild:enemy];
    [enemyArray addObject:enemy];
}

- (void)breakFloor {
    SKAction * jumpUp = [SKAction moveByX:0 y:10 duration:0.5];
    
    
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"MySpark" ofType:@"sks"];
    SKEmitterNode *rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
//    rainEmitter.position = CGPointMake(100, 100);
    rainEmitter.position = player.position;
    [self addChild:rainEmitter];
    
    NSMutableArray* removeFloors = [NSMutableArray array];
    int removeCount = 10;
    
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
        
        if(isBreak){
            for(int removeIndex = index; removeIndex < index+4; removeIndex++){
                if(removeIndex >= floorArray.count)
                    return;
                [floorArray[removeIndex] removeFromParent];
                [removeFloors addObject:floorArray[removeIndex]];
            }
            [floorArray removeObjectsInArray:removeFloors];
            break;
        }
    }
    
    
    
    
    
//    for(int i = 0; i < floorArray.count; i++){
//        player.calculateAccumulatedFrame.origin;
//        player.calculateAccumulatedFrame.size;
//        
//        if(CGRectIntersectsRect(player.calculateAccumulatedFrame, enemy.calculateAccumulatedFrame)){
//            //            gameover;
//        }
//    }
    
//    [self checkPlayerDown];
}

- (void)checkPlayerDown {
    
//    {
//        self.lastSpawnTimeInterval = 0;
//        
//        for(int i = 0; i < fireballs.count; i++){
//            SKSpriteNode * fireballForCheck = fireballs[i];
//            if(CGRectContainsRect(fireballForCheck.calculateAccumulatedFrame, player.calculateAccumulatedFrame)){
//                [self beHited];
//            }
//        }
//        
//        isStandOnFootboard = false;
//        Footboard* standedFootboard = nil;
//        
//        for (NSMutableArray * footbardsLine in footbardsByLines) {
//            for (Footboard * footboard in footbardsLine) {
//                CGRect p = player.calculateAccumulatedFrame;
//                CGRect f = footboard.calculateAccumulatedFrame;
//                //                if(CGRectIntersectsRect(player.calculateAccumulatedFrame, footboard.calculateAccumulatedFrame)){
//                //                    isStandOnFootboard = true;
//                //                    standedFootboard = footboard;
//                //                }
//                float SMOOTH_DEVIATION = 1;
//                float footboardWidth = footboard.frame.size.width;
//                bool b1 = footboard.position.x < player.position.x + player.size.width - SMOOTH_DEVIATION*4;
//                bool b2 = footboard.position.x + footboardWidth > player.position.x + SMOOTH_DEVIATION*4;
//                bool b3 = footboard.position.y <= player.position.y +1;
//                bool b4 = footboard.position.y > player.position.y
//                - DOWNSPEED - FOOTBOARD_SPEED;
//                if(b1
//                   && b2
//                   &&
//                   (
//                    b3 &&
//                    b4)){
//                       
//                       isStandOnFootboard = true;
//                       standedFootboard = footboard;
//                       [self setIndexScore:[standedFootboard getIndex]];
//                       break;
//                   }
//            }
//        }
//        
//        [self moveFootboard];
//        
//        if(isStandOnFootboard){
//            //            [self checkPlayerMoved];
//            player.position = CGPointMake(player.position.x, standedFootboard.position.y);
//        }else{
//            player.position = CGPointMake(player.position.x, player.position.y-DOWNSPEED);
//        }
//        
//        if(standedFootboard){
//            ToolUtil* toolUtil = standedFootboard.tool;
//            if (toolUtil != nil
//                && (toolUtil.tool_x < player.position.x + player.size.width -SMOOTH_DEVIATION*4)
//                && (toolUtil.tool_x + toolUtil.tool_width > player.position.x +SMOOTH_DEVIATION*4)
//                && standedFootboard.toolNum != Footboard.BOMB_EXPLODE) {
//                if (standedFootboard.toolNum == Footboard.BOMB) {
//                    //                    isInjure = true;
//                    standedFootboard.toolNum = Footboard.BOMB_EXPLODE;
//                    standedFootboard.tool = nil;
//                    [toolUtil removeFromParent];
//                    standedFootboard.tool = toolExplodingUtil = [ToolUtil spriteNodeWithTexture:nil];
//                    [toolExplodingUtil setToolUtilWithX:standedFootboard.position.x + standedFootboard.size.width/2 Y:standedFootboard.position.y type:Footboard.BOMB_EXPLODE];
//                    [self addChild:toolExplodingUtil];
//                    catCurrentHp--;
//                    [self changeCatHpBar];
//                    redNode.hidden = false;
//                } else if (standedFootboard.toolNum == Footboard.CURE){
//                    catCurrentHp++;
//                    [self changeCatHpBar];
//                    standedFootboard.toolNum = Footboard.NOTOOL;
//                    standedFootboard.tool = nil;
//                    [toolUtil removeFromParent];
//                }
//                
//            }
//            
//            if(standedFootboard.which==1){
//                if(player.position.x + -SLIDERSPEED < 0){
//                    player.position = CGPointMake(0, player.position.y);
//                }else{
//                    player.position = CGPointMake(player.position.x + -SLIDERSPEED, player.position.y);
//                    [standedFootboard setCount];
//                }
//                
//            }else if(standedFootboard.which==2){
//                if(player.position.x + SLIDERSPEED > self.frame.size.width - player.size.width){
//                    player.position = CGPointMake(self.frame.size.width - player.size.width, player.position.y);
//                }else{
//                    player.position = CGPointMake(player.position.x + SLIDERSPEED, player.position.y);
//                    [standedFootboard setCount];
//                }
//                
//            }else if(standedFootboard.which==5){
//                catCurrentHp--;
//                [self changeCatHpBar];
//                redNode.hidden = false;
//                [self checkPlayerInjure];
//                standedFootboard.texture=nil;
//            }else{
//                [standedFootboard setCount];
//            }
//            
//            if(standedFootboard.texture==nil){
//                for (NSMutableArray * footbardsLine in footbardsByLines) {
//                    if ([footbardsLine containsObject:standedFootboard]) {
//                        [footbardsLine removeObject:standedFootboard];
//                        [standedFootboard removeFromParent];
//                        [standedFootboard.tool removeFromParent];
//                        break;
//                    }
//                }
//            }
//            
//        }
//        
//        [self checkPlayerMovedTexture:key];
//        
//        if (catCurrentHp == 0 || player.position.y + player.size.height < 0) {
//            redNode.hidden = false;
//            
//            isGameRun = false;
//            //            if(!isGameFinish){
//            //                isGameFinish = true;
//            [self handler:0];
//            //            }
//        }
//    }
//    
//    [sefl breakFloor];
}

- (void)eatTool {
    
}

- (void)showCurrentLayer {
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        vvvv
//        [self addChild:sprite];
        
        if(CGRectContainsPoint(myAdView.calculateAccumulatedFrame, location)){
            
            [myAdView touchesBegan:touches withEvent:event];
        }else if(CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)){
            self.showRankView();
        }else if(!isBreakFloor && isStandOnFootboard)
            isBreakFloor = true;
        
        
    }
    
    
}

- (void)initFloorPool {
    
}

- (void)createFloorAfterCheck:(NSMutableArray*) floorsInLine positionY:(float)y {
    
    bool isNeedCreate = true;
    MoveableFloor* floor;
    if(isFromLeft){
        floor = [floorsInLine lastObject];
    }else{
        floor = [floorsInLine firstObject];
    }

    //    if(!floor){
    //        [self addChild:floor];
    //        [floorArray addObject:floor];
    //        return;
    //    }

    if(floor!=nil && [floor isNeedCreateNewInstance]){
        [self createFloor:floorsInLine positionY:y];
    }
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionY:(float)y {
    [self createFloor:floorsInLine positionX:0 positionY:y isAutoDeterminePositonX:true];
}

- (void)createFloorWitchIsFirstFloor:(NSMutableArray*) floorsInLine positionY:(float)y {
    [self createFloor:floorsInLine positionX:0 positionY:y
    isAutoDeterminePositonX:false isAutoDeterminePositonXInFirst:true];
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionX:(float)x positionY:(float)y isAutoDeterminePositonX:(BOOL)isAutoDeterminePositonX {
    [self createFloor:floorsInLine positionX:x positionY:y isAutoDeterminePositonX:isAutoDeterminePositonX isAutoDeterminePositonXInFirst:false];
}

- (void)createFloor:(NSMutableArray*) floorsInLine positionX:(float)x positionY:(float)y isAutoDeterminePositonX:(BOOL)isAutoDeterminePositonX isAutoDeterminePositonXInFirst:(BOOL)isAutoDeterminePositonXInFirst {
    
    int r = arc4random_uniform(4);
    
    MoveableFloor* newFloor = [MoveableFloor floorWithTexture:floorsTexture[r] withRangeWidth:self.frame.size.width];
    [newFloor setIsCarStartFromLeft:true];
    //        newFloor.position = CGPointMake(0, y);
    
    if(isFromLeft){
        [newFloor setIsCarStartFromLeft:YES];
        [floorsInLine addObject:newFloor];
        newFloor.name = ((MoveableFloor*)[floorsInLine firstObject]).name;
    }else{
        [newFloor setIsCarStartFromLeft:NO];
        [floorsInLine insertObject:newFloor atIndex:0];
        newFloor.name = ((MoveableFloor*)[floorsInLine lastObject]).name;
    }
    
    
    
    if(isAutoDeterminePositonX)
        [newFloor setPositionYAndAutoDeterminePositionX:y];
    else if(isAutoDeterminePositonXInFirst){
        [newFloor setPositionYAndAutoPositionXForFirstFloorInLine:y];
        layerIndex++;
        newFloor.name = [NSString stringWithFormat:@"%d", layerIndex];
    }else
        newFloor.position = CGPointMake(x, y);
    
    newFloor.size = CGSizeMake(20, 20);
    
//    NSLog(@"%d",layerIndex); 
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
    NSMutableArray* removeFloors = [NSMutableArray array];
    for(int i = 0; i < floorsByLines.count; i++){
        NSMutableArray* floorArray = floorsByLines[i];
        for (int j = 0; j < floorArray.count; j++) {
            MoveableFloor* floor = floorArray[j];
            if ([floor isNeedRemoveInstance]) {
                [floor removeFromParent];
                [removeFloors addObject:floor];
            }
        }
        
        [floorArray removeObjectsInArray:removeFloors];
        
//        if(floorArray.count==0 || ((SKSpriteNode*)floorArray[0]).position.y > self.frame.size.height){
//            [floorsByLines removeObject:floorArray];
//            i--;
//        }
    }

    [self deleteFloorsInLines];
}

- (void)checkPlayerIsOnFloor {
    isStandOnFootboard = false;
    MoveableFloor* standedFootboard = nil;
    
    for (NSMutableArray * footbardsLine in floorsByLines) {
        for (MoveableFloor * footboard in footbardsLine) {
            CGRect p = player.calculateAccumulatedFrame;
            CGRect f = footboard.calculateAccumulatedFrame;
            //                if(CGRectIntersectsRect(player.calculateAccumulatedFrame, footboard.calculateAccumulatedFrame)){
            //                    isStandOnFootboard = true;
            //                    standedFootboard = footboard;
            //                }
            float SMOOTH_DEVIATION = 1;
            float footboardWidth = footboard.frame.size.width;
            bool b1 = footboard.position.x < player.position.x + player.size.width - SMOOTH_DEVIATION*4;
            bool b2 = footboard.position.x + footboardWidth > player.position.x + SMOOTH_DEVIATION*4;
            bool b3 = footboard.position.y <= player.position.y +1;
            bool b4 = footboard.position.y > player.position.y
            - DOWNSPEED;
            if(b1
               && b2
               &&
               (
                b3 &&
                b4)){
                   if(isJumping){
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
    
//    [self moveFootboard];
    
    if(isStandOnFootboard){
        //            [self checkPlayerMoved];
        player.position = CGPointMake(player.position.x, standedFootboard.position.y);
        [self checkLayerNum:standedFootboard];
    }else{
        player.position = CGPointMake(player.position.x, player.position.y-DOWNSPEED);
    }
}

- (void)checkLayerNum:(SKSpriteNode*) standedFootboard {
//    layerNum = standedFootboard.name.intValue - 4;
//    layerNumLabel.text = [NSString stringWithFormat:@"%d", layerNum];
    layerNumLabel.text = standedFootboard.name;
    NSLog(@"%@",standedFootboard.name);
}

- (void)checkEnemyDown {
    for(SKSpriteNode *enemy in enemyArray){
        bool isStandOnFootboard = false;
        MoveableFloor* standedFootboard = nil;
        
        for (NSMutableArray * footbardsLine in floorsByLines) {
            for (MoveableFloor * footboard in footbardsLine) {
                CGRect p = enemy.calculateAccumulatedFrame;
                CGRect f = footboard.calculateAccumulatedFrame;
  
                float SMOOTH_DEVIATION = 1;
                float footboardWidth = footboard.frame.size.width;
                bool b1 = footboard.position.x < enemy.position.x + enemy.size.width - SMOOTH_DEVIATION*20;
                bool b2 = footboard.position.x + footboardWidth > enemy.position.x + SMOOTH_DEVIATION*8;
                bool b3 = footboard.position.y <= enemy.position.y +1;
                bool b4 = footboard.position.y > enemy.position.y
                - DOWNSPEED;
                if(b1
                   && b2
                   &&
                   (
                    b3 &&
                    b4)){
//                       if(isJumping){
//                           isJumping = false;
//                           player.texture = [SKTexture textureWithImageNamed:@"sheep1"];
//                           [player runAction:moveAnimation];
//                       }
                       isStandOnFootboard = true;
                       standedFootboard = footboard;
                       break;
                   }
            }
        }
        
        //    [self moveFootboard];
        
        if(isStandOnFootboard){
            //            [self checkPlayerMoved];
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
                //gameover
            } else {
                isJumping = true;
                if(player.position.x >= enemy.position.x){
                    isFromLeft = NO;
                    floorSpeed = FOOTBOARD_SPEED*-1;
                    
                    player.texture = [SKTexture textureWithImageNamed:@"sheep_jump1"];
                    player.xScale = -1;
                    
                    SKAction* upAction = [SKAction moveByX:0 y:70 duration:0.6];
                    upAction.timingMode = SKActionTimingEaseOut;
//                    SKAction* downAction = [SKAction moveByX:0 y:-30 duration: 0.2];
//                    downAction.timingMode = SKActionTimingEaseIn;
                    // 3
                    //        topNode.runAction(SKAction.sequence(
                    //                                            [upAction, downAction, SKAction.removeFromParent()]))
                    
                    SKAction* upEnd = [SKAction runBlock:^{
                        player.texture = [SKTexture textureWithImageNamed:@"sheep_jump3"];
                    }];
                    
                    SKAction* horzAction = [SKAction moveByX:20  y:0 duration:1.0];
                    
                    SKAction * end = [SKAction runBlock:^{
//                        player.texture = [SKTexture textureWithImageNamed:@"sheep1"];
//                        [player runAction:moveAnimation];
                    }];
                    

                    [player removeAllActions];
//                    [player runAction:[SKAction group:@[[SKAction sequence:@[upAction, upEnd, downAction, end]], horzAction]]];
                    [player runAction:[SKAction sequence:@[upAction, upEnd, end]]];
                } else {
                    isFromLeft = YES;
                    floorSpeed = FOOTBOARD_SPEED;
                    
                    player.texture = [SKTexture textureWithImageNamed:@"sheep_jump1"];
                    player.xScale = 1;
                    
                    SKAction* upAction = [SKAction moveByX:0 y:70 duration:0.6];
                    upAction.timingMode = SKActionTimingEaseOut;
//                    SKAction* downAction = [SKAction moveByX:0 y:-50 duration: 0.5];
//                    downAction.timingMode = SKActionTimingEaseIn;
                    
                    SKAction* upEnd = [SKAction runBlock:^{
                        player.texture = [SKTexture textureWithImageNamed:@"sheep_jump3"];
                    }];
                    
                    SKAction* horzAction = [SKAction moveByX:-20  y:0 duration:1.0];
                    
                    SKAction * end = [SKAction runBlock:^{
//                        player.texture = [SKTexture textureWithImageNamed:@"sheep1"];
//                        [player runAction:moveAnimation];
                    }];
                    
                    [player removeAllActions];
//                    [player runAction:[SKAction group:@[[SKAction sequence:@[upAction, upEnd, downAction, end]], horzAction]]];
                    [player runAction:[SKAction sequence:@[upAction, upEnd, end]]];
                }
                
                [enemy removeFromParent];
                [enemyArray removeObject:enemy];
                
                for (NSMutableArray* oneLine in floorsByLines) {
                    MoveableFloor* floor;
                    if(isFromLeft){
                        floor = [oneLine lastObject];
                        [floor setIsCarStartFromLeft:isFromLeft];
                    }else{
                        floor = [oneLine firstObject];
                        [floor setIsCarStartFromLeft:isFromLeft];
                    }
                }
            }
        }
    }
}

- (void)checkDodgeEnemy {
    for (int i = 0; i < enemyArray.count; i++) {
        SKSpriteNode * enemy = enemyArray[i];
        
        if(CGRectIntersectsRect(player.calculateAccumulatedFrame, enemy.calculateAccumulatedFrame)){
//            gameover;
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
        
        //        [self addChild:footboard];
        //        [tmpfootbardsLine addObject:footboard];
        //        [tmpfootbardsLineIndex addObject:[NSNumber numberWithInt:k]];
    }
    
    
//    if(floorIntheLastLine.position.y < 50){
//        return;
//    }
    
    //create row instance
    while (floorIntheLastLine.position.y >= -70 ) {
        if(footbardsLine.count==0){
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

    
    
    
//    NSMutableArray * tmpfootbardsLine;
//    tmpfootbardsLine = [NSMutableArray array];
//    NSMutableArray * tmpfootbardsLineIndex;
//    tmpfootbardsLineIndex = [NSMutableArray array];
    

    
//    for(int i = 0; i < tmpfootbardsLine.count; i++){
//        NSInteger index = ((NSInteger)[tmpfootbardsLineIndex indexOfObject:[NSNumber numberWithInt:i]]);
//        [footbardsLine addObject:tmpfootbardsLine[index]];
//    }
    
    
    
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
    
    if (self.lastSpawnMoveTimeInterval > 0.1) {
        self.lastSpawnMoveTimeInterval = 0;
        
        [self checkAndEatStar];
        
        [self createFoorsInLines];
        [self moveFloor];
        
        [self moveStar];
        
        [self checkAndRemoveEnemy];
        
        [self checkPlayerDown];
        [self checkPlayerIsOnFloor];
        
        [self checkEnemyDown];
        
        [self removeFloor];
        
        [self checkPlayerHitEnemy];
        
        if(isBreakFloor){
            [self breakFloor];
            isBreakFloor = false;
        }
//        [self checkPlayerMoved];
        //        [self clearFootboard];
    }
    
    if(self.lastSpawnCreateFootboardTimeInterval > 1.0){
        self.lastSpawnCreateFootboardTimeInterval = 0;
        
        [self createStar];
        [self createEnemy];
        //        [self createFootboard];
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

//
//  MyScene.h
//  Try_GoDownLayer
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

typedef void(^rankView)();
@property (atomic, copy) rankView showRankView;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnMoveTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnCreateFootboardTimeInterval;

@end

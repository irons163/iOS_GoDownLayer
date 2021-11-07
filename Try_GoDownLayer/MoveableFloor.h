//
//  MoveableFloor.h
//  Try_GoDownLayer
//
//  Created by irons on 2015/9/16.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MoveableFloor : SKSpriteNode

+ (instancetype)floorWithImageNamed:(NSString *)name withRangeWidth:(float)rangeWidth;
+ (instancetype)floorWithTexture:(SKTexture *)texture withRangeWidth:(float)rangeWidth;
- (BOOL)isNeedCreateNewInstance;
- (void)move:(float)speedX;
- (BOOL)isNeedRemoveInstance;
- (void)setIsCarStartFromLeft:(BOOL)isCarStartFromLeft;
- (void)setPositionYAndAutoDeterminePositionX:(float)y;
- (void)setPositionYAndAutoPositionXForFirstFloorInLine:(float)y;
- (void)setInstanceCreatePositionX:(float)instanceCreatePositionX;

@end

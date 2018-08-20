//
//  MoveableFloor.m
//  Try_GoDownLayer
//
//  Created by irons on 2015/9/16.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MoveableFloor.h"

static int CAR_DISTANCE = 100;

@implementation MoveableFloor{
    bool isCarStartFromLeft;
//    int carX;
//    int carY;
//    int speedX;
    float rangeWidth;
    
    float instanceCreatePositionX;
}

+(instancetype)floorWithImageNamed:(NSString *)name withRangeWidth:(float)rangeWidth{
    MoveableFloor* floor = [MoveableFloor spriteNodeWithImageNamed:name];
    floor->isCarStartFromLeft = YES;
    floor->rangeWidth = rangeWidth;
    return floor;
}

+(instancetype)floorWithTexture:(SKTexture*)texture withRangeWidth:(float)rangeWidth{
    MoveableFloor* floor = [MoveableFloor spriteNodeWithTexture:texture];
    floor->isCarStartFromLeft = YES;
    floor->rangeWidth = rangeWidth;
    return floor;
}

-(BOOL)isNeedCreateNewInstance{
    bool isNeedCreateNewInstance = false;
    if(isCarStartFromLeft && self.position.x >= CAR_DISTANCE -5){
        isNeedCreateNewInstance = true;
    }else if(!isCarStartFromLeft && self.position.x <= rangeWidth - CAR_DISTANCE +5){
        isNeedCreateNewInstance = true;
    }
//    else if(!isCarStartFromLeft && self.position.x <= rangeWidth + CAR_DISTANCE){
//        isNeedCreateNewInstance = true;
//    }
    return isNeedCreateNewInstance;
}

-(BOOL)isNeedRemoveInstance{
    bool isNeedRemoveInstance = false;
    if(isCarStartFromLeft && self.position.x >= rangeWidth + CAR_DISTANCE*4 + 50){
        isNeedRemoveInstance = true;
    }else if(!isCarStartFromLeft && self.position.x <= 0 - CAR_DISTANCE*4 -50){
        isNeedRemoveInstance = true;
    }
    return isNeedRemoveInstance;
}

-(void)move:(float) speedX{
    self.position = CGPointMake(self.position.x + speedX, self.position.y);
}

-(void)setSize:(CGSize)size{
    [super setSize:size];
    CAR_DISTANCE = size.width - 5;
}

-(void)setIsCarStartFromLeft:(BOOL)isCarStartFromLeft{
    self->isCarStartFromLeft = isCarStartFromLeft;
}

-(void)setPositionYAndAutoDeterminePositionX:(float)y{
    [self setInstanceCreatePositionX:isCarStartFromLeft?-10:rangeWidth+10];
    self.position = CGPointMake(instanceCreatePositionX, y);
}

-(void)setPositionYAndAutoPositionXForFirstFloorInLine:(float)y{
    [self setInstanceCreatePositionX:isCarStartFromLeft?-10:rangeWidth+50];
    self.position = CGPointMake(isCarStartFromLeft?rangeWidth+self.size.width*4+10:-10-self.size.width/2-5, y);
}

-(void)initPositionX:(float)x {
//    self.position = CGPointMake(x-CAR_DISTANCE, y);
}

-(void)setInstanceCreatePositionX:(float)instanceCreatePositionX{
    self->instanceCreatePositionX = instanceCreatePositionX;
    
}

@end

//
//  Enemy.m
//  Try_GoDownLayer
//
//  Created by irons on 2021/12/3.
//  Copyright © 2021 irons. All rights reserved.
//

#import "Enemy.h"
#import "TextureHelper.h"

static NSArray *_rightNsArray;
static NSArray *_leftNsArray;

@interface Enemy()

@property (class, nonatomic) NSArray *rightNsArray;
@property (class, nonatomic) NSArray *leftNsArray;

@end

@implementation Enemy

+ (NSArray *)rightNsArray {
    if (!_rightNsArray) {
        Enemy.rightNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                        //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                             sequence:@[@4,@5,@4]];
    }
    return _rightNsArray;
}

+ (void)setRightNsArray:(NSArray *)rightNsArray {
    _rightNsArray = rightNsArray;
}

+ (NSArray *)leftNsArray {
    if (!_leftNsArray) {
        Enemy.leftNsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                             //            sequence:[NSArray arrayWithObjects:@"10",@"11",@"12",@"11",@"10", nil]];
                                                                  sequence:@[@4,@5,@4]];
    }
    return _leftNsArray;
}

+ (void)setLeftNsArray:(NSArray *)leftNsArray {
    _leftNsArray = leftNsArray;
}

- (void)setupWithY:(CGFloat)positionY {
    self.size = CGSizeMake(50, 50);
    //    enemy.position = CGPointMake(0, 70);
    self.anchorPoint = CGPointMake(0.5, 0);
    
    int enemyType = arc4random_uniform(2);
    SKAction * moveAction, *animationAction;
    int direction = arc4random_uniform(2);
    if (direction == 0) {
        self.xScale = -1;
        self.position = CGPointMake(10, positionY);
//        moveAction = [SKAction moveToX:[UIScreen mainScreen].bounds.size.width + 10 duration:2];
        moveAction = [SKAction moveByX:[UIScreen mainScreen].bounds.size.width y:0 duration:2];
        
        if (enemyType == 0) {
            self.texture = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep1 = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep2 = [SKTexture textureWithImageNamed:@"sheep2"];
            SKTexture *sheep3 = [SKTexture textureWithImageNamed:@"sheep3"];
            animationAction = [SKAction animateWithTextures:@[sheep1,sheep2,sheep3] timePerFrame:0.3f];
        } else {
            self.texture = Enemy.leftNsArray[0];
            animationAction = [SKAction animateWithTextures:Enemy.leftNsArray timePerFrame:0.2f];
        }
    } else {
        self.xScale = 1;
        self.position = CGPointMake([UIScreen mainScreen].bounds.size.width -10, positionY);
//        moveAction = [SKAction moveToX:-10 duration:2];
        moveAction = [SKAction moveByX:-[UIScreen mainScreen].bounds.size.width y:0 duration:2];
        
        if (enemyType == 0) {
            self.texture = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep1 = [SKTexture textureWithImageNamed:@"sheep1"];
            SKTexture *sheep2 = [SKTexture textureWithImageNamed:@"sheep2"];
            SKTexture *sheep3 = [SKTexture textureWithImageNamed:@"sheep3"];
            animationAction = [SKAction animateWithTextures:@[sheep1,sheep2,sheep3] timePerFrame:0.3f];
        } else {
            self.texture = Enemy.rightNsArray[0];
            animationAction = [SKAction animateWithTextures:Enemy.rightNsArray timePerFrame:0.2f];//
        }
    }
    //    SKAction * moveAction = [SKAction moveToX:self.frame.size.width duration:5];
    [self runAction:[SKAction repeatActionForever:[SKAction group:@[moveAction, animationAction]]]];
}

@end

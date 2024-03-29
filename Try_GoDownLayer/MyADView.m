//
//  MyADView.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyADView.h"

@implementation MyADView {
    NSArray* ads, *adsUrl;
    int adIndex;
    SKSpriteNode* button;
    NSTimer * timer;
}

- (void)startAd {
    NSString* catAdImageName;
    int randomCatAd = arc4random_uniform(2);
    if(randomCatAd==0){
        catAdImageName = @"unlimited_cat_world_ad";
    }else{
        catAdImageName = @"UnlimitedCatWorld_ad";
    }
    
    ads = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"ad1.jpg"],
           [SKTexture textureWithImageNamed:@"Shoot_Learning_ad"],
           [SKTexture textureWithImageNamed:@"cute_dudge_ad"],
           [SKTexture textureWithImageNamed:catAdImageName],
           [SKTexture textureWithImageNamed:@"crazy_split_ad"],
           [SKTexture textureWithImageNamed:@"HappyDownStages_AD"],nil];
    
    adsUrl = [NSArray arrayWithObjects:@"http://itunes.apple.com/us/app/good-sleeper-counting-sheep/id998186214?l=zh&ls=1&mt=8",
              @"https://itunes.apple.com/us/app/shoot-learning-math/id1025414483?l=zh&ls=1&mt=8",
              @"https://itunes.apple.com/us/app/cute-dodge/id1018590182?l=zh&ls=1&mt=8",
              @"https://itunes.apple.com/us/app/unlimited-cat-world/id1000573724?l=zh&ls=1&mt=8",
              @"https://itunes.apple.com/us/app/crazy-split/id1038958249?l=zh&ls=1&mt=8",
              @"https://itunes.apple.com/us/app/adventure-happy-down-stages/id1035092790?l=zh&ls=1&mt=8",
              nil];
    
    adIndex = 0;
    self.texture = ads[adIndex];
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:2.0
                                              target:self
                                            selector:@selector(changeAd)
                                            userInfo:nil
                                             repeats:YES];
    
    button = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Close-hd"];
    button.size = CGSizeMake(30, 30);
    button.position = CGPointMake(self.size.width/2 - button.size.width, self.size.height - button.size.height);
    button.anchorPoint = CGPointMake(0, 0);
    button.zPosition =5;
    [self addChild:button];
}

- (void)changeAd {
    
    adIndex++;
    if(adIndex < ads.count){
        self.texture = ads[adIndex];
    }else{
        adIndex = 0;
        self.texture = ads[adIndex];
    }
}

- (void)doClick {
    NSString *url = adsUrl[adIndex];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.hidden)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if ([button containsPoint:location]) {
        self.hidden = YES;
    } else if (location.y < self.size.height) {
        [self doClick];
    }
}

- (void)close {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end

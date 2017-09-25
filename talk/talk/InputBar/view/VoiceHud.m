//
//  VoiceHud.m
//  talk
//
//  Created by LiLe on 2017/9/21.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "VoiceHud.h"

@interface VoiceHud()
{
    NSArray *images;
}

@end

@implementation VoiceHud

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.animationDuration = 0.5;
        self.animationRepeatCount = -1;
        images = @[[UIImage imageNamed:@"voice_1"],[UIImage imageNamed:@"voice_2"],[UIImage imageNamed:@"voice_3"],[UIImage imageNamed:@"voice_4"],[UIImage imageNamed:@"voice_5"],[UIImage imageNamed:@"voice_6"]];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(progress, 0.f), 1.f);
    [self updataImages];
}

- (void)updataImages {
    if (_progress == 0) {
        self.animationImages = nil;
        [self stopAnimating];
        return;
    }
    if (_progress >= 0.8) {
        self.animationImages = @[images[3],images[4],images[5],images[4],images[3]];
    } else {
        self.animationImages = @[images[0],images[1],images[2],images[1]];
    }
    [self startAnimating];
}

@end

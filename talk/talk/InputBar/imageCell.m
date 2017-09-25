//
//  imageCell.m
//  talk
//
//  Created by LiLe on 2017/9/19.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "imageCell.h"

@implementation imageCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.button = [[imageButton alloc]initWithFrame:self.bounds];
        self.button.userInteractionEnabled = NO;
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button setTitle:@"照片" forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
    }
    return self;
}

@end

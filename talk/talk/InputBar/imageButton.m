//
//  imageButton.m
//  talk
//
//  Created by LiLe on 2017/9/19.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "imageButton.h"

@implementation imageButton

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.x = (self.width - 48) / 2;
    self.imageView.size = CGSizeMake(48, 48);
    self.titleLabel.x = 0;
    self.titleLabel.size = CGSizeMake(self.width, 12);
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 5;
    self.titleLabel.width = self.width;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self layoutSubviews];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self layoutSubviews];
}

-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    [self layoutSubviews];
}

@end

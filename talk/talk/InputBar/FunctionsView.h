//
//  FunctionsView.h
//  talk
//
//  Created by LiLe on 2017/9/19.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chooseImg)();
@interface FunctionsView : UIView
@property (nonatomic,copy) chooseImg chooseImg;
@end

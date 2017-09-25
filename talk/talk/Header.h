//
//  Header.h
//  talk
//
//  Created by LiLe on 2017/9/18.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "UIView+Frame.h"
#import "ServerDefs.h"

#define CELL_MARGIN_TB  4.0
#define CELL_MARING_LR  10.0
#define CELL_CORNOR     18.0
#define CELL_TAIL_WIDTH 16.0
#define MAX_WIDTH_OF_TEXT  200.0
#define CELL_PADDING    8.0

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 获取RGB颜色
#define RGBA(r,g,b,a)      [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)         RGBA(r,g,b,1.0f)

#endif /* Header_h */

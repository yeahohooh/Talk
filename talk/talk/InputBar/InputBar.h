//
//  InputBar.h
//  talk
//
//  Created by LiLe on 2017/9/18.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputBarDelegate <NSObject>

- (void)chatDidStartRecordingVoice;
- (void)chatDidStopRecordingVoice;

@end

@interface InputBar : UIView

typedef void(^InputViewContents)(NSString *contents);
typedef void(^chooseImages)();

@property (nonatomic, strong) InputViewContents block;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, strong) chooseImages chooseImages;

//代理
@property (nonatomic, weak) id<InputBarDelegate>delegate;

//状态
@property (nonatomic, assign) ChatStatus status;

//初始化
- (instancetype)initInputBar;

- (void)showInputViewContents:(InputViewContents)string;

@end

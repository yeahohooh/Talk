//
//  AppDelegate.h
//  聊天界面
//
//  Created by  王伟 on 2016/12/4.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (instancetype) messageWihtContent:(NSString *)content isRight:(BOOL)isRight {
    Message *msg = [Message new];
    msg.content = content;
    msg.isRight = isRight;
    
    CGRect rect = [msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    CGRect frameOfLabel = CGRectZero;
    
    frameOfLabel.size = rect.size;
    if (msg.isRight) {
        frameOfLabel.origin.x = ScreenWidth - CELL_MARING_LR - CELL_TAIL_WIDTH - CELL_PADDING - rect.size.width - 30;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDING;
        msg.contentframe = frameOfLabel;
        
        CGRect frameOfPop = frameOfLabel;
        frameOfPop.origin.x -= CELL_PADDING;
        frameOfPop.origin.y -= CELL_PADDING;
        frameOfPop.size.width += 2 * CELL_PADDING + CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2* CELL_PADDING;
        msg.popframe = frameOfPop;
        
        CGRect bounds = CGRectMake(0, 0, ScreenWidth, 0);
        bounds.size.height = frameOfPop.size.height +2 * CELL_MARGIN_TB;
        msg.bounds = bounds;
        
        msg.headerFrame = CGRectMake(ScreenWidth - 40,  frameOfPop.origin.y, 30, 30);
    } else {
        frameOfLabel.origin.x = CELL_MARING_LR + CELL_TAIL_WIDTH + CELL_PADDING  + 30;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDING;
        msg.contentframe = frameOfLabel;
        
        CGRect frameOfPop = frameOfLabel;
        frameOfPop.origin.x = CELL_MARING_LR + 30;
        frameOfPop.origin.y = CELL_MARGIN_TB;
        frameOfPop.size.width += 2*CELL_PADDING + CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2 * CELL_PADDING;
        msg.popframe = frameOfPop;
        CGRect bounds = CGRectMake(0, 0, ScreenWidth, 0);
        bounds.size.height = frameOfPop.size.height +2 * CELL_MARGIN_TB;
        msg.bounds = bounds;
        msg.headerFrame = CGRectMake(10, frameOfPop.origin.y, 30, 30);
    }
    return msg;
}

//构造消息对象 -- 消息图片
+ (instancetype) messageWihtImage:(UIImage *)image isRight:(BOOL)isRight {
    Message *msg = [Message new];
    msg.image = image;
    msg.isRight = isRight;
    
    CGRect rect = CGRectMake(0, 0, image.size.width / image.size.height * 120, 120);//[msg.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    CGRect frameOfLabel = CGRectZero;
    
    frameOfLabel.size = rect.size;
    if (msg.isRight) {
        frameOfLabel.origin.x = ScreenWidth - CELL_MARING_LR - CELL_TAIL_WIDTH - CELL_PADDING - rect.size.width - 30;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDING;
        msg.imageFrame = frameOfLabel;
        
        CGRect frameOfPop = frameOfLabel;
        frameOfPop.origin.x -= CELL_PADDING;
        frameOfPop.origin.y -= CELL_PADDING;
        frameOfPop.size.width += 2 * CELL_PADDING + CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2* CELL_PADDING;
        msg.popframe = frameOfPop;
        
        CGRect bounds = CGRectMake(0, 0, ScreenWidth, 0);
        bounds.size.height = frameOfPop.size.height +2 * CELL_MARGIN_TB;
        msg.bounds = bounds;
        
        msg.headerFrame = CGRectMake(ScreenWidth - 40, frameOfPop.origin.y, 30, 30);
    } else {
        frameOfLabel.origin.x = CELL_MARING_LR + CELL_TAIL_WIDTH + CELL_PADDING  + 30;
        frameOfLabel.origin.y = CELL_MARGIN_TB + CELL_PADDING;
        msg.imageFrame = frameOfLabel;
        
        CGRect frameOfPop = frameOfLabel;
        frameOfPop.origin.x = CELL_MARING_LR + 30;
        frameOfPop.origin.y = CELL_MARGIN_TB;
        frameOfPop.size.width += 2*CELL_PADDING + CELL_TAIL_WIDTH;
        frameOfPop.size.height += 2 * CELL_PADDING;
        msg.popframe = frameOfPop;
        CGRect bounds = CGRectMake(0, 0, ScreenWidth, 0);
        bounds.size.height = frameOfPop.size.height +2 * CELL_MARGIN_TB;
        msg.bounds = bounds;
        msg.headerFrame = CGRectMake(10, frameOfPop.origin.y, 30, 30);
    }
    return msg;
}

//构造消息对象 -- 消息语音
+ (instancetype)messageWithVoice:(NSString *)voice isRight:(BOOL)isRight {
    Message *msg = [Message new];
    msg.voice = voice;
    msg.isRight = isRight;
    
    if (msg.isRight) {
        msg.headerFrame = CGRectMake(ScreenWidth - 40,  4.0, 30, 30);
        msg.popframe = CGRectMake(CGRectGetMinX(msg.headerFrame) - 3 - 100, 4.0, 100, 35);
        msg.durationLabel = CGRectMake(CGRectGetMinX(msg.popframe) + 10, 12.0, 50, 20);
        msg.voiceIcon = CGRectMake(CGRectGetMaxX(msg.popframe) - 22, 12.0, 11, 16.5);
        msg.bounds = CGRectMake(0, 0, ScreenWidth, 50);
    } else {
        msg.headerFrame = CGRectMake(10, 4.0, 30, 30);
        msg.popframe = CGRectMake(CGRectGetMaxX(msg.headerFrame) + 3.0, 4.0, 80, 35);
        msg.durationLabel = CGRectMake(CGRectGetMaxX(msg.popframe) - 10, 12.0, 50, 20);
        msg.voiceIcon = CGRectMake(CGRectGetMinX(msg.popframe) + 20, 12.0, 11, 16.5);
        msg.bounds = CGRectMake(0, 0, ScreenWidth, 50);
    }
    return msg;
}


@end

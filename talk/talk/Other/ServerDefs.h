//
//  ServerDefs.h
//  talk
//
//  Created by LiLe on 2017/9/19.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#ifndef ServerDefs_h
#define ServerDefs_h

typedef NS_ENUM(NSInteger, ChatStatus) {
    StatusNothing,      //默认
    StatusShowVoice,    //录音
    StatusShowFace,     //表情
    StatusShowMore,     //更多
    StatusShowKeyboard, //正常
    StatusShowVideo     //视频
};

#endif /* ServerDefs_h */

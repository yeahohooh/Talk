//
//  InputBar.m
//  talk
//
//  Created by LiLe on 2017/9/18.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "InputBar.h"
#import "FunctionsView.h"

@interface InputBar()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *EmojiBtn;
@property (nonatomic, strong) UIButton *VoiceBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UIButton *voice;

@property (nonatomic, strong) FunctionsView *funcsView;

@end

@implementation InputBar

- (instancetype)initInputBar {
    CGFloat height = 50;
    self = [super initWithFrame:CGRectMake(0, ScreenHeight - height, ScreenWidth, height)];
    self.backgroundColor = RGB(245, 245, 245);
    self.layer.borderColor = RGB(228, 228, 228).CGColor;
    self.layer.borderWidth = 0.5;
    
    if (self) {
        [self addSubview:self.voice];
        [self addSubview:self.inputView];
        [self addSubview:self.placeHolder];
        [self addSubview:self.addBtn];
        [self addSubview:self.EmojiBtn];
        [self addSubview:self.VoiceBtn];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputViewFrame = self.frame;
                         newInputViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height-CGRectGetHeight(self.frame)-kbSize.height;
                         self.frame = newInputViewFrame;
                     }
                     completion:nil];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         self.center = CGPointMake(self.bounds.size.width/2.0f, height-CGRectGetHeight(self.frame)/2.0);
                     }
                     completion:nil];
}

-(UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.EmojiBtn.frame) + 4, 10, 28, 28)];
        _addBtn.tag = 2;
        [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(ClickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UIButton *)EmojiBtn {
    if (!_EmojiBtn) {
        _EmojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.inputView.frame) + 4, 10, 28, 28)];
        _EmojiBtn.tag = 4;
        [_EmojiBtn setImage:[UIImage imageNamed:@"emoji"] forState:UIControlStateNormal];
        [_EmojiBtn addTarget:self action:@selector(ClickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _EmojiBtn;
}

-(UIButton *)VoiceBtn {
    if (!_VoiceBtn) {
        _VoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(4, 10, 28, 28)];
        _VoiceBtn.tag = 0;
        [_VoiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [_VoiceBtn addTarget:self action:@selector(ClickKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _VoiceBtn;
}

-(UITextView *)inputView {
    if (!_inputView) {
        _inputView = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.VoiceBtn.frame) + 4, 5, ScreenWidth - CGRectGetMaxX(self.VoiceBtn.frame) - (35 * 2), 40)];
        _inputView.returnKeyType = UIReturnKeySend;
        _inputView.showsVerticalScrollIndicator = NO;
        _inputView.delegate = self;
        _inputView.font = [UIFont systemFontOfSize:16];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.tintColor = [UIColor clearColor];
        _inputView.layer.cornerRadius = 7;
        _inputView.layer.borderWidth = 0.8;
        _inputView.layer.borderColor = [UIColor grayColor].CGColor;
        _inputView.layer.masksToBounds = YES;
    }
    return _inputView;
}

-(UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.inputView.frame) + 4, 5, 200, 40)];
        _placeHolder.adjustsFontSizeToFitWidth = YES;
        _placeHolder.font = [UIFont systemFontOfSize:16];
        _placeHolder.minimumScaleFactor = 0.9;
        _placeHolder.textColor = [UIColor lightGrayColor];
        _placeHolder.userInteractionEnabled = NO;
        _placeHolder.text = _place;
    }
    return _placeHolder;
}

-(UIButton *)voice {
    if (!_voice) {
        _voice = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.VoiceBtn.frame) + 4, 5, ScreenWidth - CGRectGetMaxX(self.VoiceBtn.frame) - (35 * 2), 40)];
        [_voice setTitle:@"按住说话" forState:UIControlStateNormal];
        [_voice setTitle:@"松开结束" forState:UIControlStateHighlighted];
        [_voice setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        _voice.backgroundColor = RGB(245, 245, 245);
        _voice.layer.cornerRadius = 7;
        _voice.layer.borderWidth = 0.8;
        _voice.layer.borderColor = [UIColor grayColor].CGColor;
        _voice.layer.masksToBounds = YES;
        _voice.hidden = YES;
        [_voice addTarget:self action:@selector(talkBtnDown) forControlEvents:UIControlEventTouchDown];
        [_voice addTarget:self action:@selector(talkBtnUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voice;
}

-(FunctionsView *)funcsView {
    if (!_funcsView) {
        _funcsView = [[FunctionsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2)];
        _funcsView.chooseImg = ^{
            if (self.chooseImages) {
                self.chooseImages();
            }
        };
    }
    return _funcsView;
}

#pragma Delegate
- (void)talkBtnDown {
    if ([_delegate respondsToSelector:@selector(chatDidStartRecordingVoice)]) {
        [_delegate chatDidStartRecordingVoice];
    }
}

- (void)talkBtnUpInside {
    if ([_delegate respondsToSelector:@selector(chatDidStopRecordingVoice)]) {
        [_delegate chatDidStopRecordingVoice];
    }
}

//block
-(void)showInputViewContents:(InputViewContents)string {
    self.block = string;
}

-(void)setPlace:(NSString *)place {
    self.placeHolder.text = place;
}

-(void)textViewDidChange:(UITextView *)textView {
    [self layout];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.status != StatusShowMore) {
        _inputView.inputView = nil;
    } else {
        self.status = StatusShowKeyboard;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        //点击系统键盘上的发送
        [self didClickSend];
        return NO;
    }
    return YES;
}

- (void)didClickSend {
    if (self.block) {
        self.block(_inputView.text);
    }
    _inputView.text = @"";
    [self layout];
}

-(void)ClickKeyboard:(UIButton *)sender {
    ChatStatus status = self.status;
    if (sender.tag == 0) {
        if (status == StatusShowVoice) {
            self.status = StatusShowKeyboard;
            [sender setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
            [self.inputView setHidden:NO];
            [self.placeHolder setHidden:NO];
            [self.voice setHidden:YES];
            [self.inputView becomeFirstResponder];
        } else {
            self.status = StatusShowVoice;
            [self.inputView setHidden:YES];
            [self.placeHolder setHidden:YES];
            [self.inputView resignFirstResponder];
            [self.voice setHidden:NO];
            _inputView.inputView = nil;
            [sender setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        }
    } else if (sender.tag == 2) {
        self.status = StatusShowMore;
        [_inputView setInputView:self.funcsView];
        [_inputView reloadInputViews];
        [_inputView becomeFirstResponder];
    } else {
        _inputView.inputView = nil;
        self.status = StatusShowKeyboard;
    }
}

-(void)layout{
    _placeHolder.hidden = _inputView.text.length > 0 ? YES : NO;
    CGSize textSize = [_inputView sizeThatFits:CGSizeMake(CGRectGetWidth(_inputView.frame), MAXFLOAT)];
    //CGFloat offset = 10;
    _inputView.height = MAX(40, MIN(80, textSize.height));
    //_inputView.scrollEnabled = (textSize.height > 60 - offset);
    CGFloat maxY = CGRectGetMaxY(self.frame);
    self.height = CGRectGetHeight(_inputView.frame) + CGRectGetMinY(_inputView.frame) * 2;
    self.y = maxY - CGRectGetHeight(self.frame);
    _VoiceBtn.center = CGPointMake(CGRectGetMidX(_VoiceBtn.frame), CGRectGetHeight(self.frame) / 2);
    _EmojiBtn.center = CGPointMake(CGRectGetMidX(_EmojiBtn.frame), CGRectGetHeight(self.frame) / 2);
    _addBtn.center = CGPointMake(CGRectGetMidX(_addBtn.frame), CGRectGetHeight(self.frame) / 2);
}

@end

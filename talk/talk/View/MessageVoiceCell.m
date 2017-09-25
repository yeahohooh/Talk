//
//  MessageVoiceCell.m
//  talk
//
//  Created by LiLe on 2017/9/22.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "MessageVoiceCell.h"
#import "ICRecordManager.h"
#import "VoiceConverter.h"

@interface MessageVoiceCell()<ICRecordManagerDelegate>
@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UILabel *durationLab;
@property (nonatomic,strong) UIImageView *voiceIcon;
@property (nonatomic ,strong) UIImageView *popView;
@property (nonatomic,copy) NSString *voicePath;
@property (nonatomic, strong) UIImageView *currentVoiceIcon;
@end

@implementation MessageVoiceCell

-(UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.layer.cornerRadius = 15;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UIButton *)voiceBtn
{
    if (nil == _voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

-(UIImageView *)popView{
    if (!_popView) {
        _popView = [UIImageView new];
    }
    return _popView;
}

- (UILabel *)durationLab
{
    if (nil == _durationLab ) {
        _durationLab = [[UILabel alloc] init];
        _durationLab.font = [UIFont systemFontOfSize:16.0];
    }
    return _durationLab;
}

- (UIImageView *)voiceIcon
{
    if (nil == _voiceIcon) {
        _voiceIcon = [[UIImageView alloc] init];
    }
    return _voiceIcon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setMessage:(Message *)message {
    _message = message;
    self.voicePath = [self mediaPath:message.voice];
    self.durationLab.text = [NSString stringWithFormat:@"%ld''",[[ICRecordManager shareManager] durationWithVideo:[NSURL fileURLWithPath:self.voicePath]]];
    self.voiceIcon.frame = message.voiceIcon;
    self.headerView.frame = message.headerFrame;
    self.durationLab.frame = message.durationLabel;
    self.voiceBtn.frame = message.popframe;
    self.popView.frame = message.popframe;
    self.bounds = _message.bounds;
    if (message.isRight) {
        [self.headerView setImage:[UIImage imageNamed:@"woman"]];
        self.popView.image = [[UIImage imageNamed:@"liaotianbeijing2"]resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH)];
        self.voiceIcon.image = [UIImage imageNamed:@"right-3"];
        UIImage *image1 = [UIImage imageNamed:@"right-1"];
        UIImage *image2 = [UIImage imageNamed:@"right-2"];
        UIImage *image3 = [UIImage imageNamed:@"right-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    } else {
        [self.headerView setImage:[UIImage imageNamed:@"man"]];
        self.voiceIcon.image = [UIImage imageNamed:@"left-3"];
        UIImage *image1 = [UIImage imageNamed:@"left-1"];
        UIImage *image2 = [UIImage imageNamed:@"left-2"];
        UIImage *image3 = [UIImage imageNamed:@"left-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    }
    self.voiceIcon.animationDuration = 0.8;
    
    [self.contentView addSubview:self.popView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.voiceIcon];
    [self.contentView addSubview:self.voiceBtn];
    [self.contentView addSubview:self.durationLab];
}

- (void)voiceButtonClicked:(UIButton *)voiceBtn
{
    voiceBtn.selected = !voiceBtn.selected;
    ICRecordManager *recordManager = [ICRecordManager shareManager];
    recordManager.playDelegate = self;
    //路径
    NSString *voicePath = [self mediaPath:_message.voice];
    NSString *amrPath = [[self.voicePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
    [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:voicePath];
    if (self.voicePath) {
        if ([self.voicePath isEqualToString:voicePath]) {
            self.voicePath = nil;
            [[ICRecordManager shareManager] stopPlayRecorder:voicePath];
            [self.voiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
            return;
        } else {
            [self.currentVoiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
        }
    }
    [[ICRecordManager shareManager] startPlayRecorder:voicePath];
    [self.voiceIcon startAnimating];
    self.voicePath = voicePath;
    self.currentVoiceIcon = self.voiceIcon;
}

- (void)voiceDidPlayFinished {
    self.voicePath = nil;
    ICRecordManager *manager = [ICRecordManager shareManager];
    manager.playDelegate = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath
{
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[ICRecordManager shareManager] receiveVoicePathWithFileKey:name];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

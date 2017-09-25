//
//  AppDelegate.h
//  聊天界面
//
//  Created by  王伟 on 2016/12/4.
//  Copyright © 2016年  王伟. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic ,strong) UIImageView *popView;
@property (nonatomic ,strong) UILabel *messageLB;
@end
@implementation MessageCell
-(UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.layer.cornerRadius = 15;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

-(UIImageView *)popView{
    if (!_popView) {
        _popView = [UIImageView new];
    }
    return _popView;
}
-(UILabel *)messageLB{
    if (!_messageLB) {
        _messageLB = [UILabel new];
        _messageLB.font = [UIFont systemFontOfSize:14];
        _messageLB.numberOfLines = 0;
    }
    return _messageLB;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setMessage:(Message *)message {
    _message = message;
    self.messageLB.text = message.content;
    self.bounds = _message.bounds;
    self.messageLB.frame = message.contentframe;
    self.headerView.frame = message.headerFrame;
    self.popView.frame = message.popframe;
    if (message.isRight) {
        self.messageLB.textColor = [UIColor blackColor];
        [self.headerView setImage:[UIImage imageNamed:@"woman"]];
        //self.popView.image = [[UIImage imageNamed:@"message_i"]resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR, CELL_CORNOR, CELL_CORNOR, CELL_CORNOR + CELL_TAIL_WIDTH)];
        self.popView.image = [[UIImage imageNamed:@"liaotianbeijing2"]resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH)];
    } else {
        self.messageLB.textColor = [UIColor blackColor];
        [self.headerView setImage:[UIImage imageNamed:@"man"]];
        //self.popView.image = [[UIImage imageNamed:@"message_other"]resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR, CELL_CORNOR)];
        self.popView.image = [[UIImage imageNamed:@"liaotianbeijing1"]resizableImageWithCapInsets:UIEdgeInsetsMake(CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH, CELL_CORNOR + CELL_TAIL_WIDTH)];
    }
    [self.contentView addSubview:self.popView];
    [self.contentView addSubview:self.messageLB];
    [self.contentView addSubview:self.headerView];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end

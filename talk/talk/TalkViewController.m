//
//  TalkViewController.m
//  talk
//
//  Created by LiLe on 2017/9/14.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "TalkViewController.h"
#import "GCDAsyncSocket.h"
#import "UIView+Frame.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageImageCell.h"
#import "MessageVoiceCell.h"
#import "InputBar.h"
#import "ICRecordManager.h"
#import "VoiceHud.h"

@interface TalkViewController ()<GCDAsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource,InputBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITextField *text;
@property (nonatomic,strong) NSMutableArray *MessageArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *textView;
@property (nonatomic) GCDAsyncSocket *socket;

@property (nonatomic,strong) InputBar *inputBar;
@property (nonatomic,strong) UIImagePickerController *picker;

//录音文件名
@property (nonatomic,copy) NSString *recordName;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) VoiceHud *voiceHud;

@end

@implementation TalkViewController

static NSString *cellID = @"cell";
static NSString *imageCellID = @"imageCell";
static NSString *voiceCellID = @"voiceCell";

-(NSMutableArray *)MessageArr{
    if (!_MessageArr) {
        _MessageArr = [NSMutableArray array];
    }
    return _MessageArr;
}

-(InputBar *)inputBar {
    if (!_inputBar) {
        _inputBar = [[InputBar alloc]initInputBar];
        _inputBar.place = @"请输入新消息";
        _inputBar.delegate = self;
    }
    return _inputBar;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息对象";
    self.view.backgroundColor = [UIColor whiteColor];
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //连接服务器
    [self.socket connectToHost:self.IP onPort:self.port.integerValue withTimeout:-1 error:nil];
    
    //[self initText];
    [self initView];
}

- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 104)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[MessageImageCell class] forCellReuseIdentifier:imageCellID];
    [self.tableView registerClass:[MessageVoiceCell class] forCellReuseIdentifier:voiceCellID];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.inputBar];
    [self.inputBar showInputViewContents:^(NSString *contents) {
        Message *msg = [Message messageWihtContent:contents isRight:YES];
        [self.MessageArr addObject:msg];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    __block typeof(self) weakSelf = self;
    self.inputBar.chooseImages = ^{
        [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
    };
}

-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (void)initText{
    _textView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [self.view addSubview:_textView];
    
    _text = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 40)];
    _text.backgroundColor = [UIColor whiteColor];
    _text.placeholder = @"请输入新消息";
    [_textView addSubview:_text];
    
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 0, 60, 40)];
    send.backgroundColor = [UIColor cyanColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:send];
}

- (void)send{
    NSData *data = [self.text.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:-1 tag:0];
    
    Message *msg = [Message messageWihtContent:_text.text isRight:YES];
    [self.MessageArr addObject:msg];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _text.text = @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.MessageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    MessageImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
    MessageVoiceCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:voiceCellID];
    Message *msg = self.MessageArr[indexPath.row];
    
    if (msg.image != nil) {
        imageCell.message = msg;
        return imageCell;
    } else if (msg.voice != nil) {
        voiceCell.message = msg;
        return voiceCell;
    }
    cell.message = msg;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *msg = self.MessageArr[indexPath.row];
    return msg.bounds.size.height;
}
//连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接成功");
    [self.socket readDataWithTimeout:-1 tag:0];
}
//收到消息
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    Message *msg = [Message messageWihtContent:text isRight:NO];
    [self.MessageArr addObject:msg];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.socket readDataWithTimeout:-1 tag:0];
}

#pragma InputBarDelegate
- (void)chatDidStartRecordingVoice {
    self.recordName = [self currentRecordFileName];
    
    [[ICRecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {
            
        } else {
            [self timerInvalue];
            self.voiceHud.hidden = NO;
            [self timer];
        }
    }];
}

- (void)chatDidStopRecordingVoice {
    __weak typeof(self) weakSelf = self;
    [[ICRecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        //录音太短
        if ([recordPath isEqualToString:shortRecord]) {
            [self timerInvalue];
            self.voiceHud.animationImages = nil;
            self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.voiceHud.hidden = YES;
            });
            [[ICRecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {
            [self timerInvalue];
            self.voiceHud.hidden = YES;
            if (recordPath) {
                Message *msg = [Message messageWithVoice:recordPath isRight:YES];
                [self.MessageArr addObject:msg];
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }];
}

- (NSString *)currentRecordFileName
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}

-(void)openKeyboard:(NSNotification*)notification{
    
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSTimeInterval durition = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey]intValue];
    [UIView animateWithDuration:durition delay:0 options:option animations:^{
        self.tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 50 - frame.size.height - 64);
        if (self.MessageArr.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } completion:nil];
}

-(void)closeKeyboard:(NSNotification*)notification{
    NSTimeInterval durition = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey]intValue];
    [UIView animateWithDuration:durition delay:0 options:option animations:^{
        
        self.tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 50 - 64);
    } completion:nil];
}

#pragma UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    if (image != nil) {
        [self performSelector:@selector(SendImage:) withObject:image afterDelay:0.5];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)SendImage:(UIImage *)image {
    Message *msg = [Message messageWihtImage:image isRight:YES];
    [self.MessageArr addObject:msg];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (VoiceHud *)voiceHud {
    if (!_voiceHud) {
        _voiceHud = [[VoiceHud alloc]initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    }
    return _voiceHud;
}

- (void)timerInvalue {
    [_timer invalidate];
    _timer = nil;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)progressChange {
    AVAudioRecorder *recorder = [[ICRecordManager shareManager] recorder];
    [recorder updateMeters];
    //取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    float power = [recorder averagePowerForChannel:0];
    CGFloat progress = (1.0 / 160) * (power + 160);
    self.voiceHud.progress = progress;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

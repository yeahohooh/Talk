//
//  ViewController.m
//  talk
//
//  Created by LiLe on 2017/9/14.
//  Copyright © 2017年 LiBo. All rights reserved.
//

#import "ViewController.h"
#import "TalkViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressIP;
@property (weak, nonatomic) IBOutlet UITextField *port;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)connect:(UIButton *)sender {
    TalkViewController *talk = [[TalkViewController alloc]init];
    talk.IP = _addressIP.text;
    talk.port = _port.text;
    [self.navigationController pushViewController:talk animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

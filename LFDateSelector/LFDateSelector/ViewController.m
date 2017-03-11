//
//  ViewController.m
//  LFDateSelector
//
//  Created by LF on 2017/3/11.
//  Copyright © 2017年 LF. All rights reserved.
//

#import "ViewController.h"

#import "LFDateSelector.h"

@interface ViewController ()

//**  label */
@property (nonatomic, strong) UILabel *timeLb;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.backgroundColor = [UIColor orangeColor];
    b.frame =self.view.bounds;
    [b setTitle:@"APPEAR" forState:0];
    [b addTarget:self action:@selector(appear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 60)];
    _timeLb.text = @"时间: ";
    _timeLb.textColor = [UIColor whiteColor];
    [b addSubview:_timeLb];
}

- (void)appear
{
    
    __weak typeof(self) weakSelf = self;
    [[LFDateSelector shareInstance] lf_showDateSelectorInViewController:self withResultBlock:^(NSString *dateString) {
        
        // 这里的block和对象.h里面的一个block是绑定的, 这里调外部变量的时候最好是weak一下
        weakSelf.timeLb.text = [NSString stringWithFormat:@"时间: %@",dateString];
        
        NSLog(@"时间选择的结果是: %@",dateString);
    }];
}

@end

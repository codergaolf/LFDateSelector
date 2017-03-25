//
//  LFDateSelector.m
//  LFDateSelector
//
//  Created by LF on 2017/3/11.
//  Copyright © 2017年 LF. All rights reserved.
//

#import "LFDateSelector.h"

#define LFScreenH ([UIScreen mainScreen].bounds.size.height)
#define LFScreenW ([UIScreen mainScreen].bounds.size.width)
#define LFScreenBounds [UIScreen mainScreen].bounds
#define LFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define LFNumFrom667(a) (LFScreenH/667 * a)

#define kPickerH LFNumFrom667(260)
#define kAnimateDuration 0.4

static NSString *AnimateNoti = @"LFDateSelectorNote";

@interface LFDateSelector()

//**  选择日期 */
@property (nonatomic, strong) UILabel *hintLabel;

//**  白色背景view */
@property (nonatomic, strong) UIView *whiteBgView;

//**  日期选择器 */
@property (nonatomic, strong) UIDatePicker *datePicker;

//**  确认按钮 */
@property (nonatomic, strong) UIButton *sureButton;

//**  选择结果 */
@property (nonatomic, strong) NSString *resultString;

//**  日期格式 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

//**  白色背景的frame */
@property (nonatomic, assign) CGRect whiteViewFrame;

//**  确认按钮的frame */
@property (nonatomic, assign) CGRect sureButtonFrame;

@end

@implementation LFDateSelector

+ (instancetype)shareInstance
{
    static LFDateSelector *dateSelector;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateSelector = [[LFDateSelector alloc]init];
    });
    
    // 每次到这里说明又被拿出来用了, 发一个通知让view执行一下选择器滑上来的动画
    [[NSNotificationCenter defaultCenter]postNotificationName:AnimateNoti object:nil];
    return dateSelector;
}

// 确认按钮
- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(self.sureButtonFrame.origin.x,
                                       self.sureButtonFrame.origin.y + LFScreenH,
                                       self.sureButtonFrame.size.width,
                                       self.sureButtonFrame.size.height);
        _sureButton.layer.cornerRadius = 10.0;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _sureButton;
}

// 白色的背景
- (UIView *)whiteBgView
{
    if (!_whiteBgView) {
        _whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(self.whiteViewFrame.origin.x,
                                                               self.whiteViewFrame.origin.y + LFScreenH,
                                                               self.whiteViewFrame.size.width,
                                                               self.whiteViewFrame.size.height)];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.clipsToBounds = YES;
        _whiteBgView.layer.cornerRadius = 10.0;
        _whiteBgView.layer.masksToBounds = YES;
    }
    return _whiteBgView;
}


// 时间选择器
- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(10, 10, LFScreenW - 20, kPickerH)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //[riQidatePicker setDate:nowDate animated:YES];
        //属性：datePicker.date当前选中的时间 类型 NSDate
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents: UIControlEventValueChanged];
        self.resultString = [self.dateFormatter stringFromDate:_datePicker.date];;
    }
    return _datePicker;
}

// 日期格式
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

// 选择日期
- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, LFScreenW-20, 30)];
        _hintLabel.textColor = [UIColor grayColor];
        _hintLabel.backgroundColor = [UIColor whiteColor];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"选择日期";
        _hintLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _hintLabel;
}

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self calcuteFrames];
        [self setupUI];
    }
    return self;
}

// 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, LFScreenW, LFScreenH);
        //        [self calcuteFrames];
        //        [self setupUI];
    }
    return self;
}


- (void) calcuteFrames
{
    self.whiteViewFrame = CGRectMake(10, LFScreenH - 60 - 30 - kPickerH, LFScreenW - 20, kPickerH + 20);
    self.sureButtonFrame = CGRectMake(10, LFScreenH - 60, LFScreenW - 20, 50);
}

- (void) setupUI
{
    // 半透明的黑色
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    // 添加消失手势
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfAction)];
    [self addGestureRecognizer:tapGes];
    
    [self addSubview:self.sureButton];
    [self addSubview:self.whiteBgView];
    
    [self.whiteBgView addSubview:self.datePicker];
    [self.whiteBgView addSubview:self.hintLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAnimateAppear) name:AnimateNoti object:nil];
    
    [self makeAnimateAppear];
}

// 动画出现
- (void) makeAnimateAppear
{
    
    NSDate *currentDate = [NSDate date];
    [self.datePicker setDate:currentDate];
    
    self.resultString = [self.dateFormatter stringFromDate:currentDate];
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.whiteBgView.frame = self.whiteViewFrame;
        self.sureButton.frame  = self.sureButtonFrame;
    }];
}

// 移除选择器视图
- (void) selfAction
{
    [UIView animateWithDuration:kAnimateDuration animations:^{
        
        self.whiteBgView.frame = CGRectMake(self.whiteViewFrame.origin.x,
                                            self.whiteViewFrame.origin.y + LFScreenH,
                                            self.whiteViewFrame.size.width,
                                            self.whiteViewFrame.size.height);
        
        self.sureButton.frame  = CGRectMake(self.sureButtonFrame.origin.x,
                                            self.sureButtonFrame.origin.y + LFScreenH,
                                            self.sureButtonFrame.size.width,
                                            self.sureButtonFrame.size.height);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


// 监听选择器时间
- (void)dateChange:(UIDatePicker *)senser{
    
    self.resultString = [self.dateFormatter stringFromDate:senser.date];
}

// 回调
- (void) sureAction:(UIButton *)sender
{
    [self selfAction];
    
    if (_block) {
        _block(self.resultString);
    }
}

// 展示
- (void) lf_showDateSelectorInViewController:(UIViewController *)viewController withResultBlock:(DateResult)block;
{
    [viewController.view addSubview: self];
    self.block = block;
}

// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AnimateNoti object:nil];
}


@end

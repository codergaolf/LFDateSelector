//
//  LFDateSelector.h
//  LFDateSelector
//
//  Created by LF on 2017/3/11.
//  Copyright © 2017年 LF. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用于回调结果的block
typedef void(^DateResult)(NSString *dateString);

@interface LFDateSelector : UIView

//**  回调block */
@property (nonatomic, copy) DateResult block;
//                                         /\
//                                         ||
//                                         ||
//                                         ||
//warning 这个方法里面的block实现的时候会绑定属性 |  所以在controller里面调用的时候最好是用weak修饰一下
- (void) lf_showDateSelectorInViewController:(UIViewController *)viewController
                          withResultBlock:(DateResult)block;

// 单例
+ (instancetype) shareInstance;
@end

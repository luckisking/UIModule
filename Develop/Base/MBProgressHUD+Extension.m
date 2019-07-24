//
//  MBProgressHUD+Extension.m
//  GasSteward
//
//  Created by ZhuYan on 2017/11/29.
//  Copyright © 2017年 dizhubi. All rights reserved.
//

#import "MBProgressHUD+Extension.h"


@implementation MBProgressHUD (Extension)

#pragma mark 显示加载动画
+ (void)showHudInView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    UIImageView *imageVIew =  [[UIImageView alloc] init];
    NSMutableArray *imageArr = [NSMutableArray array];
    for(int i = 1;i < 13;i++){
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.png",i]];
//        image =    //[image scaleToSize:CGSizeMake(60, 60)];
        [imageArr addObject:image];
    }
    imageVIew.animationImages = imageArr;
    imageVIew.animationDuration = imageArr.count/12;
    imageVIew.animationRepeatCount = 0;
    [imageVIew startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = imageVIew;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
}

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
//    hud.label.font = F14;
    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"MBHUD_Error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"MBHUD_Success" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.label.text = message;
    hud.label.textAlignment = NSTextAlignmentCenter;
//    hud.label.font = SGFontRegular(14);
    hud.label.textColor = [UIColor whiteColor];
    hud.label.layer.cornerRadius = 4.0;
//    hud.label.backgroundColor =    UIColorFromRGBWithAlpha(0x000000, 0.5);
    hud.label.clipsToBounds = YES;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

+ (MBProgressHUD *)showWaitMessage:(NSString *)message {
    UIView *view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.offset = CGPointMake(0, -50);
    hud.label.text = message;
//    hud.label.font = F14;
    hud.mode = MBProgressHUDModeIndeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
    
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

@end

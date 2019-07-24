//
//  DXVipServiceBaseViewController.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseViewController.h"
#import <objc/runtime.h>

@interface DXVipServiceBaseViewController ()

@property (nonatomic, strong) UIButton *vipServiceBaseViewControllerRightButton;
@property (nonatomic, strong) UIImageView *vipServiceBaseViewControllerbBackgroundImage;
@property (nonatomic, strong) UILabel *vipServiceBaseViewControllerbRightLabel;

@end

@implementation DXVipServiceBaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
 
}

//自定义位置的导航右item子视图(如不用自定义位置，请直接设置 self.navigationItem.rightBarButtonItem )
- (UIButton *)getRightButtonWithWidth:(CGFloat)width height:(CGFloat)height backImage:(nullable UIImage *)image label:(nullable UILabel *)label {
    
    _vipServiceBaseViewControllerRightButton = nil;
    _vipServiceBaseViewControllerbBackgroundImage = nil;
    _vipServiceBaseViewControllerbRightLabel = nil;
    _vipServiceBaseViewControllerRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    if (image) {
        _vipServiceBaseViewControllerbBackgroundImage = [[UIImageView alloc] initWithImage:image];
        [_vipServiceBaseViewControllerRightButton addSubview:_vipServiceBaseViewControllerbBackgroundImage];
    }
    if (label) {
        _vipServiceBaseViewControllerbRightLabel = label;
        [_vipServiceBaseViewControllerRightButton addSubview:_vipServiceBaseViewControllerbRightLabel];
    }
    return _vipServiceBaseViewControllerRightButton;
    
}
//调整导航右item子视图距离屏幕右边的位置（左正右负）
- (void)adjustmentRightButtonSubViewPositionWithRightFromScreen:(CGFloat)right topFromButton:(CGFloat)top width:(CGFloat)width height:(CGFloat)height {
    
    CGRect rect=[_vipServiceBaseViewControllerRightButton convertRect: _vipServiceBaseViewControllerRightButton.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
    if (_vipServiceBaseViewControllerbBackgroundImage) {
         _vipServiceBaseViewControllerbBackgroundImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - rect.origin.x - width - right, top, width, height);
    }
    if (_vipServiceBaseViewControllerbRightLabel) {
        _vipServiceBaseViewControllerbRightLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - rect.origin.x - width - right, top, width, height);
    }
    
}

- (nullable UIViewController *)getTargetController:(NSString *)controllerName param:(nullable NSDictionary *)param {
    Class targetClass = NSClassFromString(controllerName);
    if (!targetClass) {
        NSLog(@"未找到 %@ 控制器",controllerName);
        return nil;
    }
    UIViewController *  target = [[targetClass alloc] init];
    //属性数量
    unsigned int count = 0;
    //获取属性列表
    objc_property_t *plist = class_copyPropertyList(targetClass, &count);
    for (int i = 0; i<count; i++) {
        //取出属性
        objc_property_t property = plist[i];
        //取出属性名称
        NSString *propertyName =  [NSString stringWithUTF8String:property_getName(property)];
        //以这个属性名称作为key ,查看传入的字典里是否有这个属性的value
        if (param[propertyName]) {
            [target setValue:param[propertyName] forKey:propertyName];
        }
    }
    //释放
    free(plist);
    return target;
}
- (nullable id)executeController:(UIViewController *)controller  method:(NSString *)methodName param:(NSDictionary *)param {
    if (param)  param = @{};
    if ([controller respondsToSelector:NSSelectorFromString(methodName)]) {
        SEL selector = NSSelectorFromString(methodName);
        IMP imp = [controller methodForSelector:selector];
        id (*func)(id, SEL,NSDictionary *) = (void *)imp;
        return  func(self, selector,param);
    }else {
        NSLog(@"在 %@ 中找不到 %@ 方法",[NSString stringWithUTF8String:object_getClassName(controller)],methodName);
        return nil;
    }
}


- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

@end

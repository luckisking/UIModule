//
//  DXCreateUI.m
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXCreateUI.h"

@implementation DXCreateUI

//TextField
+ (UITextField *)initTextFieldWithTextColor:(UIColor *)textColor font:(UIFont *)font placeholder:(NSString *)placeholder {
    UITextField *textField =  [[UITextField alloc] init];
                textField.textColor = textColor;
                textField.font = font;
                textField.placeholder = placeholder;
    return  textField;
}

//Label
+ (UILabel *)initLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.text = text;
            label.textColor = textColor;
            label.font = font;
            label.textAlignment = textAlignment;
    return  label;
}
//Line
+ (UIView *)initLineViewWithBackgroundColor:(UIColor *)backgroundColor {
    UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = backgroundColor;
    return  lineView;
}

//Button
+ (UIButton *)initButtonWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                  backgroundColor:(UIColor *)backgroundColor
                             font:(UIFont *)font
               controlStateNormal:(UIControlState)controlStateNormal
          controlStateHighlighted:(UIControlState)controlStateHighlighted
                     cornerRadius:(CGFloat)cornerRadius {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:controlStateNormal];
        [button setTitle:title forState:controlStateHighlighted];
        button.titleLabel.font = font;
        [button setTitleColor:titleColor forState:controlStateNormal];
        [button setBackgroundColor:backgroundColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = cornerRadius;
    return button;
}

#pragma mark 给View添加变化的背景色
//本方法需要确定的frame 如果frame自动约束，请继承自UIView,UILabel，UIButton，写子类，在layoutSubView方法中写
+ (void)addBackgroundColorShadowWidth:(CGFloat)width
                                              height:(CGFloat)height
                                          fromeColor:(UIColor *)color1
                                             toColor:(UIColor *)color2
                                        cornerRadius:(CGFloat)radius
                                           superView:(UIView *)view {
    view.backgroundColor = [UIColor clearColor];
    view.layer.masksToBounds = NO;
    //设置渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, width?:view.frame.size.width, height?:view.frame.size.height);
    //要求更改全部渐变色
    color1 = RGBHex(0xFFF5E4);
    color2 = RGBHex(0xE8C998);
    gradient.colors = [NSArray arrayWithObjects:(id)color1.CGColor,(id)color2.CGColor,nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.cornerRadius = radius;
    [view.layer insertSublayer:gradient atIndex:0];
}
#pragma mark 判断任意对象（不含数字）是否为空
+ (BOOL)judgeEmpty:(nullable id)obj {
    
    //nil,null
    if ([obj isKindOfClass:[NSNull class]]||!obj) {
        return  YES;
    }
    
    //字符串
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = [(NSString *)obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if( str.length == 0
            || [str isEqualToString:@""]
            || [str isEqualToString:@"<null>"]
            || [str isEqualToString:@"(null)"]
            || [str isEqualToString:@"null"]) {
            return YES;
        }else{
            return NO;
        }
    }
    
     //字典
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if (((NSDictionary *)obj).count==0) {
            return YES;
        }
    }
    
     //数组
    if ([obj isKindOfClass:[NSArray  class]]) {
        if (((NSArray *)obj).count==0) {
            return YES;
        }
    }
    
    //data
    if ([obj isKindOfClass:[NSData  class]]) {
        NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
        if (!str
            || str.length == 0
            || [str isEqualToString:@"()"]
            || [str isEqualToString:@"[]"]
            || [str isEqualToString:@"{}"]) {
            return YES;
        }
    }
    return NO;
}





@end

//
//  DXCreateUI.h
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Masonry/Masonry.h>

#import "DXVipDefine.h"

#import "DXVipServiceBaseView.h"

#import <AFNetworking/UIImageView+AFNetworking.h>


#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface DXCreateUI : NSObject
//TextField
+ (UITextField *)initTextFieldWithTextColor:(UIColor *)textColor font:(UIFont *)font placeholder:(NSString *)placeholder;
//Label
+ (UILabel *)initLabelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
//LineView
+ (UIView *)initLineViewWithBackgroundColor:(UIColor *)backgroundColor;
//Button
+ (UIButton *)initButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font controlStateNormal:(UIControlState)controlStateNormal controlStateHighlighted:(UIControlState)controlStateHighlighted cornerRadius:(CGFloat)cornerRadius;
+ (void)addBackgroundColorShadowWidth:(CGFloat)width
                                             height:(CGFloat)height
                                         fromeColor:(UIColor *)color1
                                            toColor:(UIColor *)color2
                                       cornerRadius:(CGFloat)radius
                                          superView:(UIView *)view;
+ (BOOL)judgeEmpty:(nullable id)obj;
@end


NS_ASSUME_NONNULL_END

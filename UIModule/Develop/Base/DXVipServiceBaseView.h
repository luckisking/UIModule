//
//  DXVipServiceBaseView.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  DXVipServiceBaseViewDelegete <NSObject>

@optional
- (void)click;
@optional
- (void)clickButton:(UIButton *)button ;
@optional
- (void)clickTap:(UITapGestureRecognizer *)tap ;
@optional
- (void)clickWithString:(NSString *)param;
@optional
- (void)clickWithString:(NSString *)param1 string:(NSString *)param2 ;
@optional
- (void)clickWithString:(NSString *)param1 string:(NSString *)param2 string:(NSString *)param3 ;
@optional
- (void)clickWithState:(BOOL)state ;
@optional
- (void)clickWithString:(NSString *)string state:(BOOL)state ;
@optional
- (void)clickWithNumber:(NSInteger )integer ;
@optional
- (void)clickWithString:(NSString *)string number:(NSInteger )number;
@optional
- (void)clickWithDescription:(NSString *)description ;
@optional
- (void)clickWithDescription:(NSString *)description  param:(NSDictionary *)param ;
@optional
- (void)notificationAction:(NSNotification *)notification ;
@optional
- (void)response:(nullable id)response ;
@optional
- (void)callBack:(nullable id)callBack ;


@end


@interface DXVipServiceBaseView : UIView
@property (nonatomic, weak) id<DXVipServiceBaseViewDelegete>delegate;
@end

NS_ASSUME_NONNULL_END

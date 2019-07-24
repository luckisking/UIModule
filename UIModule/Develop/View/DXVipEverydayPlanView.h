//
//  DXVipEverydayPlanView.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCreateUI.h"
#import "DXVipLookCourseView.h"
#import "DXVipDoWorkView.h"

NS_ASSUME_NONNULL_BEGIN

    /*vip服务今天计划（每日计划主页面）*/
@interface DXVipEverydayPlanView : DXVipServiceBaseView

@property (nonatomic,strong) DXVipLookCourseView *lcView;
@property (nonatomic,strong) DXVipDoWorkView *dwView;
@property(nonatomic,copy)void(^notictLooking)(void);//通知后台  用户看过了这个界面
@property(nonatomic,copy)void(^completeSelect)(void);//选择学院完毕

- (instancetype)initWithFrame:(CGRect)frame target:(id)target;
- (void)promptStudyDialogBox ;
- (void)promptAcademyDialogBox ;

- (UIView *)addTopViewWithTime:(nullable NSString *)time
                          date:(nullable NSString *)date
                 needDateLabel:(BOOL)needDateLabel
                 needMyvipView:(BOOL)needMyvipView
                  needLineView:(BOOL)needLineView ;
- (UIView *)addNonePlanViewWithSuperView:(nullable UIView *)superView text:(NSString *)text ;
- (UIView *)addMenuViewHasVideo:(BOOL)video hasPaper:(BOOL)paper text:(nullable NSString *)text look:(void(^)(void))look;
- (UIView *)addBottomTestView ;
- (void)noClick ;

@end

NS_ASSUME_NONNULL_END

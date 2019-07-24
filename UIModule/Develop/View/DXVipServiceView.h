//
//  DXVipServiceView.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/17.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCreateUI.h"

NS_ASSUME_NONNULL_BEGIN

/*vip笔试和面试服务首页*/
@interface DXVipServiceView : DXVipServiceBaseView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type target:(id)target;
/* 未分配班主任 等待分配*/
- (UIView *)addWaiForTeacherView ;
/* 已经分配班主任 等待安排计划*/
- (UIView *)addTeacherViewWithHeadImv:(nullable NSString *)imvString detail:(nullable NSString *)detail ;
/* 已经分配班主任 并且安排了计划*/
- (void)addTestViewWithDataArray:(nullable NSArray *)array ;

@end


#pragma mark cell
@interface DXVipServiceCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightTopImv;
@property (nonatomic, strong) UIButton *rightBtn;

/*type 0 一个题目没做 1 已经答完 2 做了一部分*/
- (void)setCellType:(NSInteger)type title:(nullable NSString *)title score:(nullable NSString *)score time:(nullable NSString *)time;
@end
NS_ASSUME_NONNULL_END

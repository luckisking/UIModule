//
//  DXVipLookCourseView.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCreateUI.h"
#import "DXVipServiceMode.h"

NS_ASSUME_NONNULL_BEGIN

    /*vip服务看课*/
@class DXVipLookCourseCell;
@interface DXVipLookCourseView : DXVipServiceBaseView

- (instancetype)initWithFrame:(CGRect)frame target:(nullable id)target;
- (void)refreshData:(NSArray *)array ;

@end

#pragma mark cell
@interface DXVipLookCourseCell : UITableViewCell

//cell视图布局
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellTimeLabel;
@property (nonatomic, strong) UILabel *cellTetaiLabel;
@property (nonatomic, strong) UIButton *cellRightButton;

- (void)setCellInfoWithTitle:(NSString *)title time:(nullable NSString *)time detail:(nullable NSString *)detail ;
- (void)setLiveType:(NSInteger)type;


@end


NS_ASSUME_NONNULL_END



//
//  DXVipDoWorkView.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXCreateUI.h"
#import "DXVipServiceMode.h"

NS_ASSUME_NONNULL_BEGIN

/*vip服务做题*/
@interface DXVipDoWorkView : DXVipServiceBaseView



- (instancetype)initWithFrame:(CGRect)frame target:(nullable id)target;
- (void)refreshData:(NSArray *)array ;

@end



#pragma mark cell
@interface DXVipDoWorkCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightTopImv;
@property (nonatomic, strong) UIButton *rightBtn;

/*type 0 一个题目没做 1 已经答完 2 做了一部分*/
- (void)setCellType:(NSInteger)type title:(nullable NSString *)title score:(nullable NSString *)score time:(nullable NSString *)time;
@end

NS_ASSUME_NONNULL_END

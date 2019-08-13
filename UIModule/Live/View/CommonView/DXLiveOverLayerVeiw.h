//
//  DXLiveOverLayerVeiw.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/5.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DXLiveOverLayerVeiwDelegate <NSObject>

- (void)videoOverLayerClickWithName:(NSString *)name button:(UIButton *)button;

@end

@interface DXLiveOverLayerVeiw : UIView
@property (nonatomic, weak) id<DXLiveOverLayerVeiwDelegate>delegate;

@property (nonatomic, strong) UIButton *networkButton;                   // 网络按钮
@property (nonatomic, strong) UIButton *backButton;                      // 返回按钮
@property (strong, nonatomic) UIView *headerView;                   // 大视频上方视图
@property (strong, nonatomic) UIView *footerView;                   // 大视频下方视图
@property(nonatomic, strong)CAGradientLayer * gradientLayerHeader; // 大视频透明View上方渐变色
@property(nonatomic, strong)CAGradientLayer * gradientLayerFooter;// 大视频透明View下方渐变色
@property (nonatomic, strong) UIButton *shareButton;                     // 分享按钮
@property (nonatomic, strong) UIButton *menuButton;                     // 更多按钮
@property (nonatomic, strong) UILabel *titleLabel;                       // 直播标题
@property (nonatomic, strong) UIButton *cutButton;                       // 切换按钮
@property (nonatomic, strong) UIButton *fullScreenButton;                // 全屏按钮


//初始化方法
- (instancetype)initWithTarget:(id)target ;

@end

NS_ASSUME_NONNULL_END

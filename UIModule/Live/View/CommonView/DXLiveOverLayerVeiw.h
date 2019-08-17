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
//cc切换线路
@optional
- (void)selectedRodWidthIndex:(NSInteger)rodIndex ;
//cc切换清晰度
@optional
- (void)selectedRodWidthIndex:(NSInteger)rodIndex secIndex:(NSInteger)secIndex ;

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

//cc直播的切换线路和切换清晰度
@property (nonatomic, strong) UIView *bgView;                // 线路背景视图
@property (nonatomic, strong) UIButton *secRoadButton;                // 线路
@property (nonatomic, strong) UIButton *qingxiButton;                // 清晰度

//初始化方法
- (instancetype)initWithTarget:(id)target ;
//cc直播的切换线路和切换清晰度的方法
- (void)selectLinesWithFirRoad:(NSInteger)firRoadNum secRoadKeyArray:(NSArray *)secRoadKeyArray ;
@end

NS_ASSUME_NONNULL_END

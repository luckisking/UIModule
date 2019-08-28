//
//  DXPlayBackOverLayerView.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/5.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DXPlayBackOverLayerViewDelegate <NSObject>

- (void)videoOverLayerClickWithName:(NSString *)name button:(UIButton *)button;

@optional //小屏幕倍数播放按钮
- (void) speedActionButton:(UIButton *)button;

@end

@interface DXPlayBackOverLayerView : UIView
@property (nonatomic, weak) id<DXPlayBackOverLayerViewDelegate>delegate;


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
@property (nonatomic, strong) UIButton *speedButton;                  // 小屏回放倍速按钮
@property (nonatomic, strong) UIButton *speedFullButton;                  // 大屏回放倍速按钮
@property (nonatomic, strong) NSArray *speedArray;                  // 倍数数组
@property (strong, nonatomic) UIButton *downloadBtn;                  // 下载按钮

@property (nonatomic, assign) CGFloat duration; //视频总的时长
@property (nonatomic, strong) UIButton *playbackButton;               // 回放播放暂停按钮
@property (strong, nonatomic) UILabel *durationLabel;                 // 回放总播放时间Label
@property (strong, nonatomic) UILabel *currentPlaybackTimeLabel;      // 回放播放时间Label
@property (strong, nonatomic) UISlider *durationSlider;               // 回放进度条
@property (assign, nonatomic) BOOL   sliderIsMoving;                   // 进度条正在拖动 

@property (nonatomic, strong) UILabel *fullPlayTimeLabel;             //全屏下当前时长/总时长
@property (nonatomic, strong) UIView *panView;                        //拖动平移View (前进后退)
@property (nonatomic, strong) UILabel *panViewLabel;                  //拖动平移View的label(前进后退)

@property (nonatomic, strong) UIView *qualityButtonBackground;         //横屏清晰度切换背景图
@property (nonatomic, strong) UIView *speedBackground;                 //横屏倍速切换背景图



- (instancetype)initWithTarget:(id)target ;

//拖动
- (void)panActionToPanViewLabel:(NSInteger)seekTime liveType:(BOOL)liveType;

//底部竖屏布局和横屏布局
- (void) newLayout:(BOOL)type ;

@end

NS_ASSUME_NONNULL_END

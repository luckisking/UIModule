//
//  DXLiveOverLayerVeiw.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/5.
//  Copyright © 2019 都学网. All rights reserved.
//



//上下父视图的高度，也是背景阴影的高度
#define HeaderViewHeight          (60.0f)   //如果全屏 70.0
#define FootViewHeight          (40.0f)     //如果全屏 70.0
//图标的高度，（非特定图标）也是图标的宽度
#define subViewHeight     40.0f


#import "DXLiveOverLayerVeiw.h"

@implementation DXLiveOverLayerVeiw
- (instancetype)initWithTarget:(id)target {
    if (self = [super init]) {
        _delegate = target;
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    [self loadHeaderView];
    [self loadFooterView];
}
- (void)loadHeaderView
{
    self.headerView = [[UIView alloc]init];
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(HeaderViewHeight));
    }];
    
    //请按顺序加载
    [self loadBackButton];
    [self loadMenuButton];
    [self loadTitleLabel];
    //[self loadShareButton];
    
}

- (void)loadFooterView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - FootViewHeight, self.frame.size.width, FootViewHeight)];
    [self addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(@(0));
        make.height.equalTo(@(FootViewHeight));
    }];
     //请按顺序加载
    [self loadNetworkButton];
    [self loadFullScreen];
    [self loadCutButton];
    [self loadStatusLabel];
    
}

#pragma mark - 头部子视图
// 返回按钮
- (void)loadBackButton
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.backButton setImage:IMG(@"back_YM") forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backButton.backgroundColor = [UIColor clearColor];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView).offset(iPhoneX?0:20);
        make.width.height.mas_equalTo(subViewHeight);
    }];

    
}

// 菜单 ...
-(void)loadMenuButton
{
    //菜单按钮
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.backgroundColor = [UIColor clearColor];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuButton setImage:[UIImage imageNamed:@"more_YM"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView addSubview:self.menuButton];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView.mas_right);
        make.top.mas_equalTo(self.headerView).offset(iPhoneX?0:20);
        make.width.height.mas_equalTo(subViewHeight);
    }];
}
// 直播标题
- (void)loadTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    //    self.titleLabel.text = self.videoTitle;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left).offset(40);
        make.right.mas_equalTo(self.menuButton.mas_left);
        make.top.mas_equalTo(self.headerView).offset(iPhoneX?0:20);
        make.height.mas_equalTo(subViewHeight);
    }];
}
// 分享按钮
- (void)loadShareButton
{
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.shareButton setImage:IMG(@"live_share") forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor clearColor];
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.shareButton];
    //暂时不做，所以不给出frame
}


#pragma mark - 尾部子视图
- (void)loadNetworkButton {
    
    self.networkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.networkButton addTarget:self action:@selector(networkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.networkButton setImage:IMG(@"live_network_YM") forState:UIControlStateNormal];
    self.networkButton.backgroundColor = [UIColor clearColor];
    
    [self.footerView addSubview:self.networkButton];
    [self.networkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footerView.mas_left);
        make.centerY.mas_equalTo(self.footerView);
        make.width.height.mas_equalTo(subViewHeight);
    }];
}

// 全屏按钮
- (void)loadFullScreen {
    self.fullScreenButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.fullScreenButton setImage:IMG(@"live_maximize") forState:UIControlStateNormal];
    [self.fullScreenButton setImage:IMG(@"live_minimize") forState:UIControlStateSelected];
    [self.fullScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fullScreenButton.backgroundColor = [UIColor clearColor];
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:self.fullScreenButton];
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.footerView.mas_right);
        make.centerY.mas_equalTo(self.footerView);
        make.width.height.mas_equalTo(subViewHeight);
    }];

}

// 切换按钮
- (void)loadCutButton {
    self.cutButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
    self.cutButton.backgroundColor = [UIColor clearColor];
    [self.cutButton addTarget:self action:@selector(cutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:self.cutButton];
    [self.cutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left);
        make.centerY.mas_equalTo(self.footerView);
        make.width.height.mas_equalTo(subViewHeight);
    }];

}

//中间的label
- (void)loadStatusLabel {
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = @"正在直播";
    statusLabel.font = [UIFont boldSystemFontOfSize:15.0];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.footerView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.networkButton.mas_right);
        make.right.equalTo(self.cutButton.mas_left);
        make.top.mas_equalTo(self.footerView.mas_top);
        make.bottom.mas_equalTo(self.footerView.mas_bottom);
    }];
}

#pragma mark -添加阴影（之所以放在这里添加是需要适应全屏和非全屏，也就是需要自适应）
-(void)layoutSubviews {
    [super layoutSubviews];
    //头部阴影
    CAGradientLayer * headerLayer = [CAGradientLayer layer];
     headerLayer.colors = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.60].CGColor,
                          (id)[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.25].CGColor,
                          (id)[UIColor clearColor].CGColor, nil];
    headerLayer.locations = @[@(0.0),@(0.66),@(1.0),];
    headerLayer.startPoint =  CGPointMake(0, 0);
    headerLayer.endPoint = CGPointMake(0, 1);
    headerLayer.frame =_headerView.bounds;
    if (self.gradientLayerHeader) [self.gradientLayerHeader removeFromSuperlayer];
    self.gradientLayerHeader = headerLayer;
    [self.headerView.layer insertSublayer:self.gradientLayerHeader atIndex:0];

    //底部阴影
    CAGradientLayer * footLayer = [CAGradientLayer layer];
    footLayer.colors =  [NSArray arrayWithObjects:
                                 (id)[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6].CGColor,
                                 (id)[UIColor clearColor].CGColor, nil];

    footLayer.startPoint =  CGPointMake(0, 1);
    footLayer.endPoint = CGPointMake(0, 0);
    footLayer.frame = _footerView.bounds;
    if (self.gradientLayerFooter) [self.gradientLayerFooter removeFromSuperlayer];
    self.gradientLayerFooter = footLayer;
    [self.footerView.layer insertSublayer:self.gradientLayerFooter atIndex:0];
  
}

#pragma mark - 点击事件回传
- (void)backButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"返回" button:button];
}
- (void)shareButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"分享" button:button];
}
- (void)menuButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"更多" button:button];
}
- (void)networkButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"网络" button:button];
}
- (void)cutButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"切换" button:button];
}
- (void)fullScreenButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"全屏" button:button];
}

- (void)excuteDeleteMethod:(NSString *)name button:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(videoOverLayerClickWithName: button:)]) {
        [self.delegate videoOverLayerClickWithName:name button:button] ;
    }
}
@end

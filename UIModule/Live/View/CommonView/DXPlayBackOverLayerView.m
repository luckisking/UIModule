//
//   DXPlayBackOverLayerView.m
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


#import "DXPlayBackOverLayerView.h"

@implementation  DXPlayBackOverLayerView
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
    [self loadSpeedBackfroundView];
    [self loadPanView];
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
    
    //请按顺序加载（为了完全自适应，不然布局将乱）
    [self loadBackButton];
    [self loadMenuButton];
    [self loadDownloadBtn];
    [self loadSpeedButton];
    [self loadTitleLabel];//放在最后因为它左右自适应
    
    
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
    
    //请按顺序加载（为了完全自适应，不然布局将乱）
    [self loadPlaybackButton];
    [self loadCurrentPlaybackTimeLabel];
    [self loadFullScreen];
    [self loadCutButton];
    [self loadDurationLabel];
    [self loadPlaybackSlider];//放在最后因为它左右自适应
    
    [self loadSpeedFullButton];
    
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
// 下载
- (void)loadDownloadBtn {
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downloadBtn setImage:[UIImage imageNamed:@"download_YM"] forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(loadDownloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.menuButton.mas_left);
        make.centerY.mas_equalTo(self.menuButton);
        make.width.height.mas_equalTo(subViewHeight);
    }];
}
//倍速（小屏倍速按钮）
- (void)loadSpeedButton {
   _speedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_speedButton setTitle:@"1倍" forState:UIControlStateNormal];
    [_speedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_speedButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_speedButton addTarget:self action:@selector(speedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_speedButton];
    [self.speedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.downloadBtn.mas_left);
        make.centerY.mas_equalTo(self.menuButton);
        make.width.height.mas_equalTo(subViewHeight);
    }];
 
}
//倍速（大屏倍速按钮）
- (void)loadSpeedFullButton {
    _speedFullButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_speedFullButton setTitle:@"1倍" forState:UIControlStateNormal];
    [_speedFullButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_speedFullButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    _speedFullButton.hidden = YES;
    [_speedFullButton addTarget:self action:@selector(speedFullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:_speedFullButton];
    [self.speedFullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-subViewHeight/2);
        make.centerY.mas_equalTo(self.playbackButton);
        make.width.height.mas_equalTo(subViewHeight);
    }];
    
}
//全屏倍速切换视图
- (void)loadSpeedBackfroundView {
    self.speedBackground = [[UIView alloc] init];
    self.speedBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
    self.speedBackground.hidden = YES;
    [self addSubview:self.speedBackground];
    [self.speedBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(180);
    }];
    [ self.speedBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speedHidenAction)]];
    
    NSMutableArray *layoutArr = [NSMutableArray array];
    
    UILabel *speedTitleLabel = [[UILabel alloc] init];
    speedTitleLabel.textAlignment = NSTextAlignmentCenter;
    speedTitleLabel.textColor = [UIColor whiteColor];
    speedTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    speedTitleLabel.text = @"倍速";
    [self.speedBackground addSubview:speedTitleLabel];
    [layoutArr addObject:speedTitleLabel];
    
    _speedArray = @[@"1倍",@"1.5倍",@"2倍",@"3倍"];
    for (int i = 0; i < _speedArray.count; i++) {
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.tag = i + 3000;
        [nextBtn setTitle:_speedArray[i] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor colorWithRed:28 / 255.0 green:184 / 255.0 blue:119 / 255.0 alpha:1 / 1.0] forState:UIControlStateSelected];
        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [nextBtn addTarget:self action:@selector(speedControlFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        //设置选中倍速
        if (i==0) [nextBtn setSelected:YES];
        [_speedBackground addSubview:nextBtn];
        [layoutArr addObject:nextBtn];
    }
    //等间距离布局
    [layoutArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:20 leadSpacing:25 tailSpacing:50];
    [layoutArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.speedBackground);
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
        make.right.mas_equalTo(self.speedButton.mas_left);
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
//播放暂停按钮
- (void)loadPlaybackButton {
    self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playbackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.playbackButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.playbackButton];
    [self.playbackButton setImage:IMG(@"video_stop") forState:UIControlStateSelected];
    [self.playbackButton setImage:IMG(@"whitePlay_YM") forState:UIControlStateNormal];
    
    [self.playbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footerView.mas_left);
        make.centerY.mas_equalTo(self.footerView);
        make.width.height.mas_equalTo(subViewHeight);
    }];
}

//当前播放时长
- (void)loadCurrentPlaybackTimeLabel {
    _currentPlaybackTimeLabel = [[UILabel alloc] init];
    _currentPlaybackTimeLabel.text = @"00:00:00";
    _currentPlaybackTimeLabel.textColor = [UIColor whiteColor];
    _currentPlaybackTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentPlaybackTimeLabel.font = [UIFont systemFontOfSize:13];
    [self.footerView addSubview:_currentPlaybackTimeLabel];
    [self.currentPlaybackTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playbackButton.mas_right);
        make.centerY.mas_equalTo(self.playbackButton);
        make.size.mas_equalTo(CGSizeMake(60, subViewHeight));
    }];

}

//总时长
- (void)loadDurationLabel {
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.text = @"00:00:00";
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.backgroundColor = [UIColor clearColor];
    self.durationLabel.font = [UIFont systemFontOfSize:13];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    [self.footerView addSubview:self.durationLabel];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cutButton.mas_left);
        make.centerY.mas_equalTo(self.playbackButton);
        make.size.mas_equalTo(CGSizeMake(60, subViewHeight));
    }];
}
//滑块
- (void)loadPlaybackSlider {

    self.durationSlider = [[UISlider alloc] init];
    self.durationSlider.minimumValue = 0.0f;
    self.durationSlider.maximumValue = 1.0f;
    self.durationSlider.value = 0.0f;
    // NSLog(@"durationSlider.value--durationSlidersetting--%f",self.durationSlider.value);
    self.durationSlider.continuous = YES; //yes持续发,no发一下
    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"player-slider-active2"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"playPoint_YM"]
                              forState:UIControlStateNormal];
    self.durationSlider.minimumTrackTintColor = [UIColor colorWithRed:28 / 255.0 green:184 / 255.0 blue:119 / 255.0 alpha:1 / 1.0];
    self.durationSlider.maximumTrackTintColor = [UIColor whiteColor];
    
    //拖动页面和拖动进度条效果一致
    // self.durationSlider.userInteractionEnabled = NO;
    
    [self.footerView addSubview:self.durationSlider];
    [self.durationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentPlaybackTimeLabel.mas_right).offset(6);
        make.right.mas_equalTo(self.durationLabel.mas_left);
        make.centerY.mas_equalTo(self.playbackButton).offset(-1);
        make.height.mas_equalTo(subViewHeight);
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
    self.cutButton.accessibilityIdentifier= @"视频" ;
    self.cutButton.backgroundColor = [UIColor clearColor];
    [self.cutButton addTarget:self action:@selector(cutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:self.cutButton];
    [self.cutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left);
        make.centerY.mas_equalTo(self.footerView);
        make.width.height.mas_equalTo(subViewHeight);
    }];
    
}

// 拖动平移显示实现变化的View

- (void)loadPanView {
    //主项目中这个View有前进后退和取消 但是主项目没实现效果，没法参照，所以不写无用代码
    self.panView = [[UIView alloc] init];
    self.panView.layer.cornerRadius = 4.f;
    self.panView.layer.masksToBounds= YES;
    self.panView.backgroundColor = RGBAColor(76, 76, 76, 0.8f);
    self.panView.hidden = YES;
    [self addSubview:self.panView];
    [self.panView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 60));
    }];
    self.panViewLabel = [[UILabel alloc] init];
    self.panViewLabel.textColor = [UIColor whiteColor];
    self.panViewLabel.font = [UIFont systemFontOfSize:12];
    [self.panView addSubview:self.panViewLabel];
    [self.panViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.panView.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(self.panView);
    }];
    
    /* seekTime 相关 */


    
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
- (void)loadDownloadBtnAction:(UIButton *)button {
    [self excuteDeleteMethod:@"下载" button:button];
}
- (void)speedButtonAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(speedActionButton:)]) {
        [self.delegate speedActionButton:button];
    }
}
- (void)playButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"播放" button:button];
}
- (void)cutButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"切换" button:button];
}

- (void)fullScreenButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"全屏" button:button];
}

- (void)speedFullButtonAction:(UIButton *)button {
    [self excuteDeleteMethod:@"全屏倍速显示" button:nil];
}
- (void)speedControlFullScreen:(UIButton *)button {
    [self excuteDeleteMethod:@"全屏倍速选择" button:button];
}
- (void)speedHidenAction {
    [self excuteDeleteMethod:@"全屏倍速隐藏" button:nil];
}

- (void)excuteDeleteMethod:(NSString *)name button:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(videoOverLayerClickWithName: button:)]) {
        [self.delegate videoOverLayerClickWithName:name button:button] ;
    }
}


//cc和gensee的时间计算相差1000，cc是秒 ，gensee是毫秒
- (void)panActionToPanViewLabel:(NSInteger)seekTime  liveType:(BOOL)liveType{
    
    NSInteger alltime =  liveType?(int)_duration :(int)_duration  /1000;
    
    int allHours = (int)(alltime/3600);
    if (allHours) {
        
        int nowHours = (int)seekTime/3600;
        int nowMin = 0;
        int nowSec = 0;
        if (nowHours) {
            nowMin = (int)(seekTime%3600)/60;
            nowSec = (seekTime%3600)%60;
        }else{
            nowMin = (int)seekTime/60;
            nowSec = seekTime%60;
        }
    
        int allMin = (int)(alltime%3600)/60;
        int allSec = (alltime%3600)%60;
        
        self.panViewLabel.text =  [NSString stringWithFormat:@"%02d:%02d:%02d/%02d:%02d:%02d",nowHours,nowMin,nowSec,allHours,allMin,allSec];
        
    }else{
        
        int nowMin = (int)seekTime/60;
        int nowSec = seekTime%60;
        
        int allMin = (int)alltime/60;
        int allSec = alltime%60;
        
       self.panViewLabel.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",nowMin,nowSec,allMin,allSec];
    }
    
    
    
}

//底部竖屏布局和横屏布局
- (void) newLayout:(BOOL)type {
    if (type) {
        //顶部
         self.speedButton.hidden = NO;
        //底部竖屏布局
        self.speedFullButton.hidden = YES;
        self.fullScreenButton.hidden = NO;
        self.cutButton.hidden = NO;
        self.durationLabel.hidden = NO;
        [self.playbackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.footerView.mas_left);
            make.centerY.mas_equalTo(self.footerView);
            make.width.height.mas_equalTo(subViewHeight);
        }];
        [self.durationSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.currentPlaybackTimeLabel.mas_right).offset(6);
            make.right.mas_equalTo(self.durationLabel.mas_left);
            make.centerY.mas_equalTo(self.playbackButton).offset(-1);
            make.height.mas_equalTo(subViewHeight);
        }];
        [self.currentPlaybackTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, subViewHeight));
        }];
    }else {
        //顶部
        self.speedButton.hidden = YES;
        //底部横屏布局
        self.speedFullButton.hidden = NO;
        self.fullScreenButton.hidden = YES;
        self.cutButton.hidden = YES;
        self.durationLabel.hidden = YES;
        [self.playbackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.footerView.mas_left);
            make.bottom.mas_equalTo(self.footerView).offset(-10);
            make.width.height.mas_equalTo(subViewHeight);
        }];
        [self.durationSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.footerView).offset(subViewHeight/2);
            make.right.mas_equalTo(self.footerView).offset(-subViewHeight);
            make.bottom.mas_equalTo(self.playbackButton.mas_top);
            make.height.mas_equalTo(subViewHeight);
        }];
        [self.currentPlaybackTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, subViewHeight));
        }];
        self.currentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%@ / %@",  self.currentPlaybackTimeLabel.text?:@"", self.durationLabel.text?:@""] ;
    }
}

@end

//
//  DXLivePlayBackViewController.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/3.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLivePlayBackViewController.h"
#import "DXLiveRequest.h"       //网络请求
#import <SPPageMenu/SPPageMenu.h>

@interface DXLivePlayBackViewController ()  <SPPageMenuDelegate,UIGestureRecognizerDelegate,DXPlayBackOverLayerViewDelegate,DXLivePlayBackViewControllerDelegate>

@property (strong, nonatomic) DXLiveRequest *request;                            //网络请求
@property (strong, nonatomic) UIButton *smallVideoBackButton;            // 小视频上的关闭按钮
@property (assign, nonatomic) int noteCurrentPage;                       // 笔记请求页标
@property(nonatomic, strong)UIView *headerSafeView;//iphoneX头部
@property (nonatomic, assign) NSInteger toIndex; //由于SPPageMenu，全屏返回之后调整了scrollViewde contenSize，导致显示bug，借这个属性更正
@property (assign, nonatomic) BOOL isComment; //是否评论过该课程
@property (assign, nonatomic) CGFloat lastPanX; //平移X坐标
@property (assign, nonatomic) CGFloat lastSilderValue; //平移X的值

@property (nonatomic,strong)NSTimer                     *timer;//cc的计时器 ..cc回放需要自己计算计时器播放，计算聊天时序，计算暂停播放 。。。。。
@property (nonatomic,assign)float                       playBackRate;//CC播放速率 配合timer使用的




//拖动屏幕,前进后退相关
//@property (strong, nonatomic) DXPlayActionView *playActionView; //快进快退view
//视频时间滑块拖动
@property (nonatomic, assign) float sliderLastValue; //上次的时间值
@end

@implementation DXLivePlayBackViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view bringSubviewToFront:_parentPlaySmallWindow];
    [_parentPlayLargerWindow bringSubviewToFront:_overlayView];
    [_interfaceView setupDataScrollPositionBottom];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(docVideoStatus:) name:@"liveDocVideoStatus" object:nil];//初始化成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfaceOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    _request = [[DXLiveRequest alloc] init];
    [self getCommentData]; //查询是否评价过该课程
    _playBackRate = 1;
    
    [self initParentPlayLargerWindow];  //直播大父视图
    [self initParentPlaySmallWindow]; //直播小父视图
    
    //初始化直播（注意先初始化上面的大的和小的直播父视图）
    if (_liveType) {
        [self initCCPlayBack];  //ccsdk
    }else {
        [self initGenseePlayBack];  //genseesdk
    }
    
    [self initIntefaceView]; //非直播视图


}


/** 大的播放视图 */
- (void)initParentPlayLargerWindow {
    
    _headerSafeView = [[UIView alloc] init];
    [self.view addSubview:_headerSafeView];
    _headerSafeView.backgroundColor = [UIColor blackColor];
    [_headerSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.height.mas_equalTo(0);
    }];
    
    _parentPlayLargerWindow = [[UIView alloc] init];
    _parentPlayLargerWindow.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_parentPlayLargerWindow];
    [_parentPlayLargerWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?kStatusBarHeight:0);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(9.0/16.0);
    }];
    [self.view layoutIfNeeded];
    
    //播放操作
    _overlayView = [[DXPlayBackOverLayerView alloc] initWithTarget:self];
    _overlayView.titleLabel.text = _videoTitle;
    [_parentPlayLargerWindow addSubview:_overlayView];
    //    _overlayView.layer.zPosition = 100000;//不响应
    [_overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0,0,0));
    }];
    [_overlayView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelLargerTap:)]];//点击事件
//    [_overlayView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];//平移事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self; //解决手势冲突
    [_overlayView addGestureRecognizer:pan];
    //滑块事件
    [_overlayView.durationSlider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];
    [_overlayView.durationSlider addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
}
/**初始化小的播放视图 */
- (void)initParentPlaySmallWindow {
    _parentPlaySmallWindow = [[UIView alloc] init];
    _parentPlaySmallWindow.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_parentPlaySmallWindow];
    [_parentPlaySmallWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.parentPlayLargerWindow.mas_bottom).offset(50);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(144);
        make.height.mas_equalTo(144*9.0/16); //cc不支持3.0/4的比例，gensee支持,这里使用通用的9/16
    }];
    [self.view layoutIfNeeded];
    //关闭
    [_parentPlaySmallWindow addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)]];
    [self setupSmallVideoBackButton];//小播放窗口显示关闭按钮
    [_parentPlaySmallWindow addSubview:self.smallVideoBackButton];
    //拖动平移
    [_parentPlaySmallWindow addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fullPanGestureRecognizer:)]];
    
}
//初始化非播放视图
- (void)initIntefaceView {
    _interfaceView = [[DXLiveInteractionView alloc] initWithFrame:CGRectZero target:self];
    [self.view addSubview:_interfaceView];
    _interfaceView.teach_material_file_title = _videoTitle;
    _interfaceView.teach_material_file = _teach_material_file;
    [_interfaceView.fileTableView reloadData];
    [_interfaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.parentPlayLargerWindow.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    _interfaceView.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_header)];
    _interfaceView.noteTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_footer)];
    
    //由于直播和回放公用非播放页面，所以需要调整布局
    _interfaceView.textButton.superview.hidden = YES;
    [_interfaceView.textButton.superview removeFromSuperview];
    [_interfaceView.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.interfaceView.chatTableView.superview);
    }];
    [_interfaceView.noteTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.interfaceView.noteTableView.superview);
    }];
    
}

//大直播视图上面的按钮操作（——overLayView）
- (void)videoOverLayerClickWithName:(NSString *)name button:(nonnull UIButton *)button {
    if ([name isEqualToString:@"返回"]) [self backButtonAction:button];
    else if ([name isEqualToString:@"分享"]) [self shareButtonAction:button];
    else if ([name isEqualToString:@"更多"]) [self menuButtonAction:button];
    else if ([name isEqualToString:@"播放"]) [self playButtonAction:button];
    else if ([name isEqualToString:@"切换"]) [self cutButtonAction:button];
    else if ([name isEqualToString:@"全屏"]) [self fullScreenButtonAction:button];
}

#pragma mark -通知方法
//收到直播初始化化成功的通知
- (void)docVideoStatus:(NSNotification *)sender {
    if ([sender.object boolValue]) {
        //回放初始化成功，加入直播
    }else {
        [self showHint:@"视频、文档加载失败"];
    }
    //不管成功失败
    [self playButtonAction:_overlayView.playbackButton]; //设置按钮为播放状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //回放初始化视图的耗时较长，可能数据已经开始返回，视图还没有初始化完成(还没有添加到父视图上)..
        [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
    });
    
}
//播放、暂停
- (void)playButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    //不做判断 如果为nil自然调用无效
    if (button.selected) {
        //恢复播放

        if (_liveType) {
            [self.requestDataPlayBack startPlayer]; //cc
            [self.offlinePlayBack startPlayer];//cc
            [self startTimer];
        }else {
            [self.vodplayer resume]; //gensee
        }
    
   
    }
    else {
        //暂停
        
        if (_liveType) {
            [self.requestDataPlayBack pausePlayer]; //cc
            [self.offlinePlayBack pausePlayer]; //cc
            [self stopTimer];
        }else {
            [self.vodplayer pause];//gensee
        }
        

    }
}

- (void)appDidBecomeActive {
    [self.vodplayer resetAudioPlayer];
}
//CC开始播放 计时器
-(void)startTimer {
    [self stopTimer];
     __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / _playBackRate) target:weakSelf selector:@selector(timerfunc) userInfo:nil repeats:YES];
}
//CC停止播放 计时器
-(void) stopTimer {
    if([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)timerfunc{

    dispatch_async(dispatch_get_main_queue(), ^{
        //获取当前播放时间和视频总时长
        NSTimeInterval position = (int)round(self.requestDataPlayBack.currentPlaybackTime);
        NSTimeInterval duration =   self.overlayView.duration;//(int)round(self.requestDataPlayBack.playerDuration);
//        //存在播放器最后一点不播放的情况，所以把进度条的数据对到和最后一秒想同就可以了
//        if(duration - position == 1 && (self.overlayView.durationSlider.value == position || self.overlayView.durationSlider.value == duration)) {
//            position = duration;
//        }
//        self.duration = round(self.requestDataPlayBack.playerDuration);
//        self.overlayView.duration = round(self.requestDataPlayBack.playerDuration);
        
        //当前时长
        self.overlayView.currentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(position/60)/60,(int)(position/60)%60, (int)(position)%60];
        //总时长
        self.overlayView.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(duration/60)/60,(int)(duration/60)%60, (int)(duration)%60];
        if (!self.overlayView.sliderIsMoving) {
            //滑块
            [self.overlayView.durationSlider setValue:(position / duration) animated:YES];
        }
//
//        //校对SDK当前播放时间
//        if(position == 0 && self.playerView.sliderValue != 0) {
//            self.requestDataPlayBack.currentPlaybackTime = self.playerView.sliderValue;
//            //            position = self.playerView.sliderValue;
//            self.playerView.slider.value = self.playerView.sliderValue;
//            //        } else if(fabs(position - self.playerView.slider.value) > 10) {
//            //            self.requestDataPlayBack.currentPlaybackTime = self.playerView.slider.value;
//            ////            position = self.playerView.slider.value;
//            //            self.playerView.sliderValue = self.playerView.slider.value;
//        } else {
//            self.playerView.slider.value = position;
//            self.playerView.sliderValue = self.playerView.slider.value;
//        }
//
//        //校对本地显示速率和播放器播放速率
//        if(self.requestDataPlayBack.ijkPlayer.playbackRate != self.playerView.playBackRate) {
//            self.requestDataPlayBack.ijkPlayer.playbackRate = self.playerView.playBackRate;
//            //#ifdef LockView
//            //校对锁屏播放器播放速率
//            [_lockView updatePlayBackRate:self.requestDataPlayBack.ijkPlayer.playbackRate];
//            //#endif
//            [self.playerView startTimer];
//        }
//        if(self.playerView.pauseButton.selected == NO && self.requestDataPlayBack.ijkPlayer.playbackState == IJKMPMoviePlaybackStatePaused) {
//            //开启播放视频
//            [self.requestDataPlayBack startPlayer];
//        }
//        /* 获取当前时间段的文档数据  time：从直播开始到现在的秒数，SDK会在画板上绘画出来相应的图形 */
//        [self.requestDataPlayBack continueFromTheTime:self.playerView.sliderValue];
//
//        /*  加载聊天数据 */
//        [self parseChatOnTime:(int)self.playerView.sliderValue];
//        //更新左侧label
//        self.playerView.leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(self.playerView.sliderValue / 60), (int)(self.playerView.sliderValue) % 60];
//        //#ifdef LockView
//        /*  校对锁屏播放器进度 */
//        [_lockView updateCurrentDurtion:_requestDataPlayBack.currentPlaybackTime];
//        //#endif
    });
}

//设任意播放位置
- (void)setPlayLocation:(NSTimeInterval)duration {
    if (_liveType) {
        //cc
        if (_playDownload) {
            //离线
            _offlinePlayBack.currentPlaybackTime = duration;
        }else {
            //在线
            _requestDataPlayBack.currentPlaybackTime = duration;
        }
    }else {
        //gensee
        [self.vodplayer seekTo:duration];
    }
}
//小屏倍数切换
- (void) speedActionButton:(UIButton *)button {
    
    NSArray *buttonArr =  @[@"1倍",@"1.5倍",@"2倍",@"3倍"]; //我们只取4个值
    int index = 0;
    for (int i = 0; i<buttonArr.count; i++) {
        if ([button.titleLabel.text isEqualToString:buttonArr[i]]) {
            if (i==3) {
                [button setTitle:buttonArr[0] forState:(UIControlStateNormal)];
                index=0;
            }else {
                [button setTitle:buttonArr[i+1] forState:(UIControlStateNormal)];
                index = i+1;
            }
            break;
        }
    }
    if (_liveType) {
        //cc 可以任意设置值
        NSString *rateString =  buttonArr[index];
        _requestDataPlayBack.ijkPlayer.playbackRate = [[rateString substringToIndex:rateString.length-1] floatValue];
        _offlinePlayBack.ijkPlayer.playbackRate =   [[rateString substringToIndex:rateString.length-1] floatValue];
        _playBackRate = [[rateString substringToIndex:rateString.length-1] floatValue];
        
    }else {
        //gensee (Gensee SDK有9个固定的值)
        NSArray *arr =    [NSArray arrayWithObjects:@"1倍", @"1.25倍", @"1.5倍", @"1.75倍", @"2倍", @"2.5倍", @"3倍", @"3.5倍", @"4倍", nil];
        for (int i = 0; i<arr.count; i++) {
            if ([button.titleLabel.text isEqualToString:arr[i]]) {
                [self.vodplayer SpeedPlay:i];
                break;
            }
        }
    }
   
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

    _toIndex = toIndex;
    if (!_interfaceView.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [_interfaceView.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * toIndex, 0) animated:NO];
        } else {
            [_interfaceView.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH* toIndex, 0) animated:YES];
        }
    }
    if (toIndex==0) {//聊天
        [_interfaceView setupDataScrollPositionBottom];
    }else if (toIndex==1){//资料列表
    } else {// 笔记
        [_interfaceView.noteTableView.mj_header beginRefreshing];
    }
}
#pragma mark 笔记右边下拉点击事件
- (void)segmentButtonAction:(UIButton *)button {
    
    [_interfaceView.segmentButton setImage:[UIImage imageNamed:@"live_up"] forState:UIControlStateNormal];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPad?UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"课程咨询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"http://chat7714.talk99.cn/chat/chat/p.do?_server=0&c=20003089&f=10089572&g=10076235&refer=iPhone"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"即将打开课程咨询页"
                                                                       message:@"咨询完毕后，点击屏幕左上角的“都学课堂”就可以返回到课堂继续进行学习"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  if (url) {
                                                                      if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                          if (@available(iOS 10.0, *)) {
                                                                              [[UIApplication sharedApplication] openURL:url options:@{ UIApplicationOpenURLOptionUniversalLinksOnly:@(NO) } completionHandler:^(BOOL success) {
                                                                                  if (success) {
                                                                                      NSLog(@"Succeeded open URL: %@", url);
                                                                                  }
                                                                                  else {
                                                                                      NSLog(@"Failed to open URL: %@", url);
                                                                                  }
                                                                              }];
                                                                          } else {
                                                                              // Fallback on earlier versions
                                                                              [[UIApplication sharedApplication] openURL:url];
                                                                          }
                                                                      }
                                                                      else {
                                                                          NSLog(@"设备中不包含可以打开指定url(%@)的程序。", url);
                                                                      }
                                                                  }
                                                                  [self.interfaceView.segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self.interfaceView.segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
                                                             }];
        
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"意见反馈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //                DXFeedbackViewController *feedbackVC = [mainSB instantiateViewControllerWithIdentifier:@"feedbackVC"];
        UIViewController *feedbackVC = [mainSB instantiateViewControllerWithIdentifier:@"feedbackVC"];
        [feedbackVC setValue:@(0) forKey:@"feedbackType"];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"评价课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.isComment) {
            [self showHint:@"您已经点评过本课程，无需再次评价"];
        }else{
            DXLiveAppraiseViewController *liveAppraiseVC = [[DXLiveAppraiseViewController alloc] init];
            liveAppraiseVC.liveAppraiseType = LiveAppraiseChooseType;
            liveAppraiseVC.courseID = self.courseID;
            [self.navigationController pushViewController:liveAppraiseVC animated:YES];

        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.interfaceView.segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 手势点击

// 小视频上的关闭按钮
- (void)setupSmallVideoBackButton {
    self.smallVideoBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.smallVideoBackButton setImage:[UIImage imageNamed:@"live_smallVideoBack"] forState:UIControlStateNormal];
    self.smallVideoBackButton.frame = CGRectMake(0, 0, 30, 30);
    self.smallVideoBackButton.hidden = YES;
    self.smallVideoBackButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 0, 0);
    [self.smallVideoBackButton addTarget:self action:@selector(smallVideoButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
//小视频关闭按钮点击方法
- (void)smallVideoButtonAction {
    [self.overlayView.cutButton setImage:IMG(@"live_open") forState:UIControlStateNormal];
    _smallVideoBackButton.hidden = YES;
    _parentPlaySmallWindow.hidden = YES;
    
}
// 小视屏全屏拖拽方法
- (void)fullPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGPoint newCenter = CGPointMake(panGestureRecognizer.view.center.x+ translation.x,
                                    panGestureRecognizer.view.center.y + translation.y);//    限制屏幕范围
    newCenter.y = MAX(panGestureRecognizer.view.frame.size.height/2, newCenter.y);
    newCenter.y = MIN(self.view.frame.size.height - panGestureRecognizer.view.frame.size.height/2,  newCenter.y);
    newCenter.x = MAX(panGestureRecognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(self.view.frame.size.width - panGestureRecognizer.view.frame.size.width/2,newCenter.x);
    panGestureRecognizer.view.center = newCenter;
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
}
// 大视频手势点击
- (void)handleSignelLargerTap:(UIGestureRecognizer *)gestureRecognizer
{

    //点击大播放视图
    if (self.overlayView.headerView.hidden) {
        self.overlayView.footerView.hidden = NO;
        self.overlayView.headerView.hidden = NO;
        [self startClickTime];
    } else {
        self.overlayView.footerView.hidden = YES;
        self.overlayView.headerView.hidden = YES;
    }
}
// 大视频平移手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        _overlayView.panView.hidden = NO;
        _lastPanX = [pan locationInView:self.overlayView].x;
        _overlayView.sliderIsMoving = YES;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat scale =  ([pan locationInView:self.overlayView].x-_lastPanX)/_overlayView.frame.size.width;//如果觉得移动太快可以根据视频的的长度 调整
        NSTimeInterval nowTime =  (NSTimeInterval)((_overlayView.durationSlider.value + scale)*_overlayView.duration);
        if (nowTime>0) {
              [_overlayView panActionToPanViewLabel:nowTime/1000];
        }else {
              [_overlayView panActionToPanViewLabel:0];
        }
        
    }else {
        CGFloat scale =   ([pan locationInView:self.overlayView].x-_lastPanX)/_overlayView.frame.size.width;
        NSTimeInterval nowTime =  (NSTimeInterval)((_overlayView.durationSlider.value + scale)*_overlayView.duration);
        if (nowTime>0) {
            [_overlayView panActionToPanViewLabel:nowTime/1000];
            [self setPlayLocation:nowTime];
        }else {
            [_overlayView panActionToPanViewLabel:0];
            [self setPlayLocation:0];
        }
          _overlayView.panView.hidden = YES;
         _overlayView.sliderIsMoving = NO;
    }
    
}
// 由于单击手势和slider上的拖动进度条有冲突,加上这个方法可以避免出现冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UISlider class]]) {
        NSLog(@"代理过来了");
        return NO;
    }
    else {
        return YES;
    }
}

//滑块点击
- (void)durationSliderDone:(UISlider *)slider {
    
    NSLog(@"没有拖动，而是在点击");
    
//    [self.vodplayer seekTo:slider.value * _overlayView.duration];
    //    播放结束
//    if (NO) {
////        [self.vodplayer OnlinePlay:NO audioOnly:NO];
//    }
    _overlayView.playbackButton.selected = YES;//设置为播放状态

}
//拖动滑块放大显示拖动到的时间
- (void)sliderValurChanged:(UISlider *)slider forEvent:(UIEvent *)event {
    
    UITouch *touchEvent = [[event allTouches] anyObject];
    NSLog(@"拖动状态是？？？==%ld",touchEvent.phase);
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
        {
            
            _overlayView.panView.hidden = NO;
            _overlayView.sliderIsMoving = YES;
            _lastSilderValue = slider.value;
            
            NSLog(@"开始拖动....");
            
        } break;
            
        case UITouchPhaseMoved:
        {
            
            NSLog(@"正在拖动???");
            NSInteger nowTime =  (NSInteger)(slider.value*_overlayView.duration);
            [_overlayView panActionToPanViewLabel:nowTime/1000];
            
        } break;
        case UITouchPhaseEnded|UITouchPhaseCancelled:
        {
            NSLog(@"结束拖动");
            
            [self setPlayLocation:_overlayView.duration * slider.value];
            _overlayView.panView.hidden = YES;
            _overlayView.sliderIsMoving = NO;
            
        } break;
            
        default:
        {
            NSLog(@"拖动终结");
            [self setPlayLocation:_overlayView.duration * slider.value];
            _overlayView.panView.hidden = YES;
            _overlayView.sliderIsMoving = NO;
            
        } break;
    }
}
// 小视频手势点击
- (void)handleSignelSmallTap:(UIGestureRecognizer *)gestureRecognizer
{
    //点击小播放视图
    [_parentPlaySmallWindow bringSubviewToFront:_smallVideoBackButton];
    if ( self.smallVideoBackButton.hidden) {
        self.smallVideoBackButton.hidden = NO;
        [self startClickTime];
    }else{
        self.smallVideoBackButton.hidden = YES;
    }
}
- (void)startClickTime{
    __block int timeout = 5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if (timeout == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.overlayView.footerView.hidden = YES;
                self.overlayView.headerView.hidden = YES;
                self.smallVideoBackButton.hidden = YES;
                dispatch_source_cancel(timer);
                
            });
        }
        timeout--;
    });
    dispatch_resume(timer);
}

#pragma mark - -------- 大视屏button点击事件 ----------

// 返回按钮方法
- (void)backButtonAction:(UIButton *)button {
    //旋转
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        [self fullScreenButtonAction:button];
    }else{
        //Gensee
        if (self.vodplayer) {
            [self.vodplayer stop];
            [self.vodplayer.docSwfView  clearVodLastPageAndAnno];//退出前清理一下文档模块
            self.vodplayer.docSwfView = nil;
            self.vodplayer = nil;
            self.item = nil;
        }
        //CC
        if (_requestDataPlayBack) {//在线
            [_requestDataPlayBack requestCancel];
            _requestDataPlayBack = nil;
        }
        if (_offlinePlayBack) {//离线
            [_offlinePlayBack requestCancel];
            _offlinePlayBack = nil;
        }
        [self stopTimer];
//        [self.navigationController popViewControllerAnimated:YES];
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)button {
    //    DXCustomShareView *shareView = [[DXCustomShareView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    //    [shareView setShareAry:nil delegate:self];
    //    [self.navigationController.view addSubview:shareView];
    
}
#pragma mark DXCustomShareViewDelegate 分享相关
// 更多按钮方法
-(void)menuButtonAction:(UIButton *)button {
}

// 切换按钮方法
/**
 切换视频和文档视图
 
 @param button 切换视图和文档的按钮
 */
- (void)cutButtonAction:(UIButton *)button {
 
    if (_parentPlaySmallWindow.hidden) {
        //显示隐藏小视图
        _parentPlaySmallWindow.hidden = NO;
        if (_liveType) {
            //cc
            if (![self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
                [self.overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
            }else {
                [self.overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
            }
        }else {
            //gensee
            if ([self.vodplayer.mVideoView.superview isEqual:_parentPlaySmallWindow]) {
                [self.overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
            }else {
                [self.overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
            }
        }
        
    }else{
        if (_liveType) {
            //cc 就是这么复杂，已经写的很简洁了
            if ( [self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
                if (_playDownload) {//离线
                    [_offlinePlayBack changeDocParent:_parentPlaySmallWindow];
                    [_offlinePlayBack changePlayerParent:_parentPlayLargerWindow];
                    [_offlinePlayBack changeDocFrame:_parentPlaySmallWindow.bounds];
                    [_offlinePlayBack changePlayerFrame:_parentPlayLargerWindow.bounds];
                }else {//在线
                    [_requestDataPlayBack changeDocParent:_parentPlaySmallWindow];
                    [_requestDataPlayBack changePlayerParent:_parentPlayLargerWindow];
                    [_requestDataPlayBack changeDocFrame:_parentPlaySmallWindow.bounds];
                    [_requestDataPlayBack changePlayerFrame:_parentPlayLargerWindow.bounds];
                }
         
                
                [_overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
                _overlayView.cutButton.accessibilityIdentifier = @"文档";
            }else {
                if (_playDownload) {//离线
                    [_offlinePlayBack changeDocParent:_parentPlayLargerWindow];
                    [_offlinePlayBack changePlayerParent:_parentPlaySmallWindow];
                    [_offlinePlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                    [_offlinePlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
                }else {//在线
                    [_requestDataPlayBack changeDocParent:_parentPlayLargerWindow];
                    [_requestDataPlayBack changePlayerParent:_parentPlaySmallWindow];
                    [_requestDataPlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                    [_requestDataPlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
                }
          
                [_overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
                _overlayView.cutButton.accessibilityIdentifier = @"视频";
            }
            
        }else {
            //gensee
            if ([self.vodplayer.mVideoView.superview isEqual:_parentPlaySmallWindow]) {
                [_parentPlayLargerWindow addSubview:self.vodplayer.mVideoView];
                [_parentPlaySmallWindow addSubview:self.vodplayer.docSwfView];
                self.vodplayer.mVideoView.frame = _parentPlayLargerWindow.bounds;
                self.vodplayer.docSwfView.frame = _parentPlaySmallWindow.bounds;
                [self.overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
            }else {
                [_parentPlayLargerWindow addSubview:self.vodplayer.docSwfView];
                [_parentPlaySmallWindow addSubview:self.vodplayer.mVideoView];
                self.vodplayer.docSwfView.frame = _parentPlayLargerWindow.bounds;
                self.vodplayer.mVideoView.frame = _parentPlaySmallWindow.bounds;
                [self.overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
            }
        }
        
        [_parentPlayLargerWindow bringSubviewToFront:_overlayView];
        [_parentPlaySmallWindow bringSubviewToFront:_smallVideoBackButton];
    }
}

#pragma mark -- 全屏与非全屏之间的切换
//iphonex自动隐藏底部条纹
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
- (BOOL)shouldAutorotate {
    return NO;
}
//初始化的时候和模态present屏幕的方向（竖屏初始化）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
//自动旋转监听，竖屏和横屏
-(void)interfaceOrientationNotification:(NSNotification*)notification{
    [self orientationRotation];
}
//旋转
-(void)orientationRotation {
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        //竖屏
        _overlayView.fullScreenButton.selected = NO;
        [_parentPlayLargerWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?kStatusBarHeight:0);
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(9.0/16.0);
        }];
        [_parentPlaySmallWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.parentPlayLargerWindow.mas_bottom).offset(50);
            make.right.mas_equalTo(self.view.mas_right);
            make.width.mas_equalTo(144);
            make.height.mas_equalTo(144*9.0/16);
        }];
        [_overlayView.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
        [_overlayView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        [_headerSafeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.height.mas_equalTo(0);
        }];
        
        
    }else {
        //全屏
        _overlayView.fullScreenButton.selected = YES;
        [_parentPlayLargerWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, iPhoneX?44:0, 0, 0));
        }];
        [_parentPlaySmallWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(iPhoneX?-70-34:-70);
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
            make.width.mas_equalTo(144);
            make.height.mas_equalTo(144*9.0/16);
        }];
        [_overlayView.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
        [_overlayView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);//直播为70
        }];
        //设置iphoneX 的44黑色刘海
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            [_headerSafeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.view);
                make.left.mas_equalTo(self.view);
                make.width.mas_equalTo(iPhoneX?44:0);
            }];
        }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            [_headerSafeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.width.mas_equalTo(iPhoneX?44:0);
            }];
        }
        
        [self.view bringSubviewToFront:_headerSafeView];
        
        
    }
    
    //如果不需要和视频播放保持一致，这个方法可以注释
    [_overlayView newLayout:[UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait];
    [self.view bringSubviewToFront:_parentPlayLargerWindow];
    [self.view bringSubviewToFront:_parentPlaySmallWindow];
    [self.view layoutIfNeeded];
    if (_liveType) {
        //cc
        if ([self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
            if (_playDownload) {//离线
                [_offlinePlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                [_offlinePlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
            }else {//在线
                [_requestDataPlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                [_requestDataPlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
            }
       
        }else {
            if (_playDownload) {//离线
                [_offlinePlayBack changeDocFrame:_parentPlaySmallWindow.bounds];
                [_offlinePlayBack changePlayerFrame:_parentPlayLargerWindow.bounds];
            }else {//在线
                [_requestDataPlayBack changeDocFrame:_parentPlaySmallWindow.bounds];
                [_requestDataPlayBack changePlayerFrame:_parentPlayLargerWindow.bounds];
            }
        
        }
    }else {
        //gensee
        if ([self.vodplayer.docSwfView.superview isEqual:_parentPlayLargerWindow]) {
            self.vodplayer.docSwfView.frame = _parentPlayLargerWindow.bounds ;
            self.vodplayer.mVideoView.frame = _parentPlaySmallWindow.bounds ;
        }else {
            self.vodplayer.docSwfView.frame = _parentPlaySmallWindow.bounds ;
            self.vodplayer.mVideoView.frame = _parentPlayLargerWindow.bounds ;
        }
    }
    [_interfaceView.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * _toIndex, 0) animated:NO];
}
// 全屏按钮方法
- (void)fullScreenButtonAction:(UIButton *)button {

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    }else {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    }
}

#pragma mark - 数据请求

#pragma mark -- 笔记数据请求设置
- (void)getNotelist_header {
    _noteCurrentPage = 1;
    [_interfaceView.noteListArray removeAllObjects];
    [self getNotelist];
}

- (void)getNotelist_footer {
    _noteCurrentPage ++;
    [self getNotelist];
}

- (void)getNotelist {
    
    //参数就是这么传的 （笔记每次请求10页）
    [_request getNotelistWithUID:_uid courseID:_courseID chapterID:0 JieID:0 andPageIndex:_noteCurrentPage PageSize:10 success:^(NSDictionary * _Nonnull dic, BOOL state) {
        
        [self.interfaceView.noteTableView.mj_header endRefreshing];
        [self.interfaceView.noteTableView.mj_footer endRefreshing];
        if (state){
            [self.interfaceView.noteListArray addObjectsFromArray:(NSArray *)dic];
            [self.interfaceView.noteTableView reloadData];
        }else{
            self.noteCurrentPage --;
        }
    } fail:^(NSError * _Nonnull error) {
        [self.interfaceView.noteTableView.mj_header endRefreshing];
        [self.interfaceView.noteTableView.mj_footer endRefreshing];
    }];
}

- (void)getCommentData {
    [_request getCourseComment:_courseID pageIndex:0 pageSize:10 uid:_uid success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if (state) {
            self.isComment = YES;
        }else {
            self.isComment = NO;
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}



#pragma mark - 提示信息
- (void)showHint:(NSString *)hint {
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

#pragma mark -- 懒加载


#pragma mark -- dealloc
- (void)dealloc {
    
    NSLog(@"被销毁了。。。。。。。。。。。。。。");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

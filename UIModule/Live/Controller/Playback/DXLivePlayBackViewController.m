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
@property (assign, nonatomic) BOOL lockLandscape; //用户是否点击全屏状态下锁定自动旋转
@property (assign, nonatomic) int timeout; //倒计时
@property (nonatomic,strong)NSTimer   *countDownTimer;//操作视图消失倒计时
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    _request = [[DXLiveRequest alloc] init];
    [self getCommentData]; //查询是否评价过该课程
    _playBackRate = 1;
    [self startcountDownTimer];
    //    _lockLandscape = YES;//横屏锁定（设计图横屏左边有个锁的点击事件）默认不锁定 NO
    
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
- (void)setUserInfoWihtUid:(long long)uid uname:(NSString *)uname email:(NSString *)email phone:(NSString *)phone  {
    _uid = uid;
    _uname = uname;
    _email = email;
    _phone = phone;
}

/** 大的播放视图 */
- (void)initParentPlayLargerWindow {
    
    _headerSafeView = [[UIView alloc] init];
    [self.view addSubview:_headerSafeView];
    _headerSafeView.backgroundColor = [UIColor blackColor];
    [_headerSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(iPhoneX?44:0);
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
    [self initOverlayView];//初始化播放操作视图(要先于sdk加载，不然duration会赋值失败)
}
/**初始化小的播放视图 */
- (void)initParentPlaySmallWindow {
    CGRect frame = CGRectMake(IPHONE_WIDTH-144, CGRectGetMaxY(_parentPlayLargerWindow.frame)+50, 144, 144*9.0/16);
    _parentPlaySmallWindow = [[UIView alloc] initWithFrame:frame];//自动布局无法移动（播放时间一直在更新，自动布局跟着更新）
    _parentPlaySmallWindow.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_parentPlaySmallWindow];
    //关闭
    [_parentPlaySmallWindow addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)]];
    [self setupSmallVideoBackButton];//小播放窗口显示关闭按钮
    [_parentPlaySmallWindow addSubview:self.smallVideoBackButton];
    //拖动平移
    [_parentPlaySmallWindow addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fullPanGestureRecognizer:)]];
    
}
//初始化播放操作视图
- (void)initOverlayView {
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];//平移事件
    pan.delegate = self; //解决手势冲突
    [_overlayView addGestureRecognizer:pan];
    //滑块事件
    //    [_overlayView.durationSlider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];//不适用
    [_overlayView.durationSlider addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    [_overlayView.durationSlider  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(durationSliderDone:)]];
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
    else if ([name isEqualToString:@"下载"]) [self startDownloadAction:button];
    else if ([name isEqualToString:@"播放"]) [self playButtonAction:button];
    else if ([name isEqualToString:@"切换"]) [self cutButtonAction:button];
    else if ([name isEqualToString:@"全屏"]) [self fullScreenButtonAction:button];
    else if ([name isEqualToString:@"全屏倍速显示"]) [self fullScreenSpeedShowAction];
    else if ([name isEqualToString:@"全屏倍速选择"]) [self fullScreenSpeedSelectAction:button];
    else if ([name isEqualToString:@"全屏倍速隐藏"]) [self fullScreenSpeedHidenAction];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        _overlayView.playbackButton.selected = NO;
        [self playButtonAction:_overlayView.playbackButton]; //设置按钮为播放状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //cc回放初始化视图的耗时较长，可能数据已经开始返回，视图还没有初始化完成(还没有添加到父视图上)..
            [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
        });
    });
}
//下载
- (void)startDownloadAction:(UIButton *)button {
    if (_liveType) {
        //cc
    }else {
        //gensee
        if (_genseePlayDownload) {
            [self showHint:@"该视频已经下载完成"];
        }else {
              [self genseeDownload];
        }
    }
}
//播放、暂停
- (void)playButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        //恢复播放
        if (_liveType) {
            if (_isplayFinish) {
                _isplayFinish = NO;
                [self.requestDataPlayBack replayPlayer]; //cc
                [self.offlinePlayBack replayPlayer];//cc  //不做判断 如果为nil自然调用无效
            }else {
                [self.requestDataPlayBack startPlayer]; //cc
                [self.offlinePlayBack startPlayer];//cc  //不做判断 如果为nil自然调用无效
            }
           
            [self startTimer];
        }else {
            if (_isplayFinish) {
                _isplayFinish = NO;
                button.selected = NO;//设置播放按钮为非播放（原因是播放结束后按钮自动为暂停状态,重新播放会自动设置按钮为播放状态）
                if (_genseePlayDownload) {
                    //重新播放下载视频方法--（不在重新推送聊天）
                    [self.vodplayer OfflinePlay:NO];
                }else {
                    //重新播放在线视频--(不在重新推送聊天)
                    [self.vodplayer OnlinePlay:NO audioOnly:NO];
                }
            }else {
                [self.vodplayer resume]; //gensee
            }
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
//APP将要进入后台
- (void)appWillEnterBackgroundNotification {
    [self stopTimer];
    [self stopcountDownTimer];
}

//APP将要进入前台
- (void)appDidBecomeActive {
    [self startcountDownTimer];
    if (_liveType) {
        //cc
        /*  当视频播放被打断时，重新加载视频  cc只能从新开始。。。。(如果不支持后台模式暂停进入后台再回来只能重新开始。。。。。cc设计。。。)*/
        if (self.requestDataPlayBack?!self.requestDataPlayBack.ijkPlayer.playbackState:!self.offlinePlayBack.ijkPlayer.playbackState) {
            [self.requestDataPlayBack replayPlayer];
            [self.offlinePlayBack replayPlayer];
        }
        if (self.overlayView.playbackButton.selected||self.requestDataPlayBack.isPlaying||self.offlinePlayBack.isPlaying) {
            [self startTimer];
        }
    }else {
        //gensee
        [self.vodplayer resetAudioPlayer];
    }



}
//拔出耳机暂停播放
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            //暂停
            if (_overlayView.playbackButton.selected) {
                _overlayView.playbackButton.selected = NO;
                if (_liveType) {
                    [self.requestDataPlayBack pausePlayer]; //cc
                    [self.offlinePlayBack pausePlayer]; //cc
                    [self stopTimer];
                }else {
                    [self.vodplayer pause];//gensee
                }
            }
        }
    }

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
        [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
        //获取当前播放时间和视频总时长
        NSTimeInterval position = round(self.requestDataPlayBack?self.requestDataPlayBack.currentPlaybackTime:self.offlinePlayBack.currentPlaybackTime);
        NSTimeInterval duration = round(self.requestDataPlayBack?self.requestDataPlayBack.playerDuration:self.offlinePlayBack.playerDuration);
        self.overlayView.duration = duration;//必须写在这里其他地方可能拿不到。。。
        //当前时长
        self.overlayView.currentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(position/60)/60,(int)(position/60)%60, (int)(position)%60];
        //总时长
        self.overlayView.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(duration/60)/60,(int)(duration/60)%60, (int)(duration)%60];
        if (!self.overlayView.sliderIsMoving) {
            //滑块
            [self.overlayView.durationSlider setValue:(position / duration) animated:YES];
        }

        /* 获取当前时间段的文档数据  time：从直播开始到现在的秒数，SDK会在画板上绘画出来相应的图形 （同步文档信息）*/
        [self.requestDataPlayBack continueFromTheTime:self.overlayView.durationSlider.value*self.overlayView.duration];
        [self.offlinePlayBack continueFromTheTime:self.overlayView.durationSlider.value*self.overlayView.duration];
        /*  按照时间顺序显示加载聊天数据 */
        NSUInteger index = self.interfaceView.chatArray.count;//当前聊天位置
        for (NSUInteger i = index; i<self.chatArr.count; i++) {
            int time =  [self.chatArr[i][@"time"] intValue];
            if (time< (int)position) {
                NSDictionary *dic = self.chatArr[i];
                    if (![dic[@"status"] isEqualToString:@"1"]){
                        if (dic[@"content"]) {
                            [self.interfaceView.chatArray addObject:dic[@"content"]];
                            [self.interfaceView.nameArray addObject:dic[@"userName"]?:@""];
                            if ([dic[@"userrole"] isEqualToString:@"publisher"]) {
                                [self.interfaceView.imageArray addObject:@"lecturer_nor"];
                            }else {
                                [self.interfaceView.imageArray addObject:dic[@"useravatar"]?:@""];
                            }
            
                        }
                    }
                    [self.interfaceView setupDataScrollPositionBottom];
            }else{
                break;
            }
        }


    });
}

//设任意播放位置
- (void)setPlayLocation:(NSTimeInterval)duration {
    if (_liveType) {
        //cc
        if (_CCPlayDownload) {
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
    
    NSArray *buttonArr = _overlayView.speedArray;  //@[@"1倍",@"1.5倍",@"2倍",@"3倍"]; //我们只取4个值
    for (int i = 0; i<buttonArr.count; i++) {
        if ([button.titleLabel.text isEqualToString:buttonArr[i]]) {
            if (i==3) {
                [button setTitle:buttonArr[0] forState:(UIControlStateNormal)];
            }else {
                [button setTitle:buttonArr[i+1] forState:(UIControlStateNormal)];

            }
            break;
        }
    }
    [self setSpeedWithString: button.titleLabel.text];
    //大小屏同步
    for (UIButton *btn in _overlayView.speedBackground.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
            if ([btn.titleLabel.text isEqualToString:button.titleLabel.text]) {
                btn.selected = YES;
            }
        }
    }
}
- (void)setSpeedWithString:(NSString *)string {
    if (_liveType) {
        //cc 可以任意设置值
        NSString *rateString =  string;
        _requestDataPlayBack.ijkPlayer.playbackRate = [[rateString substringToIndex:rateString.length-1] floatValue];
        _offlinePlayBack.ijkPlayer.playbackRate =   [[rateString substringToIndex:rateString.length-1] floatValue];
        _playBackRate = [[rateString substringToIndex:rateString.length-1] floatValue];
        
    }else {
        //gensee (Gensee SDK有9个固定的值)
        NSArray *arr =    [NSArray arrayWithObjects:@"1倍", @"1.25倍", @"1.5倍", @"1.75倍", @"2倍", @"2.5倍", @"3倍", @"3.5倍", @"4倍", nil];
        for (int i = 0; i<arr.count; i++) {
            if ([string isEqualToString:arr[i]]) {
                [self.vodplayer SpeedPlay:i];
                break;
            }
        }
    }
}
//大屏倍数显示
- (void)fullScreenSpeedShowAction{
    _overlayView.speedBackground.hidden = NO;
    [self.view bringSubviewToFront:_parentPlayLargerWindow];//防止被小播放视图遮挡
}
//大屏倍数切换
- (void)fullScreenSpeedSelectAction:(UIButton*)button {
    for (UIButton *btn in button.superview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
        }
    }
    button.selected = YES;
    [_overlayView.speedButton setTitle:button.titleLabel.text forState:(UIControlStateNormal)];//大小屏同步
    [self setSpeedWithString: button.titleLabel.text];
    [self fullScreenSpeedHidenAction];
}
//大屏倍数隐藏
- (void)fullScreenSpeedHidenAction{
    _overlayView.speedBackground.hidden = YES;
    [self.view bringSubviewToFront:_parentPlaySmallWindow];//调出小播放视图
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
    _timeout = 5; //倒计时时间
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
     _timeout = 5; //倒计时时间
    //点击大播放视图
    if (self.overlayView.headerView.hidden) {
        self.overlayView.footerView.hidden = NO;
        self.overlayView.headerView.hidden = NO;
    } else {
        self.overlayView.footerView.hidden = YES;
        self.overlayView.headerView.hidden = YES;
    }
}
// 大视频平移手势
- (void)panAction:(UIPanGestureRecognizer *)pan {
     _timeout = 5; //倒计时时间
    if (_isplayFinish) {
        //如果播放已经结束，平移事件无效，需要用户手动点击重新开始播放，或者滑动slider
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        
        _lastPanX = [pan locationInView:self.overlayView].x;
        _overlayView.sliderIsMoving = YES;
        NSLog(@"pan开始拖动");
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        
        _overlayView.panView.hidden = NO;
        CGFloat scale =  ([pan locationInView:self.overlayView].x-_lastPanX)/_overlayView.frame.size.width;//如果觉得移动太快可以根据视频的的长度 调整
        NSTimeInterval nowTime =  (NSTimeInterval)((_overlayView.durationSlider.value + scale)*_overlayView.duration);
        if (nowTime>0) {
            [_overlayView panActionToPanViewLabel:_liveType?nowTime:nowTime/1000 liveType:_liveType];
        }else {
              [_overlayView panActionToPanViewLabel:0 liveType:_liveType];
        }
        
    }else {
         NSLog(@"pan结束拖动");
        CGFloat scale =   ([pan locationInView:self.overlayView].x-_lastPanX)/_overlayView.frame.size.width;
        NSTimeInterval nowTime =  (NSTimeInterval)((_overlayView.durationSlider.value + scale)*_overlayView.duration);
        if (nowTime>0) {
            [_overlayView panActionToPanViewLabel:_liveType?nowTime:nowTime/1000 liveType:_liveType];
            [self setPlayLocation:nowTime];
        }else {
            [_overlayView panActionToPanViewLabel:0 liveType:_liveType];
            [self setPlayLocation:0];
        }
        _overlayView.playbackButton.selected = YES;//设置按钮为播放状态
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
- (void)durationSliderDone:(UITapGestureRecognizer *)tap {
    
     _timeout = 5; //倒计时时间
    NSLog(@"点滑动结束");
    if (_overlayView.sliderIsMoving) {
        _overlayView.sliderIsMoving = NO;
    }else {
            CGFloat value = [tap locationInView:tap.view].x/tap.view.frame.size.width;
            [_overlayView.durationSlider setValue:value animated:YES];
    }
    _overlayView.sliderIsMoving = NO;//结束拖动
    _overlayView.panView.hidden = YES;

    //播放结束
    if (_isplayFinish) {
        [self playButtonAction:_overlayView.playbackButton];//主动调用重新播放按钮
    }
    //设置播放位置（顺序不能错 ，要先判断是否播放结束）
    [self setPlayLocation:_overlayView.duration * _overlayView.durationSlider.value];


}
//拖动滑块放大显示拖动到的时间
- (void)sliderValurChanged:(UISlider *)slider forEvent:(UIEvent *)event {
     _timeout = 5; //倒计时时间
    UITouch *touchEvent = [[event allTouches] anyObject];
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
        {
            _overlayView.panView.hidden = NO;
            _overlayView.sliderIsMoving = YES;
            _lastSilderValue = slider.value;
            NSInteger nowTime =  (NSInteger)(slider.value*_overlayView.duration);
            [_overlayView panActionToPanViewLabel:_liveType?nowTime:nowTime/1000 liveType:_liveType];
            NSLog(@"开始拖动....");
            
        } break;
            
        case UITouchPhaseMoved:
        {
            NSLog(@"正在拖动???");
            NSInteger nowTime =  (NSInteger)(slider.value*_overlayView.duration);
            [_overlayView panActionToPanViewLabel:_liveType?nowTime:nowTime/1000 liveType:_liveType];
            
        } break;
        case UITouchPhaseEnded:
        {
            //结束拖动和点击手势有冲突
            [self setPlayLocation:_overlayView.duration * _overlayView.durationSlider.value];
            _overlayView.sliderIsMoving = NO;//结束拖动
            _overlayView.panView.hidden = YES;
            NSLog(@"结束拖动。。。。。。。。。。。。。。。。。。。。");
        } break;
        case UITouchPhaseCancelled:
        {
            NSLog(@"取消拖动。。。。。。。。。。。。。。。。。。。。。。");
        } break;
        default:
        {
            NSLog(@"拖动default。。。。。。。。。。。。。。。。。。");
        } break;
    }
}
// 小视频手势点击
- (void)handleSignelSmallTap:(UIGestureRecognizer *)gestureRecognizer
{
     _timeout = 5; //倒计时时间
    //点击小播放视图
    [_parentPlaySmallWindow bringSubviewToFront:_smallVideoBackButton];
    if ( self.smallVideoBackButton.hidden) {
        self.smallVideoBackButton.hidden = NO;
    }else{
        self.smallVideoBackButton.hidden = YES;
    }
}
//计时器
-(void)startcountDownTimer {
    __weak typeof(self) weakSelf = self;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:weakSelf selector:@selector(startClickTime) userInfo:nil repeats:YES];
}
-(void) stopcountDownTimer {
    if([_countDownTimer isValid]) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}
- (void)startClickTime{
    self.timeout --; //倒计时时间
    if (self.timeout==0) {
        self.overlayView.footerView.hidden = YES;
        self.overlayView.headerView.hidden = YES;
        self.smallVideoBackButton.hidden = YES;
    }
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
        self.manager = nil;
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
        [self stopcountDownTimer];
        [self.navigationController popViewControllerAnimated:YES];
//         [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)button {
    //    DXCustomShareView *shareView = [[DXCustomShareView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT)];
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
                if (_CCPlayDownload) {//离线
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
                if (_CCPlayDownload) {//离线
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
    if (_lockLandscape&&[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        return NO;//横屏锁定
    }
    return YES;
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
            make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?44:0);
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(9.0/16.0);
        }];
        [_overlayView.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
        [_overlayView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        [_headerSafeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.view);
            make.height.mas_equalTo(iPhoneX?44:0);
        }];
        
    }else {
        //全屏
        //全屏下masonry提示约束多于冲突原因是pageMenu的高度是44 但是此时他的父视图( _interfaceView)没有高度，不影响布局;强逼症者去除pageMenu高度即可
        _overlayView.fullScreenButton.selected = YES;
        [_overlayView.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
        [_overlayView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(90);//直播为70
        }];
        //设置iphoneX 的44黑色刘海
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            [_parentPlayLargerWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, iPhoneX?44:0, 0, 0));
            }];
            [_headerSafeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(self.view);
                make.left.mas_equalTo(self.view);
                make.width.mas_equalTo(iPhoneX?44:0);
            }];
        }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            [_parentPlayLargerWindow mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, iPhoneX?44:0));
            }];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        //这个必须放在主线程中，不然layoutIfNeeded可能不会第一时间生效，一半的可能性
        [self.view layoutIfNeeded];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            _parentPlaySmallWindow.frame = CGRectMake(IPHONE_WIDTH-144, CGRectGetMaxY(_parentPlayLargerWindow.frame)+50, 144, 144*9.0/16);
        }else {
            _parentPlaySmallWindow.frame = CGRectMake(IPHONE_WIDTH-144-(iPhoneX?44:0), IPHONE_HEIGHT-144*9.0/16-(iPhoneX?70+34:70), 144, 144*9.0/16);
        }
        if (_liveType) {
            //cc
            if ([self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
                if (_CCPlayDownload) {//离线
                    [_offlinePlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                    [_offlinePlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
                }else {//在线
                    [_requestDataPlayBack changeDocFrame:_parentPlayLargerWindow.bounds];
                    [_requestDataPlayBack changePlayerFrame:_parentPlaySmallWindow.bounds];
                }
           
            }else {
                if (_CCPlayDownload) {//离线
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
    });

}
// 全屏按钮方法
- (void)fullScreenButtonAction:(UIButton *)button {

    if (_lockLandscape) {
        _lockLandscape = NO;
    }
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
    [_request getCourseComment:_courseID pageIndex:0 pageSize:10 uid:(NSInteger)_uid success:^(NSDictionary * _Nonnull dic, BOOL state) {
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];//xcode7之后这句话可以不写 ，编译器会加上
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

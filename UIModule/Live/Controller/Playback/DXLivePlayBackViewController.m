//////
//////  DXLivePlayBackViewController.m
//////  Doxuewang
//////
//////  Created by doxue_ios on 2018/3/3.
//////  Copyright © 2018年 都学网. All rights reserved.
//////
////
//#define HeaderViewHeight (isTransition == YES ? 70.0f : 60.0f)
//#define FootViewHeight (isTransition == YES ? 70.0f : 40.0f)
//#define headerSubViewHeight 40.0f
//#define headerSubViewWidth 40.0f
//#define headerSubViewFullWidth 40.0f
//#define footerSubViewFullWidth 40.0f
//#define footerSubViewFullHeight 40.0f
//
//#define MO_DOMAIN @"V_FAST_CONFIG_DOMAIN"
//#define MO_SERVICE @"V_FAST_CONFIG_SERVICE_TYPE"
//#define MO_ROOMID @"V_FAST_CONFIG_ROOMID"
//#define MO_NICKNAME @"V_FAST_CONFIG_NICKNAME"
//#define MO_PWD @"V_FAST_CONFIG_PWD"
//#define MO_LOGIN_NAME @"V_FAST_CONFIG_LOGIN_NAME"
//#define MO_LOGIN_PWD @"V_FAST_CONFIG_LOGIN_PWD"
//#define MO_THIRD_KEY @"V_FAST_CONFIG_THIRD_KEY"
//#define MO_REWARD @"V_FAST_CONFIG_REWARD"
//#define MO_USERID @"V_FAST_CONFIG_USERID"
//
//#import "DXLiveBackDownLoadingManager.h"
//#import "DXLivePlaybackModel.h"
//#import "DXLivePlaybackFMDBManager.h"
//#import "DXPlayActionView.h"
//#import "DXLiveKeyboardView.h"
//#import "DXLiveFootView.h"
//#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
//#import <QuickLook/QuickLook.h>
//#import "DXLivePlayBackViewController.h"
//#import <VodSDK/VodSDK.h>
//#import "DXLiveShowCell.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import "DXCustomShareView.h"
//#import "UIImage+LMImage.h"
//#import "CCSegment.h"
//#import "DXLiveNoteCell.h"
//#import "DXApiGetNoteExcutor.h"
//#import "DXApiUpNoteExcutor.h"
//#import "DXApiUploadNoteIMGExcutor.h"
//#import "DXLiveShieldView.h"
//#import "DXLiveAppraiseViewController.h"
//#import "DXFeedbackViewController.h"
//#import "DXLiveConnectShieldView.h"
//#import "OHAttributedLabel.h"
//#import "MarkupParser.h"
//#import "NSAttributedString+Attributes.h"
//#import "SCGIFImageView.h"
//#import "DXLiveNoteKeyboardView.h"
//#import "UIView+Extension.h"
//#import "DXApiGetCourseCommentExcutor.h"
//#import "DXLiveConnectShieldView.h"
//#import "UIView+YMTool.h"
//
//#define NOTEPAGESIZE 10
//
//static NSString *showLiveCellIdentifier = @"DXLiveShowCell";
//static NSString *noteLiveCellIdentifier = @"DXLiveNoteCell";
//
//typedef enum : NSUInteger {
//    SegmentIndexNode = -1,
//    SegmentIndexChat = 0,
//    SegmentIndexMaterial = 1,
//    SegmentIndexNote = 2
//} SegmentIndex;
//
//@interface DXLivePlayBackViewController () <VodDownLoadDelegate, VodPlayDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, GSVodDocViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, GSVodManagerDelegate, DZNEmptyDataSetSource,
//                                            DZNEmptyDataSetDelegate, QLPreviewControllerDataSource, liveNoteKeyboardViewDelegate, liveChatButtonDelegate, UIWebViewDelegate> {
//    BOOL isTransition;    // 是否是全屏
//    BOOL isCut;           // 切换
//    BOOL isVideoFinished; // 播放完成
//    float videoRestartValue;
//    BOOL isDragging;
//    BOOL hasOrientation;
//    BOOL isSliderValue;
//    int _duration;
//    int _position;
//    float _sliderValue;
//    BOOL isSegment;     // 是否是聊天或者笔记  YES是聊天  NO是笔记
//    BOOL isHiddenVideo; // 是否隐藏小视频     YES是隐藏  NO是不隐藏
//    BOOL isDocVideo;    // 是否是文档        YES是文档  NO是视频
//    CGFloat height;     // 直播聊天高度
//    BOOL isComment;     // 是否评价完成       YES是已经评价  NO是没评价
//    dispatch_source_t _timer;
//    NSString *contentText; // 输入框内容
//
//    /* 添加手势相关 */
//    UIPanGestureRecognizer *_panGesture;
//    CGPoint _lastPanPoint;
//    CGPoint _nowPanPoint;
//    CGFloat _rightPanDistance;
//    CGFloat _leftPanDistance;
//    NSInteger _totalSeconds;
//    NSInteger _pastSeccons;
//    CGFloat _durationSliderValue;
//}
//@property (nonatomic, assign) BOOL isPublicNote;                            // 是否公布
//@property (nonatomic, strong) DXLiveNoteKeyboardView *liveNoteKeyboardView; // 弹出笔记键盘时显示的View
//@property (nonatomic, assign) CGFloat keyboardHeight;                       // 键盘高度
//@property (nonatomic, strong) DXLiveKeyboardView *liveKeyboardView;         // 弹出聊天键盘时显示的View
//
//@property (nonatomic, strong) DXLiveFootView *liveFootView; // 最下方者笔记视图
//@property (copy, nonatomic) NSURL *pdfFileURL;              //PDF文件路径
//// 课程详情界面传过来的回放参数item
//@property (nonatomic, strong) downItem *item;
//@property (nonatomic, strong) VodDownLoader *vodDownLoader;           // 管理点播件（录制件）下载的类
//@property (nonatomic, strong) VodPlayer *vodplayer;                   // 管理播放点播件（录制件）的类
//@property (nonatomic, strong) DXLiveShowCell *cell;                   // 显示直播聊天的cell
//@property (nonatomic, strong) UIButton *segmentButton;                // 分段控制器(下拉按钮)
//@property (nonatomic, strong) UIView *liveTopView;                    // 回放上方视图
//@property (nonatomic, strong) UITableView *noteTableView;             // 笔记tableView */
//@property (nonatomic, strong) NSMutableArray *dataArray;              // 数据数组
//@property (nonatomic, strong) NSMutableArray *nameArray;              // 昵称数组
//@property (nonatomic, strong) NSMutableArray *imageArray;             // 图片数组
//@property (assign, nonatomic) BOOL hiddenAll;                         // 隐藏视频view上下控件
//@property (strong, nonatomic) UIView *overlayView;                    // 大视频透明View
//@property (strong, nonatomic) UIView *panResponseView;                //拖动时间时间响应区域
//@property (strong, nonatomic) UITapGestureRecognizer *signelTap;      // 点击大视频手势
//@property (strong, nonatomic) UITapGestureRecognizer *signelSmallTap; // 点击小视频手势
//@property (strong, nonatomic) UIPanGestureRecognizer *dragPanGesture; //视频拖动进度
//@property (strong, nonatomic) UIView *headerView;                     // 大视频透明View上方蒙版
//@property (strong, nonatomic) UIView *footerView;                     // 大视频透明View下方蒙版
//@property (nonatomic, strong) CAGradientLayer *gradientLayerHeader;   // 大视频透明View上方渐变色
//@property (nonatomic, strong) CAGradientLayer *gradientLayerFooter;   // 大视频透明View下方渐变色
//@property (nonatomic, strong) UIView *bootomSafeView;                 //iphoneX底部
//@property (nonatomic, strong) UIView *headerSafeView;                 //iphoneX底部
//@property (nonatomic, strong) UIButton *backButton;                   // 回放返回按钮
//@property (nonatomic, strong) UIButton *speedButton;                  // 小屏回放倍速按钮
//@property (strong, nonatomic) UIButton *speedAcitonDown;              //下面倍速按钮
//@property (nonatomic, strong) UILabel *titleLabel;                    // 回放标题
//@property (strong, nonatomic) UIButton *downloadBtn;                  // 下载按钮
//@property (strong, nonatomic) UIButton *menuButton;                   //菜单按钮
//@property (nonatomic, strong) UIButton *shareButton;                  // 回放分享按钮
//@property (nonatomic, strong) UIButton *cutButton;                    // 回放切换按钮
//@property (nonatomic, strong) UIButton *fullScreenButton;             // 回放全屏按钮
//@property (nonatomic, strong) UIButton *playbackButton;               // 回放播放暂停按钮
//@property (strong, nonatomic) UILabel *durationLabel;                 // 回放总播放时间Label
//@property (strong, nonatomic) UILabel *currentPlaybackTimeLabel;      // 回放播放时间Label
//@property (strong, nonatomic) UISlider *durationSlider;               // 回放进度条
//@property (assign, nonatomic) NSInteger speedCode;                    // 回放倍速(1.0,1.5,2.0,3.0)
//@property (nonatomic, strong) UILabel *fullPlayTimeLabel;             //全屏下当前时长/总时长
//
//@property (nonatomic, strong) UIView *qualityButtonBackground;         //横屏清晰度切换背景图
//@property (nonatomic, strong) UIView *qualityButtonBackgroundRestView; //
//@property (nonatomic, strong) UIView *speedBackground;                 //横屏倍速切换背景图
//@property (nonatomic, strong) UIView *speedBackgroundRestView;         //
//
//@property (assign, nonatomic) BOOL hiddenBack;                   // 隐藏小视频view控件
//@property (nonatomic, strong) NSDictionary *key2fileDic;         // 直播表情相关DIC
//@property (nonatomic, strong) NSDictionary *text2keyDic;         // 直播表情相关DIC
//@property (strong, nonatomic) UIButton *smallVideoBackButton;    // 小视频上的关闭按钮
//@property (nonatomic, strong) UIView *segmentView;               // 整体分段控制器视图(显示聊天、笔记以及下拉按钮)
//@property (nonatomic, strong) UIView *nodeLineView;              // 节点下方的线
//@property (nonatomic, strong) UIView *chatLineView;              // 聊天下方的线
//@property (nonatomic, strong) UIView *learningMaterialsLineView; //学习资料
//@property (nonatomic, strong) UIView *noteLineView;              // 笔记下方的线
//
//@property (nonatomic, strong) CCSegment *segment;                                 // 分段控制器(显示聊天和笔记)
//@property (nonatomic, strong) UIPanGestureRecognizer *fullPan;                    // 全屏拖拽手势
//@property (nonatomic, strong) NSArray *networkArray;                              // 存放网络的数组
//@property (nonatomic, strong) DXLiveConnectShieldView *connectShieldView;         // 进入直播间时弹出的视图
//@property (nonatomic, strong) DXLiveShieldView *shieldView;                       // 关闭直播时弹出的视图
//@property (nonatomic, strong) UIImage *screenshotsImage;                          // 截图
//@property (strong, nonatomic) DXApiGetNoteExcutor *apiGetNoteExcutor;             // 笔记api
//@property (strong, nonatomic) DXApiUpNoteExcutor *apiUpNoteExcutor;               // 笔记api
//@property (strong, nonatomic) DXApiGetCourseCommentExcutor *apiGetCommentExcutor; // 笔记api
//@property (assign, nonatomic) int noteCurrentPage;                                // 笔记请求页标
//@property (nonatomic, strong) NSMutableArray *noteListArray;                      // 存放笔记数组
//@property (nonatomic, strong) UITableView *chatTableView;                         // 聊天tableView
//@property (nonatomic, strong) UITableView *LearningMaterialsView;                 // 资料View
////直播回放下载相关
//@property (nonatomic, strong) GSVodManager *manager;
//@property (nonatomic, strong) VodParam *vodParam;
//
////拖动屏幕,前进后退相关
//@property (strong, nonatomic) DXPlayActionView *playActionView; //快进快退view
////视频时间滑块拖动
//@property (nonatomic, assign) float sliderLastValue; //上次的时间值
//
//@property (nonatomic, strong) UIWebView *pdfWebView;
//@property (strong, nonatomic) UIButton *closePdfButton;
////准备下载的item
////@property (strong, nonatomic)downItem * downloadingItem;
//@end
//
//@implementation DXLivePlayBackViewController
//
//#pragma mark - 生命周期
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    // 更新导航栏的外观和状态
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self.navigationController setNavigationBarHidden:YES];
//    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//    
//    [self getCommentData];
//}
//
//- (void)appDidBecomeActive {
//    [self.vodplayer resetAudioPlayer];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    isDragging = NO;
//    self.speedCode = 0;
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"RtSDK" ofType:@"bundle"]];
//    _key2fileDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"key2file" ofType:@"plist"]];
//    _text2keyDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"text2key" ofType:@"plist"]];
//
//    [self.view addSubview:self.connectShieldView];
//
//    [self initVodDownloader];
//
//    _manager = [GSVodManager sharedInstance];
//    _manager.delegate = self;
//}
//
////多个下载管理器
//- (void)setGSVodManager {
//    //  获取已经下载完成的点播件（录制件）
//    NSArray *doneItemArray = [[VodManage shareManage] searchFinishedItems];
//    NSMutableArray *downloadIngArray = [[DXLiveBackDownLoadingManager sharedInstance] allDownLoadIngArray];
//    NSMutableArray *items = [NSMutableArray arrayWithArray:doneItemArray];
//    [items addObjectsFromArray:downloadIngArray];
//    NSLog(@"%d", self.item.state);
//
//    if (!items.count) {
//        [self insertGSVodMagerDownloadQueueWith:self.item];
//    }
//    else {
//        NSLog(@"%ld", items.count);
//        NSMutableArray *strDownloadIDArray = [NSMutableArray arrayWithCapacity:0];
//        [items enumerateObjectsUsingBlock:^(downItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
//            [strDownloadIDArray addObject:obj.strDownloadID];
//        }];
//        if ([strDownloadIDArray containsObject:self.item.strDownloadID]) {
//            NSLog(@"GSVodDownloadController : 已经下载过该点播件");
//            [[HUDHelper sharedInstance] tipMessage:@"已经下载过该点播件"];
//        }
//        else {
//            [self insertGSVodMagerDownloadQueueWith:self.item];
//        }
//    }
//}
//
//
////插入到下载队列
//- (void)insertGSVodMagerDownloadQueueWith:(downItem *)item {
//    NSLog(@"insertGSVodMagerDownloadQueueWith");
//    //把下载的直播回放信息插入数据库
//    DXLivePlaybackModel *livePlaybackModel = [[DXLivePlaybackModel alloc] init];
//    livePlaybackModel.PrimaryTitle = self.videoTitle;
//    livePlaybackModel.SecondaryTitle = self.SecondTitle;
//    livePlaybackModel.coverImageUrl = self.imgUrl;
//    livePlaybackModel.strDownloadID = _item.strDownloadID;
//    livePlaybackModel.live_room_id = self.live_room_id;
//    livePlaybackModel.courseID = [NSString stringWithFormat:@"%ld", self.courseID];
//    //NSLog(@"%@",livePlaybackModel);
//    [[DXLivePlaybackFMDBManager shareManager] insertLivePlaybackWatchItem:livePlaybackModel];
//    // NSLog(@"%@",_item.strDownloadID);
//    DXLivePlaybackModel *model = [[DXLivePlaybackFMDBManager shareManager] selectCurrentModelWithStrDownloadID:item.strDownloadID];
//    NSLog(@"%@", model);
//    if ([NSString isEmpty:model.strDownloadID]) {
//        [[HUDHelper sharedInstance] tipMessage:@"下载失败" delay:3.0];
//    }
//    else {
//        [[HUDHelper sharedInstance] tipMessage:@"开始下载" delay:3.0];
//        //插入到末尾
//        [[GSVodManager sharedInstance] insertQueue:item atIndex:-1];
//        [[DXLiveBackDownLoadingManager sharedInstance] allDownLoadIngArray];
//        [[DXLiveBackDownLoadingManager sharedInstance] insertDownItem:item];
//        NSLog(@"%@", [[DXLiveBackDownLoadingManager sharedInstance] allDownLoadIngArray]);
//        [[GSVodManager sharedInstance] startQueue];
//        NSLog(@"%lu", [[GSVodManager sharedInstance] state]);
//    }
//}
//
////下载
//- (void)initVodDownloader {
//    VodParam *vodParam = [[VodParam alloc] init];
//    vodParam.domain = @"doxue.gensee.com";
//    //vodParam.number = self.live_room_id ;//2.    number为房间号
//    vodParam.number = self.number; //   vodId为点播id
//    vodParam.vodPassword = self.live_student_client_token;
//    vodParam.nickName = [DXUserManager sharedManager].user.uname;
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"training";
//    vodParam.customUserID = 1000000000 + [DXUserManager sharedManager].user.uid;
//    //vodParam.oldVersion = NO;
//    _vodParam = vodParam;
//    if (!_vodDownLoader) {
//        _vodDownLoader = [[VodDownLoader alloc] initWithDelegate:self];
//    }
//    [_vodDownLoader addItem:vodParam];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}
//
//#pragma mark - SafeView _ iphonex
//- (void)loadSafeView {
//    if (iPhoneX) {
//        if (isTransition) {
//            self.headerSafeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, KScreenWidth)];
//            self.headerSafeView.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:self.headerSafeView];
//            [self.view bringSubviewToFront:self.headerSafeView];
//            self.headerSafeView.hidden = NO;
//
//            self.bootomSafeView = [[UIView alloc] initWithFrame:CGRectMake(KScreenHeight - 34, 0, 34, KScreenWidth)];
//            self.bootomSafeView.backgroundColor = [UIColor blackColor];
//
//            [self.view addSubview:self.bootomSafeView];
//            [self.view bringSubviewToFront:self.bootomSafeView];
//            self.bootomSafeView.hidden = NO;
//        }
//        else {
//            self.headerSafeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
//            self.headerSafeView.backgroundColor = [UIColor blackColor];
//
//            [self.view addSubview:self.headerSafeView];
//            [self.view bringSubviewToFront:self.headerSafeView];
//
//            self.bootomSafeView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 34, KScreenWidth, 34)];
//            self.bootomSafeView.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:self.bootomSafeView];
//            [self.view bringSubviewToFront:self.bootomSafeView];
//            self.bootomSafeView.hidden = YES;
//        }
//    }
//}
//
//- (void)setupPlayBack {
//    //在线播放
//    downItem *Litem = [[VodManage shareManage] findDownItem:_item.strDownloadID];
//    if (Litem) {
//        if (self.vodplayer) {
//            [self.vodplayer stop];
//            self.vodplayer = nil;
//        }
//        self.vodplayer = ((AppDelegate *) [UIApplication sharedApplication].delegate).vodplayer;
//        if (!self.vodplayer) {
//            self.vodplayer = [[VodPlayer alloc] init];
//        }
//
//        self.vodplayer.playItem = Litem;
//
//        if (IS_IPHONE_X) {
//            self.vodplayer.docSwfView = [[GSVodDocView alloc] initWithFrame:CGRectMake(0, 44, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9)];
//        }
//        else {
//            self.vodplayer.docSwfView = [[GSVodDocView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9)];
//        }
//        self.vodplayer.docSwfView.zoomEnabled = NO;
//        self.vodplayer.docSwfView.isVectorScale = NO;
//        [self.view addSubview:self.vodplayer.docSwfView];
//        self.vodplayer.delegate = self;
//        self.vodplayer.docSwfView.vodDocDelegate = self;
//        self.vodplayer.docSwfView.gSDocModeType = VodScaleToFill;
//        self.vodplayer.docSwfView.backgroundColor = dominant_BlockColor;       //文档没有显示出来之前，GSVodDocView显示的背景色
//        [self.vodplayer.docSwfView setGlkBackgroundColor:51 green:51 blue:51]; //文档加载以后，侧边显示的颜色
//        [self.vodplayer OnlinePlay:YES audioOnly:NO];
//        self.overlayView = [[UIView alloc] initWithFrame:self.vodplayer.docSwfView.bounds];
//
//        self.vodplayer.docSwfView.userInteractionEnabled = YES;
//        [self.vodplayer.docSwfView addSubview:_overlayView];
//        self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//        self.signelTap.numberOfTapsRequired = 1;
//        self.signelTap.delegate = self;
//        [self.vodplayer.docSwfView addGestureRecognizer:self.signelTap];
//
//        // 初始化子视图
//        [self loadFooterView];
//        [self loadHeaderView];
//        [self loadPanResponseViewV];
//        [self loadSafeView];
//
//        //拖动进度
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//        _panGesture.delegate = self;
//        [self.panResponseView addGestureRecognizer:_panGesture];
//        self.playActionView.center = self.overlayView.center;
//        [self.overlayView addSubview:self.playActionView];
//    }
//}
//
////横屏
//- (void)loadPanResponseViewL {
//    self.panResponseView = [[UIView alloc] init];
//    self.panResponseView.frame = CGRectMake(0, headerSubViewHeight, self.overlayView.width, self.overlayView.height - headerSubViewHeight - footerSubViewFullHeight - 30);
//    [self.overlayView addSubview:self.panResponseView];
//}
//
////竖屏
//- (void)loadPanResponseViewV {
//    self.panResponseView = [[UIView alloc] init];
//    if (iPhoneX) {
//        self.panResponseView.frame = CGRectMake(0, headerSubViewHeight, self.overlayView.width, self.overlayView.height - headerSubViewHeight - footerSubViewFullHeight);
//    }
//    else {
//        self.panResponseView.frame = CGRectMake(0, headerSubViewHeight + kStatusBarHeight, self.overlayView.width, self.overlayView.height - headerSubViewHeight - kStatusBarHeight - footerSubViewFullHeight);
//    }
//    [self.overlayView addSubview:self.panResponseView];
//}
//
////全屏倍速切换视图
//- (void)loadSpeedBackfroundView {
//    self.speedBackground = [[UIView alloc] initWithFrame:CGRectMake(self.overlayView.width - 200, 0, 200, self.overlayView.height)];
//    self.speedBackground.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
//    self.speedBackground.hidden = YES;
//    [self.overlayView addSubview:self.speedBackground];
//
//    UILabel *speedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 200, 25)];
//    speedTitleLabel.textAlignment = NSTextAlignmentCenter;
//    speedTitleLabel.textColor = [UIColor whiteColor];
//    speedTitleLabel.font = [UIFont boldSystemFontOfSize:18];
//    speedTitleLabel.text = @"倍速";
//    [_speedBackground addSubview:speedTitleLabel];
//
//    for (int i = 0; i < 4; i++) {
//        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        nextBtn.tag = i + 3000;
//        nextBtn.frame = CGRectMake(0, 117 + 54 * i, 200, 54);
//        //nextBtn.frame = CGRectMake(0, CGRectGetMaxY(speedTitleLabel.frame)+30+54*i, 200, 54);
//        if (i == 0) {
//            [nextBtn setTitle:@"1x" forState:UIControlStateNormal];
//        }
//        else if (i == 1) {
//            [nextBtn setTitle:@"1.5x" forState:UIControlStateNormal];
//        }
//        else if (i == 2) {
//            [nextBtn setTitle:@"2x" forState:UIControlStateNormal];
//        }
//        else {
//            [nextBtn setTitle:@"3x" forState:UIControlStateNormal];
//        }
//
//        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [nextBtn setTitleColor:[UIColor colorWithRed:28 / 255.0 green:184 / 255.0 blue:119 / 255.0 alpha:1 / 1.0] forState:UIControlStateSelected];
//        nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        ;
//        [_speedBackground addSubview:nextBtn];
//        [nextBtn addTarget:self action:@selector(speedControlFullScreen:) forControlEvents:UIControlEventTouchUpInside];
//
//        //设置选中倍速
//        if (self.speedCode) {
//            if (self.speedCode % 4 == i) {
//                [nextBtn setSelected:YES];
//            }
//        }
//    }
//
//    self.speedBackgroundRestView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlayView.height - 200, KScreenWidth)];
//    self.speedBackgroundRestView.backgroundColor = [UIColor clearColor];
//    self.speedBackgroundRestView.hidden = YES;
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speedBackgroundRestViewTap:)];
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.delegate = self;
//    [self.speedBackgroundRestView addGestureRecognizer:singleTap];
//    [self.overlayView addSubview:self.speedBackgroundRestView];
//}
//
////全屏下点击倍速切换背景其余视图
//- (void)speedBackgroundRestViewTap:(UITapGestureRecognizer *)tap {
//    [self.speedBackground setHidden:YES];
//    [self.speedBackgroundRestView setHidden:YES];
//    //    [_overlayView addGestureRecognizer:_signelTap];
//    self.playActionView.center = self.overlayView.center;
//    [self.overlayView addSubview:self.playActionView];
//}
//
////全屏切换倍速
//- (void)speedControlFullScreen:(UIButton *)sender {
//    [self.overlayView bringSubviewToFront:self.speedBackground];
//    [self.overlayView bringSubviewToFront:self.speedBackgroundRestView];
//
//    for (UIView *obj in _speedBackground.subviews) {
//        if ([obj isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *) obj;
//            [btn setSelected:NO];
//        }
//    }
//    [sender setSelected:YES];
//
//    if (sender.tag == 3000) {
//        _speedCode = 0;
//        [self.vodplayer SpeedPlay:1.0];
//        [self.speedButton setTitle:@"1.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"1.0倍" forState:UIControlStateNormal];
//        self.speedCode = 0;
//    }
//    else if (sender.tag == 3001) {
//        self.speedCode = 1;
//        [self.vodplayer SpeedPlay:1.5];
//        [self.speedButton setTitle:@"1.5倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"1.5倍" forState:UIControlStateNormal];
//    }
//    else if (sender.tag == 3002) {
//        self.speedCode = 2;
//        [self.vodplayer SpeedPlay:2.0];
//        [self.speedButton setTitle:@"2.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"2.0倍" forState:UIControlStateNormal];
//    }
//    else {
//        self.speedCode = 3;
//        [self.vodplayer SpeedPlay:3.0];
//        [self.speedButton setTitle:@"3.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"3.0倍" forState:UIControlStateNormal];
//    }
//
//    [self.speedBackground setHidden:YES];
//    [self.speedBackgroundRestView setHidden:YES];
//}
//
//
//#pragma mark - 手势识别 UIGestureRecognizerDelegate
//
//- (void)handleSignelTap:(UIGestureRecognizer *)gestureRecognizer {
//    _hiddenAll = !_hiddenAll;
//    if (self.hiddenAll) {
//        _footerView.hidden = YES;
//        _headerView.hidden = YES;
//    }
//    else {
//        _footerView.hidden = NO;
//        _headerView.hidden = NO;
//        [self startClickVideoTime];
//    }
//}
//
///**
// 加载视频窗口顶部的功能条
// */
//- (void)loadHeaderView {
//    if (iPhoneX) {
//        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, HeaderViewHeight)];
//    }
//    else {
//        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, HeaderViewHeight)];
//    }
//    [self.overlayView addSubview:self.headerView];
//
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    NSArray *newColors = @[(id)[UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.65].CGColor,
//                                  (id)[UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.25].CGColor,
//                                  (id)[UIColor clearColor].CGColor];
//
//    gradientLayer.colors = newColors;
//    gradientLayer.locations = @[
//        @(0.0),
//        @(0.66),
//        @(1.0),
//    ];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1);
//    gradientLayer.frame = CGRectMake(0, 0, KScreenWidth, self.headerView.height);
//    [self.headerView.layer addSublayer:gradientLayer];
//    self.gradientLayerHeader = gradientLayer;
//
//    [self loadBackButton];
//    [self loadTitleLabel];
//    [self loadMenuButton];
//    [self loadDownloadBtn];
//    [self loadSpeedButton];
//    //[self loadShareButton];
//}
//
///**
// 加载视频底部区域工具条
// */
//- (void)loadFooterView {
//    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.overlayView.height - FootViewHeight, self.overlayView.width, FootViewHeight)];
//    [self.overlayView addSubview:self.footerView];
//    self.footerView.userInteractionEnabled = YES;
//
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    NSArray *newColors = @[(id) [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.6].CGColor,
//                           (id)[UIColor clearColor].CGColor];
//
//
//    gradientLayer.colors = newColors;
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(0, 0);
//    gradientLayer.frame = CGRectMake(0, 0, self.overlayView.frame.size.width, FootViewHeight);
//    [self.footerView.layer addSublayer:gradientLayer];
//    self.gradientLayerFooter = gradientLayer;
//
//
//    [self loadPlaybackButton];
//    [self loadCurrentPlaybackTimeLabel];
//    [self loadFullScreen];
//    [self loadCutButton];
//    [self loadDurationLabel];
//    [self loadPlaybackSlider];
//}
//
//- (void)loadBackButton {
//    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.backButton setImage:IMG(@"back_YM") forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    self.backButton.backgroundColor = [UIColor clearColor];
//    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:self.backButton];
//    if (iPhoneX) {
//        self.backButton.frame = CGRectMake(0, 0, headerSubViewHeight, headerSubViewHeight);
//    }
//    else {
//        self.backButton.frame = CGRectMake(0, 20, headerSubViewHeight, headerSubViewHeight);
//    }
//}
//
//- (void)loadMenuButton {
//    //菜单按钮
//    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.headerView addSubview:self.menuButton];
//    if (iPhoneX) {
//        self.menuButton.frame = CGRectMake(self.headerView.frame.size.width - headerSubViewWidth, 0, headerSubViewWidth, headerSubViewHeight);
//    }
//    else {
//        self.menuButton.frame = CGRectMake(self.headerView.frame.size.width - headerSubViewWidth, 20, headerSubViewWidth, headerSubViewHeight);
//    }
//
//    self.menuButton.backgroundColor = [UIColor clearColor];
//    // self.menuButton.backgroundColor = [UIColor redColor];
//    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.menuButton setImage:[UIImage imageNamed:@"more_YM"] forState:UIControlStateNormal];
//    [self.menuButton addTarget:self
//                        action:@selector(menuButtonAction:)
//              forControlEvents:UIControlEventTouchUpInside];
//}
//
//
//- (void)loadDownloadBtn {
//    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //[self.downloadBtn setTitle:@"" forState:UIControlStateNormal];
//    [self.downloadBtn setImage:[UIImage imageNamed:@"download_YM"] forState:UIControlStateNormal];
//    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//
//    [self.downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //[self.downloadBtn setBackgroundColor:[UIColor redColor]];
//    [self.downloadBtn addTarget:self action:@selector(loadDownloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:self.downloadBtn];
//
//    if (iPhoneX) {
//        self.downloadBtn.frame = CGRectMake(self.headerView.frame.size.width - headerSubViewWidth * 2, 0, headerSubViewWidth, headerSubViewHeight);
//    }
//    else {
//        self.downloadBtn.frame = CGRectMake(self.headerView.frame.size.width - headerSubViewWidth * 2, 20, headerSubViewWidth, headerSubViewHeight);
//    }
//}
//
//- (void)loadSpeedButton {
//    UIButton *speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (self.speedCode % 4 == 0) {
//        [speedBtn setTitle:@"1.0倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 1) {
//        [speedBtn setTitle:@"1.5倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 2) {
//        [speedBtn setTitle:@"2.0倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 3) {
//        [speedBtn setTitle:@"3.0倍" forState:UIControlStateNormal];
//    }
//    [speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [speedBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [speedBtn addTarget:self action:@selector(speedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.speedButton = speedBtn;
//    [self.headerView addSubview:self.speedButton];
//    //[self.speedAcitonUp setBackgroundColor:[UIColor redColor]];
//
//    CGRect headerRect = self.headerView.frame;
//    if (iPhoneX) {
//        self.speedButton.frame = CGRectMake(headerRect.size.width - headerSubViewWidth * 3, 0, headerSubViewWidth, headerSubViewHeight);
//    }
//    else {
//        self.speedButton.frame = CGRectMake(headerRect.size.width - headerSubViewWidth * 3, 20, headerSubViewWidth, headerSubViewHeight);
//    }
//}
//
//- (void)loadShareButton {
//    //    self.shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    //    [self.shareButton setImage:IMG(@"live_share") forState:UIControlStateNormal];
//    //    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    self.shareButton.backgroundColor = [UIColor clearColor];
//    //    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    //    [self.headerView addSubview:self.shareButton];
//    //    CGRect frame = self.headerView.frame;
//    //    self.shareButton.frame = CGRectMake(frame.size.width-44, frame.origin.y+ 20, 44, 44);
//}
//
//- (void)loadTitleLabel {
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.text = self.videoTitle;
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.headerView addSubview:self.titleLabel];
//
//    if (iPhoneX) {
//        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame), 0, (KScreenWidth - headerSubViewWidth * 4), headerSubViewHeight);
//    }
//    else {
//        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame), 20, (KScreenWidth - headerSubViewWidth * 4), headerSubViewHeight);
//    }
//}
//- (void)loadPlaybackButton {
//    self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.playbackButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.footerView addSubview:self.playbackButton];
//    self.playbackButton.frame = CGRectMake(0, 0, footerSubViewFullHeight, footerSubViewFullHeight);
//    [self.playbackButton setImage:IMG(@"video_stop") forState:UIControlStateNormal];
//}
//
//- (void)loadCurrentPlaybackTimeLabel {
//    _currentPlaybackTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_playbackButton.frame.origin.x + _playbackButton.frame.size.width, FootViewHeight - footerSubViewFullHeight, 60, footerSubViewFullHeight)];
//    _currentPlaybackTimeLabel.text = @"00:00:00";
//    //NSLog(@"currentPlaybackTimeLabel--loadCurrentPlaybackTimeLabel--%@",_currentPlaybackTimeLabel.text);
//    _currentPlaybackTimeLabel.textColor = [UIColor whiteColor];
//    _currentPlaybackTimeLabel.textAlignment = NSTextAlignmentCenter;
//    _currentPlaybackTimeLabel.font = [UIFont systemFontOfSize:13];
//    [self.footerView addSubview:_currentPlaybackTimeLabel];
//    //NSLog(@"%f--%f",_playbackButton.frame.origin.x,_playbackButton.frame.size.width);
//}
//
//- (void)loadDurationLabel {
//    self.durationLabel = [[UILabel alloc] init];
//    self.durationLabel.text = @"00:00:00";
//    self.durationLabel.textColor = [UIColor whiteColor];
//    self.durationLabel.backgroundColor = [UIColor clearColor];
//    self.durationLabel.font = [UIFont systemFontOfSize:13];
//    self.durationLabel.textAlignment = NSTextAlignmentCenter;
//    [self.footerView addSubview:self.durationLabel];
//
//    self.durationLabel.frame = CGRectMake(self.footerView.size.width - self.fullScreenButton.size.width - 60 - footerSubViewFullHeight, 0, 60, footerSubViewFullHeight);
//}
//
//- (void)loadPlaybackSlider {
//    CGFloat sliderWidth = self.footerView.frame.size.width - _currentPlaybackTimeLabel.frame.origin.x - _currentPlaybackTimeLabel.frame.size.width - _durationLabel.frame.size.width - _fullScreenButton.frame.size.width * 2;
//    self.durationSlider = [[UISlider alloc] init];
//    [self durationSlidersetting];
//    [self.footerView addSubview:self.durationSlider];
//    self.durationSlider.frame = CGRectMake(_currentPlaybackTimeLabel.frame.origin.x + _currentPlaybackTimeLabel.frame.size.width, 0, sliderWidth, footerSubViewFullHeight);
//}
//
//- (void)durationSlidersetting {
//    self.durationSlider.minimumValue = 0.0f;
//    self.durationSlider.maximumValue = 1.0f;
//    self.durationSlider.value = 0.0f;
//    // NSLog(@"durationSlider.value--durationSlidersetting--%f",self.durationSlider.value);
//    self.durationSlider.continuous = YES; //yes持续发,no发一下
//    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
//                                     forState:UIControlStateNormal];
//    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"player-slider-active2"]
//                                     forState:UIControlStateNormal];
//    [self.durationSlider setThumbImage:[UIImage imageNamed:@"playPoint_YM"]
//                              forState:UIControlStateNormal];
//    [self.durationSlider addTarget:self action:@selector(durationSliderMoving:) forControlEvents:UIControlEventValueChanged];
//    [self.durationSlider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];
//    [self.durationSlider addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
//    self.durationSlider.minimumTrackTintColor = [UIColor colorWithRed:28 / 255.0 green:184 / 255.0 blue:119 / 255.0 alpha:1 / 1.0];
//    self.durationSlider.maximumTrackTintColor = [UIColor whiteColor];
//
//    //拖动页面和拖动进度条效果一致
//    // self.durationSlider.userInteractionEnabled = NO;
//}
//
//- (void)loadCutButton {
//    self.cutButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.cutButton setImage:IMG(@"cutSmall_YM") forState:UIControlStateNormal];
//    [self.cutButton setImage:IMG(@"cutSmall_YM ") forState:UIControlStateSelected];
//    self.cutButton.backgroundColor = [UIColor clearColor];
//    [self.cutButton addTarget:self action:@selector(cutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.footerView addSubview:self.cutButton];
//    CGRect frame = self.footerView.frame;
//    self.cutButton.frame = CGRectMake(frame.size.width - footerSubViewFullHeight * 2, FootViewHeight - footerSubViewFullHeight, footerSubViewFullHeight, footerSubViewFullHeight);
//}
//
//- (void)loadFullScreen {
//    self.fullScreenButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//    self.fullScreenButton.backgroundColor = [UIColor clearColor];
//    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.footerView addSubview:self.fullScreenButton];
//    self.fullScreenButton.hidden = NO;
//    self.fullScreenButton.frame = CGRectMake(self.footerView.frame.size.width - footerSubViewFullHeight, 0, footerSubViewFullHeight, footerSubViewFullHeight);
//}
//
//// 由于单击手势和slider上的拖动进度条有冲突,加上这个方法可以避免出现冲突
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
//    if ([touch.view isKindOfClass:[UISlider class]]) {
//        return NO;
//    }
//    else {
//        return YES;
//    }
//}
//
//- (void)menuButtonAction:(UIButton *)button {
//    //NSLog(@"menuButtonAction");
//    //    CGRect frame = CGRectZero;
//    //    frame.origin.x = self.overlayView.frame.size.width * 1 / 2;
//    //    frame.origin.y = 0;
//    //    frame.size.width = self.overlayView.frame.size.width / 2;
//    //    frame.size.height = self.overlayView.frame.size.height;
//    //    self.menuView = [[UIView alloc]initWithFrame:frame];
//    //    self.menuView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
//    //    [self.overlayView addSubview:self.menuView];
//
//    //    self.restView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.overlayView.frame.size.width * 1 / 2, self.overlayView.frame.size.height)];
//    //    self.restView.backgroundColor = [UIColor clearColor];
//    //    [self.overlayView addSubview:self.restView];
//    //    self.restviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRestviewTap:)];
//    //    self.restviewTap.numberOfTapsRequired = 1;
//    //    self.restviewTap.delegate = self;
//    //    [self.restView addGestureRecognizer:self.restviewTap];
//    //
//    //    [self hiddenAllView];
//    //    //    [self loadScreenSizeView];
//    //    [self.overlayView removeGestureRecognizer:self.signelTap];
//}
//
//- (void)backButtonAction:(UIButton *)button {
//
//    if (isTransition) {
//        [self fullScreenButtonAction:self.fullScreenButton];
//    }
//    else {
//        [self.vodplayer stop];
//        [self.vodplayer.docSwfView clearVodLastPageAndAnno]; //退出前清理一下文档模块
//        self.vodplayer.docSwfView = nil;
//        self.vodplayer = nil;
//        self.item = nil;
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//- (void)speedButtonAction:(UIButton *)button {
//
//    //NSLog(@"%ld",self.speedCode);
//    if (self.speedCode % 4 == 0) {
//        [self.vodplayer SpeedPlay:1.5];
//        [self.speedButton setTitle:@"1.5倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"1.5倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 1) {
//        [self.vodplayer SpeedPlay:2.0];
//        [self.speedButton setTitle:@"2.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"2.0倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 2) {
//        [self.vodplayer SpeedPlay:3.0];
//        [self.speedButton setTitle:@"3.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"3.0倍" forState:UIControlStateNormal];
//    }
//    if (self.speedCode % 4 == 3) {
//        [self.vodplayer SpeedPlay:1.0];
//        [self.speedButton setTitle:@"1.0倍" forState:UIControlStateNormal];
//        [self.speedAcitonDown setTitle:@"1.0倍" forState:UIControlStateNormal];
//    }
//    self.speedCode++;
//    //  NSLog(@"%ld",self.speedCode);
//}
//
////全屏speedAcitonDownOnClick
//- (void)speedAcitonDownOnClick {
//    for (int i = 0; i < 5; i++) {
//        UIView *subView = self.speedBackground.subviews[i];
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel *titleLabel = (UILabel *) subView;
//            CGRect labelRect = titleLabel.frame;
//            labelRect.origin.y = 62;
//            labelRect.size.height = 25;
//        }
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *) subView;
//            [btn setSelected:NO];
//            CGRect btnRect = btn.frame;
//            btnRect.origin.y = 117 + 54 * (i - 1);
//            btn.frame = btnRect;
//            if (self.speedCode % 4 == i - 1) {
//                [btn setSelected:YES];
//            }
//        }
//    }
//    self.speedBackground.hidden = NO;
//    self.speedBackgroundRestView.hidden = NO;
//    //    [self.overlayView removeGestureRecognizer:self.signelTap];
//}
//
//- (void)loadDownloadBtnAction {
//    [self setGSVodManager];
//}
//
//- (void)shareButtonAction:(UIButton *)button {
//
//    DXCustomShareView *shareView = [[DXCustomShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//    [shareView setShareAry:nil delegate:self];
//    [self.navigationController.view addSubview:shareView];
//}
//
//#pragma mark DXCustomShareViewDelegate
//
//- (void)easyCustomShareViewButtonAction:(DXCustomShareView *)shareView title:(NSString *)title {
//    NSString *shareText;
//    NSArray *imageArr;
//    NSURL *reCallUrl;
//    NSString *shareTitle;
//
//    reCallUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.doxue.com/m_live/detail/%ld", (long) self.courseID]];
//
//    shareTitle = self.videoTitle;
//    if (self.imgUrl.length) {
//        imageArr = @[ [NSString stringWithFormat:@"%@", self.imgUrl] ];
//    }
//    else {
//        imageArr = @[ [UIImage imageNamed:@"ForShare"] ];
//    }
//
//    shareText = @"都学网,让你学习更方便!";
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
//    dateFormatter.dateFormat = @"MM月dd日 HH:mm";
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.broadcastTime]];
//    shareText = [NSString stringWithFormat:@"我在都学课堂预约了%@的直播课——“%@”，快来一起学习吧！", dateString, self.videoTitle];
//
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//    [shareParams SSDKSetupShareParamsByText:shareText
//                                     images:imageArr
//                                        url:reCallUrl
//                                      title:shareTitle
//                                       type:SSDKContentTypeAuto];
//    [shareParams SSDKEnableUseClientShare];
//
//    if ([title isEqualToString:@"微信好友"]) {
//        //微信好友分享
//        [ShareSDK share:SSDKPlatformSubTypeWechatSession
//                parameters:shareParams
//            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                switch (state) { //判断分享是否成功
//                    case SSDKResponseStateSuccess: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                            message:nil
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateFail: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateCancel: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享取消"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//
//                    default:
//                        break;
//                }
//            }];
//    }
//    if ([title isEqualToString:@"朋友圈"]) {
//        //朋友圈分享
//
//        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
//                parameters:shareParams
//            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                switch (state) { //判断分享是否成功
//                    case SSDKResponseStateSuccess: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                            message:nil
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateFail: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateCancel: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享取消"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//
//                    default:
//                        break;
//                }
//            }];
//    }
//    if ([title isEqualToString:@"新浪微博"]) {
//        //新浪微博分享
//
//        [ShareSDK share:SSDKPlatformTypeSinaWeibo
//                parameters:shareParams
//            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                switch (state) { //判断分享是否成功
//                    case SSDKResponseStateSuccess: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                            message:nil
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateFail: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateCancel: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享取消"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//
//                    default:
//                        break;
//                }
//            }];
//    }
//    if ([title isEqualToString:@"QQ好友"]) {
//        //QQ好友分享
//
//        [ShareSDK share:SSDKPlatformSubTypeQQFriend
//                parameters:shareParams
//            onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                switch (state) { //判断分享是否成功
//                    case SSDKResponseStateSuccess: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                            message:nil
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateFail: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//                    case SSDKResponseStateCancel: {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享取消"
//                                                                            message:[NSString stringWithFormat:@"%@", error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                        break;
//                    }
//
//                    default:
//                        break;
//                }
//            }];
//    }
//}
//- (void)playButtonAction:(UIButton *)button {
//    button.selected = !button.selected;
//    if (button.selected == false) {
//        //恢复播放
//        [button setImage:IMG(@"video_stop") forState:UIControlStateNormal];
//        if (self.vodplayer) {
//            [self.vodplayer resume];
//        }
//    }
//    else {
//        //暂停
//        [button setImage:IMG(@"whitePlay_YM") forState:UIControlStateNormal];
//
//        if (self.vodplayer) {
//            [self.vodplayer pause];
//        }
//    }
//}
////拖动滑块放大显示拖动到的时间
//- (void)sliderValurChanged:(UISlider *)slider forEvent:(UIEvent *)event {
//
//    UITouch *touchEvent = [[event allTouches] anyObject];
//    switch (touchEvent.phase) {
//        case UITouchPhaseBegan: // NSLog(@"开始拖动");
//        {
//            // 暂停播放
//            isDragging = YES;
//            if (self.vodplayer) {
//                [self.vodplayer pause];
//            }
//            self.playActionView.hidden = NO;
//            [self.playbackButton setImage:IMG(@"whitePlay_YM") forState:UIControlStateNormal];
//
//            NSLog(@"开始拖动");
//
//        } break;
//
//        case UITouchPhaseMoved: // NSLog(@"正在拖动");
//        {
//            NSLog(@"正在拖动");
//            _durationSlider.value = slider.value;
//            //NSLog(@"durationSlider.value--sliderValurChanged--正在拖动--%f",_durationSlider.value);
//            float sliderNowValue = slider.value;
//            float leftOrRight = _sliderLastValue - sliderNowValue;
//            //            float precision = 0.0005;
//            //            if (isTransition) {//横屏
//            //                precision = 0.0005*KScreenHeight/KScreenWidth;
//            //            }else{
//            //                precision = 0.0005;
//            //            }
//            //            if (fabs(leftOrRight)<precision) {
//            //
//            //            }else
//            if (leftOrRight <= 0) {
//                [self.playActionView setActionStatue:ActionStateForward andSeekTime:slider.value * _duration / 1000];
//            }
//            else {
//                [self.playActionView setActionStatue:ActionStateBack andSeekTime:self.durationSlider.value * _duration / 1000];
//            }
//            _sliderLastValue = sliderNowValue;
//
//
//        } break;
//
//        case UITouchPhaseEnded: // NSLog(@"结束拖动");
//        {
//            NSLog(@"结束拖动");
//            _durationSlider.value = slider.value;
//            CGFloat time = _duration * slider.value;
//            //NSLog(@"durationSlider.value--sliderValurChanged--UITouchPhaseEnded结束拖动--%f",_durationSlider.value);
//            //    //让视频从指定的CMTime对象处播放。滑动用scrub方法
//            //    播放结束
//            if (isVideoFinished) {
//                [self.vodplayer OnlinePlay:NO audioOnly:NO];
//            }
//
//            videoRestartValue = time;
//            [self.vodplayer seekTo:time];
//
//            [self currentPlayTime:time];
//
//            isDragging = NO;
//            //            //恢复播放
//            [self.playbackButton setImage:IMG(@"video_stop") forState:UIControlStateNormal];
//            if (self.vodplayer) {
//                [self.vodplayer resume];
//            }
//            self.playActionView.hidden = YES; //一定要放到最后
//
//        } break;
//
//        default:
//            break;
//    }
//}
//
//- (void)durationSliderDone:(UISlider *)slider {
//
//    if (isTransition) {
//        //    播放结束
//        if (isVideoFinished) {
//            [self.vodplayer OnlinePlay:NO audioOnly:NO];
//        }
//        float duratino = slider.value * _duration;
//        videoRestartValue = slider.value * _duration;
//        [self.vodplayer seekTo:duratino];
//    }
//    else {
//        //    播放结束
//        if (isVideoFinished) {
//            [self.vodplayer OnlinePlay:NO audioOnly:NO];
//        }
//        float duratino = slider.value * _duration;
//        videoRestartValue = slider.value * _duration;
//        [self.vodplayer seekTo:duratino];
//    }
//
//    //恢复播放
//    isDragging = NO;
//    [self.playbackButton setImage:IMG(@"video_stop") forState:UIControlStateNormal];
//    if (self.vodplayer) {
//        [self.vodplayer resume];
//    }
//}
//
//- (void)durationSliderHold:(UISlider *)slider {
//    isDragging = YES;
//}
//
//- (void)durationSliderValueChanged:(UISlider *)slider {
//    _sliderValue = slider.value;
//}
//
//- (void)cutButtonAction:(UIButton *)button {
//    if (isHiddenVideo) {
//        self.vodplayer.mVideoView.hidden = NO;
//        self.vodplayer.docSwfView.hidden = NO;
//        isHiddenVideo = NO;
//        if (isDocVideo) {
//            [self.cutButton setImage:IMG(@"cutSmall_YM") forState:UIControlStateNormal];
//        }
//        else {
//            [self.cutButton setImage:IMG(@"cutSmall_YM") forState:UIControlStateNormal];
//        }
//    }
//    else {
//        isCut = !isCut;
//        button.selected = !button.selected;
//
//        if (isTransition) {
//            if (isCut) {
//                [self.overlayView removeFromSuperview];
//                [self.footerView removeFromSuperview];
//                [self.headerView removeFromSuperview];
//                [self.headerSafeView removeFromSuperview];
//                [self.bootomSafeView removeFromSuperview];
//                [self removeSomeView:self.vodplayer.mVideoView];
//                isDocVideo = YES;
//                if (iPhoneX) {
//                    self.vodplayer.mVideoView.frame = CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.height - 44 - 34, [UIScreen mainScreen].bounds.size.width);
//                    self.vodplayer.docSwfView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 44 - 34 - 192, [UIScreen mainScreen].bounds.size.width - 192, 192, 192 / 16 * 9);
//                }
//                else {
//                    self.vodplayer.mVideoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                    self.vodplayer.docSwfView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 192, [UIScreen mainScreen].bounds.size.width - 192, 192, 192 / 16 * 9);
//                }
//
//                [self.view insertSubview:self.vodplayer.docSwfView atIndex:999];
//                [self.vodplayer.mVideoView removeGestureRecognizer:self.fullPan];
//                self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                self.signelSmallTap.numberOfTapsRequired = 1;
//                self.signelSmallTap.delegate = self;
//                [self.vodplayer.docSwfView addGestureRecognizer:self.signelSmallTap];
//                [self setupSmallVideoBackButton];
//                [self.vodplayer.docSwfView addSubview:self.smallVideoBackButton];
//                self.fullPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fullPanGestureRecognizer:)];
//                [self.vodplayer.docSwfView addGestureRecognizer:self.fullPan];
//                self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.mVideoView.width, self.vodplayer.mVideoView.height)];
//                [self.vodplayer.mVideoView addSubview:_overlayView];
//
//
//                self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//                self.signelTap.numberOfTapsRequired = 1;
//                self.signelTap.delegate = self;
//                [self.vodplayer.mVideoView addGestureRecognizer:self.signelTap];
//                [self loadFooterView];
//                [self loadHeaderView];
//                self.panResponseView = [[UIView alloc] init];
//                [self loadPanResponseViewL];
//                [self.panResponseView addGestureRecognizer:_panGesture];
//                self.playActionView.center = self.overlayView.center;
//                [self.overlayView addSubview:self.playActionView];
//                [self loadSafeView];
//                [self loadSpeedBackfroundView];
//                self.headerView.frame = CGRectMake(0, 0, self.overlayView.width, HeaderViewHeight);
//                self.gradientLayerHeader.frame = CGRectMake(0, 0, self.headerView.width, self.headerView.height);
//                self.backButton.frame = CGRectMake(0, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.titleLabel.frame = CGRectMake(headerSubViewFullWidth, 0, self.headerView.width - headerSubViewFullWidth * 3, headerSubViewHeight);
//                self.menuButton.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.downloadBtn.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth * 2, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.speedButton.hidden = YES;
//
//                self.footerView.frame = CGRectMake(0, self.overlayView.height - FootViewHeight, self.overlayView.width, self.overlayView.height);
//                self.gradientLayerFooter.frame = CGRectMake(0, 0, self.overlayView.width, FootViewHeight);
//                //播放按钮
//                self.playbackButton.frame = CGRectMake(0, FootViewHeight - footerSubViewFullHeight, footerSubViewFullHeight, footerSubViewFullHeight);
//
//                //全屏切换按钮偏移量 IPHONE_HEIGHT-IPHONE_WIDTH
//                [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//                self.fullScreenButton.hidden = YES;
//
//                //下方倍速按钮--新建
//                UIButton *speedAcitonDown = [UIButton buttonWithType:UIButtonTypeCustom];
//                if (self.speedCode % 4 == 0) {
//                    [speedAcitonDown setTitle:@"1.0倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 1) {
//                    [speedAcitonDown setTitle:@"1.5倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 2) {
//                    [speedAcitonDown setTitle:@"2.0倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 3) {
//                    [speedAcitonDown setTitle:@"3.0倍" forState:UIControlStateNormal];
//                }
//                [speedAcitonDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                speedAcitonDown.titleLabel.font = [UIFont systemFontOfSize:13];
//                [self.footerView addSubview:speedAcitonDown];
//                [speedAcitonDown addTarget:self action:@selector(speedAcitonDownOnClick) forControlEvents:UIControlEventTouchUpInside];
//                // speedAcitonDown.backgroundColor = [UIColor redColor]
//                speedAcitonDown.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//                self.speedAcitonDown = speedAcitonDown;
//
//                //pdf和视频切换按钮
//                _cutButton.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth * 2, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//
//                //时长标签右偏移量,时长标签隐藏
//                self.durationLabel.hidden = YES;
//
//                //当前时长隐藏
//                self.currentPlaybackTimeLabel.hidden = YES;
//
//                //全屏下当前时长/总时长
//                UILabel *fullPlayTimeLabel = [[UILabel alloc] init];
//                fullPlayTimeLabel.textColor = [UIColor whiteColor];
//                fullPlayTimeLabel.font = [UIFont systemFontOfSize:13];
//                [self.footerView addSubview:fullPlayTimeLabel];
//                //fullPlayTimeLabel.backgroundColor = [UIColor redColor];
//                fullPlayTimeLabel.frame = CGRectMake(footerSubViewFullHeight + 8, FootViewHeight - footerSubViewFullHeight, 150, footerSubViewFullHeight);
//                self.fullPlayTimeLabel = fullPlayTimeLabel;
//
//                //滑块长度增加
//                self.durationSlider.frame = CGRectMake(24, FootViewHeight - footerSubViewFullHeight - 30, self.footerView.width - 48, 30);
//
//                if (isHiddenVideo) {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                }
//                else {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                }
//            }
//            else {
//                [self.overlayView removeFromSuperview];
//                [self.footerView removeFromSuperview];
//                [self.headerView removeFromSuperview];
//                [self.headerSafeView removeFromSuperview];
//                [self.bootomSafeView removeFromSuperview];
//                [self removeSomeView:self.vodplayer.docSwfView];
//                isDocVideo = NO;
//                if (iPhoneX) {
//                    self.vodplayer.docSwfView.frame = CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.height - 44 - 34, [UIScreen mainScreen].bounds.size.width);
//                    self.vodplayer.mVideoView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 44 - 34 - 144, [UIScreen mainScreen].bounds.size.width - 144, 144, 144 / 16 * 9);
//                }
//                else {
//                    self.vodplayer.docSwfView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                    self.vodplayer.mVideoView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 144, [UIScreen mainScreen].bounds.size.width - 144, 144, 144 / 16 * 9);
//                }
//
//                [self.view insertSubview:self.vodplayer.mVideoView atIndex:999];
//                [self.vodplayer.docSwfView removeGestureRecognizer:self.fullPan];
//                self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                self.signelSmallTap.numberOfTapsRequired = 1;
//                self.signelSmallTap.delegate = self;
//                [self.vodplayer.mVideoView addGestureRecognizer:self.signelSmallTap];
//                [self setupSmallVideoBackButton];
//                [self.vodplayer.mVideoView addSubview:self.smallVideoBackButton];
//                self.fullPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fullPanGestureRecognizer:)];
//                [self.vodplayer.mVideoView addGestureRecognizer:self.fullPan];
//                self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.docSwfView.width, self.vodplayer.docSwfView.height)];
//                [self.vodplayer.docSwfView addSubview:_overlayView];
//
//                self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//                self.signelTap.numberOfTapsRequired = 1;
//                self.signelTap.delegate = self;
//                [self.vodplayer.docSwfView addGestureRecognizer:self.signelTap];
//                [self loadFooterView];
//                [self loadHeaderView];
//                self.panResponseView = [[UIView alloc] init];
//                [self loadPanResponseViewL];
//                [self.panResponseView addGestureRecognizer:_panGesture];
//                self.playActionView.center = self.overlayView.center;
//                [self.overlayView addSubview:self.playActionView];
//                [self loadSafeView];
//                [self loadSpeedBackfroundView];
//                self.headerView.frame = CGRectMake(0, 0, self.overlayView.width, HeaderViewHeight);
//                self.gradientLayerHeader.frame = CGRectMake(0, 0, self.headerView.width, self.headerView.height);
//
//                self.backButton.frame = CGRectMake(0, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.titleLabel.frame = CGRectMake(headerSubViewFullWidth, 0, self.headerView.width - headerSubViewFullWidth * 3, headerSubViewHeight);
//                self.menuButton.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.downloadBtn.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth * 2, 0, headerSubViewFullWidth, headerSubViewHeight);
//                self.speedButton.hidden = YES;
//                //下方工具栏
//                [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//                self.footerView.frame = CGRectMake(0, self.overlayView.height - FootViewHeight, self.overlayView.width, self.overlayView.height);
//                self.gradientLayerFooter.frame = CGRectMake(0, 0, self.overlayView.width, FootViewHeight);
//                //播放按钮
//                self.playbackButton.frame = CGRectMake(0, FootViewHeight - footerSubViewFullHeight, footerSubViewFullHeight, footerSubViewFullHeight);
//
//                //全屏切换按钮偏移量 IPHONE_HEIGHT-IPHONE_WIDTH
//                [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//                self.fullScreenButton.hidden = YES;
//
//                //下方倍速按钮--新建
//                UIButton *speedAcitonDown = [UIButton buttonWithType:UIButtonTypeCustom];
//                if (self.speedCode % 4 == 0) {
//                    [speedAcitonDown setTitle:@"1.0倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 1) {
//                    [speedAcitonDown setTitle:@"1.5倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 2) {
//                    [speedAcitonDown setTitle:@"2.0倍" forState:UIControlStateNormal];
//                }
//                if (self.speedCode % 4 == 3) {
//                    [speedAcitonDown setTitle:@"3.0倍" forState:UIControlStateNormal];
//                }
//                [speedAcitonDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                speedAcitonDown.titleLabel.font = [UIFont systemFontOfSize:13];
//                [self.footerView addSubview:speedAcitonDown];
//                [speedAcitonDown addTarget:self action:@selector(speedAcitonDownOnClick) forControlEvents:UIControlEventTouchUpInside];
//                // speedAcitonDown.backgroundColor = [UIColor redColor]
//                speedAcitonDown.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//                self.speedAcitonDown = speedAcitonDown;
//
//                //pdf和视频切换按钮
//                _cutButton.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth * 2, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//
//                //时长标签右偏移量,时长标签隐藏
//                self.durationLabel.hidden = YES;
//
//                //当前时长隐藏
//                self.currentPlaybackTimeLabel.hidden = YES;
//
//                //全屏下当前时长/总时长
//                UILabel *fullPlayTimeLabel = [[UILabel alloc] init];
//                fullPlayTimeLabel.textColor = [UIColor whiteColor];
//                fullPlayTimeLabel.font = [UIFont systemFontOfSize:13];
//                [self.footerView addSubview:fullPlayTimeLabel];
//                //fullPlayTimeLabel.backgroundColor = [UIColor redColor];
//                fullPlayTimeLabel.frame = CGRectMake(footerSubViewFullHeight + 8, FootViewHeight - footerSubViewFullHeight, 150, footerSubViewFullHeight);
//                self.fullPlayTimeLabel = fullPlayTimeLabel;
//
//                //滑块长度增加
//                self.durationSlider.frame = CGRectMake(24, FootViewHeight - footerSubViewFullHeight - 30, self.footerView.width - 48, 30);
//
//
//                if (isHiddenVideo) {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                }
//                else {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                }
//            }
//        }
//        else {
//            if (isCut) {
//                [self.overlayView removeFromSuperview];
//                [self.footerView removeFromSuperview];
//                [self.headerView removeFromSuperview];
//                [self.headerSafeView removeFromSuperview];
//                [self.bootomSafeView removeFromSuperview];
//                isDocVideo = YES;
//                if (IS_IPHONE_X) {
//                    self.vodplayer.mVideoView.frame = CGRectMake(0, 44, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                    self.vodplayer.docSwfView.frame = CGRectMake(IPHONE_WIDTH - 192, IPHONE_WIDTH / 16 * 9 + 84, 192, 192 / 16 * 9);
//                }
//                else {
//                    self.vodplayer.mVideoView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                    self.vodplayer.docSwfView.frame = CGRectMake(IPHONE_WIDTH - 192, IPHONE_WIDTH / 16 * 9 + 40, 192, 192 / 16 * 9);
//                }
//                [self.view insertSubview:self.vodplayer.docSwfView atIndex:999];
//                self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.mVideoView.width, self.vodplayer.mVideoView.height)];
//                [self.vodplayer.mVideoView addSubview:_overlayView];
//
//                [self.overlayView addGestureRecognizer:_panGesture];
//                self.playActionView.center = self.overlayView.center;
//                [self.overlayView addSubview:self.playActionView];
//
//                self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//                self.signelTap.numberOfTapsRequired = 1;
//                self.signelTap.delegate = self;
//                [self.vodplayer.mVideoView addGestureRecognizer:self.signelTap];
//                [self loadFooterView];
//                [self loadHeaderView];
//                [self loadSafeView];
//                [self loadPanResponseViewV];
//                [self.vodplayer.mVideoView removeGestureRecognizer:self.fullPan];
//                [self.vodplayer.docSwfView addGestureRecognizer:self.fullPan];
//                self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                self.signelSmallTap.numberOfTapsRequired = 1;
//                self.signelSmallTap.delegate = self;
//                [self.vodplayer.docSwfView addGestureRecognizer:self.signelSmallTap];
//                [self setupSmallVideoBackButton];
//                [self.vodplayer.docSwfView addSubview:self.smallVideoBackButton];
//
//                isTransition = NO;
//                if (isSegment) {
//                    self.chatTableView.hidden = NO;
//                    self.noteTableView.hidden = YES;
//                }
//                else {
//                    self.noteTableView.hidden = NO;
//                    self.chatTableView.hidden = YES;
//                }
//                if (isHiddenVideo) {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                }
//                else {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                }
//                [self removeSomeView:self.vodplayer.mVideoView];
//            }
//            else {
//                [self.overlayView removeFromSuperview];
//                [self.footerView removeFromSuperview];
//                [self.headerView removeFromSuperview];
//                [self.headerSafeView removeFromSuperview];
//                [self.bootomSafeView removeFromSuperview];
//                isDocVideo = NO;
//                if (IS_IPHONE_X) {
//                    self.vodplayer.docSwfView.frame = CGRectMake(0, 44, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                    self.vodplayer.mVideoView.frame = CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 84, 144, 144 / 16 * 9);
//                }
//                else {
//                    self.vodplayer.docSwfView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                    self.vodplayer.mVideoView.frame = CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 40, 144, 144 / 16 * 9);
//                }
//
//                [self.view insertSubview:self.vodplayer.mVideoView atIndex:999];
//                self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.docSwfView.width, self.vodplayer.docSwfView.height)];
//                [self.vodplayer.docSwfView addSubview:_overlayView];
//
//                [self.vodplayer.docSwfView removeGestureRecognizer:self.fullPan];
//                [self.vodplayer.mVideoView addGestureRecognizer:self.fullPan];
//                self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//                self.signelTap.numberOfTapsRequired = 1;
//                self.signelTap.delegate = self;
//                [self.vodplayer.docSwfView addGestureRecognizer:self.signelTap];
//
//                [self loadFooterView];
//                [self loadHeaderView];
//                [self loadSafeView];
//                [self loadPanResponseViewV];
//                [self.panResponseView addGestureRecognizer:_panGesture];
//                self.playActionView.center = self.overlayView.center;
//                [self.overlayView addSubview:self.playActionView];
//
//                self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                self.signelSmallTap.numberOfTapsRequired = 1;
//                self.signelSmallTap.delegate = self;
//                [self.vodplayer.mVideoView addGestureRecognizer:self.signelSmallTap];
//                [self setupSmallVideoBackButton];
//                [self.vodplayer.mVideoView addSubview:self.smallVideoBackButton];
//                isTransition = NO;
//                if (isSegment) {
//                    self.chatTableView.hidden = NO;
//                    self.noteTableView.hidden = YES;
//                }
//                else {
//                    self.noteTableView.hidden = NO;
//                    self.chatTableView.hidden = YES;
//                }
//                if (isHiddenVideo) {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                }
//                else {
//                    [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                }
//                [self removeSomeView:self.vodplayer.docSwfView];
//            }
//        }
//        _durationLabel.text = [self formatTime:_duration];
//        //_durationSlider.maximumValue = _duration;
//        [_durationSlider setValue:(_position / ((float) _duration)) animated:YES];
//        //NSLog(@"durationSlider.value--cutButtonAction:(UIButton *)button--%f",(_position/((float)_duration) ));
//    }
//}
//
//#pragma mark - 屏幕旋转
//- (void)fullScreenButtonAction:(UIButton *)button {
//
//    [self setNeedsStatusBarAppearanceUpdate];
//    //强制旋转
//    if (!isTransition) {
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.overlayView removeFromSuperview];
//                             [self.footerView removeFromSuperview];
//                             [self.headerView removeFromSuperview];
//                             [self.headerSafeView removeFromSuperview];
//                             [self.bootomSafeView removeFromSuperview];
//                             isTransition = YES;
//                             self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
//                             self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                             self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                             self.signelSmallTap.numberOfTapsRequired = 1;
//                             self.signelSmallTap.delegate = self;
//                             if (isCut) {
//                                 if (iPhoneX) {
//                                     self.vodplayer.mVideoView.frame = CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.height - 44 - 34, [UIScreen mainScreen].bounds.size.width);
//                                     self.vodplayer.docSwfView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 44 - 34 - 192, [UIScreen mainScreen].bounds.size.width - 192, 192, 192 / 16 * 9);
//                                     self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.mVideoView.width, self.vodplayer.mVideoView.height)];
//                                 }
//                                 else {
//                                     self.vodplayer.mVideoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                                     self.vodplayer.docSwfView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 192, [UIScreen mainScreen].bounds.size.width - 192, 192, 192 / 16 * 9);
//                                     self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.mVideoView.width, self.vodplayer.mVideoView.height)];
//                                 }
//
//                                 [self.vodplayer.mVideoView removeGestureRecognizer:self.fullPan];
//                                 [self.vodplayer.mVideoView addSubview:_overlayView];
//
//                                 [self loadFooterView];
//                                 [self loadHeaderView];
//                                 [self loadSafeView];
//                                 [self loadSpeedBackfroundView];
//                                 self.headerView.frame = CGRectMake(0, 0, self.overlayView.width, HeaderViewHeight);
//                                 self.gradientLayerHeader.frame = CGRectMake(0, 0, self.headerView.width, self.headerView.height);
//                                 NSMutableArray *newColors = [NSArray arrayWithObjects:
//                                                                          (id) [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.6].CGColor,
//                                                                          (id) [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.25].CGColor,
//                                                                          (id)[UIColor clearColor].CGColor, nil];
//
//                                 self.gradientLayerHeader.colors = newColors;
//                                 self.gradientLayerHeader.locations = @[ @(0.0), @(0.55), @(1.0) ];
//                                 [self loadPanResponseViewL];
//                                 [self.overlayView addSubview:self.panResponseView];
//
//                                 [self.panResponseView addGestureRecognizer:_panGesture];
//                                 self.playActionView.center = self.overlayView.center;
//                                 [self.overlayView addSubview:self.playActionView];
//
//                                 [self.vodplayer.mVideoView addGestureRecognizer:self.signelTap];
//                                 [self.vodplayer.docSwfView addGestureRecognizer:self.fullPan];
//                                 [self.vodplayer.docSwfView addGestureRecognizer:self.signelSmallTap];
//                             }
//                             else {
//                                 if (iPhoneX) {
//                                     self.vodplayer.docSwfView.frame = CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.height - 44 - 34, [UIScreen mainScreen].bounds.size.width);
//                                     self.vodplayer.mVideoView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 44 - 34 - 144, [UIScreen mainScreen].bounds.size.width - 144, 144, 144 / 16 * 9);
//                                     self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.docSwfView.width, self.vodplayer.docSwfView.height)];
//                                 }
//                                 else {
//                                     self.vodplayer.docSwfView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//                                     self.vodplayer.mVideoView.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 144, [UIScreen mainScreen].bounds.size.width - 144, 144, 144 / 16 * 9);
//                                     self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.docSwfView.width, self.vodplayer.docSwfView.height)];
//                                 }
//
//                                 [self.vodplayer.docSwfView removeGestureRecognizer:self.fullPan];
//                                 [self.vodplayer.docSwfView addSubview:_overlayView];
//                                 [self loadFooterView];
//                                 [self loadHeaderView];
//                                 [self loadSafeView];
//                                 [self loadSpeedBackfroundView];
//                                 self.headerView.frame = CGRectMake(0, 0, self.overlayView.width, HeaderViewHeight);
//                                 self.gradientLayerHeader.frame = CGRectMake(0, 0, self.headerView.width, self.headerView.height);
//                                 [self loadPanResponseViewL];
//
//                                 [self.panResponseView addGestureRecognizer:_panGesture];
//                                 self.playActionView.center = self.overlayView.center;
//                                 [self.overlayView addSubview:self.playActionView];
//
//                                 [self.vodplayer.docSwfView addGestureRecognizer:self.signelTap];
//                                 [self.vodplayer.mVideoView addGestureRecognizer:self.fullPan];
//                                 [self.vodplayer.mVideoView addGestureRecognizer:self.signelSmallTap];
//                             }
//                             [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//
//                             [[UIApplication sharedApplication] setStatusBarHidden:YES];
//                             self.chatTableView.hidden = YES;
//                             self.noteTableView.hidden = YES;
//                             self.headerView.hidden = YES;
//                             self.footerView.hidden = YES;
//                             self.segmentView.hidden = YES;
//                             self.liveFootView.hidden = YES;
//
//
//                             self.closePdfButton.hidden = self.pdfWebView.hidden = YES;
//                             self.LearningMaterialsView.hidden = YES;
//
//                             self.backButton.frame = CGRectMake(0, 0, headerSubViewFullWidth, headerSubViewHeight);
//                             self.titleLabel.frame = CGRectMake(headerSubViewFullWidth, 0, self.headerView.width - headerSubViewFullWidth * 3, headerSubViewHeight);
//                             self.menuButton.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth, 0, headerSubViewFullWidth, headerSubViewHeight);
//                             self.downloadBtn.frame = CGRectMake(self.headerView.width - headerSubViewFullWidth * 2, 0, headerSubViewFullWidth, headerSubViewHeight);
//                             self.speedButton.hidden = YES;
//
//                             //下方工具栏
//                             self.footerView.frame = CGRectMake(0, self.overlayView.height - FootViewHeight, self.overlayView.width, self.overlayView.height);
//                             self.gradientLayerFooter.frame = CGRectMake(0, 0, self.overlayView.width, FootViewHeight);
//                             NSMutableArray *footerNewColors = [NSArray arrayWithObjects:
//                                                                            (id) [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.6].CGColor,
//                                                                            (id) [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.25].CGColor,
//                                                                            (id)[UIColor clearColor].CGColor, nil];
//
//
//                             self.gradientLayerFooter.colors = footerNewColors;
//                             self.gradientLayerFooter.locations = @[ @(0.0), @(0.43), @(1.0) ];
//
//                             //播放按钮
//                             self.playbackButton.frame = CGRectMake(0, FootViewHeight - footerSubViewFullHeight, footerSubViewFullHeight, footerSubViewFullHeight);
//
//                             //全屏切换按钮偏移量 IPHONE_HEIGHT-IPHONE_WIDTH
//                             [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//                             self.fullScreenButton.hidden = YES;
//
//                             //下方倍速按钮--新建
//                             UIButton *speedAcitonDown = [UIButton buttonWithType:UIButtonTypeCustom];
//                             if (self.speedCode % 4 == 0) {
//                                 [speedAcitonDown setTitle:@"1.0倍" forState:UIControlStateNormal];
//                             }
//                             if (self.speedCode % 4 == 1) {
//                                 [speedAcitonDown setTitle:@"1.5倍" forState:UIControlStateNormal];
//                             }
//                             if (self.speedCode % 4 == 2) {
//                                 [speedAcitonDown setTitle:@"2.0倍" forState:UIControlStateNormal];
//                             }
//                             if (self.speedCode % 4 == 3) {
//                                 [speedAcitonDown setTitle:@"3.0倍" forState:UIControlStateNormal];
//                             }
//                             [speedAcitonDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                             speedAcitonDown.titleLabel.font = [UIFont systemFontOfSize:13];
//                             [self.footerView addSubview:speedAcitonDown];
//                             [speedAcitonDown addTarget:self action:@selector(speedAcitonDownOnClick) forControlEvents:UIControlEventTouchUpInside];
//                             // speedAcitonDown.backgroundColor = [UIColor redColor]
//                             speedAcitonDown.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//                             self.speedAcitonDown = speedAcitonDown;
//
//                             //pdf和视频切换按钮
//                             _cutButton.frame = CGRectMake(self.footerView.width - footerSubViewFullWidth * 2, FootViewHeight - footerSubViewFullHeight, footerSubViewFullWidth, footerSubViewFullHeight);
//
//                             //时长标签右偏移量,时长标签隐藏
//                             self.durationLabel.hidden = YES;
//
//                             //当前时长隐藏
//                             self.currentPlaybackTimeLabel.hidden = YES;
//
//                             //全屏下当前时长/总时长
//                             UILabel *fullPlayTimeLabel = [[UILabel alloc] init];
//                             fullPlayTimeLabel.textColor = [UIColor whiteColor];
//                             fullPlayTimeLabel.font = [UIFont systemFontOfSize:13];
//                             [self.footerView addSubview:fullPlayTimeLabel];
//                             //fullPlayTimeLabel.backgroundColor = [UIColor redColor];
//                             fullPlayTimeLabel.frame = CGRectMake(footerSubViewFullHeight + 8, FootViewHeight - footerSubViewFullHeight, 150, footerSubViewFullHeight);
//                             self.fullPlayTimeLabel = fullPlayTimeLabel;
//
//                             //滑块长度增加
//                             self.durationSlider.frame = CGRectMake(24, FootViewHeight - footerSubViewFullHeight - 30, self.footerView.width - 48, 30);
//
//                             if (isCut) {
//                                 if (isHiddenVideo) {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                                 }
//                                 else {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                                 }
//                                 [self removeSomeView:self.vodplayer.mVideoView];
//                             }
//                             else {
//                                 if (isHiddenVideo) {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                                 }
//                                 else {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutFull_YM"] forState:UIControlStateNormal];
//                                 }
//                                 [self removeSomeView:self.vodplayer.docSwfView];
//                             }
//                         }];
//    }
//    else {
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.overlayView removeFromSuperview];
//                             [self.footerView removeFromSuperview];
//                             [self.headerView removeFromSuperview];
//                             [self.headerSafeView removeFromSuperview];
//                             [self.bootomSafeView removeFromSuperview];
//                             self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
//                             self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                             self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
//                             self.signelTap.numberOfTapsRequired = 1;
//                             self.signelTap.delegate = self;
//                             self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//                             self.signelSmallTap.numberOfTapsRequired = 1;
//                             self.signelSmallTap.delegate = self;
//
//                             isTransition = NO;
//                             [[UIApplication sharedApplication] setStatusBarHidden:NO];
//                             [self.fullScreenButton setImage:IMG(@"fullScreenSwitch_YM") forState:UIControlStateNormal];
//                             if (isSegment) {
//                                 self.chatTableView.hidden = NO;
//                                 self.noteTableView.hidden = YES;
//                             }
//                             else {
//                                 self.noteTableView.hidden = NO;
//                                 self.chatTableView.hidden = YES;
//                             }
//                             self.segmentView.hidden = NO;
//
//                             if (self.pdfWebView.hidden == NO) {
//                                 self.closePdfButton.hidden = self.pdfWebView.hidden = NO;
//                             }
//
//                             [self didSelectSegment:_segment.selectedIndex];
//
//                             if (isCut) {
//                                 if (IS_IPHONE_X) {
//                                     self.vodplayer.mVideoView.frame = CGRectMake(0, 44, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                                     self.vodplayer.docSwfView.frame = CGRectMake(IPHONE_WIDTH - 192, IPHONE_WIDTH / 16 * 9 + 84, 192, 192 / 16 * 9);
//                                 }
//                                 else {
//                                     self.vodplayer.mVideoView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                                     self.vodplayer.docSwfView.frame = CGRectMake(IPHONE_WIDTH - 192, IPHONE_WIDTH / 16 * 9 + 40, 192, 192 / 16 * 9);
//                                 }
//
//                                 self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.mVideoView.width, self.vodplayer.mVideoView.height)];
//                                 [self.vodplayer.mVideoView addSubview:_overlayView];
//
//                                 //NSLog(@"%f--%f",self.vodplayer.mVideoView.width,self.vodplayer.mVideoView.height);
//                                 [self loadFooterView];
//                                 [self loadHeaderView];
//                                 [self loadSafeView];
//                                 [self loadPanResponseViewV];
//
//                                 [self.panResponseView addGestureRecognizer:_panGesture];
//                                 self.playActionView.center = self.overlayView.center;
//                                 [self.overlayView addSubview:self.playActionView];
//
//                                 [self.vodplayer.mVideoView addGestureRecognizer:self.signelTap];
//                                 [self.vodplayer.docSwfView addGestureRecognizer:self.signelSmallTap];
//                             }
//                             else {
//                                 if (IS_IPHONE_X) {
//                                     self.vodplayer.docSwfView.frame = CGRectMake(0, 44, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                                     self.vodplayer.mVideoView.frame = CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 84, 144, 144 / 16 * 9);
//                                 }
//                                 else {
//                                     self.vodplayer.docSwfView.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_WIDTH / 16 * 9);
//                                     self.vodplayer.mVideoView.frame = CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 40, 144, 144 / 16 * 9);
//                                 }
//
//                                 self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.vodplayer.docSwfView.width, self.vodplayer.docSwfView.height)];
//                                 [self.vodplayer.docSwfView addSubview:_overlayView];
//                                 //NSLog(@"%f--%f",self.vodplayer.mVideoView.width,self.vodplayer.mVideoView.height);
//                                 [self loadFooterView];
//                                 [self loadHeaderView];
//                                 [self loadSafeView];
//                                 [self loadPanResponseViewV];
//
//                                 [self.panResponseView addGestureRecognizer:_panGesture];
//                                 self.playActionView.center = self.overlayView.center;
//                                 [self.overlayView addSubview:self.playActionView];
//
//                                 [self.vodplayer.docSwfView addGestureRecognizer:self.signelTap];
//                                 [self.vodplayer.mVideoView addGestureRecognizer:self.signelSmallTap];
//                             }
//
//
//                             if (isCut) {
//                                 if (isHiddenVideo) {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                                 }
//                                 else {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                                 }
//                                 [self removeSomeView:self.vodplayer.mVideoView];
//                             }
//                             else {
//                                 if (isHiddenVideo) {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                                 }
//                                 else {
//                                     [self.cutButton setImage:[UIImage imageNamed:@"cutSmall_YM"] forState:UIControlStateNormal];
//                                 }
//                                 [self removeSomeView:self.vodplayer.docSwfView];
//                             }
//                         }];
//    }
//    _durationLabel.text = [self formatTime:_duration];
//    //_durationSlider.maximumValue = _duration;
//    [_durationSlider setValue:(_position / ((float) _duration)) animated:YES];
//    //NSLog(@"durationSlider.value--fullScreenButtonAction:(UIButton *)button--%f",(_position/((float)_duration)));
//}
//
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//
//
//#pragma mark -VodPlayDelegate
////初始化VodPlayer代理
//- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos {
//
//    //_durationSlider.maximumValue = duration;
//    // _durationSlider.minimumValue = 0;
//
//    //    播放结束
//    if (isVideoFinished) {
//        isVideoFinished = NO;
//        //    从设定好的位置开始
//        [self.vodplayer seekTo:videoRestartValue];
//    }
//
//    _duration = duration;
//
//    _durationLabel.text = [self formatTime:duration];
//
//    [self.playActionView setItemDuration:_duration / 1000];
//}
//
//- (void)OnChat:(NSArray *)chatArray {
//    VodChatInfo *chatInfo = [chatArray objectAtIndex:0];
//
//    if (chatInfo.role == 7) {
//        [self.imageArray insertObject:@"live_lecturer" atIndex:self.imageArray.count];
//    }
//    else if (chatInfo.role == 4) {
//        [self.imageArray insertObject:@"live_assistant" atIndex:self.imageArray.count];
//    }
//    else {
//        [self.imageArray insertObject:@"" atIndex:self.imageArray.count];
//    }
//
//    [self.dataArray insertObject:[[chatArray objectAtIndex:0] text] atIndex:self.dataArray.count];
//
//    if (self.nameArray == nil) {
//    }
//    else {
//        [self.nameArray insertObject:[[chatArray objectAtIndex:0] senderName] atIndex:self.nameArray.count];
//    }
//    DXWeak(self, weakSelf);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.chatTableView reloadData];
//        [weakSelf setupDataScrollPositionBottom];
//    });
//}
//
//- (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format {
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//
//    [formatter setDateFormat:format];
//
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//
//    [formatter setTimeZone:timeZone];
//
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
//
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//
//    return confromTimespStr;
//}
///**
// *用于vodToolView.timeLabel
// */
//- (NSString *)currentPlayTime:(int)position {
//    if (!_durationLabel.text) {
//        _durationLabel.text = @"00:00:00";
//    }
//    return [NSString stringWithFormat:@"%@", [self formatTime:position]];
//}
//
//- (NSString *)formatTime:(int)msec {
//    int hours = msec / 1000 / 60 / 60;
//    int minutes = (msec / 1000 / 60) % 60;
//    int seconds = (msec / 1000) % 60;
//
//    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
//}
//
////进度条定位播放，如快进、快退、拖动进度条等操作回调方法
//- (void)onSeek:(int)position {
//
//    [_durationSlider setValue:(position / ((float) _duration)) animated:YES];
//    //NSLog(@"durationSlider.value--onSeek:(int) position--%f",(position/((float)_duration)));
//    _position = position;
//    _currentPlaybackTimeLabel.text = [self currentPlayTime:position];
//    // NSLog(@"currentPlaybackTimeLabel--onSeek:(int) position--%@",_currentPlaybackTimeLabel.text);
//}
//
//// 进度通知
//- (void)onPosition:(int)position {
//    if (isDragging) {
//        // NSLog(@"isDragging");
//        return;
//    }
//
//    _position = position;
//
//    //NSLog(@"durationSlider.value--onPosition:(int)position--%f",(position/((float)_duration)));
//    [_durationSlider setValue:(position / ((float) _duration)) animated:YES];
//    _currentPlaybackTimeLabel.text = [self currentPlayTime:position];
//    _fullPlayTimeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self currentPlayTime:position], [self formatTime:_duration]];
//    //NSLog(@"_currentPlaybackTimeLabel--onPosition:(int)position--%@",_currentPlaybackTimeLabel.text);
//}
//
///**
// * 文档信息通知
// * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
// */
//- (void)onPage:(int)position width:(unsigned int)width height:(unsigned int)height;
//{
//
//    //_currentPlaybackTimeLabel.text= [self currentPlayTime:position];
//    // NSLog(@"currentPlaybackTimeLabel---onPage:(int) position width:(unsigned int)width height:(unsigned int)height--%@",_currentPlaybackTimeLabel.text);
//}
//
//- (void)onAnnotaion:(int)position {
//    _currentPlaybackTimeLabel.text = [self currentPlayTime:position];
//    //NSLog(@"currentPlaybackTimeLabel---onAnnotaion:(int)position--%@",_currentPlaybackTimeLabel.text);
//}
//
////播放完成停止通知，
//- (void)onStop {
//    isVideoFinished = YES;
//    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"播放结束" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
//    //    [alertView show];
//}
//
//- (void)onVideoStart {
//    // 直播初始化成功，加入直播
//    [self.connectShieldView removeFromSuperview];
//}
//#pragma mark-- 分段控制器Viewd
//- (void)setupSegmentView {
//    self.segmentView = [[UIView alloc] init];
//    self.segmentView.backgroundColor = [UIColor whiteColor];
//    if (IS_IPHONE_X) {
//        self.segmentView.frame = CGRectMake(0, IPHONE_WIDTH / 16 * 9 + 44, IPHONE_WIDTH, 40);
//    }
//    else {
//        self.segmentView.frame = CGRectMake(0, IPHONE_WIDTH / 16 * 9, IPHONE_WIDTH, 40);
//    }
//    [self.view addSubview:self.segmentView];
//
//    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.5)];
//    topLineView.backgroundColor = live_segmentLineColor;
//    [self.segmentView addSubview:topLineView];
//
//    NSArray *segmentTitles = @[ @"聊天", @"资料", @"笔记" ];
//    //    _segment = [[CCSegment alloc]initWithSectionTitles:@[@"节点",@"聊天",@"资料",@"笔记"]];
//    _segment = [[CCSegment alloc] initWithSectionTitles:segmentTitles];
//    _segment.frame = CGRectMake(0, 0.5, IPHONE_WIDTH - 53.5, 40);
//    _segment.selectionIndicatorColor = dominant_GreenColor;
//    _segment.selectionIndicatorMode = HMSelectionIndicatorNoneSegment;
//
//    @weakify(self);
//    _segment.indexChangeBlock = ^(NSUInteger index) {
//        @strongify(self);
//        [self didSelectSegment:index];
//    };
//    [self.segmentView addSubview:_segment];
//
//    CGFloat segmentWidth = _segment.frame.size.width / segmentTitles.count;
//
//    //    _nodeLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segment.frame)-3, segmentWidth, 2)];
//    //    _nodeLineView.backgroundColor = dominant_GreenColor;
//    //    [_segment addSubview:_nodeLineView];
//
//    _chatLineView = [[UIView alloc] initWithFrame:CGRectMake(segmentWidth * 0, CGRectGetMaxY(_segment.frame) - 3, segmentWidth, 2)];
//    _chatLineView.backgroundColor = dominant_GreenColor;
//    [_segment addSubview:_chatLineView];
//
//    _learningMaterialsLineView = [[UIView alloc] initWithFrame:CGRectMake(segmentWidth * 1, CGRectGetMaxY(_segment.frame) - 3, segmentWidth, 2)];
//    _learningMaterialsLineView.backgroundColor = dominant_GreenColor;
//    [_segment addSubview:_learningMaterialsLineView];
//
//    _noteLineView = [[UIView alloc] initWithFrame:CGRectMake(segmentWidth * 2, CGRectGetMaxY(_segment.frame) - 3, segmentWidth, 2)];
//    _noteLineView.backgroundColor = dominant_GreenColor;
//    [_segment addSubview:_noteLineView];
//
//    UIView *centerLineView = [[UIView alloc] initWithFrame:CGRectMake(_segment.frame.size.width / 2, CGRectGetMaxY(topLineView.frame) + 5, 0.5, 30)];
//    centerLineView.backgroundColor = live_segmentLineColor;
//    [_segment addSubview:centerLineView];
//
//    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(_segment.frame.size.width, CGRectGetMaxY(topLineView.frame) + 5, 0.5, 30)];
//    rightLineView.backgroundColor = live_segmentLineColor;
//    [_segment addSubview:rightLineView];
//
//    _segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _segmentButton.backgroundColor = [UIColor whiteColor];
//    _segmentButton.frame = CGRectMake(IPHONE_WIDTH - 53, CGRectGetMaxY(topLineView.frame), 53, 40);
//    [_segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
//    [_segmentButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.segmentView addSubview:_segmentButton];
//}
//
//- (void)didSelectSegment:(NSUInteger)index {
//    //    if (index == SegmentIndexNode) {//节点
//    //        isSegment = NO;
//    //        [self.chatTableView setHidden:YES];
//    //        [self.LearningMaterialsView setHidden:YES];
//    //        [self.noteTableView setHidden:YES];
//    //
//    //        _pdfWebView.hidden = YES;
//    //        _nodeLineView.hidden = NO;
//    //        _chatLineView.hidden = YES;
//    //        _learningMaterialsLineView.hidden = YES;
//    //        _noteLineView.hidden = YES;
//    //        _liveFootView.hidden = YES;
//    //        [self setupDataScrollPositionBottom];
//    //    }else
//    if (index == SegmentIndexChat) { //聊天
//        isSegment = YES;
//        [self.chatTableView setHidden:NO];
//        [self.LearningMaterialsView setHidden:YES];
//        [self.noteTableView setHidden:YES];
//
//        _closePdfButton.hidden = _pdfWebView.hidden = YES;
//
//        _nodeLineView.hidden = YES;
//        _chatLineView.hidden = NO;
//        _learningMaterialsLineView.hidden = YES;
//        _noteLineView.hidden = YES;
//        _liveFootView.hidden = NO;
//        [self setupDataScrollPositionBottom];
//    }
//    else if (index == SegmentIndexMaterial) { //资料
//        isSegment = NO;
//        [self.chatTableView setHidden:YES];
//        [self.LearningMaterialsView setHidden:NO];
//        [self.noteTableView setHidden:YES];
//
//        if (_pdfWebView.hidden == NO) {
//            _closePdfButton.hidden = _pdfWebView.hidden = NO;
//        }
//        _nodeLineView.hidden = YES;
//        _chatLineView.hidden = YES;
//        _learningMaterialsLineView.hidden = NO;
//        _noteLineView.hidden = YES;
//        _liveFootView.hidden = YES;
//        [self setupDataScrollPositionBottom];
//    }
//    else if (index == SegmentIndexNote) { //笔记
//        isSegment = NO;
//        [self.chatTableView setHidden:YES];
//        [self.LearningMaterialsView setHidden:YES];
//        [self.noteTableView setHidden:NO];
//
//        _closePdfButton.hidden = _pdfWebView.hidden = YES;
//        _nodeLineView.hidden = YES;
//        _chatLineView.hidden = YES;
//        _learningMaterialsLineView.hidden = YES;
//        _noteLineView.hidden = NO;
//        _liveFootView.hidden = YES;
//        [self.noteTableView.mj_header beginRefreshing];
//    }
//}
//
//- (void)segmentButtonAction:(UIButton *)button {
//    [_segmentButton setImage:[UIImage imageNamed:@"live_up"] forState:UIControlStateNormal];
//    if (_item) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"课程咨询", @"意见反馈", @"评价课程", @"下载", nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        [actionSheet showInView:self.view];
//    }
//    else {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"课程咨询", @"意见反馈", @"评价课程", nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        [actionSheet showInView:self.view];
//    }
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        NSURL *url = [NSURL URLWithString:@"http://chat7714.talk99.cn/chat/chat/p.do?_server=0&c=20003089&f=10089572&g=10076235&refer=iPhone"];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"即将打开课程咨询页"
//                                                                       message:@"咨询完毕后，点击屏幕左上角的“都学课堂”就可以返回到课堂继续进行学习"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"好"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  if (url) {
//                                                                      if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                                                                          [[UIApplication sharedApplication] openURL:url
//                                                                              options:@{ UIApplicationOpenURLOptionUniversalLinksOnly : @(NO) }
//                                                                              completionHandler:^(BOOL success) {
//                                                                                  if (success) {
//                                                                                      //NSLog(@"Succeeded open URL: %@", url);
//                                                                                  }
//                                                                                  else {
//                                                                                      //NSLog(@"Failed to open URL: %@", url);
//                                                                                  }
//                                                                              }];
//                                                                      }
//                                                                      else {
//                                                                          //NSLog(@"设备中不包含可以打开指定url(%@)的程序。", url);
//                                                                      }
//                                                                  }
//                                                              }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action){
//
//                                                             }];
//
//        [alert addAction:cancelAction];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    else if (buttonIndex == 1) {
//        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        DXFeedbackViewController *feedbackVC = [mainSB instantiateViewControllerWithIdentifier:@"feedbackVC"];
//        feedbackVC.feedbackType = FeedbackLiveType;
//        [self.navigationController pushViewController:feedbackVC animated:YES];
//    }
//    else if (buttonIndex == 2) {
//        if (isComment) {
//            [self showHint:@"您已经点评过本课程，无需再次评价"];
//        }
//        else {
//            DXLiveAppraiseViewController *liveAppraiseVC = [[DXLiveAppraiseViewController alloc] init];
//            liveAppraiseVC.liveAppraiseType = PlayBackAppraiseChooseType;
//            liveAppraiseVC.courseID = self.courseID;
//            [self.navigationController pushViewController:liveAppraiseVC animated:YES];
//        }
//    }
//    else if (buttonIndex == 3) {
//        NSLog(@"下载");
//
//        [self setGSVodManager];
//    }
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    [_segmentButton setImage:[UIImage imageNamed:@"live_down"] forState:UIControlStateNormal];
//}
//
//- (void)setupChatTableView {
//    if (IS_IPHONE_X) {
//        self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IPHONE_WIDTH / 16 * 9 + 84, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 16 * 9 - 84) style:UITableViewStylePlain];
//    }
//    else {
//        self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IPHONE_WIDTH / 16 * 9 + 40, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 16 * 9 - 40) style:UITableViewStylePlain];
//    }
//
//    self.chatTableView.backgroundColor = live_tableViewBgColor;
//    self.chatTableView.delegate = self;
//    self.chatTableView.dataSource = self;
//    self.chatTableView.tag = 66666;
//    self.chatTableView.tableHeaderView = [[UIView alloc] init];
//    self.chatTableView.tableFooterView = [[UIView alloc] init];
//    [self.chatTableView registerClass:[DXLiveShowCell class] forCellReuseIdentifier:showLiveCellIdentifier];
//    self.chatTableView.estimatedRowHeight = 200;
//    [self.view addSubview:self.chatTableView];
//    //-----------
//    if (IS_IPHONE_X) {
//        self.vodplayer.mVideoView = [[VodGLView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 84, 144, 144 / 16 * 9)];
//    }
//    else {
//        self.vodplayer.mVideoView = [[VodGLView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 144, IPHONE_WIDTH / 16 * 9 + 40, 144, 144 / 16 * 9)];
//    }
//    self.vodplayer.mVideoView.backgroundColor = [UIColor blackColor];
//
//    [self.view insertSubview:self.vodplayer.mVideoView atIndex:999];
//
//    self.signelSmallTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelSmallTap:)];
//    self.signelSmallTap.numberOfTapsRequired = 1;
//    self.signelSmallTap.delegate = self;
//    [self.vodplayer.mVideoView addGestureRecognizer:self.signelSmallTap];
//    [self setupSmallVideoBackButton];
//    [self.vodplayer.mVideoView addSubview:self.smallVideoBackButton];
//
//    self.fullPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fullPanGestureRecognizer:)];
//    [self.vodplayer.mVideoView addGestureRecognizer:self.fullPan];
//}
//
//#pragma mark-- 学习资料setupLearningMaterialsView
//- (void)setupLearningMaterialsView {
//    self.LearningMaterialsView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.LearningMaterialsView.backgroundColor = [UIColor whiteColor];
//    self.LearningMaterialsView.dataSource = self;
//    self.LearningMaterialsView.delegate = self;
//    self.LearningMaterialsView.emptyDataSetSource = self;
//    self.LearningMaterialsView.emptyDataSetDelegate = self;
//    self.LearningMaterialsView.tag = 77777;
//    self.LearningMaterialsView.hidden = YES;
//    self.LearningMaterialsView.tableHeaderView = [[UIView alloc] init];
//    self.LearningMaterialsView.tableFooterView = [[UIView alloc] init];
//    self.LearningMaterialsView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    //    self.LearningMaterialsView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_header)];
//    //    self.LearningMaterialsView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_footer)];
//
//    self.LearningMaterialsView.backgroundColor = live_tableViewBgColor;
//    self.LearningMaterialsView.rowHeight = 80;
//    [self.view addSubview:self.LearningMaterialsView];
//
//    [self.LearningMaterialsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.segmentView.mas_bottom);
//        make.left.and.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
//}
//
//
//#pragma mark-- 回放笔记TableView
//- (void)setupNoteTableView {
//    if (IS_IPHONE_X) {
//        self.noteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IPHONE_WIDTH / 16 * 9 + 84, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 16 * 9 - 84) style:UITableViewStylePlain];
//    }
//    else {
//        self.noteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IPHONE_WIDTH / 16 * 9 + 40, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 16 * 9 - 40) style:UITableViewStylePlain];
//    }
//    self.noteTableView.backgroundColor = [UIColor whiteColor];
//    self.noteTableView.dataSource = self;
//    self.noteTableView.tag = 55555;
//    self.noteTableView.hidden = YES;
//    self.noteTableView.tableHeaderView = [[UIView alloc] init];
//    self.noteTableView.tableFooterView = [[UIView alloc] init];
//    self.noteTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_header)];
//    self.noteTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNotelist_footer)];
//    [self.noteTableView registerClass:[DXLiveNoteCell class] forCellReuseIdentifier:noteLiveCellIdentifier];
//    [self.noteTableView dx_addTapTarget:self action:@selector(clickAction)];
//    self.noteTableView.backgroundColor = live_tableViewBgColor;
//    self.noteTableView.estimatedRowHeight = 50;
//    self.noteTableView.rowHeight = UITableViewAutomaticDimension;
//    [self.view addSubview:self.noteTableView];
//
//    [self.noteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.segmentView.mas_bottom);
//        make.left.and.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-kBootomSafeHeight);
//    }];
//    [self.view insertSubview:_vodplayer.mVideoView atIndex:999];
//}
//
//#pragma mark - 聊天对话框(Button)
//- (void)setupFootView {
//    self.liveFootView = [[DXLiveFootView alloc] initWithFrame:CGRectZero];
//    self.liveFootView.delegate = self;
//    [self.liveFootView.textButton setTitle:@"请积极发言" forState:UIControlStateNormal];
//    [self.view addSubview:self.liveFootView];
//
//    [_liveFootView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-kBootomSafeHeight);
//        make.left.and.right.equalTo(self.view);
//        make.height.equalTo(@44);
//    }];
//}
//
//#pragma mark-- 键盘监听方法
//- (void)keyboardChanged:(NSNotification *)notification {
//
//    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect currentFrame;
//    if (isSegment == YES) {
//        currentFrame = self.liveKeyboardView.frame;
//    }
//    else {
//        currentFrame = self.liveNoteKeyboardView.contentView.frame;
//    }
//
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         //输入框最终的位置
//                         CGRect resultFrame;
//
//                         if (isSegment) {
//                             if (frame.origin.y == IPHONE_HEIGHT) {
//                                 resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
//                                 self.keyboardHeight = 0;
//                                 if (IS_IPHONE_X) {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 84, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - 167);
//                                 }
//                                 else {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 40, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - 84);
//                                 }
//                                 self.liveKeyboardView.frame = CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, self.liveKeyboardView.KeyboardTextView.dx_height + 16);
//                                 [self setupDataScrollPositionBottom];
//                             }
//                             else {
//                                 if (![self.liveKeyboardView.KeyboardTextView.text isEqualToString:@""]) {
//                                     resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - frame.size.height - self.liveKeyboardView.dx_height, currentFrame.size.width, currentFrame.size.height);
//                                 }
//                                 else {
//                                     resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - currentFrame.size.height - frame.size.height, currentFrame.size.width, currentFrame.size.height);
//                                 }
//
//                                 self.keyboardHeight = frame.size.height;
//                                 if (IS_IPHONE_X) {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 84, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - self.keyboardHeight - 128);
//                                 }
//                                 else {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 40, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - self.keyboardHeight - 84);
//                                 }
//                                 self.liveKeyboardView.frame = resultFrame;
//                                 [self setupDataScrollPositionBottom];
//                             }
//                         }
//                         else {
//                             if (frame.origin.y == IPHONE_HEIGHT) {
//                                 resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
//                                 self.keyboardHeight = 0;
//                                 if (IS_IPHONE_X) {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 84, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - 167);
//                                 }
//                                 else {
//                                     self.chatTableView.frame = CGRectMake(0, IPHONE_WIDTH / 4 * 3 + 40, IPHONE_WIDTH, IPHONE_HEIGHT - IPHONE_WIDTH / 4 * 3 - 84);
//                                 }
//                                 self.liveNoteKeyboardView.contentView.frame = CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 179);
//                             }
//                             else {
//                                 resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - currentFrame.size.height - frame.size.height, currentFrame.size.width, currentFrame.size.height);
//                                 self.keyboardHeight = frame.size.height;
//                                 self.liveNoteKeyboardView.contentView.frame = resultFrame;
//                             }
//                         }
//                     }];
//}
//
//#pragma mark-- textView改变方法
//- (void)textViewDidChange:(UITextView *)textView {
//
//    if (isSegment) {
//
//        contentText = textView.text;
//
//        CGSize maxSize = CGSizeMake(textView.bounds.size.width, MAXFLOAT);
//
//        //测量string的大小
//        CGRect frame = [contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : textView.font } context:nil];
//        //设置self.textView的高度，默认是30
//        CGFloat tarHeight = 30;
//        //如果文本框内容的高度+10大于30也就是初始的self.textview的高度的话，设置tarheight的大小为文本的内容+10，其中10是文本框和背景view的上下间距；
//        if (frame.size.height + 10 > 30) {
//            tarHeight = frame.size.height + 10;
//        }
//        //如果self.textView的高度大于200时，设置为200，即最高位200
//        if (tarHeight > 200) {
//            tarHeight = 200;
//        }
//
//        CGFloat width = IPHONE_WIDTH;
//
//        //设置输入框的frame
//        self.liveKeyboardView.frame = CGRectMake(0, (IPHONE_HEIGHT - self.keyboardHeight) - (tarHeight + 13), width, tarHeight + 13);
//        if (self.liveKeyboardView.isEmoji) {
//            //设置输入框的frame
//            self.liveKeyboardView.KeyboardTextView.frame = CGRectMake(60, (self.liveKeyboardView.bounds.size.height - tarHeight) / 2, IPHONE_WIDTH - 120, tarHeight);
//        }
//        else {
//            //设置输入框的frame
//            self.liveKeyboardView.KeyboardTextView.frame = CGRectMake(60, (self.liveKeyboardView.bounds.size.height - tarHeight) / 2, IPHONE_WIDTH - 74, tarHeight);
//        }
//    }
//    else {
//        if (textView.text.length == 0) {
//            self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
//        }
//        else if (textView.text.length > 300) {
//            [self showHint:@"笔记字数超出限制"];
//        }
//        else {
//            self.liveNoteKeyboardView.placeHolderLabel.text = @"";
//        }
//    }
//}
//
//- (void)setupLiveNoteKeyboardView {
//    self.liveNoteKeyboardView.contentView.frame = CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 179);
//    self.liveNoteKeyboardView.noteTextView.delegate = self;
//    self.liveNoteKeyboardView.delegate = self;
//}
//
//#pragma mark-- 点击tableView关闭键盘方法
//- (void)clickAction {
//    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
//    [self.chatTableView reloadData];
//    [self setupDataScrollPositionBottom];
//}
//
//#pragma mark-- 全屏手势方法
//- (void)fullPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
//
//    if (isTransition) {
//        CGPoint translation = [panGestureRecognizer translationInView:self.view];
//        CGPoint newCenter = CGPointMake(panGestureRecognizer.view.center.x + translation.x,
//                                        panGestureRecognizer.view.center.y + translation.y); //    限制屏幕范围
//        newCenter.y = MAX(panGestureRecognizer.view.frame.size.height / 2, newCenter.y);
//        newCenter.y = MIN(IPHONE_WIDTH - panGestureRecognizer.view.frame.size.height / 2, newCenter.y);
//        newCenter.x = MAX(panGestureRecognizer.view.frame.size.width / 2, newCenter.x);
//        newCenter.x = MIN(IPHONE_HEIGHT - panGestureRecognizer.view.frame.size.width / 2, newCenter.x);
//        panGestureRecognizer.view.center = newCenter;
//        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
//    }
//    else {
//        CGPoint translation = [panGestureRecognizer translationInView:self.view];
//        CGPoint newCenter = CGPointMake(panGestureRecognizer.view.center.x + translation.x,
//                                        panGestureRecognizer.view.center.y + translation.y); //    限制屏幕范围
//        newCenter.y = MAX(panGestureRecognizer.view.frame.size.height / 2, newCenter.y);
//        newCenter.y = MIN(self.view.frame.size.height - panGestureRecognizer.view.frame.size.height / 2, newCenter.y);
//        newCenter.x = MAX(panGestureRecognizer.view.frame.size.width / 2, newCenter.x);
//        newCenter.x = MIN(self.view.frame.size.width - panGestureRecognizer.view.frame.size.width / 2, newCenter.x);
//        panGestureRecognizer.view.center = newCenter;
//        [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
//    }
//}
//
//#pragma mark-- 小视频手势识别UIGestureRecognizerDelegate
//- (void)handleSignelSmallTap:(UIGestureRecognizer *)gestureRecognizer {
//    _hiddenBack = !_hiddenBack;
//    if (self.hiddenBack) {
//        self.smallVideoBackButton.hidden = YES;
//    }
//    else {
//        self.smallVideoBackButton.hidden = NO;
//        [self startClickSmallVideoTime];
//    }
//}
//
//// 设置数据超过一屏时滚动到底部
//- (void)setupDataScrollPositionBottom {
//    if (self.dataArray.count > 0) {
//        id lastObject = [self.dataArray lastObject];
//        NSInteger indexOfLastRow = [self.dataArray indexOfObject:lastObject];
//        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfLastRow inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//}
//
//#pragma mark-- 小视频上的关闭按钮
//- (void)setupSmallVideoBackButton {
//    self.smallVideoBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.smallVideoBackButton.frame = CGRectMake(0, 0, 30, 30);
//    [self.smallVideoBackButton setImage:[UIImage imageNamed:@"live_smallVideoBack"] forState:UIControlStateNormal];
//    self.smallVideoBackButton.hidden = YES;
//    self.smallVideoBackButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 0, 0);
//    self.smallVideoBackButton.tag = 67;
//    [self.smallVideoBackButton addTarget:self action:@selector(smallVideoButtonAction) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)smallVideoButtonAction {
//    [self.cutButton setImage:IMG(@"live_open") forState:UIControlStateNormal];
//    if (isDocVideo) {
//        self.vodplayer.docSwfView.hidden = YES;
//        isHiddenVideo = YES;
//    }
//    else {
//        self.vodplayer.mVideoView.hidden = YES;
//        isHiddenVideo = YES;
//    }
//}
//
//#pragma mark-- 笔记数据请求设置
//- (void)getNotelist_header {
//    self.noteCurrentPage = 1;
//    [self.noteListArray removeAllObjects];
//    [self getNotelist];
//}
//
//- (void)getNotelist_footer {
//    self.noteCurrentPage++;
//    [self getNotelist];
//}
//
//- (void)getNotelist {
//
//    @weakify(self);
//    ApiRequestStateHandler *requestHandle = [ApiRequestStateHandler apiRequestStateHandlerOnSuccess:^(ApiExcutor *apiExcutor, BOOL *cache) {
//        @strongify(self);
//        if ([self.noteTableView.mj_header isRefreshing]) {
//            [self.noteTableView.mj_header endRefreshing];
//            [_noteListArray removeAllObjects];
//        }
//        else if ([self.noteTableView.mj_footer isRefreshing]) {
//            [self.noteTableView.mj_footer endRefreshing];
//        }
//
//        if (self.apiGetNoteExcutor.flag == 1) {
//            [self.noteListArray addObjectsFromArray:self.apiGetNoteExcutor.dataSource];
//
//            [self.noteTableView reloadData];
//        }
//        else {
//            self.noteCurrentPage--;
//        }
//    }
//        onFail:^(ApiExcutor *apiExcutor, NSError *error) {
//            @strongify(self);
//            if ([self.noteTableView.mj_header isRefreshing]) {
//                [self.noteTableView.mj_header endRefreshing];
//            }
//            else if ([self.noteTableView.mj_footer isRefreshing]) {
//                [self.noteTableView.mj_footer endRefreshing];
//                self.noteCurrentPage--;
//            }
//        }];
//
//    [self.apiGetNoteExcutor apiGetNotelistWithUID:[DXUserManager sharedManager].user.uid
//                                         courseID:self.courseID
//                                        chapterID:[[NSString stringWithFormat:@""] longLongValue]
//                                            JieID:[[NSString stringWithFormat:@""] longLongValue]
//                                     andPageIndex:self.noteCurrentPage
//                                         PageSize:NOTEPAGESIZE
//                                 andRequestHandle:requestHandle];
//}
//
///**
// 获得本课程用户是否评价过
// */
//- (void)getCommentData {
//    @weakify(self);
//    ApiRequestStateHandler *requestHandle = [ApiRequestStateHandler apiRequestStateHandlerOnSuccess:^(ApiExcutor *apiExcutor, BOOL *cache) {
//        @strongify(self);
//
//        if (self.apiGetCommentExcutor.flag == 1) {
//            if (self.apiGetCommentExcutor.dataSource == nil || self.apiGetCommentExcutor.dataSource.count == 0) {
//                isComment = NO;
//            }
//            else {
//                isComment = YES;
//            }
//        }
//    }
//        onFail:^(ApiExcutor *apiExcutor, NSError *error) {
//            @strongify(self);
//            [self showHint:self.apiGetCommentExcutor.msg];
//        }];
//    [self.apiGetCommentExcutor getCourseComment:self.courseID pageIndex:0 pageSize:10 uid:[DXUserManager sharedManager].user.uid andRequestHandle:requestHandle];
//}
//
//#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView.tag == 66666) {
//        return self.dataArray.count;
//    }
//    else if (tableView.tag == 77777) {
//        if ([NSString isEmpty:self.teach_material_file]) {
//            return 0;
//        }
//        else {
//            return 1;
//        }
//    }
//    else {
//        return self.noteListArray.count;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.cell.key2fileDic = _key2fileDic;
//    static NSString *cellId = @"cell";
//    if (tableView.tag == 66666) {
//
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        self.cell = [tableView dequeueReusableCellWithIdentifier:showLiveCellIdentifier];
//
//        if (!cell) {
//            self.cell = [[DXLiveShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showLiveCellIdentifier];
//        }
//
//        UIImageView *statusImageView = [[UIImageView alloc] init];
//        statusImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
//        [self.cell addSubview:statusImageView];
//        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.cell.mas_left).offset(14);
//            make.height.mas_equalTo(16);
//            make.width.mas_equalTo(30);
//            make.top.mas_equalTo(17.5);
//        }];
//
//        UILabel *nickNameLabel = [[UILabel alloc] init];
//        nickNameLabel.font = [UIFont systemFontOfSize:14];
//        nickNameLabel.text = self.nameArray[indexPath.row];
//        [self.cell addSubview:nickNameLabel];
//        if ([self.imageArray[indexPath.row] isEqualToString:@""]) {
//            [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.cell.mas_left).offset(14);
//                make.height.mas_equalTo(20);
//                make.width.mas_equalTo(IPHONE_WIDTH - 28);
//                make.top.mas_equalTo(15);
//            }];
//        }
//        else {
//            [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(statusImageView.mas_right).offset(7);
//                make.height.mas_equalTo(20);
//                make.width.mas_equalTo(IPHONE_WIDTH - 58);
//                make.top.mas_equalTo(15);
//            }];
//        }
//
//        OHAttributedLabel *chatContenLabel = [[OHAttributedLabel alloc] init];
//        [self creatAttributedLabel:self.dataArray[indexPath.row] Label:chatContenLabel indexPath:indexPath];
//        [self heightOfText:[self transfromString2:self.dataArray[indexPath.row]] width:IPHONE_WIDTH - 26 fontSize:14.f];
//        [chatContenLabel setFont:[UIFont systemFontOfSize:14.f]];
//        [chatContenLabel.layer display];
//        [self drawImageView:chatContenLabel];
//        [self.cell addSubview:chatContenLabel];
//        return self.cell;
//    }
//    else if (tableView.tag == 77777) {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        UILabel *nameLable = [[UILabel alloc] init];
//        nameLable.textAlignment = NSTextAlignmentLeft;
//        nameLable.textColor = [UIColor blackColor];
//        nameLable.font = [UIFont systemFontOfSize:15];
//        nameLable.text = [NSString stringWithFormat:@"%@.pdf", self.videoTitle];
//        [cell.contentView addSubview:nameLable];
//        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.offset(0);
//            make.left.offset(15.0f);
//            make.right.offset(15.0f);
//        }];
//        return cell;
//    }
//    else {
//        DXLiveNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:noteLiveCellIdentifier];
//        if (!cell) {
//            cell = [[DXLiveNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteLiveCellIdentifier];
//        }
//        cell.noteModel = [self.noteListArray objectAtIndex:indexPath.row];
//
//        return cell;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return height + 51;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.LearningMaterialsView) {
//        [self loadDataDown];
//    }
//}
//
//#pragma mark-- 显示表情相关方法
//- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label indexPath:(NSIndexPath *)indexPath {
//    [label setNeedsDisplay];
//
//    NSString *text = [self transformString:o_text];
//    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@", text];
//
//    MarkupParser *p = [[MarkupParser alloc] init];
//    NSMutableAttributedString *attString = [p attrStringFromMarkup:text];
//    [attString setFont:[UIFont systemFontOfSize:14]];
//    label.backgroundColor = [UIColor clearColor];
//    [label setAttString:attString withImages:p.images];
//    label.frame = CGRectMake(13, 39, IPHONE_WIDTH, 0);
//
//    CGRect labelRect = label.frame;
//    labelRect.size.width = [label sizeThatFits:CGSizeMake(IPHONE_WIDTH - 26, CGFLOAT_MAX)].width;
//    labelRect.size.height = [label sizeThatFits:CGSizeMake(IPHONE_WIDTH - 26, CGFLOAT_MAX)].height;
//    label.frame = labelRect;
//    height = labelRect.size.height;
//}
//
//- (NSString *)transformString:(NSString *)originalStr {
//    //匹配表情，将表情转化为html格式
//    NSString *text = originalStr;
//
//    NSRegularExpression *preRegex = [[NSRegularExpression alloc]
//        initWithPattern:@"<IMG.+?src=\"(.*?)\".*?>"
//                options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
//                  error:nil]; //2
//    NSArray *matches = [preRegex matchesInString:text
//                                         options:0
//                                           range:NSMakeRange(0, [text length])];
//
//
//    int offset = 0;
//
//    for (NSTextCheckingResult *match in matches) {
//
//        NSRange imgMatchRange = [match rangeAtIndex:0];
//        imgMatchRange.location += offset;
//
//        NSString *imgMatchString = [text substringWithRange:imgMatchRange];
//
//
//        NSRange srcMatchRange = [match rangeAtIndex:1];
//        srcMatchRange.location += offset;
//
//        NSString *srcMatchString = [text substringWithRange:srcMatchRange];
//
//        NSString *i_transCharacter = [self.key2fileDic objectForKey:srcMatchString];
//        if (i_transCharacter) {
//            NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='24' height='24'>", i_transCharacter];
//            text = [text stringByReplacingCharactersInRange:NSMakeRange(imgMatchRange.location, [imgMatchString length]) withString:imageHtml];
//            offset += (imageHtml.length - imgMatchString.length);
//        }
//    }
//
//    return text;
//}
//
//- (NSString *)transfromString2:(NSString *)originalString {
//    //匹配表情，将表情转化为html格式
//    NSString *text = originalString;
//    //【伤心】
//    //NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//
//    NSRegularExpression *preRegex = [[NSRegularExpression alloc]
//        initWithPattern:@"<IMG.+?src=\"(.*?)\".*?>"
//                options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
//                  error:nil]; //2
//    NSArray *matches = [preRegex matchesInString:text
//                                         options:0
//                                           range:NSMakeRange(0, [text length])];
//    int offset = 0;
//
//    for (NSTextCheckingResult *match in matches) {
//        //NSRange srcMatchRange = [match range];
//        NSRange imgMatchRange = [match rangeAtIndex:0];
//        imgMatchRange.location += offset;
//
//        NSString *imgMatchString = [text substringWithRange:imgMatchRange];
//
//
//        NSRange srcMatchRange = [match rangeAtIndex:1];
//        srcMatchRange.location += offset;
//
//        NSString *srcMatchString = [text substringWithRange:srcMatchRange];
//
//        NSString *i_transCharacter = [self.key2fileDic objectForKey:srcMatchString];
//        if (i_transCharacter) {
//            NSString *imageHtml = @"表情表情表情"; //表情占位，用于计算文本长度
//            text = [text stringByReplacingCharactersInRange:NSMakeRange(imgMatchRange.location, [imgMatchString length]) withString:imageHtml];
//            offset += (imageHtml.length - imgMatchString.length);
//        }
//    }
//    //返回转义后的字符串
//    return text;
//}
//
//- (NSString *)chatString:(NSString *)originalStr {
//
//    NSArray *textTailArray = [[NSArray alloc] initWithObjects:@"【太快了】", @"【太慢了】", @"【赞同】", @"【反对】", @"【鼓掌】", @"【值得思考】", nil];
//
//    NSRegularExpression *preRegex = [[NSRegularExpression alloc]
//        initWithPattern:@"【([\u4E00-\u9FFF]*?)】"
//                options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
//                  error:nil]; //2
//    NSArray *matches = [preRegex matchesInString:originalStr
//                                         options:0
//                                           range:NSMakeRange(0, [originalStr length])];
//
//    int offset = 0;
//
//    for (NSTextCheckingResult *match in matches) {
//        //NSRange srcMatchRange = [match range];
//        NSRange emotionRange = [match rangeAtIndex:0];
//        emotionRange.location += offset;
//
//        NSString *emotionString = [originalStr substringWithRange:emotionRange];
//
//        NSString *i_transCharacter = [_text2keyDic objectForKey:emotionString];
//        if (i_transCharacter) {
//            NSString *imageHtml = nil;
//            if ([textTailArray containsObject:emotionString]) {
//                imageHtml = [NSString stringWithFormat:@"<IMG src=\"%@\" custom=\"false\">", i_transCharacter];
//            }
//            else {
//                imageHtml = [NSString stringWithFormat:@"<IMG src=\"%@\" custom=\"false\">", i_transCharacter];
//            }
//            originalStr = [originalStr stringByReplacingCharactersInRange:NSMakeRange(emotionRange.location, [emotionString length]) withString:imageHtml];
//            offset += (imageHtml.length - emotionString.length);
//        }
//    }
//
//    NSMutableString *richStr = [[NSMutableString alloc] init];
//    [richStr appendString:@"<SPAN style=\"FONT-SIZE: 10pt; FONT-WEIGHT: normal; COLOR: #000000; FONT-STYLE: normal\">"];
//    [richStr appendString:originalStr];
//    [richStr appendString:@"</SPAN>"];
//
//    return richStr;
//}
//
//- (CGFloat)heightOfText:(NSString *)content width:(CGFloat)width fontSize:(CGFloat)fontSize {
//    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
//    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
//    return MAX(size.height, 20);
//}
//
//- (void)drawImageView:(OHAttributedLabel *)label {
//    for (NSArray *info in label.imageInfoArr) {
//
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
//        NSString *filePath = [resourceBundle pathForResource:[info objectAtIndex:0] ofType:nil];
//        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
//        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
//        imageView.frame = CGRectFromString([info objectAtIndex:2]);
//        [label addSubview:imageView]; //label内添加图片层
//        [label bringSubviewToFront:imageView];
//        imageView = nil;
//    }
//}
//
//- (void)removeSomeView:(UIView *)view {
//    if ([view isKindOfClass:[self.vodplayer.mVideoView class]]) {
//        UIView *subView = [view viewWithTag:67];
//        [subView removeFromSuperview];
//    }
//    else {
//        UIView *subView = [view viewWithTag:67];
//        [subView removeFromSuperview];
//    }
//}
//
//- (void)startClickVideoTime {
//    __block int timeout = 5; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if (timeout == 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _footerView.hidden = YES;
//                _headerView.hidden = YES;
//                _hiddenAll = !_hiddenAll;
//            });
//        }
//        timeout--;
//    });
//    dispatch_resume(_timer);
//}
//
//- (void)startClickSmallVideoTime {
//    __block int timeout = 5; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if (timeout == 0) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.smallVideoBackButton.hidden = YES;
//                _hiddenBack = !_hiddenBack;
//            });
//        }
//        timeout--;
//    });
//    dispatch_resume(_timer);
//}
//
//- (NSMutableArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [[NSMutableArray alloc] init];
//    }
//    return _dataArray;
//}
//
//- (NSMutableArray *)nameArray {
//    if (!_nameArray) {
//        _nameArray = [[NSMutableArray alloc] init];
//    }
//    return _nameArray;
//}
//
//- (NSMutableArray *)imageArray {
//    if (!_imageArray) {
//        _imageArray = [[NSMutableArray alloc] init];
//    }
//    return _imageArray;
//}
//
//- (NSMutableArray *)noteListArray {
//    if (!_noteListArray) {
//        _noteListArray = [[NSMutableArray alloc] init];
//    }
//    return _noteListArray;
//}
//
///* 获得笔记列表 */
//- (DXApiGetNoteExcutor *)apiGetNoteExcutor {
//    if (_apiGetNoteExcutor == nil) {
//        _apiGetNoteExcutor = [DXApiGetNoteExcutor excutor];
//    }
//    return _apiGetNoteExcutor;
//}
//
///* 上传用户笔记 */
//- (DXApiUpNoteExcutor *)apiUpNoteExcutor {
//    if (_apiUpNoteExcutor == nil) {
//        _apiUpNoteExcutor = [DXApiUpNoteExcutor excutor];
//    }
//    return _apiUpNoteExcutor;
//}
//
///* 得到用户评论 */
//- (DXApiGetCourseCommentExcutor *)apiGetCommentExcutor {
//    if (_apiGetCommentExcutor == nil) {
//        _apiGetCommentExcutor = [DXApiGetCourseCommentExcutor excutor];
//    }
//    return _apiGetCommentExcutor;
//}
//
//- (DXLiveConnectShieldView *)connectShieldView {
//    if (_connectShieldView == nil) {
//        _connectShieldView = [[DXLiveConnectShieldView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _connectShieldView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
//        _connectShieldView.layer.masksToBounds = YES;
//        _connectShieldView.layer.cornerRadius = 5;
//        _connectShieldView.userInteractionEnabled = NO;
//    }
//    return _connectShieldView;
//}
//
//- (void)dealloc {
//    if (self.vodplayer) {
//        [self.vodplayer stop];
//        [self.vodplayer.docSwfView clearVodLastPageAndAnno]; //退出前清理一下文档模块
//        self.vodplayer.docSwfView = nil;
//        self.vodplayer = nil;
//        self.item = nil;
//    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//
//    NSLog(@"DXLivePlayBackViewController--dealloc");
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - VodDownLoadDelegate
////  添加到下载代理
//- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item {
//    // 直播初始化成功，加入直播
//    [self.connectShieldView removeFromSuperview];
//    self.connectShieldView = nil;
//
//    if (resultType == RESULT_SUCCESS) {
//        self.item = item;
//
//        // 回放相关的方法 (包含回放的View)
//        [self setupPlayBack];
//
//        // 隐藏控制器
//        _hiddenAll = YES;
//        if (self.hiddenAll) {
//            _footerView.hidden = YES;
//            _headerView.hidden = YES;
//        }
//
//        // 隐藏小视频控制器
//        _hiddenBack = YES;
//        if (self.hiddenBack) {
//            self.smallVideoBackButton.hidden = YES;
//        }
//
//        [self setupSegmentView];
//        self.segment.selectedIndex = 0;
//
//        isSegment = YES;
//        isHiddenVideo = NO;
//        isDocVideo = NO;
//
//        [self setupFootView]; //笔记记录输入框
//        [self setupLiveNoteKeyboardView];
//        [self setupChatTableView];
//        //初始化学习资料
//        [self setupLearningMaterialsView];
//        [self setupNoteTableView];
//        [self getNotelist];
//        self.noteCurrentPage = 1;
//
//        isSliderValue = NO;
//        isVideoFinished = NO;
//        videoRestartValue = 0;
//    }
//    else if (resultType == RESULT_ROOM_NUMBER_UNEXIST) {
//        [self showHint:@"点播间不存在"];
//    }
//    else if (resultType == RESULT_FAILED_NET_REQUIRED) {
//        [self showHint:@"网络请求失败"];
//    }
//    else if (resultType == RESULT_FAIL_LOGIN) {
//        [self showHint:@"用户名或密码错误"];
//    }
//    else if (resultType == RESULT_NOT_EXSITE) {
//        [self showHint:@"该点播的编号的点播不存在"];
//    }
//    else if (resultType == RESULT_INVALID_ADDRESS) {
//        [self showHint:@"无效地址"];
//    }
//    else if (resultType == RESULT_UNSURPORT_MOBILE) {
//        [self showHint:@"不支持移动设备"];
//    }
//    else if (resultType == RESULT_FAIL_TOKEN) {
//        [self showHint:@"口令错误"];
//    }
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//
//
//
//
///**
// *  下载完成代理
// *
// *  @param downloadID 已经下载完成的点播件（录制件）的ID
// */
//- (void)onDLFinish:(NSString *)downloadID {
//    _vodplayer.playItem = self.item; //换成本地播放资源
//    NSLog(@"下载完成代理");
//}
//
///**
// *  下载进度代理
// *
// *  @param downloadID 正在下载的点播件（录制件）的ID
// *  @param percent    下载的进度
// */
//- (void)onDLPosition:(NSString *)downloadID percent:(float)percent {
//    NSLog(@"%f", percent);
//}
//
///**
// *  下载开始代理
// *
// *  @param downloadID 开始下载的点播件（录制件）的ID
// */
//- (void)onDLStart:(NSString *)downloadID {
//    NSLog(@"下载开始代理");
//}
//
///**
// *  下载停止代理
// *
// *  @param downloadID 停止下载的点播件（录制件）的ID
// */
//- (void)onDLStop:(NSString *)downloadID {
//    NSLog(@"下载停止代理");
//}
//
///**
// *  下载出错代理\
// *
// *  @param downloadID 下载出错的点播件（录制件）的ID
// *  @param errorCode  错误码
// */
//- (void)onDLError:(NSString *)downloadID Status:(VodDownLoadStatus)errorCode // 下载出错
//{
//    NSLog(@"下载出错代理");
//}
//
//
//
//#pragma mark - PDF下载相关
////判断文件是否已经在沙盒中存在
//- (BOOL)isFileExist:(NSString *)fileName {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSString *filePath = [path stringByAppendingPathComponent:fileName];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL result = [fileManager fileExistsAtPath:filePath];
//    return result;
//}
//
////资料文件下载并打开
//- (void)loadDataDown {
//    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //    QLPreviewController *previewVC  =  [[QLPreviewController alloc]  init];
//    //    previewVC.dataSource  = self;
//    //
//    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSString *urlStr = self.teach_material_file;
//    //    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
//    if (urlStr) {
//        NSURL *URL = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//        [self.pdfWebView setHidden:NO];
//        self.closePdfButton.hidden = NO;
//        [self.pdfWebView loadRequest:request];
//    }
//
//
//    //判断是否存在
//    //    if([self isFileExist:fileName]) {
//    //        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    //        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
//    //        self.pdfFileURL = url;
//    //        [self presentViewController:previewVC animated:YES completion:nil];
//
//    //用webview显示pdf
//    //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
//    //        [previewVC refreshCurrentPreviewItem];
//    //    }
//    //    else {
//    //        [SVProgressHUD showWithStatus:@"下载中"];
//    //        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
//    //
//    //        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//    //            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    //            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
//    //            return url;
//    //        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//    //            [SVProgressHUD dismiss];
//    //            self.pdfFileURL = filePath;
//    //            [self presentViewController:previewVC animated:YES completion:nil];
//    //            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
//    //            [previewVC refreshCurrentPreviewItem];
//    //        }];
//    //        [downloadTask resume];
//    //    }
//}
//
//#pragma mark - QLPreviewControllerDataSource
//- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
//    return self.pdfFileURL;
//}
//
//- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
//    return 1;
//}
//
//- (UIWebView *)pdfWebView {
//
//    if (!_pdfWebView) {
//
//        _pdfWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        _pdfWebView.delegate = self;
//        _pdfWebView.backgroundColor = KWhiteColor;
//        _pdfWebView.opaque = NO;
//        _pdfWebView.scrollView.showsVerticalScrollIndicator = NO;
//
//        _pdfWebView.scrollView.bounces = NO;
//        [self.view addSubview:_pdfWebView];
//
//        [_pdfWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.segmentView.mas_top);
//            make.left.and.right.equalTo(self.view);
//            make.bottom.equalTo(self.view).offset(-kBootomSafeHeight);
//        }];
//
//        self.closePdfButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_closePdfButton addTarget:self action:@selector(tapClosePdf:) forControlEvents:UIControlEventTouchUpInside];
//        ;
//        ;
//        [_closePdfButton setTitle:@"关闭" forState:UIControlStateNormal];
//        [_closePdfButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        _closePdfButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        [_closePdfButton setCornerRadius:8];
//        [_closePdfButton setBackgroundColor:[UIColor darkGrayColor]];
//        [self.view addSubview:_closePdfButton];
//        [_closePdfButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.segmentView.mas_top).offset(10);
//            make.left.equalTo(self.view).offset(15);
//            make.width.equalTo(@(60));
//            make.height.equalTo(@(30));
//        }];
//    }
//    return _pdfWebView;
//}
//
//- (void)tapClosePdf:(UIButton *)button {
//    self.pdfWebView.hidden = YES;
//    self.closePdfButton.hidden = YES;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//}
//
//#pragma mark - liveNoteKeyboardViewDelegate
//- (void)didSelectNoteBackButton {
//    [self.liveNoteKeyboardView removeFromSuperview];
//    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
//    self.liveNoteKeyboardView.noteTextView.text = @"";
//    self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
//    self.liveNoteKeyboardView.pictureImageView.image = nil;
//}
//
//- (void)didSelectScreenshotsButton {
//    //    self.liveNoteKeyboardView.pictureButton.selected = !self.liveNoteKeyboardView.pictureButton.selected;
//    //    NSLog(@"%d",self.liveNoteKeyboardView.pictureButton.selected);
//    //    if (self.liveNoteKeyboardView.pictureButton.selected) {
//    //        self.screenshotsImage = [self snapshot:self.docView];
//    //        self.liveNoteKeyboardView.pictureImageView.image = self.screenshotsImage;
//    //    }
//    //    else
//    //    {
//    //        self.screenshotsImage = [self snapshot:nil];
//    //        self.liveNoteKeyboardView.pictureImageView.image = nil;
//    //    }
//}
//
//- (void)didSelectSaveButton {
//    NSString *imgUrl = nil;
//    NSString *textField = nil;
//
//    if (self.liveNoteKeyboardView.noteTextView.text.length == 0) {
//        [self showHint:@"你还没写下任何笔记"];
//        return;
//    }
//
//    @weakify(self);
//    ApiRequestStateHandler *requestHandle = [ApiRequestStateHandler apiRequestStateHandlerOnSuccess:^(ApiExcutor *apiExcutor, BOOL *cache) {
//        @strongify(self);
//        [self hideHud];
//        if (self.apiUpNoteExcutor.flag == 1) {
//            [self showHint:@"笔记保存成功"];
//            /* 刷新笔记 */
//            [self.noteTableView.mj_header beginRefreshing];
//            [self.noteTableView reloadData];
//            self.liveNoteKeyboardView.noteTextView.text = @"";
//            self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
//            [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
//            [self.liveNoteKeyboardView removeFromSuperview];
//            self.liveNoteKeyboardView.pictureImageView.image = nil;
//        }
//        else {
//            [self showHint:self.apiUpNoteExcutor.msg];
//            //NSLog(@" - - %@ - - ",self.apiUpNoteExcutor.msg);
//        }
//    }
//        onFail:^(ApiExcutor *apiExcutor, NSError *error) {
//
//            [self hideHud];
//
//            //NSLog(@" - - %@ - - ",error.description);
//        }];
//
//    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a = [dat timeIntervalSince1970];
//
//    /* 没有截图的时候 */
//    if (self.screenshotsImage == nil) {
//        [self.apiUpNoteExcutor uploadNoteWithUID:[DXUserManager sharedManager].user.uid
//                                        courseID:self.courseID
//                                       chapterID:[[NSString stringWithFormat:@""] longLongValue]
//                                           JieID:[[NSString stringWithFormat:@""] longLongValue]
//                                    andNoteTitle:@""
//                                         Content:self.liveNoteKeyboardView.noteTextView.text
//                                        NoteTime:a
//                                       Thumbnail:imgUrl
//                                       andisOpen:self.isPublicNote
//                                     FinallyWith:requestHandle];
//    }
//    else {
//        textField = self.liveNoteKeyboardView.noteTextView.text;
//        NSData *data = UIImagePNGRepresentation(self.screenshotsImage);
//
//        [self showHudInView:self.view hint:@"上传笔记中..."];
//        [DXApiUploadNoteIMGExcutor uploadImageFile:data
//            userID:[DXUserManager sharedManager].user.uid
//            courseID:self.courseID
//            chapterID:[[NSString stringWithFormat:@""] longLongValue]
//            jieID:[[NSString stringWithFormat:@""] longLongValue]
//            noteTitle:@""
//            content:textField
//            noteTime:a
//            isOpen:self.isPublicNote
//            Successed:^(id sender) {
//
//                NSDictionary *dict = (NSDictionary *) sender;
//
//                if ([dict[@"flag"] intValue] == 1) {
//                    [self hideHud];
//                    [self showHint:@"笔记上传成功"];
//
//                    /* 刷新笔记 */
//                    [self.noteTableView.mj_header beginRefreshing];
//                    self.liveNoteKeyboardView.noteTextView.text = @"";
//                    self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
//                    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
//                    [self.liveNoteKeyboardView removeFromSuperview];
//                    self.liveNoteKeyboardView.pictureImageView.image = nil;
//                }
//                else {
//                    [self hideHud];
//                    NSLog(@" - - 缺少参数 - - ");
//                }
//
//            }
//            failed:^(id sender) {
//                [self hideHud];
//            }];
//    }
//}
//
//#pragma mark - 拖动屏幕前进,后退
//
//- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
//
//    if (pan.state == UIGestureRecognizerStateEnded) {
//
//        [self durationSliderDone:self.durationSlider];
//        [self.playActionView setHidden:YES];
//    }
//    else if (pan.state == UIGestureRecognizerStateBegan) {
//        _durationSliderValue = _durationSlider.value;
//        _lastPanPoint = [pan locationInView:self.overlayView];
//        _nowPanPoint = _lastPanPoint;
//
//        /* 右滑行程. */
//        _rightPanDistance = self.overlayView.width - _lastPanPoint.x;
//
//        /* 左滑形成 */
//        _leftPanDistance  = _lastPanPoint.x;
//
//        /* 总时长 */
//        _totalSeconds = _duration;
//
//        /* 获取当前时间点 */
//        _pastSeccons = (NSInteger)(_durationSlider.value * _duration);
//
//        // 暂停播放
//        [self.playbackButton setImage:IMG(@"whitePlay_YM") forState:UIControlStateNormal];
//        if (self.vodplayer) {
//            [self.vodplayer pause];
//        }
//          isDragging = YES;
//    }else if (pan.state == UIGestureRecognizerStateChanged){
//        self.playActionView.hidden = NO;
//
//        CGPoint nowPoint = [pan locationInView:self.overlayView];
//
//        float panLenght = nowPoint.x - _lastPanPoint.x;
//
//        float leftOrRight = _nowPanPoint.x - nowPoint.x;
//
//        //        [self durationSliderMoving:self.durationSlider];
//
//        float durSec =_duration;
//        if (durSec == 0) {
//            //self.durationSlider.value = 0;
//        }else {
//            float distance = 0;
//            if (panLenght > 0)
//            {
//                distance = (_pastSeccons + (panLenght / _rightPanDistance) * (_totalSeconds - _pastSeccons));
//                self.durationSlider.value = distance / durSec;
//               // NSLog(@"durationSlider.value--UIGestureRecognizerStateChanged--panLenght > 0--%f",self.durationSlider.value);
//            }
//            else
//            {
//                distance = (_pastSeccons + (panLenght / _leftPanDistance) * _pastSeccons);
//                self.durationSlider.value = distance / durSec;
//                //NSLog(@"durationSlider.value--UIGestureRecognizerStateChanged--else--%f",self.durationSlider.value);
//            }
//
//        }
//        //self.progressView.progress = self.durationSlider.value;
//
////        float precision = 0.2f;
////        if (isTransition) {
////            precision = 0.2f*KScreenHeight/KScreenWidth;;
////        }else{
////            precision = 0.2f;
////        }
////
////        if (fabs(leftOrRight)<=precision)
////        {
////            /* 修正极其缓慢情况下移动造成的 "前进"和"后退" 图标混乱. */
////        }else
//            if (leftOrRight <= 0){
//            [self.playActionView setActionStatue:ActionStateForward andSeekTime:self.durationSlider.value * durSec/1000];
//        } else{
//            [self.playActionView setActionStatue:ActionStateBack andSeekTime:self.durationSlider.value * durSec/1000];
//        }
//        _nowPanPoint = nowPoint;
//    } else{
//        //[self durationSliderDone:self.durationSlider];
//        [self.playActionView setHidden:YES];
//    }
//}
//
//
//
//- (DXPlayActionView *)playActionView{
//    if (_playActionView == nil) {
//        _playActionView = [[[NSBundle mainBundle]loadNibNamed:@"DXPlayActionView" owner:nil options:nil]lastObject];
//        [_playActionView setFrame:CGRectMake(0, 0, 120.f, 60.f)];
//        /* seekTime 相关 */
//        self.playActionView.hidden = YES;
//        self.playActionView.center = self.overlayView.center;
//        [self.vodplayer.docSwfView addSubview:self.playActionView];
//    }
//    return _playActionView;
//}
//
//-(void)durationSliderMoving:(UISlider*)durationSlider{
//    
//    
//}
//
//
//#pragma mark - GSVodManagerDelegate
//
////已经请求到点播件数据,并加入队列
//- (void)vodManager:(GSVodManager *)manager downloadEnqueueItem:(downItem *)item state:(RESULT_TYPE)type {
//    NSLog(@"已经请求到点播件数据,并加入队列--GSVodManage");
//        //[self resetCustomButton:_start flag:0];
//}
////开始下载
//- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
//    NSArray *UnFinishedItems1 =  [[VodManage shareManage] searchNeedDownloadAndUnFinishedItems];
//    NSLog(@"UnFinishedItems--%@--strDownloadID__%@",UnFinishedItems1,[(downItem *)UnFinishedItems1.firstObject strDownloadID]);
//    
//    NSLog(@"开始下载--GSVodManage--%@",item.strDownloadID);
//    //按钮状态逻辑
//    //    {
//    //        _state.isPause = NO;
//    //        [self resetCustomButton:_stopResume  flag:1];
//    //        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
//    //    }
//    
//}
////下载进度
//- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
//    NSLog(@"下载进度");
////    NSLog(@"percent ： %f",percent);
////    NSLog(@"下载进度--GSVodManager--%@",item.name);
//    //    {
//    //        _state.isPause = NO;
//    //        [self resetCustomButton:_stopResume  flag:1];
//    //        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
//    //    }
//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    //        _progress.percent = percent/100;
//    //    });
//}
//
////下载暂停
//- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
////        [self resetCustomButton:_stopResume  flag:1];
////        [_stopResume setTitle:@"恢复下载" forState:UIControlStateNormal];
////        _state.isPause = YES;
//}
//
////下载停止
//- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
//    //按钮状态逻辑
////        [self resetCustomButton:_start  flag:1];
////        [_start setTitle:@"开始下载" forState:UIControlStateNormal];
////        [self resetCustomButton:_stopResume  flag:0];
////        [self resetCustomButton:_delete  flag:0];
////        [self resetCustomButton:_play  flag:0];
////        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
////        _state.isStop = YES;
//}
//
////下载完成
//- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item
//{
//    NSLog(@"GSVodManager--下载完成");
//    [NSThread sleepForTimeInterval:2.0f];//此时并没有把下载完成的对象放入[[VodManage shareManage] searchFinishedItems],延时操作
//    [[DXLiveBackDownLoadingManager sharedInstance] removeDownItem:item];//从正在下载数组中移除
//}
//
////下载失败
//- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
//    //按钮状态逻辑
////        [self resetCustomButton:_start  flag:1];
////        [self resetCustomButton:_play  flag:0];
//}
//
//
//@end

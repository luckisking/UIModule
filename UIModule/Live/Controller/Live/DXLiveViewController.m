//
//  DXLiveViewController.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/1/23.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveViewController.h"
#import "DXLiveConnectShieldView.h"     //进来时候的欢迎界面
#import "DXLiveShieldView.h"            //离开时候的原因界面
#import "DXLiveOverLayerVeiw.h"  //大的播放视频操作层
#import "DXLiveRequest.h"       //网络请求
#import <SPPageMenu/SPPageMenu.h>

/*分享相关，先不做*/
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import "DXCustomShareView.h"

/* 下面4个和表情输入法有关系*/
//#import "OHAttributedLabel.h"
//#import "MarkupParser.h"
//#import "NSAttributedString+Attributes.h"
//#import "SCGIFImageView.h"

@interface DXLiveViewController ()  <UITextViewDelegate,UIScrollViewDelegate,SPPageMenuDelegate,liveShieldViewDelegate,liveNoteKeyboardViewDelegate, LiveNetworkViewDelegate,DXLiveOverLayerVeiwDelegate,DXLiveViewControllerDelegate>

#pragma mark 修改切换（视频与文档）和（全屏与非全屏）的实现方式
@property (strong, nonatomic) DXLiveOverLayerVeiw *overlayView;                  //播放操作视图
@property (strong, nonatomic) DXLiveRequest *request;                            //网络请求
@property (strong, nonatomic) UIButton *smallVideoBackButton;            // 小视频上的关闭按钮
@property (assign, nonatomic) int noteCurrentPage;                       // 笔记请求页标
@property (nonatomic, strong) UIImage *screenshotsImage;                 // 笔记截图
@property(nonatomic, strong)UIView *headerSafeView;//iphoneX头部
@property(nonatomic, strong)UIView *bootomSafeView;//iphoneX底部
@property (nonatomic, strong) DXLiveConnectShieldView *connectShieldView;// 进入直播间时弹出的视图
@property (nonatomic, strong) DXLiveShieldView *shieldView;              // 关闭直播时弹出的视图
@property (nonatomic, assign) CGFloat keyboardHeight;                    // 键盘高度
@property (nonatomic, assign) NSInteger toIndex; //由于SPPageMenu，全屏返回之后调整了scrollViewde contenSize，导致显示bug，借这个属性更正
@property (assign, nonatomic) BOOL lockLandscape; //用户是否点击全屏状态下锁定自动旋转
@end

@implementation DXLiveViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view bringSubviewToFront:_parentPlaySmallWindow];
    [_parentPlayLargerWindow bringSubviewToFront:_overlayView];
    [self.view bringSubviewToFront:_connectShieldView];
    [_interfaceView setupDataScrollPositionBottom];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    [self.liveNoteKeyboardView removeFromSuperview];
    [self.liveKeyboardView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //键盘的frame即将发生变化时立刻发出该通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(docVideoStatus:) name:@"liveDocVideoStatus" object:nil];//初始化成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfaceOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    isSegment = YES;
    _request = [[DXLiveRequest alloc] init];
    [self getCommentData]; //查询是否评价过该课程
    //    _lockLandscape = YES;//横屏锁定（设计图横屏左边有个锁的点击事件）默认不锁定 NO

    [self initParentPlayLargerWindow];  //直播大父视图
    [self initParentPlaySmallWindow]; //直播小父视图
    
    //初始化直播（注意先初始化上面的大的和小的直播父视图）
    if (_liveType) {
         [self initCCLive];  //ccsdk
    }else {
         [self initGenseeLive];  //genseesdk
    }
    [self initIntefaceView]; //非直播视图
    [self setupLiveKeyboardView]; //聊天textView父视图
    [self setupLiveNoteKeyboardView]; //笔记textView父视图
    [self.view addSubview:self.connectShieldView]; //正在进入直播
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
    _parentPlayLargerWindow.backgroundColor  = [UIColor blackColor];
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
    _parentPlaySmallWindow = [[UIView alloc] init];
    _parentPlaySmallWindow.backgroundColor  = [UIColor blackColor];
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
//初始化播放操作视图
- (void)initOverlayView {
    
    //播放操作
    _overlayView = [[DXLiveOverLayerVeiw alloc] initWithTarget:self];
    _overlayView.titleLabel.text = _videoTitle;
    [_parentPlayLargerWindow addSubview:_overlayView];
    //    _overlayView.layer.zPosition = 100000;//不响应
    [_overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0,0,0));
    }];
    [_overlayView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelLargerTap:)]];
    
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
    
    [_interfaceView.textButton setTitle:@"请积极发言" forState:UIControlStateNormal];
    [_interfaceView.chatTableView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];//关闭聊天键盘键盘
    
}

//大直播视图上面的按钮操作（——overLayView）
- (void)videoOverLayerClickWithName:(NSString *)name button:(nonnull UIButton *)button {
    if ([name isEqualToString:@"返回"]) [self backButtonAction:button];
    else if ([name isEqualToString:@"分享"]) [self shareButtonAction:button];
    else if ([name isEqualToString:@"更多"]) [self menuButtonAction:button];
    else if ([name isEqualToString:@"网络"]) [self networkButtonAction:button];
    else if ([name isEqualToString:@"切换"]) [self cutButtonAction:button];
    else if ([name isEqualToString:@"全屏"]) [self fullScreenButtonAction:button];
}

#pragma mark -通知方法
//收到直播初始化化成功的通知
- (void)docVideoStatus:(NSNotification *)sender {
    if ([sender.object boolValue]) {
        // 直播初始化成功，加入直播
    }else {
        [self showHint:@"视频、文档加载失败"];
    }
    [self.connectShieldView removeFromSuperview];
 
    if (_liveType) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //由于cc直播初始化视图的耗时较长，可能数据已经开始返回，视图还没有初始化完成(还没有添加到父视图上)..
            [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
        });
    }
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
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
         isSegment = YES;
        _interfaceView.textButton.superview.hidden = NO;
        [_interfaceView setupDataScrollPositionBottom];
        [_interfaceView.textButton setTitle:@"请积极发言" forState:UIControlStateNormal];

    }else if (toIndex==1){//资料列表
        
        _interfaceView.textButton.superview.hidden = YES;
        
    } else {// 笔记
        
        isSegment = NO;
        _interfaceView.textButton.superview.hidden = NO;
        [_interfaceView.noteTableView.mj_header beginRefreshing];
        [_interfaceView.textButton setTitle:@"请记笔记" forState:UIControlStateNormal];
     
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
        if (self-> isComment) {
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


#pragma mark - 键盘，聊天，笔记相关方法

//点击了聊天对话框(Button)按钮
- (void)didSelectChatButton {
    if (isSegment == YES) {
        [self.liveNoteKeyboardView removeFromSuperview];
        [[[UIApplication sharedApplication]keyWindow] addSubview:self.liveKeyboardView];
        [self.liveKeyboardView.KeyboardTextView becomeFirstResponder];
        self.liveNoteKeyboardView.hidden = YES;
        self.liveKeyboardView.hidden = NO;
    }
    else
    {
        [self.liveKeyboardView removeFromSuperview];
        [self.view addSubview:self.liveNoteKeyboardView];
        [self.liveNoteKeyboardView.noteTextView becomeFirstResponder];
        self.screenshotsImage = [self snapshot:self.docView];
        if (self.screenshotsImage != nil) {
            self.liveNoteKeyboardView.pictureButton.selected = YES;
        }
        else
        {
            self.liveNoteKeyboardView.pictureButton.selected = NO;
        }
        self.liveNoteKeyboardView.publicButton.selected = YES;
        self.liveKeyboardView.hidden = YES;
        self.liveNoteKeyboardView.hidden = NO;
        self.liveNoteKeyboardView.pictureImageView.image = [self snapshot:self.docView];
    }
}

#pragma mark -- 弹出键盘显示的View
//加载聊天键盘视图
- (void)setupLiveKeyboardView {
    _liveKeyboardView = [[DXLiveKeyboardView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 44)];
    _liveKeyboardView.KeyboardTextView.delegate = self;
    _liveKeyboardView.KeyboardTextView.enablesReturnKeyAutomatically = YES;
}

//加载笔记键盘视图
- (void)setupLiveNoteKeyboardView
{
    _liveNoteKeyboardView = [[DXLiveNoteKeyboardView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _liveNoteKeyboardView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    _liveNoteKeyboardView.contentView.frame = CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 179);
    _liveNoteKeyboardView.noteTextView.delegate = self;
    _liveNoteKeyboardView.delegate = self;
}

//笔记获取获得屏幕图像
- (UIImage *)snapshot:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self , nil, nil);
    return image;
}
//笔记返回
- (void)didSelectNoteBackButton
{
    [self.liveNoteKeyboardView removeFromSuperview];
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    self.liveNoteKeyboardView.noteTextView.text = @"";
    self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
    self.liveNoteKeyboardView.pictureImageView.image = nil;
}

//笔记带上图片
- (void)didSelectScreenshotsButton
{
    self.liveNoteKeyboardView.pictureButton.selected = !self.liveNoteKeyboardView.pictureButton.selected;
    NSLog(@"%d",self.liveNoteKeyboardView.pictureButton.selected);
    if (self.liveNoteKeyboardView.pictureButton.selected) {
        self.screenshotsImage = [self snapshot:self.docView];
        self.liveNoteKeyboardView.pictureImageView.image = self.screenshotsImage;
    }
    else
    {
        self.screenshotsImage = [self snapshot:nil];
        self.liveNoteKeyboardView.pictureImageView.image = nil;
    }
}
//笔记保存
- (void)didSelectSaveButton{

    if (self.liveNoteKeyboardView.noteTextView.text.length == 0 ) {
        [self showHint:@"你还没写下任何笔记"];
        return;}
//    if (_screenshotsImage) [self showHudInView:self.view hint:@"上传笔记中..."];//有截图上传笔记需要时间
    [self showHint:@"上传笔记中..."];
    [_request uploadNoteWithUID:_uid
                       courseID:_courseID
                      chapterID:0
                          JieID:0
                   andNoteTitle:@""
                        Content:self.liveNoteKeyboardView.noteTextView.text
                       NoteTime:[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]
                      Thumbnail:@""
                      andisOpen:YES
                      imageFile:_screenshotsImage?UIImagePNGRepresentation(self.screenshotsImage):nil
                        success:^(NSDictionary * _Nonnull dic, BOOL state) {
                            if (state) {
                                [self showHint:@"笔记保存成功"];
                                /* 刷新笔记 */
                                [self.interfaceView.noteTableView.mj_header beginRefreshing];
                                [self.interfaceView.noteTableView reloadData];
                                self.liveNoteKeyboardView.noteTextView.text = @"";
                                self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
                                [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
                                [self.liveNoteKeyboardView removeFromSuperview];
                                self.liveNoteKeyboardView.pictureImageView.image = nil;
                            }
                        }
                           fail:^(NSError * _Nonnull error) {
                               
                           }];
}


//点击tableView关闭键盘方法
- (void)clickAction {
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
}
// 键盘监听方法
- (void)keyboardChanged:(NSNotification *)notification{
    
    CGRect frame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{

        if (self->isSegment) {
            if (frame.origin.y == IPHONE_HEIGHT) {
                [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
                //键盘收起
                NSLog(@"键盘收起来了");
                //更新聊天keyboard
                self.keyboardHeight=0;
                self.liveKeyboardView.frame = CGRectMake(0, IPHONE_HEIGHT , IPHONE_WIDTH , self.liveKeyboardView.KeyboardTextView.frame.size.height+16);
                //更新聊天的tableVeiw
                [ self.interfaceView.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.interfaceView.chatTableView.superview).offset(-44);//避开下方的聊天视图
                }];
                [self.interfaceView.chatTableView.superview layoutIfNeeded];
                [self.interfaceView setupDataScrollPositionBottom];
            }else{
            //键盘弹出
                NSLog(@"键盘弹出了");
                //更新聊天keyboard
                self.keyboardHeight = frame.size.height;
                CGRect keyboardframe =   self.liveKeyboardView.frame;
                keyboardframe.origin.y = IPHONE_HEIGHT-frame.size.height-keyboardframe.size.height;
                self.liveKeyboardView.frame = keyboardframe;
                //更新聊天的tableVeiw
                [self.interfaceView.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.interfaceView.chatTableView.superview).offset(-(frame.size.height+self.liveKeyboardView.frame.size.height));
                }];
                [self.interfaceView.chatTableView.superview layoutIfNeeded];//要求立即更新
                [self.interfaceView setupDataScrollPositionBottom];
            }
        }else{
            if (frame.origin.y == IPHONE_HEIGHT) {
                self.keyboardHeight=0;
                self.liveNoteKeyboardView.contentView.frame = CGRectMake(0, IPHONE_HEIGHT , IPHONE_WIDTH , 179);
            }else{
                self.keyboardHeight = frame.size.height;
                CGRect currentFrame =  self.liveNoteKeyboardView.contentView.frame;
                self.liveNoteKeyboardView.contentView.frame = CGRectMake(currentFrame.origin.x,IPHONE_HEIGHT - currentFrame.size.height - frame.size.height , currentFrame.size.width, currentFrame.size.height);
                
            }
        }
    }];
}

#pragma mark - textView代理方法
- (void)textViewDidChange:(UITextView *)textView{
    if (isSegment) {
        
        CGSize maxSize = CGSizeMake(textView.bounds.size.width, MAXFLOAT);
        
        //测量string的大小
        CGRect frame=[textView.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
        //设置self.textView的高度，默认是30
        CGFloat tarHeight = 30;
        //如果文本框内容的高度+10大于30也就是初始的self.textview的高度的话，设置tarheight的大小为文本的内容+10，其中10是文本框和背景view的上下间距；
        if (frame.size.height + 10 > 30) {
            tarHeight=frame.size.height + 10;
        }
        //如果self.textView的高度大于200时，设置为200，即最高位200
        if (tarHeight > 200) {
            tarHeight = 200;
        }
        
        CGFloat width = IPHONE_WIDTH;
        
        //设置输入框的frame
        self.liveKeyboardView.frame = CGRectMake(0,(IPHONE_HEIGHT - self.keyboardHeight)-(tarHeight+13) , width, tarHeight +13);
        if (self.liveKeyboardView.isEmoji) {
            //设置输入框的frame
            self.liveKeyboardView.KeyboardTextView.frame = CGRectMake(60,(self.liveKeyboardView.bounds.size.height-tarHeight)/2 , IPHONE_WIDTH - 120, tarHeight);
        }
        else
        {
            //设置输入框的frame
            self.liveKeyboardView.KeyboardTextView.frame = CGRectMake(60,(self.liveKeyboardView.bounds.size.height-tarHeight)/2 , IPHONE_WIDTH - 74, tarHeight);
        }
    }
    else
    {
        if (textView.text.length == 0) {
            self.liveNoteKeyboardView.placeHolderLabel.text = @"请输入笔记内容";
        }
        else if (textView.text.length > 300)
        {
            [self showHint:@"笔记字数超出限制"];
        }
        else
        {
            self.liveNoteKeyboardView.placeHolderLabel.text = @"";
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (isSegment) {
        /*由于是textView 没有textField的-textFieldShouldReturn代理方法，所有在这里监听return键*/
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            [self sendChatMessage:textView.text];

            textView.text = @"";
            [textView resignFirstResponder];
            return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
    }
    return YES;
}

#pragma mark -- 发送消息
- (void)sendChatMessage:(NSString *)content {
    if (_liveType) {
        [self sendCCMessage:content];
    }else {
        [self sendGenseeMessage:content];
    }
}

#pragma mark - 手势点击

// 小视频上的关闭按钮
- (void)setupSmallVideoBackButton {
    self.smallVideoBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.smallVideoBackButton setImage:[UIImage imageNamed:@"live_smallVideoBack"] forState:UIControlStateNormal];
    self.smallVideoBackButton.frame = CGRectMake(0, 0, 30, 30);
    self.smallVideoBackButton.hidden = YES;
    self.smallVideoBackButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 0, 0);
//    [self.smallVideoBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    self.smallVideoBackButton.tag = 67;
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
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
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
        [self.view addSubview:self.shieldView];
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

// 网络按钮方法
- (void)networkButtonAction:(UIButton *)button
{
    if (_liveType) {
        //cc切换
        [_overlayView selectLinesWithFirRoad:_firRoadNum secRoadKeyArray:_secRoadKeyArray];
    }else {
        //gensee切换网络
        if (self.networkArray != nil) {
            [self.view addSubview:self.networkView];
        }else{
            [self showHint:@"没有可更换网络"];
        }
    }
   
}

// 切换按钮方法
/**
 切换视频和文档视图

 @param button 切换视图和文档的按钮
 */
- (void)cutButtonAction:(UIButton *)button {
    // 关闭键盘
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
    
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
            if ([_videoView.superview isEqual:_parentPlaySmallWindow]) {
                [self.overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
            }else {
                [self.overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
            }
        }
        
    }else{
        if (_liveType) {
            //cc直播
            if ( [self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
                [_requestData changeDocParent:_parentPlaySmallWindow];
                [_requestData changePlayerParent:_parentPlayLargerWindow];
                [_requestData changeDocFrame:_parentPlaySmallWindow.bounds];
                [_requestData changePlayerFrame:_parentPlayLargerWindow.bounds];
                [_overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
                _overlayView.cutButton.accessibilityIdentifier = @"文档";
            }else {
                [_requestData changeDocParent:_parentPlayLargerWindow];
                [_requestData changePlayerParent:_parentPlaySmallWindow];
                [_requestData changeDocFrame:_parentPlayLargerWindow.bounds];
                [_requestData changePlayerFrame:_parentPlaySmallWindow.bounds];
                [_overlayView.cutButton setImage:IMG(@"live_video") forState:UIControlStateNormal];
                _overlayView.cutButton.accessibilityIdentifier = @"视频";
            }
            
        }else {
            //gensee直播
            if ([_videoView.superview isEqual:_parentPlaySmallWindow]) {
                [_parentPlayLargerWindow addSubview:_videoView];
                [_parentPlaySmallWindow addSubview:_docView];
                _videoView.frame = _parentPlayLargerWindow.bounds;
                _docView.frame = _parentPlaySmallWindow.bounds;
                [self.overlayView.cutButton setImage:IMG(@"live_doc") forState:UIControlStateNormal];
            }else {
                [_parentPlayLargerWindow addSubview:_docView];
                [_parentPlaySmallWindow addSubview:_videoView];
                _docView.frame = _parentPlayLargerWindow.bounds;
                _videoView.frame = _parentPlaySmallWindow.bounds;
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
        //全屏下masonry提示约束多于冲突原因是pageMenu的高度是44 但是此时他的父视图( _interfaceView)没有高度，不影响布局;强逼症者去除pageMenu高度即可
        _overlayView.fullScreenButton.selected = YES;
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
            make.height.mas_equalTo(70);
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
    [self.view bringSubviewToFront:_parentPlayLargerWindow];
    [self.view bringSubviewToFront:_parentPlaySmallWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        //这个必须放在主线程中，不然layoutIfNeeded可能不会第一时间生效，一半的可能性
        [self.view layoutIfNeeded];
        if (_liveType) {
            //cc直播
            if ([self.overlayView.cutButton.accessibilityIdentifier isEqualToString:@"视频"]) {
                [_requestData changeDocFrame:_parentPlayLargerWindow.bounds];
                [_requestData changePlayerFrame:_parentPlaySmallWindow.bounds];
            }else {
                [_requestData changeDocFrame:_parentPlaySmallWindow.bounds];
                [_requestData changePlayerFrame:_parentPlayLargerWindow.bounds];
            }
        }else {
            //gensee直播
            if ([_docView.superview isEqual:_parentPlayLargerWindow]) {
                _docView.frame = _parentPlayLargerWindow.bounds ;
                _videoView.frame = _parentPlaySmallWindow.bounds ;
            }else {
                _docView.frame = _parentPlaySmallWindow.bounds ;
                _videoView.frame = _parentPlayLargerWindow.bounds ;
            }
        }
        [_interfaceView.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * _toIndex, 0) animated:NO];
    });
}
// 全屏按钮方法
- (void)fullScreenButtonAction:(UIButton *)button {
    // 关闭键盘
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
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
            self-> isComment = YES;
        }else {
            self-> isComment = NO;
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}

- (void)didSelectNetworkButtonTag:(NSInteger)tag index:(NSInteger)index {
    
    switch (tag) {
        case 100000:
            [self.networkView removeFromSuperview];
            break;
        case 110000:
            [_broadcastManager setCurrentIDC:[self.networkArray[index] ID]];
            [self showHint:@"切换网络成功"];
            [self.networkView removeFromSuperview];
            break;
        default:
            break;
    }
}

- (void)didSelectShieldButtonTag:(NSInteger)tag index:(NSString *)index {
    NSString *backReasonString = @"";
    if ([index isEqualToString:@"0"]) {
        backReasonString = @"临时有事";
    }
    else if ([index isEqualToString:@"1"]) {
        backReasonString = @"播放卡顿严重";
    }
    else if ([index isEqualToString:@"2"]) {
        backReasonString = @"课程质量差";
    }
    else if ([index isEqualToString:@"3"]) {
        backReasonString = @"其他";
    }
    else
    {
        backReasonString = nil;
    }
    switch (tag) {
        case 50000:
            [self.shieldView removeFromSuperview];
            break;
        case 60000:
            [self.requestData requestCancel];
            self.requestData = nil;
            [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
            [self.broadcastManager invalidate];
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
            [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
            if (backReasonString == nil) {
                
            }else{
                #pragma mark -- 退出直播选中理由接口
                [_request liveFeedbackWithPhone:_phone email:_email uid:(NSInteger)_uid txt:backReasonString courseId:_courseID sectionID:_sectionID success:nil fail:nil];
            }
            break;
        default:
            break;
    }
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

- (DXLiveShieldView *)shieldView {
    if (_shieldView == nil) {
        _shieldView = [[DXLiveShieldView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shieldView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
        _shieldView.userInteractionEnabled = YES;
        _shieldView.layer.masksToBounds = YES;
        _shieldView.layer.cornerRadius = 5;
        _shieldView.delegate = self;
    }
    return _shieldView;
}

- (DXLiveConnectShieldView *)connectShieldView {
    if (_connectShieldView == nil) {
        _connectShieldView = [[DXLiveConnectShieldView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _connectShieldView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
        _connectShieldView.layer.masksToBounds = YES;
        _connectShieldView.layer.cornerRadius = 5;
        _connectShieldView.userInteractionEnabled = NO;
    }
    return _connectShieldView;
}

- (DXLiveNetworkView *)networkView {
    if (!_networkView) {
        _networkView = [[DXLiveNetworkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _networkView.dataArray = self.networkArray;
        _networkView.backgroundColor = RGBAColor(0, 0, 0, 0.7);
        _networkView.userInteractionEnabled = YES;
        _networkView.delegate = self;
    }
    return _networkView;
}

#pragma mark -- dealloc
- (void)dealloc {
  
    NSLog(@"被销毁了。。。。。。。。。。。。。。");
    
    //CC有内存泄漏。。。。。。
    [self.requestData requestCancel];
    self.requestData = nil;
    
    //在控制器将要退出的时候，清理一下文档模块
    //gensee
    //    [self.docView cleanAllAnnos];
    if (self.broadcastManager) {
        [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
        [self.broadcastManager invalidate];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

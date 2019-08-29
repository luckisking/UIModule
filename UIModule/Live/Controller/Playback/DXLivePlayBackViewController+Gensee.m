//
//  DXLivePlayBackViewController+Gensee.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/15.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLivePlayBackViewController+Gensee.h"
#import "DXLivePlaybackModel.h"
#import "DXLivePlaybackFMDBManager.h"

@implementation DXLivePlayBackViewController (Gensee)

- (void)initGenseePlayBack {
    
    /* 经过测试这两个都是单例
    [GSVodManager sharedInstance];
    [VodManage shareManage]
     */
    
    if (self.item) {
        //播放下载（这个item是从下载页面直接传过来的）
        self.manager = [GSVodManager sharedInstance];
        self.manager.delegate = self;
        [self initPlayBackWithOnline:NO];

    }else {
        //在线播放
        [self initVodParam];//初始化参数
        [self initRequestItem];//初始化播放item
    }
}

- (void)initVodParam {
    VodParam *vodParam = [[VodParam alloc] init];
    vodParam.domain = @"doxue.gensee.com";
    //vodParam.number = self.live_room_id ;//2.    number为房间号
    vodParam.number = self.number; //   vodId为点播id
    vodParam.vodPassword = self.live_student_client_token;
    vodParam.nickName = self.uname;
    vodParam.downFlag = 0;//是否下载视频0 不下载
    vodParam.serviceType = @"training";
    vodParam.customUserID = 1000000000 +self.uid;
    self.vodParam = vodParam;
    self.manager = [GSVodManager sharedInstance];
    self.manager.delegate = self;
        
}

- (void)initRequestItem {
    [self.manager requestParam:self.vodParam enqueue:NO completion:^(downItem *item, GSVodWebaccessError type) {
        NSString *msg = nil;
        switch (type) {
            case GSVodWebaccessSuccess:
            {
               //gensee 返回成功后有黑屏现象，不播放，啥都没有,[CThreadProxyConnector::CancelConnect:186][m_stoppedflag=1]
              //gensee 只有播放开始监听 -onVideoStart  没有播放失败的监听。。。。,目前尝试了，没办法解决这个问题，一般来说，都是gensee服务器的问题，一会自动就好了
                /* 如果用户不是从下载页面过来的的，这需要搜索该item是否已经在完成下载的列表中*/
                BOOL __block isLoad = NO;
                [[[VodManage shareManage] searchFinishedItems] enumerateObjectsUsingBlock:^(downItem*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
                        isLoad = YES;
                        [self showHint:@"该回放您已下载，播放本地视频"];
//                        [self.manager removeOnDisk:item.strDownloadID];
                    }
                }];
                self.item = item;
                [self initPlayBackWithOnline:!isLoad]; //isload决定是播放下载还是在线播放
                return;
            }
                break;
            case GSVodWebaccessFailed:{
                msg = @"未知错误:2";
            }
                break;
            case GSVodWebaccessNumberError:{
                msg = @"房间号错误 或 站点类型设置错误";
            }
                break;
            case GSVodWebaccessWrongPassword:{
                msg = @"观看密码错误";
            }
                break;
            case GSVodWebaccessLoginFailed:{
                msg = @"登录账号密码错误";
            }
                break;
            case GSVodWebaccessVodIdError:{
                msg = @"VodID错误";
            }
                break;
            case GSVodWebaccessNoAccountOrPwd:{
                msg = @"账号为空 或 密码为空";
            }
                break;
            case GSVodWebaccessThirdKeyError:{
                msg = @"第三方验证码错误";
            }
                break;
            case GSVodWebaccessNetworkError:{
                msg = @"网络请求失败";
            }
                break;
            default:{
                msg = [NSString stringWithFormat:@"错误类型:%lu",(unsigned long)type];
            }
                break;
        }
        if (msg) {
            [self showHint:msg];
        }
    }];
}
- (void)initPlayBackWithOnline:(BOOL)isOnline {
    
    self.genseePlayDownload = !isOnline;//设置是否是播放下载视频
    if (isOnline) {
       [self.interfaceView addloadViewWithSuperView:self.overlayView text:@"加载中..." userEnabled:YES];
    }
    //播放初始化播放
    self.vodplayer = self.manager.player;//可以直接init vodplayer 一样的
    self.vodplayer.playItem = self.item;
    self.vodplayer.delegate = self;
    //文档初始化
    self.vodplayer.docSwfView = [[GSVodDocView alloc] initWithFrame:self.parentPlayLargerWindow.bounds];
    [self.parentPlayLargerWindow addSubview:self.vodplayer.docSwfView];
    self.vodplayer.docSwfView.zoomEnabled = NO;
    self.vodplayer.docSwfView.isVectorScale = NO;
    self.vodplayer.docSwfView.vodDocDelegate = self;
    self.vodplayer.docSwfView.gSDocModeType = VodScaleToFill;
    self.vodplayer.docSwfView.backgroundColor = [UIColor blackColor];       //文档没有显示出来之前，GSVodDocView显示的背景色
    [self.vodplayer.docSwfView setGlkBackgroundColor:51 green:51 blue:51]; //文档加载以后，侧边显示的颜色
    
    //视频初始化
    self.vodplayer.mVideoView = [[VodGLView alloc] initWithFrame:self.parentPlaySmallWindow.bounds];
    self.vodplayer.mVideoView.backgroundColor = [UIColor blackColor];
    [self.parentPlaySmallWindow addSubview:self.vodplayer.mVideoView];
    
    if (isOnline) {
        
        //在线播放- onlineplay-yes 推送聊天 audioonly - no 缓存视频(播放视频和音频)
        [self.vodplayer OnlinePlay:YES audioOnly:NO];
//        [self.manager play:self.item online:YES];//如果 self.vodplayer == self.manager.player;这个方法和上面等价;
    }else {
        //播放下载（没网也可以播放）
        //离线播放 如果下载完毕，则离线播放 -offflinePlay- yes 推送聊天
            [self.vodplayer OfflinePlay:YES];
//            [self.manager play:self.item online:NO];//如果 self.vodplayer == self.manager.player;这个方法和上面等价;
    }
    
}

//gensee下载事件
- (void)genseeDownload {
    
    /*
     *gensee下载不流畅，代理返回间隔较长，频繁操作数据库（估计是内部下载原理设计问题）
     *gensee的下载管理器，内部有数据库，但是都是存储的item相关的信息，所以我们需要另外建立相关联的数据库，
     *存贮我们自己的：封面图片，courseID,回放标题和下载ID(该id和item的下载id一一对应
     */
        if (!self.item) return;
        GSVodManager *manager =  [GSVodManager sharedInstance];
        //把下载的直播回放信息插入(同步到我们自己的)数据库中，主要作用是，到我们app的我的下载页面，方便管理
            DXLivePlaybackModel *livePlaybackModel = [[DXLivePlaybackModel alloc] init];
            livePlaybackModel.PrimaryTitle = self.videoTitle;
            livePlaybackModel.SecondaryTitle = self.SecondTitle;
            livePlaybackModel.coverImageUrl = self.imgUrl;
            livePlaybackModel.strDownloadID = self.item.strDownloadID;
            livePlaybackModel.live_room_id = self.live_room_id;
            livePlaybackModel.courseID = [NSString stringWithFormat:@"%ld",(long)self.courseID];
            livePlaybackModel.fileUrl = self.teach_material_file;
            //查询，更新，插入，一步到位
           BOOL  success =  [[DXLivePlaybackFMDBManager shareManager] insertLivePlaybackWatchItem:livePlaybackModel];
        if (success) {
            //同步成功 （不需要判断是否下载完成，因为下载完成根本不会走到这里）
            //查询所有未完成的下载（包括没下完的和等待的）
            BOOL __block isLoading = NO;
            [[[VodManage shareManage] searchNeedDownloadAndUnFinishedItems] enumerateObjectsUsingBlock:^(downItem*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.strDownloadID isEqualToString:self.item.strDownloadID]) {
                    isLoading = YES;
                }
            }];
            if (!isLoading) {
                //新的下载，插入队列
                NSLog(@"全新的下载。。。。。。。");
                [manager insertQueue:self.item atIndex:-1];
//                [manager startQueue];//队列下载使用（开启所有的下载,直接使用这个开始新的下载，默认不会下载聊天信息）
                [manager.downloader start:self.item.strDownloadID chatPost:YES];
            }else {
                NSLog(@"非全新的下载。。。。。。。");//其实应该判断是否在下载队列中，但是直接这样也可以，省的判断
                [manager.downloader start:self.item.strDownloadID chatPost:YES];
            }
            [self showHint:@"正在下载"];
//            /*监听当前单个item的下载进度,manager的delegate的进度会计算队列中等待（可能有未完成的下载，比如app退出之后，下载没有完成）的所有的大小，所以我们需要监听当前item的进度*/
//            manager.downloader.delegate = self;//经测试，该代理和manager自己本身的代理只能二选一，设置了该代理后，manager自己的下载相关的代理将失效（将影响下载管理页面的下载）
            
        }else {
            //同步失败
            [self showHint:@"下载失败，稍后重试"];
        }
   
}
- (void)initVodDownloader {
    //该类不是单例 适合边下载边播放，单个item的下载（如果自己设计下载管理器，可以设计同时多下载）（GSVodManager 是下载管理器单例，排队下载多个item）
//        self.vodDownLoader = [[VodDownLoader alloc] initWithDelegate:self];
    //    [self.vodDownLoader addItem:self.vodParam];
}

#pragma mark - VodPlayDelegate------------------------------------------------
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos {
    
    self.overlayView.duration = duration;//设置总时长
    self.overlayView.durationLabel.text = [self formatTime:duration]; //设置总时长显示
    [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
    NSLog(@"视频播放初始化完成,时长=%d ???%@",duration,self.overlayView.durationLabel.text);
}

- (void)OnChat:(NSArray *)chatArray {
    VodChatInfo *chatInfo = [chatArray objectAtIndex:0];
    
    if (chatInfo.role == 7) {
        [self.interfaceView.imageArray insertObject:@"live_lecturer" atIndex:self.interfaceView.imageArray.count];
    }
    else if (chatInfo.role == 4) {
        [self.interfaceView.imageArray insertObject:@"live_assistant" atIndex:self.interfaceView.imageArray.count];
    }
    else {
        [self.interfaceView.imageArray insertObject:@"" atIndex:self.interfaceView.imageArray.count];
    }
    //有html5 转义一下
    NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString* attrs = [[NSMutableAttributedString alloc] initWithData:[[[chatArray objectAtIndex:0] text]  dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
    [self.interfaceView.chatArray insertObject:attrs.string atIndex:self.interfaceView.chatArray.count];
    if (self.interfaceView.nameArray == nil) {
    }
    else {
        [self.interfaceView.nameArray insertObject:[[chatArray objectAtIndex:0] senderName] atIndex:self.interfaceView.nameArray.count];
    }
    DXWeak(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.interfaceView setupDataScrollPositionBottom];
    });
}

- (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
/**
 *用于vodToolView.timeLabel
 */
- (NSString *)currentPlayTime:(int)position {
//    if (!self.overlayView.durationLabel.text) {
//        self.overlayView.durationLabel.text = @"00:00:00";
//    }
    return [NSString stringWithFormat:@"%@", [self formatTime:position]];
}

- (NSString *)formatTime:(int)msec {
    int hours = msec / 1000 / 60 / 60;
    int minutes = (msec / 1000 / 60) % 60;
    int seconds = (msec / 1000) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

//进度条定位播放，如快进、快退、拖动进度条等操作回调方法
- (void)onSeek:(int)position {
    if (!self.overlayView.sliderIsMoving) {
           [self.overlayView.durationSlider setValue:(position / ((float) self.overlayView.duration)) animated:YES];
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        self.overlayView.currentPlaybackTimeLabel.text = [self currentPlayTime:position];
    }else {
        self.overlayView.currentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self currentPlayTime:position], self.overlayView.durationLabel.text] ;
    }
    NSLog(@"播放---------进度条定位%d",position);
}

// 进度通知
- (void)onPosition:(int)position {

    if (!self.overlayView.sliderIsMoving) {
        [self.overlayView.durationSlider setValue:(position / ((float) self.overlayView.duration)) animated:YES];
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
           self.overlayView.currentPlaybackTimeLabel.text = [self currentPlayTime:position];
    }else {
        self.overlayView.currentPlaybackTimeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self currentPlayTime:position], self.overlayView.durationLabel.text] ;
    }
//    NSLog(@"播放---------进度条每次变化%d",position);
}

/**
 * 文档信息通知
 * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
 */
- (void)onPage:(int)position width:(unsigned int)width height:(unsigned int)height {
}

- (void)onAnnotaion:(int)position {
}

//播放完成停止通知，
- (void)onStop {
    self.isplayFinish = YES;
    self.overlayView.playbackButton.selected = NO;//设置为未播放状态
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"播放结束" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    //    [alertView show];
     NSLog(@"播放完成----------");
}

- (void)onVideoStart {
    // 初始化成功，加入播放
     [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",YES]];
    dispatch_async(dispatch_get_main_queue(), ^{
           [self.interfaceView removeloadView];
    });
    NSLog(@"播放开始---------");
}
/**
 * 缓存通知
 * @param bBeginBuffer ture: 缓存结束  false:缓存开始
 */
- (void) OnBuffer:(BOOL)bBeginBuffer {
    NSLog(@"播放  缓存状态----%@",bBeginBuffer?@"yes":@"no");
}



#pragma mark - GSVodManagerDelegate-----------------------------------------

//已经请求到点播件数据,并加入队列
- (void)vodManager:(GSVodManager *)manager downloadEnqueueItem:(downItem *)item state:(RESULT_TYPE)type {
    NSLog(@"下载已经请求到点播件数据,并加入队列--GSVodManage");
}
//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
    NSLog(@"开始下载--GSVodManage--%@",item.strDownloadID);
}
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
//    [[VodManage shareManage] updateItem:item];//更新点播
    NSLog(@" GSVodManage ：下载大小??? %f",item.fileSize.doubleValue/1024/1024);
    NSLog(@" GSVodManage ：下载进度 %f",percent);
}
//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
     NSLog(@" GSVodManage ：下载暂停");
}
//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
    //按钮状态逻辑
       NSLog(@"GSVodManager--下载停止");
}
//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item
{
    NSLog(@"GSVodManager--下载完成");
    //此时并没有把下载完成的对象放入[[VodManage shareManage] searchFinishedItems],延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
}
//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
    //按钮状态逻辑
        NSLog(@"GSVodManager--下载失败");
}


#pragma mark - VodDownLoadDelegate----------------------------------
//  添加到下载代理
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item {

    if (resultType == RESULT_SUCCESS) {
        //        self.item = item;
        //        [self initPlayBack];
    }
    else if (resultType == RESULT_ROOM_NUMBER_UNEXIST) {
        [self showHint:@"点播间不存在"];
    }
    else if (resultType == RESULT_FAILED_NET_REQUIRED) {
        [self showHint:@"网络请求失败"];
    }
    else if (resultType == RESULT_FAIL_LOGIN) {
        [self showHint:@"用户名或密码错误"];
    }
    else if (resultType == RESULT_NOT_EXSITE) {
        [self showHint:@"该点播的编号的点播不存在"];
    }
    else if (resultType == RESULT_INVALID_ADDRESS) {
        [self showHint:@"无效地址"];
    }
    else if (resultType == RESULT_UNSURPORT_MOBILE) {
        [self showHint:@"不支持移动设备"];
    }
    else if (resultType == RESULT_FAIL_TOKEN) {
        [self showHint:@"口令错误"];
    }
}

/**
 *  下载完成代理
 *
 *  @param downloadID 已经下载完成的点播件（录制件）的ID
 */
- (void)onDLFinish:(NSString *)downloadID {
    self.vodplayer.playItem = self.item; //换成本地播放资源
    NSLog(@"VodDownLoadDelegate： 下载完成代理");
}

/**
 *  下载进度代理
 *
 *  @param downloadID 正在下载的点播件（录制件）的ID
 *  @param percent    下载的进度
 */
- (void)onDLPosition:(NSString *)downloadID percent:(float)percent {
    NSLog(@"VodDownLoadDelegate ：下载进度%f", percent);
}

/**
 *  下载开始代理
 *
 *  @param downloadID 开始下载的点播件（录制件）的ID
 */
- (void)onDLStart:(NSString *)downloadID {
    NSLog(@"VodDownLoadDelegate ：下载开始代理");
}

/**
 *  下载停止代理
 *
 *  @param downloadID 停止下载的点播件（录制件）的ID
 */
- (void)onDLStop:(NSString *)downloadID {
    NSLog(@"VodDownLoadDelegate ：下载停止代理");
}

/**
 *  下载出错代理\
 *
 *  @param downloadID 下载出错的点播件（录制件）的ID
 *  @param errorCode  错误码
 */
- (void)onDLError:(NSString *)downloadID Status:(VodDownLoadStatus)errorCode // 下载出错
{
    NSLog(@" VodDownLoadDelegate ：下载出错代理");
}


@end

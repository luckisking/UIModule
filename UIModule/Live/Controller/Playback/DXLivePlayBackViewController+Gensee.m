//
//  DXLivePlayBackViewController+Gensee.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/15.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLivePlayBackViewController+Gensee.h"

@implementation DXLivePlayBackViewController (Gensee)

- (void)initGenseePlayBack {
    [self initVodParam];//初始化参数
    [self initVodDownloader]; //初始化下载器（如果不需要下载，可以不初始化,如果默认需要下载，可以直接使用下载的item直接播放，省的二次请求(省去 [self initOnlinePlay])）
    [self initOnlinePlay];//初始化播放item
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
    //vodParam.oldVersion = NO;
    self.vodParam = vodParam;
    self.manager = [GSVodManager sharedInstance];
    self.manager.delegate = self;
}

- (void)initOnlinePlay {
    [self.manager requestParam:self.vodParam enqueue:NO completion:^(downItem *item, GSVodWebaccessError type) {
        NSString *msg = nil;
        switch (type) {
            case GSVodWebaccessSuccess:
            {
                self.item = item;
                [self initPlayBack];
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
- (void)initVodDownloader {
    
    self.vodDownLoader = [[VodDownLoader alloc] initWithDelegate:self];
    [self.vodDownLoader addItem:self.vodParam];
    
}
- (void)initPlayBack {
    // 隐藏控制器按钮
    //        self.overlayView.headerView.hidden = YES;
    //        self.overlayView.footerView.hidden = YES;
    
    //在线播放
    self.vodplayer = self.manager.player;
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
    
    //播放（可以播放指定的item） [[VodManage shareManage] findDownItem:self.item.strDownloadID];通过id可以查找出管理器中所有的对应的item
//    [self.manager play:self.item online:YES];

    //在线播放- onlieplay-yes 推送聊天 audioonly - no 缓存视频(播放视频和音频)
    [self.vodplayer OnlinePlay:YES audioOnly:NO];
//    //离线播放 如果下载完毕，则离线播放 -offflinePlay- yes 推送聊天
    //        [self.vodplayer OfflinePlay:YES];
//
    
    
}

//多个下载管理器
- (void)setGSVodManager {
//    //  获取已经下载完成的点播件（录制件）
//        NSArray *doneItemArray = [[VodManage shareManage] searchFinishedItems];
//    NSMutableArray<downItem*> *downloadIngArray =  [NSMutableArray array];// [[DXLiveBackDownLoadingManager sharedInstance] allDownLoadIngArray];
//        NSMutableArray *items = [NSMutableArray arrayWithArray:doneItemArray];
//        [items addObjectsFromArray:downloadIngArray];
//        NSLog(@"%d", self.item.state);
//
//        if (!items.count) {
//            [self insertGSVodMagerDownloadQueueWith:self.item];
//        }
//        else {
//            NSLog(@"%ld", items.count);
//            NSMutableArray *strDownloadIDArray = [NSMutableArray arrayWithCapacity:0];
//            [items enumerateObjectsUsingBlock:^(downItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
//                [strDownloadIDArray addObject:obj.strDownloadID];
//            }];
//            if ([strDownloadIDArray containsObject:self.item.strDownloadID]) {
//                [self showHint:@"已经下载过该点播件"];
//            }
//            else {
//                [self insertGSVodMagerDownloadQueueWith:self.item];
//            }
//        }
}

//插入到下载队列
- (void)insertGSVodMagerDownloadQueueWith:(downItem *)item {
    NSLog(@"insertGSVodMagerDownloadQueueWith");
        //把下载的直播回放信息插入数据库
//        DXLivePlaybackModel *livePlaybackModel = [[DXLivePlaybackModel alloc] init];
//        livePlaybackModel.PrimaryTitle = self.videoTitle;
//        livePlaybackModel.SecondaryTitle = self.SecondTitle;
//        livePlaybackModel.coverImageUrl = self.imgUrl;
//        livePlaybackModel.strDownloadID = _item.strDownloadID;
//        livePlaybackModel.live_room_id = self.live_room_id;
//        livePlaybackModel.courseID = [NSString stringWithFormat:@"%ld", self.courseID];
//        //NSLog(@"%@",livePlaybackModel);
//        [[DXLivePlaybackFMDBManager shareManager] insertLivePlaybackWatchItem:livePlaybackModel];
//        // NSLog(@"%@",_item.strDownloadID);
//        DXLivePlaybackModel *model = [[DXLivePlaybackFMDBManager shareManager] selectCurrentModelWithStrDownloadID:item.strDownloadID];
//        NSLog(@"%@", model);
//        if ([NSString isEmpty:model.strDownloadID]) {
//            [[HUDHelper sharedInstance] tipMessage:@"下载失败" delay:3.0];
//        }
//        else {
            [self showHint:@"开始下载"];
            //插入到末尾
            [[GSVodManager sharedInstance] insertQueue:item atIndex:-1];
//            [[DXLiveBackDownLoadingManager sharedInstance] allDownLoadIngArray];
//            [[DXLiveBackDownLoadingManager sharedInstance] insertDownItem:item];
            [[GSVodManager sharedInstance] startQueue];
            NSLog(@"%lu", [[GSVodManager sharedInstance] state]);
//        }
}

#pragma mark - VodDownLoadDelegate----------------------------------
//  添加到下载代理
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item {
    // 直播初始化成功，加入直播

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
    NSLog(@"下载完成代理");
}

/**
 *  下载进度代理
 *
 *  @param downloadID 正在下载的点播件（录制件）的ID
 *  @param percent    下载的进度
 */
- (void)onDLPosition:(NSString *)downloadID percent:(float)percent {
    NSLog(@"%f", percent);
}

/**
 *  下载开始代理
 *
 *  @param downloadID 开始下载的点播件（录制件）的ID
 */
- (void)onDLStart:(NSString *)downloadID {
    NSLog(@"下载开始代理");
}

/**
 *  下载停止代理
 *
 *  @param downloadID 停止下载的点播件（录制件）的ID
 */
- (void)onDLStop:(NSString *)downloadID {
    NSLog(@"下载停止代理");
}

/**
 *  下载出错代理\
 *
 *  @param downloadID 下载出错的点播件（录制件）的ID
 *  @param errorCode  错误码
 */
- (void)onDLError:(NSString *)downloadID Status:(VodDownLoadStatus)errorCode // 下载出错
{
    NSLog(@"下载出错代理");
}



#pragma mark - VodPlayDelegate------------------------------------------------
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos {
    
//
//    //    播放结束
//    if (isVideoFinished) {
//        isVideoFinished = NO;
//        //    从设定好的位置开始
//        [self.vodplayer seekTo:videoRestartValue];
//    }
//
    self.duration = duration; //设置总时长
    self.overlayView.duration = duration;
    self.overlayView. durationLabel.text = [self formatTime:duration]; //设置总时长显示
//
//    [self.playActionView setItemDuration:_duration / 1000];
    
    NSLog(@"播放开始---------");
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
    
    [self.interfaceView.chatArray insertObject:[[chatArray objectAtIndex:0] text] atIndex:self.interfaceView.chatArray.count];
    
    if (self.interfaceView.nameArray == nil) {
    }
    else {
        [self.interfaceView.nameArray insertObject:[[chatArray objectAtIndex:0] senderName] atIndex:self.interfaceView.nameArray.count];
    }
    DXWeak(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.interfaceView.chatTableView reloadData];
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
    if (!self.overlayView.durationLabel.text) {
        self.overlayView.durationLabel.text = @"00:00:00";
    }
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
    
       NSLog(@"播放---------进度条美妙变化%d",position);
}

/**
 * 文档信息通知
 * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
 */
- (void)onPage:(int)position width:(unsigned int)width height:(unsigned int)height;
{
    
    //_currentPlaybackTimeLabel.text= [self currentPlayTime:position];
    // NSLog(@"currentPlaybackTimeLabel---onPage:(int) position width:(unsigned int)width height:(unsigned int)height--%@",_currentPlaybackTimeLabel.text);
}

- (void)onAnnotaion:(int)position {
//    _currentPlaybackTimeLabel.text = [self currentPlayTime:position];
//    //NSLog(@"currentPlaybackTimeLabel---onAnnotaion:(int)position--%@",_currentPlaybackTimeLabel.text);
}

//播放完成停止通知，
- (void)onStop {
//    isVideoFinished = YES;
//    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"播放结束" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
//    //    [alertView show];
     NSLog(@"播放停止了，播放停止了播放停止了播放停止了播放停止了播放停止了播放停止了播放停止了播放停止了播放停止了");
}

- (void)onVideoStart {
    // 初始化成功，加入播放
     [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",YES]];
    NSLog(@"播放开始播了，开始播了，开始播了，开始播了，开始播了，开始播了开始播了");
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
    NSLog(@"已经请求到点播件数据,并加入队列--GSVodManage");
    //[self resetCustomButton:_start flag:0];
}
//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
    NSArray *UnFinishedItems1 =  [[VodManage shareManage] searchNeedDownloadAndUnFinishedItems];
    NSLog(@"UnFinishedItems--%@--strDownloadID__%@",UnFinishedItems1,[(downItem *)UnFinishedItems1.firstObject strDownloadID]);
    
    NSLog(@"开始下载--GSVodManage--%@",item.strDownloadID);
    //按钮状态逻辑
    //    {
    //        _state.isPause = NO;
    //        [self resetCustomButton:_stopResume  flag:1];
    //        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
    //    }
    
}
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
    NSLog(@"下载进度");
    //    NSLog(@"percent ： %f",percent);
    //    NSLog(@"下载进度--GSVodManager--%@",item.name);
    //    {
    //        _state.isPause = NO;
    //        [self resetCustomButton:_stopResume  flag:1];
    //        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
    //    }
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        _progress.percent = percent/100;
    //    });
}

//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
    //        [self resetCustomButton:_stopResume  flag:1];
    //        [_stopResume setTitle:@"恢复下载" forState:UIControlStateNormal];
    //        _state.isPause = YES;
}

//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
    //按钮状态逻辑
    //        [self resetCustomButton:_start  flag:1];
    //        [_start setTitle:@"开始下载" forState:UIControlStateNormal];
    //        [self resetCustomButton:_stopResume  flag:0];
    //        [self resetCustomButton:_delete  flag:0];
    //        [self resetCustomButton:_play  flag:0];
    //        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
    //        _state.isStop = YES;
}

//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item
{
//    NSLog(@"GSVodManager--下载完成");
//    [NSThread sleepForTimeInterval:2.0f];//此时并没有把下载完成的对象放入[[VodManage shareManage] searchFinishedItems],延时操作
//    [[DXLiveBackDownLoadingManager sharedInstance] removeDownItem:item];//从正在下载数组中移除
}

//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
    //按钮状态逻辑
    //        [self resetCustomButton:_start  flag:1];
    //        [self resetCustomButton:_play  flag:0];
}

@end

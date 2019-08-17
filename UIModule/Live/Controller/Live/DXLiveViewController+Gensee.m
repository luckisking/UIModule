//
//  DXLiveViewController+Gensee.m
//  DXLiveSeparation
//
//  Created by doxue self.imac on 2019/8/7.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLiveViewController+Gensee.h"
#import <GSCommonKit/GSCommonKit.h>
#import "ChatMessageInfo.h"  //gensee 聊天模型

@implementation DXLiveViewController (Gensee)

- (void)initGenseeLive {
    [self addPlayView];
    [self initBroadCastManager];
}
- (void)addPlayView {
    //初始化文档视图（默认大的播放视图）
     self.docView = [[GSDocView alloc] initWithFrame: self.parentPlayLargerWindow.bounds];
     self.docView.backgroundColor = [UIColor blackColor];
     self.docView.gSDocShowType = GSDocEqualFullScreenType;
     self.docView.delegate = (DXLiveViewController<UIScrollViewDelegate>*)self;//代理方法
     [self.parentPlayLargerWindow addSubview: self.docView];
 
    
    //初始化视频视图（默认下方小的播放视图）
     self.videoView = [[GSVideoView alloc] initWithFrame: self.parentPlaySmallWindow.bounds];
     self.videoView.backgroundColor = [UIColor blackColor];
     self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFill;
     self.videoView.contentMode = UIViewContentModeScaleToFill;
    [ self.parentPlaySmallWindow addSubview: self.videoView];
}
/**
 初始化直播管理器。主控制器
 */
- (void)initBroadCastManager {
    
    GSConnectInfo *connectInfo = [[GSConnectInfo alloc] init];
    
    connectInfo.domain = @"doxue.gensee.com";
    connectInfo.serviceType = GSBroadcastServiceTypeTraining;
    
    //#warning 由于直播是固定时候的,测试就写了死值
    if (self.liveId == nil) {
        connectInfo.roomNumber = @"27798355";
    }
    else {
        connectInfo.roomNumber = self.liveId;
    }
    
    if (self.liveToken == nil) {
        connectInfo.watchPassword = @"783176";
    }
    else {
        connectInfo.watchPassword = self.liveToken;
    }
    
    connectInfo.nickName =  self.uname;
    connectInfo.oldVersion = YES;
    connectInfo.customUserID = 1000000000 +  self.uid;
    
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.documentView = self.docView;
    self.broadcastManager.videoView = self.videoView;
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.documentDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.audioDelegate = self;
    self.broadcastManager.chatDelegate = self;
    self.broadcastManager.investigationDelegate = self;
    
    [ self.broadcastManager connectBroadcastWithConnectInfo:connectInfo];
}
#pragma mark - GSBroadcastRoomDelegate
// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    switch (result) {
        case GSBroadcastConnectResultSuccess: {
            BOOL result = [self.broadcastManager join];
            NSLog(@"result: %@", @(result));
            if (result == NO) {
                
            }
            self.networkArray = [ self.broadcastManager getIDCArray];
            break;
        }
        case GSBroadcastConnectResultInitFailed:
                        [self showHint:@"初始化出错"];
            break;
        case GSBroadcastConnectResultJoinCastPasswordError:
                        [self showHint:@"口令错误"];
            break;
        case GSBroadcastConnectResultWebcastIDInvalid:
                        [self showHint:@"webcastID错误"];
            break;
        case GSBroadcastConnectResultRoleOrDomainError:
                        [self showHint:@"口令错误"];
            break;
        case GSBroadcastConnectResultLoginFailed:
                        [self showHint:@"登录信息错误"];
            break;
        case GSBroadcastConnectResultNetworkError:
                        [self showHint:@"网络错误"];

            break;
        case GSBroadcastConnectResultWebcastIDNotFound:
                        [self showHint:@"参数错误"];
            
            break;
        case  GSBroadcastConnectResultThirdTokenError:
                        [self showHint:@"第三方验证错误"];
            
            break;
        default:
                        [self showHint:@"未知错误"];
            
            break;
    }
    //    //用于断线重连
    if ( self.progressHUD != nil) {
        [ self.progressHUD hideAnimated:YES];
         self.progressHUD = nil;
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    [[GSBroadcastManager sharedBroadcastManager]activateSpeaker];
    [ self.progressHUD hideAnimated:YES];
    
    NSString * errorMsg = nil;
    
    switch (joinResult) {
            
            /**
             *  直播加入成功
             */
            
        case GSBroadcastJoinResultSuccess:
        {
            // 服务器重启导致重连的相应处理
            // 服务器重启的重连，直播中的各种状态将不再保留，如果想要实现重连后恢复之前的状态需要在本地记住，然后再重连成功后主动恢复。
            if (rebooted) {
            }
            //            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //            appDelegate.manager =   self.broadcastManager;
            
            break;
        }
            /**
             *  未知错误
             */
        case GSBroadcastJoinResultUnknownError:
            errorMsg = @"未知错误";
            break;
            /**
             *  直播已上锁
             */
        case GSBroadcastJoinResultLocked:
            errorMsg = @"直播已上锁";
            break;
            /**
             *  直播组织者已经存在
             */
        case GSBroadcastJoinResultHostExist:
            errorMsg = @"直播组织者已经存在";
            break;
            /**
             *  直播成员人数已满
             */
        case GSBroadcastJoinResultMembersFull:
            errorMsg = @"直播成员人数已满";
            break;
            /**
             *  音频编码不匹配
             */
        case GSBroadcastJoinResultAudioCodecUnmatch:
            errorMsg = @"音频编码不匹配";
            break;
            /**
             *  加入直播超时
             */
        case GSBroadcastJoinResultTimeout:
            errorMsg = @"加入直播超时";
            break;
            /**
             *  ip被ban
             */
        case GSBroadcastJoinResultIPBanned:
            errorMsg = @"ip地址被ban";
            
            break;
            /**
             *  组织者还没有入会，加入时机太早
             */
        case GSBroadcastJoinResultTooEarly:
            errorMsg = @"直播尚未开始";
            break;
            
        default:
            errorMsg = @"未知错误";
            break;
    }
    
    if (errorMsg) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
     self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
     self.progressHUD.label.text = NSLocalizedString(@"正在重连...", @"");
    [self.view addSubview: self.progressHUD];
    [ self.progressHUD showAnimated:YES];
}

- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason {
    DXLiveAppraiseViewController *liveAppraiseVC = [[DXLiveAppraiseViewController alloc] init];
    switch (leaveReason) {
        case GSBroadcastLeaveReasonEjected:
                        [self showHint:@"被踢出直播"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case GSBroadcastLeaveReasonTimeout:
                        [self showHint:@"超时"];
            break;
        case GSBroadcastLeaveReasonClosed:
                        [self showHint:@"直播关闭"];
            [ self.broadcastManager invalidate];
            [ self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
            if (isComment) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                liveAppraiseVC.liveAppraiseType = LiveAppraiseFinishType;
                liveAppraiseVC.uid =  self.uid;
                [self.navigationController pushViewController:liveAppraiseVC animated:YES];
            }
            break;
        case GSBroadcastLeaveReasonIPBanned:
                        [self showHint:@"位置错误"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",result]];
}


#pragma mark - GSBroadcastVideoDelegate

- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    //    loginfo(@"视频模块初始化 %@", result ? @"YES":@"NO");
    NSLog(@"视频模块初始化 %@",result?@"yes":@"no");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.broadcastManager activateSpeaker];
    });
}


// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    //    loginfo(@"收到一路用户视频. UserID: %lld, User Name: %@", userInfo.userID, userInfo.userName);
    NSLog(@"收到一路用户视频. UserID: %lld, User Name: %@",userInfo.userID, userInfo.userName);
    // 判断是否是插播，插播优先级比摄像头视频大
    if (userInfo.userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [ self.videoView.videoLayer removeFromSuperlayer];
         self.videoView.videoLayer = nil;
        
        [ self.broadcastManager displayVideo:LOD_USER_ID];
    }
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    //    loginfo(@"用户 UserID: %lld, User Name: %@ 被%@", userInfo.userID, userInfo.userName, active ? @"激活":@"关闭");
    NSLog(@"用户 UserID: %lld, User Name: %@ 被%@", userInfo.userID, userInfo.userName, active ? @"激活":@"关闭");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",active]];
    if (active)
    {
        [ self.broadcastManager displayVideo:userInfo.userID];
    }
    else
    {
        [ self.broadcastManager undisplayVideo:userInfo.userID];
    }
}

// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    // 指定Videoview渲染每一帧数据
    [ self.videoView hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat];
}

// 发布一项问卷调查
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigation:(GSInvestigation*)investigation
{
    NSLog(@"------%@,-------%@,-------%@",investigation.isResultPublished?@"YES":@"NO",investigation.hasTerminated?@"YES":@"NO",investigation.isPublished?@"YES":@"NO");
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    [self.liveNoteKeyboardView removeFromSuperview];
    [self.liveKeyboardView removeFromSuperview];
    
    self.liveEnteringInvestigationView = [[DXLiveEnteringInvestigationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.liveEnteringInvestigationView.backgroundColor = RGBAColor(0, 0, 0, 0.5);
    self.liveEnteringInvestigationView.userInteractionEnabled = NO;
    [self.view addSubview:self.liveEnteringInvestigationView];
   
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
        if (timeout == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveEnteringInvestigationView.timeLabel.text = @"0";
               
            });
           dispatch_source_cancel(timer);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveEnteringInvestigationView.timeLabel.text = [NSString stringWithFormat:@"%@",strTime];
            });
        }
        
        timeout--;
    });
    dispatch_resume(timer);
    
 
    __weak DXLiveViewController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.liveEnteringInvestigationView removeFromSuperview];
        [weakSelf.investigationView removeFromSuperview];
        [weakSelf.investigationResultsView removeFromSuperview];
        weakSelf.investigationView.investigation = nil;
           //初始化问卷调查
        weakSelf.investigationView = [[DXLiveInvestigationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        weakSelf.investigationView.backgroundColor = [UIColor whiteColor];
        weakSelf.investigationView.userInteractionEnabled = YES;
        
        weakSelf.investigationView.investigation = investigation;
        [weakSelf.investigationView.investigationTableView reloadData];
        weakSelf.investigationView.isResultPublished = investigation.isResultPublished;
        weakSelf.investigationView.titleLabel.text = investigation.theme;
        weakSelf.investigationView.broadcastManager = weakSelf.broadcastManager;
        [weakSelf.view addSubview:weakSelf.investigationView];
    });
    
    
}

// 发布一项问卷调查的结果
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigationResult:(GSInvestigation*)investigation
{
    NSLog(@"------%@,-------%@,-------%@",investigation.isResultPublished?@"YES":@"NO",investigation.hasTerminated?@"YES":@"NO",investigation.isPublished?@"YES":@"NO");
    [self.liveKeyboardView.KeyboardTextView resignFirstResponder];
    [self.liveNoteKeyboardView.noteTextView resignFirstResponder];
    [self.liveNoteKeyboardView removeFromSuperview];
    [self.liveKeyboardView removeFromSuperview];
    [self.investigationView removeFromSuperview];
    [self.investigationResultsView removeFromSuperview];
    self.investigationResultsView.investigation = nil;
    //初始化
    self.investigationResultsView = [[DXLiveInvestigationResultsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.investigationResultsView.backgroundColor = [UIColor whiteColor];
    self.investigationResultsView.userInteractionEnabled = YES;
    
    self.investigationResultsView.investigation = investigation;
    NSUInteger totalNumber = 0;
    NSMutableArray *totalUsersArray = [[NSMutableArray alloc] init]; //总答题人数
    NSMutableArray *totalArray = [[NSMutableArray alloc] init];      //总答题结果
    for (int i = 0; i < investigation.questions.count; i ++)
    {
        totalNumber = 0;
        GSInvestigationQuestion *que = investigation.questions[i];
        for (int j = 0; j < que.options.count; j++) {
            GSInvestigationOption *option = que.options[j];
            totalNumber += option.totalSumOfUsers;
            [totalUsersArray addObject:[NSString stringWithFormat:@"%ld",option.totalSumOfUsers]];
        }
        [totalArray addObject:[NSString stringWithFormat:@"%ld",totalNumber]];
    }
    [self.investigationResultsView.investigationTableView reloadData];
    self.investigationResultsView.titleLabel.text = investigation.theme;
    self.investigationResultsView.totalUsersArray =totalUsersArray;
    self.investigationResultsView.totalArray = totalArray;
    [self.view addSubview:self.investigationResultsView];
}


// 问卷调查截止
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didTerminateInvestigation:(GSInvestigation *)investigation
{
    [self.investigationView removeFromSuperview];
    [self.investigationResultsView removeFromSuperview];
}

#pragma mark - GSBroadcastChatDelegate

// 聊天模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveChatModuleInitResult:(BOOL)result
{
    //    loginfo(@"聊天模块初始化: %@", result?@"成功":@"失败");
    NSLog(@"聊天模块初始化: %@", result?@"成功":@"失败");
}

// 收到私人聊天代理, 只有自己能看到。
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePrivateMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user
{
    [self receiveChatMessage:msg from:user messageType:ChatMessageTypePrivate];
}

// 收到公共聊天代理，所有人都能看到
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePublicMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user
{
    [self receiveChatMessage:msg from:user messageType:ChatMessageTypePublic];
}

// 收到嘉宾聊天代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceivePanelistMessage:(GSChatMessage*)msg fromUser:(GSUserInfo*)user
{
    [self receiveChatMessage:msg from:user messageType:ChatMessageTypePanelist];
}

// 针对个人禁止或允许聊天/问答 状态改变代理，如果想设置整个房间禁止聊天，请用其他的代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSetChattingEnabled:(BOOL)enabled
{
    
}

- (void)receiveChatMessage:(GSChatMessage*)msg from:(GSUserInfo*)user messageType:(ChatMessageType)messageType
{
    ChatMessageInfo *messageInfo = [ChatMessageInfo new];
    
    if (messageType == ChatMessageTypeFromMe) {
        messageInfo.senderName = NSLocalizedString(@"Me", @"我");
        
        NSInteger _myUserID = 1000000000 + self.uid;
        messageInfo.senderID = _myUserID;
    }
    else if (messageType == ChatMessageTypeSystem)
    {
        messageInfo.senderName = NSLocalizedString(@"System", @"系统消息");
    }
    else
    {
        messageInfo.senderID = user.userID;
        messageInfo.senderName = user.userName;
    }
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSString *curTime = [formater stringFromDate:curDate];
    messageInfo.receiveTime = curTime;
    
    messageInfo.messageType = messageType;
    
    messageInfo.message = msg;
    
    if (user.role == 1) {
        //组织者
        [self.interfaceView.imageArray addObject:@"live_lecturer"];
    }
    else if (user.role == 2) {
        //讲师
        [self.interfaceView.imageArray addObject:@""];
    }
    else if (user.role == 4) {
        //嘉宾
        [self.interfaceView.imageArray addObject:@"live_assistant"];
    }
    else {
        //普通用户
        [self.interfaceView.imageArray addObject:@""];
    }
    
    [self.interfaceView.chatArray addObject:msg.richText];
    [self.interfaceView.nameArray addObject:user.userName];

    [self.interfaceView.chatTableView reloadData];
    [self.interfaceView setupDataScrollPositionBottom];
}

#pragma mark -- 发送消息

#pragma GCC diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)sendGenseeMessage:(NSString *)content
{
    NSLog(@"????嗯%@",content);
    [ self.broadcastManager setUser:1000000001 chatEnabled:NO];
    if (!content || [[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"EmptyChat", @"消息为空") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    GSChatMessage *message = [GSChatMessage new];
    message.text = [NSString stringWithFormat:@"<span>%@</span>", content];
    message.richText = content;//  [self chatString:content];
    
    // 发送公共消息
    if ([ self.broadcastManager sendMessageToPublic:message]) {
        GSUserInfo *gsUserInfo = [[GSUserInfo alloc] init];
        gsUserInfo.userName =  self.uname;
        gsUserInfo.userID = 1000000000 +  self.uid;
        [self receiveChatMessage:message from:gsUserInfo messageType:ChatMessageTypeFromMe];
    }else{
    }
}

@end

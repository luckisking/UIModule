//
//  DXLiveViewController+CC.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/13.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLiveViewController+CC.h"


@implementation DXLiveViewController (CC)


- (void)initCCLive  {
    dispatch_async(dispatch_get_main_queue(), ^{
         [self integrationSDK];
    });
}
/**
 集成sdk
 */
- (void)integrationSDK {

    PlayParameter *parameter = [[PlayParameter alloc] init];
    
    //测试专用
    parameter.userId = self.userId;//userId
    parameter.roomId = self.roomId;//roomId
    parameter.viewerName = self.viewerName?:self.uname;//用户名
    parameter.token = self.token;//密码
    parameter.playerParent = self.parentPlaySmallWindow;//视频小视图
    parameter.playerFrame = self.parentPlaySmallWindow.bounds;//视频位置,ps:起始位置为视频视图坐标
    parameter.docParent = self.parentPlayLargerWindow;//文档大窗
    parameter.docFrame = self.parentPlayLargerWindow.bounds;//文档位置,ps:起始位置为文档视图坐标
    parameter.security = YES;//是否开启https,建议开启
    parameter.PPTScalingMode = 1;//ppt展示模式,建议值为4
    parameter.scalingMode = 2;//屏幕适配方式
    parameter.pauseInBackGround = NO;//后台是否暂停
    parameter.viewerCustomua = @"viewercustomua";//自定义参数,没有的话这么写就可以
    parameter.pptInteractionEnabled = NO;//是否开启ppt滚动
    parameter.DocModeType = 0;//设置当前的文档模式
    //    parameter.DocShowType = 1;
    //    parameter.groupid = _contentView.groupId;//用户的groupId
    self.requestData = [[RequestData alloc] initWithParameter:parameter];
    self.requestData.delegate = self;
}

#pragma mark- SDK 必须实现的代理方法

/**
 *    @brief    请求成功
 */
-(void)requestSucceed {
     NSLog(@"请求成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",YES]];
}

/**
 *    @brief    登录请求失败
 */
-(void)requestFailed:(NSError *)error reason:(NSString *)reason {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",NO]];
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
     [self showHint:message];

}
#pragma mark- 直播未开始和开始
/**
 *    @brief  收到播放直播状态 0直播 1未直播
 */
- (void)getPlayStatue:(NSInteger)status {
    
    if (status==1) {
           [self showHint:@"直播未开始"];
    }
}

/**
 *    @brief  主讲开始推流
 */
- (void)onLiveStatusChangeStart {

      NSLog(@"主讲开始推流");
}
/**
 *    @brief  停止直播，endNormal表示是否停止推流
 */
- (void)onLiveStatusChangeEnd:(BOOL)endNormal {

     [self showHint:@"直播结束"];
}
#pragma mark - 服务器端给自己设置的信息
/**
 *    @brief    服务器端给自己设置的信息(The new method)
 *    viewerId 服务器端给自己设置的UserId
 *    groupId 分组id
 *    name 用户名
 */
-(void)setMyViewerInfo:(NSDictionary *) infoDic{
    self.viewerId = infoDic[@"viewerId"];
}
/**
 发送聊天
 -自己写的私有方法
 @param content 聊天内容
 */
- (void)sendCCMessage:(NSString *)content {
    //公聊
    [self.requestData chatMessage:content];
    // 发送私聊信息,目前不实现私聊功能
//    [self.requestData privateChatWithTouserid:@"" msg:content];
}
#pragma mark- 聊天
/**
 *    @brief    收到私聊信息
 */
- (void)OnPrivateChat:(NSDictionary *)dic {
      NSLog(@"cc收到私聊信息===%@",dic);
        [self.interfaceView.chatArray addObject:dic[@"msg"]?:@""];
        [self.interfaceView.nameArray addObject:[NSString stringWithFormat:@"%@:@私信你", dic[@"fromusername"]?:@""]];
        [self.interfaceView.imageArray addObject:@"lecturer_nor"];//讲师私信
        [self.interfaceView.chatTableView reloadData];
        [self.interfaceView setupDataScrollPositionBottom];

}
/**
 *    @brief  历史聊天数据
 */
- (void)onChatLog:(NSArray *)chatLogArr {
    NSLog(@"历史聊天信息=%@",chatLogArr);
    for (NSDictionary *dic in chatLogArr) {
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
    }
    [self.interfaceView.chatTableView reloadData];
    [self.interfaceView setupDataScrollPositionBottom];
}
/**
 *    @brief  收到公聊消息
 */
- (void)onPublicChatMessage:(NSDictionary *)dic {
      NSLog(@"cc收到公聊信息===%@",dic);
//    [_contentView onPublicChatMessage:dic];
    //聊天审核-------------如果消息状态码为1,不显示此消息,状态栏可能没有
//    lecturer_nor
    if (![dic[@"status"] isEqualToString:@"1"]){
        [self.interfaceView.chatArray addObject:dic[@"msg"]?:@""];
        [self.interfaceView.nameArray addObject:dic[@"username"]?:self.uname];
        if ([dic[@"userrole"] isEqualToString:@"publisher"]) {
             [self.interfaceView.imageArray addObject:@"lecturer_nor"];
        }else {
             [self.interfaceView.imageArray addObject:dic[@"useravatar"]?:@""];
        }
        [self.interfaceView.chatTableView reloadData];
        [self.interfaceView setupDataScrollPositionBottom];
    }
}
/**
 *  @brief  接收到发送的广播
 */
- (void)broadcast_msg:(NSDictionary *)dic {
       NSLog(@"cc收到广播信息===%@",dic);
    if ([dic[@"value"] isKindOfClass:[NSDictionary class]]) {
        [self.interfaceView.chatArray addObject:dic[@"value"][@"content"]?:@"欢迎大家"];
        [self.interfaceView.nameArray addObject:@"系统消息："];
        [self.interfaceView.imageArray addObject:@""];
        [self.interfaceView.chatTableView reloadData];
        [self.interfaceView setupDataScrollPositionBottom];
    }
}
/*
 *  @brief  收到自己的禁言消息，如果你被禁言了，你发出的消息只有你自己能看到，其他人看不到
 */
- (void)onSilenceUserChatMessage:(NSDictionary *)message {
    [self showHint:@"你被禁言了"];
}

/**
 *    @brief    当主讲全体禁言时，你再发消息，会出发此代理方法，information是禁言提示信息
 */
- (void)information:(NSString *)information {
    //添加提示窗
     [self showHint:@"全体禁言"];
}
/**
 *    @brief  收到踢出消息，停止推流并退出播放（被主播踢出）(change)
 kick_out_type
 10 在允许重复登录前提下，后进入者会登录会踢出先前登录者
 20 讲师、助教、主持人通过页面踢出按钮踢出用户
 */
- (void)onKickOut:(NSDictionary *)dictionary{
     NSLog(@"cc收到收到踢出消息===%@",dictionary);
    if ([self.viewerId isEqualToString:dictionary[@"viewerid"]]) {
        [self showHint:@"你被踢出直播"];
        if (isComment) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            DXLiveAppraiseViewController *liveAppraiseVC = [[DXLiveAppraiseViewController alloc] init];
            liveAppraiseVC.liveAppraiseType = LiveAppraiseFinishType;
            liveAppraiseVC.uid =  self.uid;
            [self.navigationController pushViewController:liveAppraiseVC animated:YES];
        }
    }
}
#pragma mark- 聊天禁言
/**
 *    @brief    收到聊天禁言(The new method)
 *    mode 禁言类型 1：个人禁言  2：全员禁言
 */
-(void)onBanChat:(NSDictionary *) modeDic{
    NSInteger mode = [modeDic[@"mode"] integerValue];
    if (mode==1) {
        [self showHint:@"你被禁言"];
    }else{
        [self showHint:@"全体禁言"];
    }
}
/**
 *    @brief    收到解除禁言事件(The new method)
 *    mode 禁言类型 1：个人禁言  2：全员禁言
 */
-(void)onUnBanChat:(NSDictionary *) modeDic{
    NSInteger mode = [modeDic[@"mode"] integerValue];
    if (mode==1) {
        [self showHint:@"你被解除禁言"];
    }else{
        [self showHint:@"全体禁言解除"];
    }
}


#pragma mark- 视频线路和清晰度------------------------
/*
 *  @brief 切换源，firRoadNum表示一共有几个源，secRoadKeyArray表示每
 *  个源的描述数组
 */
- (void)firRoad:(NSInteger)firRoadNum secRoadKeyArray:(NSArray *)secRoadKeyArray {
    self.secRoadKeyArray = [secRoadKeyArray mutableCopy];
    self.firRoadNum = firRoadNum;
}
/**
 切换线路-- （ 该方法非sdk代理 为我们自己的overlayerView的代理方法 点击线路）
 @param rodIndex 线路
 */
- (void)selectedRodWidthIndex:(NSInteger)rodIndex {
    if(rodIndex > self.firRoadNum) {
        [self.requestData switchToPlayUrlWithFirIndex:0 key:@""];//仅仅音频
    } else {
        //线路从1开始计数
        [self.requestData switchToPlayUrlWithFirIndex:rodIndex-1 key:[self.secRoadKeyArray firstObject]];
    }
}
/**
 切换清晰度 -- （该方法非sdk代理 是我们自己的overlayerView的代理方法 点击清晰度按钮）
 
 @param rodIndex 线路
 @param secIndex 清晰度
 */
- (void)selectedRodWidthIndex:(NSInteger)rodIndex secIndex:(NSInteger)secIndex {
     //线路从1开始计数
    [self.requestData switchToPlayUrlWithFirIndex:rodIndex-1 key:[self.secRoadKeyArray objectAtIndex:secIndex]];
}




#pragma mark - 签到-------------------------
/**
 *  @brief  开始签到
 */
- (void)start_rollcall:(NSInteger)duration{
    [self.view endEditing:YES];
    WS(ws)
     RollcallView *rollcallView  = [[RollcallView alloc] initWithDuration:duration lotteryblock:^{
        [ws.requestData answer_rollcall];//签到
    } isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait];
    //添加签到视图
    [[UIApplication sharedApplication].delegate.window addSubview:rollcallView];
    [self.rollcallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:rollcallView];
}

#pragma mark - 答题卡-------------------------
#pragma mark - 移除答题卡视图
-(void)removeVoteView{
    [self.voteView removeFromSuperview];
    self.voteView = nil;
    [self.voteViewResult removeFromSuperview];
    self.voteViewResult = nil;
    [self.view endEditing:YES];
}
/**
 *  @brief  开始答题
 */
- (void)start_vote:(NSInteger)count singleSelection:(BOOL)single{
    [self removeVoteView];
    self.mySelectIndex = -1;
    [self.mySelectIndexArray removeAllObjects];
    WS(ws)
    VoteView *voteView = [[VoteView alloc] initWithCount:count singleSelection:single voteSingleBlock:^(NSInteger index) {
        //答单选题
        [ws.requestData reply_vote_single:index];
        ws.mySelectIndex = index;
    } voteMultipleBlock:^(NSMutableArray *indexArray) {
        //答多选题
        [ws.requestData reply_vote_multiple:indexArray];
        ws.mySelectIndexArray = [indexArray mutableCopy];
    } singleNOSubmit:^(NSInteger index) {
        //        ws.mySelectIndex = index;
    } multipleNOSubmit:^(NSMutableArray *indexArray) {
        //        ws.mySelectIndexArray = [indexArray mutableCopy];
    } isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait];
    //避免强引用 weak指针指向局部变量
    self.voteView = voteView;
    
    //添加voteView
    [[UIApplication sharedApplication].delegate.window addSubview:self.voteView];
    [self.voteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
/**
 *  @brief  结束答题
 */
- (void)stop_vote{
    [self removeVoteView];
}
/**
 *  @brief  答题结果
 */
- (void)vote_result:(NSDictionary *)resultDic{
    [self removeVoteView];
    VoteViewResult *voteViewResult = [[VoteViewResult alloc] initWithResultDic:resultDic mySelectIndex:self.mySelectIndex mySelectIndexArray:self.mySelectIndexArray isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait];
    self.voteViewResult = voteViewResult;
    //添加答题结果
    [[UIApplication sharedApplication].delegate.window addSubview:self.voteViewResult];
    [self.voteViewResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.voteViewResult addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeVoteView)]];
}





#pragma mark - 问卷及问卷统计------------------------
//移除问卷视图
-(void)removeQuestionnaireSurvey {
    [self.questionnaireSurvey removeFromSuperview];
    self.questionnaireSurvey = nil;
    [self.questionnaireSurveyPopUp removeFromSuperview];
    self.questionnaireSurveyPopUp = nil;
}
/**
 *  @brief  问卷功能
 */
- (void)questionnaireWithTitle:(NSString *)title url:(NSString *)url {
    //初始化第三方问卷视图
    [self.questionNaire removeFromSuperview];
    self.questionNaire = nil;
    [self.view endEditing:YES];
    self.questionNaire = [[QuestionNaire alloc] initWithTitle:title url:url isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait];
    //添加第三方问卷视图
//    [self addAlerView:self.questionNaire];
    [[UIApplication sharedApplication].delegate.window addSubview:self.questionNaire];
    [self.questionNaire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
/**
 *  @brief  提交问卷结果（成功，失败）
 */
- (void)commitQuestionnaireResult:(BOOL)success {
    WS(ws)
    [self.questionnaireSurvey commitSuccess:success];
    if(success &&self.submitedAction != 1) {
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:ws selector:@selector(removeQuestionnaireSurvey) userInfo:nil repeats:NO];
    }
}
/**
 *  @brief  发布问卷
 */
- (void)questionnaire_publish {
    [self removeQuestionnaireSurvey];
}
/**
 *  @brief  获取问卷详细内容
 */
- (void)questionnaireDetailInformation:(NSDictionary *)detailDic {
    [self.view endEditing:YES];
    self.submitedAction     = [detailDic[@"submitedAction"] integerValue];
    //初始化问卷详情页面
    self.questionnaireSurvey = [[QuestionnaireSurvey alloc] initWithCloseBlock:^{
        [self removeQuestionnaireSurvey];
    } CommitBlock:^(NSDictionary *dic) {
        //提交问卷结果
        [self.requestData commitQuestionnaire:dic];
    } questionnaireDic:detailDic isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait isStastic:NO];
    //添加问卷详情
    [[UIApplication sharedApplication].delegate.window addSubview:self.questionnaireSurvey];
    [self.questionnaireSurvey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
/**
 *  @brief  结束发布问卷
 */
- (void)questionnaire_publish_stop{
    WS(ws)
    [self.questionnaireSurveyPopUp removeFromSuperview];
    self.questionnaireSurveyPopUp = nil;
    if(self.questionnaireSurvey == nil) return;//如果已经结束发布问卷，不需要加载弹窗
    //结束编辑状态
    [self.view endEditing:YES];
    [self.questionnaireSurvey endEditing:YES];
    //初始化结束问卷弹窗
    self.questionnaireSurveyPopUp = [[QuestionnaireSurveyPopUp alloc] initIsScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait SureBtnBlock:^{
        [ws removeQuestionnaireSurvey];
    }];
    //添加问卷弹窗
    [[UIApplication sharedApplication].delegate.window addSubview:self.questionnaireSurveyPopUp];
    [self.questionnaireSurveyPopUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
/**
 *  @brief  获取问卷统计
 */
- (void)questionnaireStaticsInformation:(NSDictionary *)staticsDic {
    [self.view endEditing:YES];
    if (self.questionnaireSurvey != nil) {
        [self.questionnaireSurvey removeFromSuperview];
        self.questionnaireSurvey = nil;
    }
    //初始化问卷统计视图
    self.questionnaireSurvey = [[QuestionnaireSurvey alloc] initWithCloseBlock:^{
        [self removeQuestionnaireSurvey];
    } CommitBlock:nil questionnaireDic:staticsDic isScreenLandScape:[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait isStastic:YES];
    //添加问卷统计视图
    [[UIApplication sharedApplication].delegate.window addSubview:self.questionnaireSurvey];
    [self.questionnaireSurvey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.questionnaireSurvey addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeQuestionnaireSurvey)]];
}


@end

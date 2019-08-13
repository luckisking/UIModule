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
    parameter.userId = @"F554B5014CE0DFD3";//userId
    parameter.roomId = @"1BB459E07F6A57299C33DC5901307461";//roomId
    parameter.viewerName =@"ff";//用户名
//    parameter.token = @"";//密码
    
    parameter.playerParent = self.parentPlaySmallWindow;//视频小视图
    parameter.playerFrame = self.parentPlaySmallWindow.bounds;//视频位置,ps:起始位置为视频视图坐标
    parameter.docParent = self.parentPlayLargerWindow;//文档大窗
    parameter.docFrame = self.parentPlayLargerWindow.bounds;//文档位置,ps:起始位置为文档视图坐标
    parameter.security = YES;//是否开启https,建议开启
    parameter.PPTScalingMode = 4;//ppt展示模式,建议值为4
    parameter.defaultColor = [UIColor whiteColor];//ppt默认底色，不写默认为白色
    parameter.scalingMode = 1;//屏幕适配方式
    parameter.pauseInBackGround = NO;//后台是否暂停
    parameter.viewerCustomua = @"viewercustomua";//自定义参数,没有的话这么写就可以
    parameter.pptInteractionEnabled = YES;//是否开启ppt滚动
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
    //        NSLog(@"请求成功！");
//    [self stopTimer];
//    CCProxy *weakObject = [CCProxy proxyWithWeakObject:self];
//    _userCountTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:weakObject selector:@selector(timerfunc) userInfo:nil repeats:YES];
//    if (!_testView) {//如果已经存在随堂测视图，避免断网重连
//        [_requestData getPracticeInfo:@""];
//    }
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
    // 添加提示窗,提示message
//    [self addBanAlertView:message];
}
#pragma mark- 直播未开始和开始
/**
 *    @brief  收到播放直播状态 0直播 1未直播
 */
- (void)getPlayStatue:(NSInteger)status {
//    [_playerView getPlayStatue:status];
//    if (status == 0 && self.firstUnStart) {
//        NSDate *date = [NSDate date];// 获得时间对象
//        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
//        [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *dateStr = [forMatter stringFromDate:date];
//        SaveToUserDefaults(LIVE_STARTTIME, dateStr);
//    }
    NSLog(@"直播状态==%ld",status);
}

/**
 *    @brief  主讲开始推流
 */
- (void)onLiveStatusChangeStart {
//    [_playerView onLiveStatusChangeStart];
      NSLog(@"主讲开始推流");
}
/**
 *    @brief  停止直播，endNormal表示是否停止推流
 */
- (void)onLiveStatusChangeEnd:(BOOL)endNormal {
//    [_playerView onLiveStatusChangeEnd:endNormal];
     NSLog(@"直播停止");
}
@end

//
//  DXLivePlayBackViewController+CC.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLivePlayBackViewController+CC.h"
#import "CCDownloadSessionManager.h"

@implementation DXLivePlayBackViewController (CC)

- (void)initCCPlayBack  {
    
    /*cc*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self integrationSDK];
        //监听 回放状态变化和播放状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:)
                                                     name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieLoadStateDidChange:)
                                                     name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        //播放结束
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerFinish:)
                                                     name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    });
    
    /*cc回放的下载，需要后台返回一个下载地址.ccr，下载模式和普通的下载没有区别，需要自己实现下载的所有操作，下载播放需要使用OfflinePlayBack类*/
}
//集成SDK
- (void)integrationSDK {

    PlayParameter *parameter = [[PlayParameter alloc] init];
    parameter.userId = self.userId;//userId
    parameter.roomId = self.roomId;//roomId
    parameter.liveId = self.liveId;//liveId
    parameter.recordId = self.recordId;//回放Id
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
    
    if (self.ccDownloadedPlayfile) {
        self.CCPlayDownload = YES;//播放下载视频
        parameter.destination = self.ccDownloadedPlayfile;//文件地址 为下载好的沙河里面的文件路径
    }
    //cc在线播放和离线播放 分开成了两个独立管理的类。。。。。。。。
    if (self.CCPlayDownload) {
        [self initOfflinePlay:parameter]; //未实现
    }else {
        [self initOnlinePlay:parameter];
    }
    [self.interfaceView addloadViewWithSuperView:self.overlayView text:@"加载中..." userEnabled:YES];
    
}
//在线播放
- (void)initOnlinePlay:(PlayParameter *)parameter {
    self.requestDataPlayBack = [[RequestDataPlayBack alloc] initWithParameter:parameter];
    self.requestDataPlayBack.delegate = self;
}
//下载播放
- (void)initOfflinePlay:(PlayParameter *)parameter {
    self.offlinePlayBack = [[OfflinePlayBack alloc] initWithParameter:parameter];
    self.offlinePlayBack.delegate = self;
    [self.offlinePlayBack startPlayAndDecompress];
}

//下载点击事件
- (void)CCDownload  {
    if (self.ccDownloadedPlayfile) {
        [self showHint:@"你已经下载该视频"];
        return;
    }
    if (!self.ccDownloadedUrl) {
        [self showHint:@"下载失败，稍后重试"];
    }else {
        NSString * url = [self.ccDownloadedUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        if ([[CCDownloadSessionManager manager] checkLocalResourceWithUrl:url]) {//是否已经创建
            
            CCDownloadModel * model = [[CCDownloadSessionManager manager]downLoadingModelForURLString:url];
            if (model.state == CCPBDownloadStateRunning || model.state == CCPBDownloadStateCompleted) {
                [self showHint:@"你已经下载该视频"];
                return ;//跳过
            }
            [[CCDownloadSessionManager manager] resumeWithDownloadModel:model];
            
        } else {//创建下载链接
            NSArray *array = [url componentsSeparatedByString:@"/"];
            NSString * fileName = array.lastObject;
            fileName = [fileName substringToIndex:(fileName.length - 4)];
            CCDownloadModel *downloadModel = [CCDownloadSessionManager createDownloadModelWithUrl:url FileName:fileName MimeType:@"ccr" AndOthersInfo:@{}];
            downloadModel.primaryTitle = self.videoTitle;
            downloadModel.secondaryTitle = self.SecondTitle;
            downloadModel.sort = self.numberSecondTitle;
            downloadModel.coverImageUrl = self.imgUrl;
            downloadModel.courseID = [NSString stringWithFormat:@"%ld",(long)self.courseID];
            downloadModel.fileUrl = self.teach_material_file;
            [[CCDownloadSessionManager manager] startWithDownloadModel:downloadModel];
        }
    }
 
}










//监听回放改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    switch (self.requestDataPlayBack?self.requestDataPlayBack.ijkPlayer.playbackState:self.offlinePlayBack.ijkPlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            break;
        }
        case IJKMPMoviePlaybackStatePlaying:
            
            NSLog(@"cc回放正在播放。。。。。。。。。。。。。。。。。。。。。。。");
            [self.interfaceView removeloadView];
            [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
        case IJKMPMoviePlaybackStatePaused: {
             NSLog(@"cc回放暂停了。。。。。。。。。。。。。。。。。。。。。。。");
        }
             break;
        case IJKMPMoviePlaybackStateInterrupted: {
               NSLog(@"cc回放被打断了。。。。。。。。。。。。。。。。。。。。。。。");
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"cc回放前进。。。。。。。。。。。。。。。。。。。。。。。");
            [self.interfaceView removeloadView];
            [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
               break;
        case IJKMPMoviePlaybackStateSeekingBackward: {
             NSLog(@"cc回放后退。。。。。。。。。。。。。。。。。。。。。。。");
            [self.interfaceView removeloadView];
            [self.parentPlayLargerWindow bringSubviewToFront:self.overlayView];
            break;
        }
        default: {
            break;
        }
    }
}

//监听播放状态
-(void)movieLoadStateDidChange:(NSNotification*)notification
{
        switch (self.requestDataPlayBack.ijkPlayer.loadState)
        {
            case IJKMPMovieLoadStateStalled:   NSLog(@"cc加载自动暂停(正在加载)。。。。。。。。。。。。。。。。。。。。。。。");
                break;
            case IJKMPMovieLoadStatePlayable:   NSLog(@"cc加载可以播放。。。。。。。。。。。。。。。。。。。。。。。");
                break;
            case IJKMPMovieLoadStatePlaythroughOK:   NSLog(@"cc加载可以自动播放。。。。。。。。。。。。。。。。。。。。。。。");
                break;
            default:
                break;
        }
}
//监听播放结束
- (void)moviePlayerFinish:(NSNotification*)notification {
    self.isplayFinish = YES;//播放结束
    self.overlayView.playbackButton.selected = NO;//设置为未播放状态
}
#pragma mark- 必须实现的代理方法RequestDataPlayBackDelegate

/**
 *    @brief    请求成功
 */
-(void)requestSucceed {
    //    NSLog(@"请求成功！");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",YES]];
}

/**
 *    @brief    登录请求失败
 */
-(void)requestFailed:(NSError *)error reason:(NSString *)reason {
    NSString *message = nil;
    if (reason == nil) {
        message = [error localizedDescription];
    } else {
        message = reason;
    }
    [self showHint:message];
    [self.interfaceView removeloadView];
}
#pragma mark-----------------------功能代理方法 用哪个实现哪个-------------------------------
#pragma mark - 服务端给自己设置的信息
/**
 *    @brief    服务器端给自己设置的信息(The new method)
 *    groupId 分组id
 *    name 用户名
 */
-(void)setMyViewerInfo:(NSDictionary *) infoDic{
  self.viewerId = infoDic[@"viewerId"];
}
#pragma mark- 回放的开始时间和结束时间
/**
 *  @brief 回放的开始时间和结束时间
 */
-(void)liveInfo:(NSDictionary *)dic {
    //    NSLog(@"%@",dic);
//    SaveToUserDefaults(LIVE_STARTTIME, dic[@"startTime"]);
}
#pragma mark- 聊天
/**
 *    @brief    解析本房间的历史聊天数据
 */
-(void)onParserChat:(NSArray *)chatArr {
    if ([chatArr count] == 0) {
        return;
    }
    //解析历史聊天
//    NSLog(@"cc历史聊天数组==%@",chatArr);
    self.chatArr = chatArr;
}


#pragma mark - OfflinePlayBackDelegate 代理方法---------------------
#pragma mark- 房间信息
/**
 *    @brief  房间信息
 */
-(void)offline_roomInfo:(NSDictionary *)dic{
//    _roomName = dic[@"name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"liveDocVideoStatus" object:[NSString stringWithFormat:@"%d",YES]];
    
}
#pragma mark- 聊天
/**
 *    @brief    解析本房间的历史聊天数据
 */
-(void)offline_onParserChat:(NSArray *)arr {
    if ([arr count] == 0) {
        return;
    }
    //解析历史聊天
    self.chatArr = arr;
}
- (void)offline_loadVideoFail {
    NSLog(@"播放器异常，加载失败");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频错误,请重新下载" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

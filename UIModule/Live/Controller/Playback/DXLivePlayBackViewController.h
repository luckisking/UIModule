//
//  DXLivePlayBackViewController.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/3.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXLiveAppraiseViewController.h"    //评价
#import "DXLiveInteractionView.h"           //用户交流视图（非播放视图部分）
#import "DXPlayBackOverLayerView.h"         //大的播放视频操作层
//gensee 回放
#import <VodSDK/VodSDK.h>
//cc回放
#import "CCSDK/RequestDataPlayBack.h"//sdk
#import "CCSDK/OfflinePlayBack.h"//离线下载


@protocol DXLivePlayBackViewControllerDelegate <NSObject>
@optional
- (void)initGenseePlayBack ;
@optional
- (void)initCCPlayBack ;
@end


/**
 直播回放控制器
 */
@interface DXLivePlayBackViewController : UIViewController

// 点播的编号
@property (nonatomic, copy) NSString *number;
// 学生观看密码vodPassword
@property (nonatomic, copy) NSString *live_student_client_token;
// 房间号live_room_id,vodid
@property (nonatomic, copy) NSString *live_room_id;

// 课程详情界面传过来的分享的标题
@property (nonatomic, copy) NSString *videoTitle;

// 课程详情界面传过来的课程的Id
@property (nonatomic, assign) NSInteger courseID;

// 课程详情界面传过来的分享的链接
@property (nonatomic, copy) NSString *imgUrl;

// 课程详情界面传过来的分享的直播课时间
@property (nonatomic, assign) double broadcastTime;

// 章节列表里传过来的资料文件
@property (nonatomic, copy) NSString *teach_material_file;

// 本节标题带序号
@property (nonatomic, copy) NSString *numberSecondTitle;
// 本节标题无序号
@property (nonatomic, copy) NSString *SecondTitle;



/* 跳转本页面CCSDK回放需要传递的参数 + 用户信息*/
@property (nonatomic, copy) NSString *userId;// cc用户Id（平台标识id）,必须
@property (nonatomic, copy) NSString *roomId;// cc直播房间Id ，必须
@property (nonatomic, copy) NSString *liveId;// cc直播id,必须
@property (nonatomic, copy) NSString *recordId;// cc回放Id ，必须
@property (nonatomic, copy) NSString *viewerName;// cc直播访问者名字
@property (nonatomic, copy) NSString *token;// cc直播房间Token（都为空)

//用户信息--> 由于项目分离（主项目没有独立出pod来，无法使用主项目中的类），需要用户信息（对应主项目中的DXUser类中的属性）
@property (nonatomic, assign) BOOL  liveType;   //CC直播还是展视直播（gensee==no）
@property (nonatomic, assign) long long  uid;
@property (nonatomic, copy) NSString * uname;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * phone;



/* 通用的属性*/
@property (nonatomic, strong) UIView *parentPlayLargerWindow;                    // 直播大的播放父视图
@property (nonatomic, strong) UIView *parentPlaySmallWindow;                     // 直播小的播放父视图
@property (strong, nonatomic) DXLiveInteractionView *interfaceView;              //交流界面
@property (strong, nonatomic) DXPlayBackOverLayerView *overlayView;                  //播放操作视图


/*gensee回放*/
#pragma mark
@property (nonatomic, assign) CGFloat duration; //视频总的时长
@property (nonatomic, strong) downItem *item;
@property (nonatomic, strong) VodDownLoader *vodDownLoader;           // 管理点播件（录制件）下载的类
@property (nonatomic, strong) VodPlayer *vodplayer;                   // 管理播放点播件（录制件）的类
@property (nonatomic, strong) GSVodManager *manager; //下载
@property (nonatomic, strong) VodParam *vodParam;   //参数配置

/*CC回放*/
@property (nonatomic,strong)RequestDataPlayBack         * requestDataPlayBack;//sdk
@property (nonatomic,copy)  NSString                 * viewerId;//观看者的id (离线播放没有该字段)
@property (nonatomic,strong)OfflinePlayBack          * offlinePlayBack; //播放下载视频
@property (nonatomic,assign)BOOL             playDownload; //是否播放下载视频
//提示消息
- (void)showHint:(NSString *)hint ;
@end

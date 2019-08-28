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
- (void)genseeDownload ;
@optional
- (void)initCCPlayBack ;
- (void)CCDownload ;
@end


/**
 直播回放控制器
 */
@interface DXLivePlayBackViewController : UIViewController

/* 跳转本页面GenseeSDK回放需要传递的参数 + 用户信息*/
@property (nonatomic, copy) NSString *number; // 点播的编号
@property (nonatomic, copy) NSString *live_student_client_token;// 学生观看密码vodPassword
@property (nonatomic, copy) NSString *live_room_id; // 房间号live_room_id,vodid

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

//+课程相关
@property (nonatomic, copy) NSString *videoTitle; // 课程详情界面传过来的分享的标题
@property (nonatomic, assign) NSInteger courseID; // 课程详情界面传过来的课程的Id
@property (nonatomic, copy) NSString *imgUrl; // 课程详情界面传过来的分享的链接
@property (nonatomic, assign) double broadcastTime; // 课程详情界面传过来的分享的直播课时间
@property (nonatomic, copy) NSString *teach_material_file; // 章节列表里传过来的资料文件
@property (nonatomic, copy) NSString *numberSecondTitle; // 本节标题带序号
@property (nonatomic, copy) NSString *SecondTitle; // 本节标题无序号

/*以上是需要传递的参数*/



















/*y以下所有属性主要是需要分享给分类使用，都是扩展里面的私有属性*/
/* 通用的属性*/
@property (nonatomic, strong) UIView *parentPlayLargerWindow;                    // 直播大的播放父视图
@property (nonatomic, strong) UIView *parentPlaySmallWindow;                     // 直播小的播放父视图
@property (strong, nonatomic) DXLiveInteractionView *interfaceView;              //交流界面
@property (strong, nonatomic) DXPlayBackOverLayerView *overlayView;              //播放操作视图
@property (assign, nonatomic) BOOL isplayFinish;                  //播放结束


/*gensee回放*/
#pragma mark
@property (nonatomic, strong) downItem *item;
//@property (nonatomic, strong) VodDownLoader *vodDownLoader;           // 管理点播件（录制件）下载的类
@property (nonatomic, strong) VodPlayer *vodplayer;                   // 管理播放点播件（录制件）的类
@property (nonatomic, strong) GSVodManager *manager; //下载
@property (nonatomic, strong) VodParam *vodParam;   //参数配置
@property (nonatomic,assign)BOOL       genseePlayDownload; //是否播放Gensee下载视频(好几个地方需要用到，不得不写成属性)

/*CC回放*/
@property (nonatomic,strong)RequestDataPlayBack      * requestDataPlayBack;//sdk 在线播放
@property (nonatomic,copy)  NSString                 * viewerId;//观看者的id (离线播放没有该字段)
@property (nonatomic,strong)OfflinePlayBack          * offlinePlayBack; // sdk 播放下载视频
@property (nonatomic,strong)NSString                 *ccDownloadedPlayfile; //播放下载视频文件
@property (nonatomic,strong)NSString                 *ccDownloadedUrl; //下载地址
@property (nonatomic,assign)BOOL                    CCPlayDownload; //是否播放CC下载视频(好几个地方需要用到，不得不写成属性)
@property (nonatomic,strong)NSArray                 *chatArr; //cc历史聊天信息

//提示消息
- (void)showHint:(NSString *)hint ;
- (void)setUserInfoWihtUid:(long long)uid uname:(NSString *)uname email:(NSString *)email phone:(NSString *)phone ;
@end

//
//  DXLiveViewController.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/1/23.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXLiveAppraiseViewController.h"    //评价
#import "DXLiveKeyboardView.h"      //聊天键盘
#import "DXLiveNoteKeyboardView.h" //笔记键盘
#import "DXLiveInteractionView.h" //用户交流视图（非播放视图部分）

//gensee问卷相关
#import "DXLiveEnteringInvestigationView.h"
#import "DXLiveInvestigationView.h"
#import "DXLiveInvestigationResultsView.h"

//CC相关
#import "CCSDK/RequestData.h"//SDK

@protocol DXLiveViewControllerDelegate <NSObject>
@optional
- (void)initGenseeLive ;
@optional
- (void)initCCLive ;

@end

/**
 课程的直播界面（项目采用展视直播和cc直播使用同一个页面），
 为实现界面和逻辑分离，cc与展视的分离要求，便于维护，本类将使用分类进行扩张，用于分化cc和展视的逻辑部分
 本主Controller将负责展视共有的界面和逻辑
 */
@interface DXLiveViewController : UIViewController
{
    BOOL isSegment;             // 是否是聊天或者笔记  YES是聊天  NO是笔记
    BOOL isComment;             // 是否评价完成
}

/* 跳转本页面geense需要传递的参数  + 用户信息*/
@property (nonatomic, copy) NSString *liveId;// 课程详情界面传过来的直播房间Id
@property (nonatomic, copy) NSString *liveToken;// 课程详情界面传过来的直播房间Token
@property (nonatomic, copy) NSString *videoTitle;// 课程详情界面传过来的分享的标题
@property (nonatomic, assign) NSInteger courseID;// 课程详情界面传过来的课程的Id
@property (nonatomic, assign) NSInteger sectionID;// 课程详情界面传过来的课程的节Id
@property (nonatomic, copy) NSString *imgUrl;// 课程详情界面传过来的分享的链接
@property (nonatomic, assign) double broadcastTime;// 课程详情界面传过来的分享的直播课时间
@property (nonatomic, copy) NSString *teach_material_file;// 章节列表里传过来的资料文件

/* 跳转本页面CCSDK直播需要传递的参数 + 用户信息*/

//由于项目分离（主项目没有独立出pod来，无法使用主项目中的类），需要用户信息（对应主项目中的DXUser类中的属性）
@property (nonatomic, assign) BOOL  liveType;   //CC直播还是展视直播（gensee==no）
@property (nonatomic, assign) long long  uid;
@property (nonatomic, copy) NSString * uname;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * phone;



















/*y以下所有属性主要是需要分享给分类使用，都是扩展里面的私有属性*/


/* 通用的属性*/
@property (nonatomic, strong) UIView *parentPlayLargerWindow;                    // 直播大的播放父视图
@property (nonatomic, strong) UIView *parentPlaySmallWindow;                     // 直播小的播放父视图
@property (nonatomic, strong) MBProgressHUD *progressHUD;                // HUD
@property (nonatomic, strong) DXLiveKeyboardView *liveKeyboardView;      // 弹出聊天键盘时显示的View
@property (nonatomic, strong) DXLiveNoteKeyboardView *liveNoteKeyboardView; // 弹出笔记键盘时显示的View
@property (strong, nonatomic) DXLiveInteractionView *interfaceView;              //交流界面


/* gensee展视直播相关的属性*/
@property (nonatomic, strong) GSBroadcastManager *broadcastManager;      // 直播属性
@property (nonatomic, strong) GSDocView *docView;                        // 直播文档视图
@property (nonatomic, strong) GSVideoView *videoView;                    // 直播视频视图
@property (nonatomic, strong) GSInvestigation *investigation;            // 答题卡
@property (nonatomic, strong) NSArray *networkArray;                     // 存放网络的数组
@property (nonatomic, strong) DXLiveEnteringInvestigationView *liveEnteringInvestigationView; // 有答题卡时进入答题卡的View
@property (nonatomic, strong) DXLiveInvestigationView *investigationView;// 答题视图
@property (nonatomic, strong) DXLiveInvestigationResultsView *investigationResultsView; // 答题结果视图
@property (nonatomic, strong) NSMutableArray *totalArray;               // 存放答题结果数组
@property (nonatomic, strong) NSMutableArray *totalUsersArray;          // 存放总答题人数数组



/* CC直播相关的属性*/
@property (nonatomic,strong)RequestData              * requestData;//sdk

/*Gensee的相关方法*/
- (void)sendMessage:(NSString *)content ;
/*CC的相关方法*/



//提示消息
- (void)showHint:(NSString *)hint ;
@end

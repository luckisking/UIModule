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
#import "DXLiveNetworkView.h"           //选择网络界面（只有gensee 有这个视图）
#import "DXLiveEnteringInvestigationView.h"
#import "DXLiveInvestigationView.h"
#import "DXLiveInvestigationResultsView.h"

//CC相关
#import "CCSDK/RequestData.h"//SDK
#import "RollcallView.h"//cc签到
#import "VoteView.h"  //cc答题卡
#import "VoteViewResult.h"  //cc答题卡结果
#import "QuestionNaire.h"//cc第三方调查问卷
#import "QuestionnaireSurvey.h"//cc问卷和问卷统计
#import "QuestionnaireSurveyPopUp.h"//cc问卷弹窗

@protocol DXLiveViewControllerDelegate <NSObject>
@optional
- (void)initGenseeLive ;
- (void)sendGenseeMessage:(NSString *)content ;//gensee发送聊天
@optional
- (void)initCCLive ;
- (void)sendCCMessage:(NSString *)content ;//cc发送聊天

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
@property (nonatomic, copy) NSString *liveId;// 课程详情界面传过来的直播房间Id ，必须
@property (nonatomic, copy) NSString *liveToken;// 课程详情界面传过来的直播房间Token ，必须
/* 跳转本页面CCSDK直播需要传递的参数 + 用户信息*/
@property (nonatomic, copy) NSString *userId;// cc用户Id（平台标识id）,必须
@property (nonatomic, copy) NSString *roomId;// cc直播房间Id ，必须
@property (nonatomic, copy) NSString *viewerName;// cc直播访问者名字
@property (nonatomic, copy) NSString *token;// cc直播房间Token（都为空)


//用户信息--> 由于项目分离（主项目没有独立出pod来，无法使用主项目中的类），需要用户信息（对应主项目中的DXUser类中的属性）
@property (nonatomic, assign) BOOL  liveType;   //CC直播还是展视直播（gensee==no）
@property (nonatomic, assign) long long  uid;
@property (nonatomic, copy) NSString * uname;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * phone;

@property (nonatomic, copy) NSString *videoTitle;// 课程详情界面传过来的分享的标题
@property (nonatomic, assign) NSInteger courseID;// 课程详情界面传过来的课程的Id
@property (nonatomic, assign) NSInteger sectionID;// 课程详情界面传过来的课程的节Id
@property (nonatomic, copy) NSString *imgUrl;// 课程详情界面传过来的分享的链接
@property (nonatomic, assign) double broadcastTime;// 课程详情界面传过来的分享的直播课时间
@property (nonatomic, copy) NSString *teach_material_file;// 章节列表里传过来的资料文件
























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
//@property (nonatomic, strong) GSInvestigation *investigation;            // 答题卡
#pragma mark - gensee切换网络
@property (nonatomic, strong) NSArray *networkArray;                     // 存放网络的数组
@property (nonatomic, strong) DXLiveNetworkView *networkView;            // 点击网络弹出视图（只有gensee有这个视图 cc的没有）
#pragma mark - gensee 答题卡（问卷）
@property (nonatomic, strong) DXLiveEnteringInvestigationView *liveEnteringInvestigationView; // 有答题卡时进入答题卡的View
@property (nonatomic, strong) DXLiveInvestigationView *investigationView;// 答题视图
@property (nonatomic, strong) DXLiveInvestigationResultsView *investigationResultsView; // 答题结果视图




/* CC直播相关的属性*/
@property (nonatomic,strong)RequestData              * requestData;//sdk
@property (nonatomic,copy)  NSString                 * viewerId;//观看者的id
@property (nonatomic,assign)NSInteger                firRoadNum;//房间线路
@property (nonatomic,strong)NSMutableArray           * secRoadKeyArray;//清晰度数组
#pragma mark - 签到
@property (nonatomic,weak)  RollcallView             * rollcallView;//签到
@property (nonatomic,assign)NSInteger                duration;//签到时间
#pragma mark - 答题卡
@property(nonatomic,weak)  VoteView                  * voteView;//答题卡
@property(nonatomic,weak)  VoteViewResult            * voteViewResult;//答题结果
@property(nonatomic,assign)NSInteger                 mySelectIndex;//答题单选答案
@property(nonatomic,strong)NSMutableArray            * mySelectIndexArray;//答题多选答案
#pragma mark - 问卷（cc的答题卡和问卷不是同一个东西）
@property (nonatomic,assign)NSInteger                submitedAction;//提交事件
@property (nonatomic,strong)QuestionNaire            * questionNaire;//第三方调查问卷
@property (nonatomic,strong)QuestionnaireSurvey      * questionnaireSurvey;//问卷视图
@property (nonatomic,strong)QuestionnaireSurveyPopUp * questionnaireSurveyPopUp;//问卷弹窗




/*Gensee的相关方法*/

/*CC的相关方法*/



//提示消息
- (void)showHint:(NSString *)hint ;
- (void)setUserInfoWihtUid:(long long)uid uname:(NSString *)uname email:(NSString *)email phone:(NSString *)phone  ;
@end

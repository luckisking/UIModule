//
//  DXVipServiceMode.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/7/1.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceMode : DXVipServiceBaseMode
@property (nonatomic, strong) NSString *str;
@end

NS_ASSUME_NONNULL_END



//每天学习计划的mode（某一天的计划安排）
NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceStudyMode : DXVipServiceBaseMode
@property (nonatomic, strong) NSString *stage;  //所处的阶段
@property (nonatomic, strong) NSString *date;  //日期 如 2019-03-03
@property (nonatomic, strong) NSString *theDay;  //今天是第几天
@property (nonatomic, strong) NSString *eventDesc;  //作业的说明文字
@property (nonatomic, strong) NSString *startTime;  //开始阶段
@property (nonatomic, strong) NSString *endTime;  //结束阶段
@property (nonatomic, strong) NSDictionary *prevDayState;  //前一天的学习内容 （如果不是为空 需要弹出前一天的学习的窗口）
@property (nonatomic, strong) NSArray *video;  //视频数组
@property (nonatomic, strong) NSArray *paper;  //试卷数组
@property (nonatomic, strong) NSString *is_task;  //是否查看作业

@end

NS_ASSUME_NONNULL_END


//试卷mode（paper）
NS_ASSUME_NONNULL_BEGIN

@interface DXVipServicePaperMode : DXVipServiceBaseMode
@property (nonatomic, strong) NSString *paper_id;           //试卷的id
@property (nonatomic, strong) NSString *paper;              //试卷的标题
@property (nonatomic, strong) NSString *submit_state;       //提交状态：1-已提交，0-未提交
@property (nonatomic, strong) NSString *score;              //试卷得分
@property (nonatomic, strong) NSString *done_question_count; //已答题数量
@property (nonatomic, strong) NSString *ctime;              //答题时间
@property (nonatomic, strong) NSString *use_time;           //使用时间
@property (nonatomic, strong) NSString *record_id;          //已做题记录id  (如果为空说明一个题目  没有做)
@property (nonatomic, strong) NSString *subject_type;       //试卷的类型

@end

NS_ASSUME_NONNULL_END



//Video de mode (视频和直播的模型)
NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceVideoMode : DXVipServiceBaseMode
@property (nonatomic, strong) NSString *courseId;         //课程的id
@property (nonatomic, strong) NSString *kctype;    //课程类型：0-线下课程；1-视频课程；2-直播课程
@property (nonatomic, strong) NSString *video_title;//课程标题
@property (nonatomic, strong) NSString *thumb;      //课程图片
@property (nonatomic, strong) NSString *duration;   //总共节时长
@property (nonatomic, strong) NSArray *jie;         //小节的数组
@property (nonatomic, strong) NSString *broadcast_endtime;    //直播开始
@property (nonatomic, strong) NSString *broadcast_time;       //直播结束  teacher_name
@property (nonatomic, strong) NSString *teacher_name;         //老师的名字
@end

NS_ASSUME_NONNULL_END




//小节mode （视频和直播的小节模型）
NS_ASSUME_NONNULL_BEGIN

@interface DXVipServiceJieMode : DXVipServiceBaseMode
@property (nonatomic, strong) NSString *jieId;                 //节id
@property (nonatomic, strong) NSString *zhangid;            //章id
@property (nonatomic, strong) NSString *video_title;        //课程节标题
@property (nonatomic, strong) NSString *kctype;             //课程类型：0-线下课程；1-视频课程；2-直播课程
@property (nonatomic, strong) NSString *broadcast_time;     //直播课开始时间
@property (nonatomic, strong) NSString *broadcast_endtime;  //直播课结束时间
@property (nonatomic, strong) NSString *live_playback_url;  //直播课回放id
@property (nonatomic, strong) NSString *duration;           //时长
@property (nonatomic, strong) NSString *teacher_name;       //讲师  如果直播课 该字段可以很长（很多名老师）  显示不下 需要截取
@property (nonatomic, strong) NSString *study;              //是否已经学习 已经学习过的要置灰
@end

NS_ASSUME_NONNULL_END



//日历mode  (层次结构过深，放弃使用 4层)
NS_ASSUME_NONNULL_BEGIN
@interface DXVipServiceDateMode : DXVipServiceBaseMode
//改阶段的主信息
@property (nonatomic, strong) NSString *stage;
@property (nonatomic, strong) NSString *myTime;
@property (nonatomic, strong) NSString *myEndTime;
@property (nonatomic, strong) NSArray *months;

//每月的数组内容
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *finishState;

//老师的信息
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@end
NS_ASSUME_NONNULL_END

//
//  DXVipServiceApiRequest.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/20.
//  Copyright © 2019 都学网. All rights reserved.
//

//#define VSDomain @"http://192.168.1.97"
//#define VSDomain @"http://api.dx.com"
#define VSDomain  @"https://api.doxue.com"
#define VSApi(host,api)                   [NSString stringWithFormat:@"%@%@",host,api]

#define API_VS_Token                      VSApi(VSDomain,@"/v1/vip_student/token")                        //获取token
#define API_VS_IsBuyVS                    VSApi(VSDomain,@"/v1/vip_student/check_student_service")        //检查是否购买服务
#define API_VS_Allot                      VSApi(VSDomain,@"/v1/vip_student/allot_info")                   //获取分配信息
#define API_VS_StudyTest                  VSApi(VSDomain,@"/v1/vip_student/first_paper_record")           //入学测试

#define API_VS_IsAcademy                  VSApi(VSDomain,@"/v1/vip_student/check_exam_college")           //检查是否填写报考院校
#define API_VS_SearchAcademy              VSApi(VSDomain,@"/v1/vip_student/search_major_college")         //根据专业搜索院校
#define API_VS_CommitAcademy              VSApi(VSDomain,@"/v1/vip_student/add_exam_college")         //提交院校信息
#define API_VS_DayPlan                    VSApi(VSDomain,@"/v1/vip_student/plan_stage_day")               //查看某一天计划安排
#define API_VS_HadLook                    VSApi(VSDomain,@"/v1/vip_student/add_study_task")               //用户查看了某一天的作业

#define API_VS_CalendarPlan               VSApi(VSDomain,@"/v1/vip_student/stage_plan_month")               //日历计划
#define API_VS_LearnPath                  VSApi(VSDomain,@"/v1/vip_student/study_stage_pathpic")            //学习路径图
#define API_VS_Report                     VSApi(VSDomain,@"/v1/vip_student/study_stage_report")            //学习报告

#define API_VS_EvaluateState               VSApi(VSDomain,@"/v1/vip_student/written_teacher_evaluate")      //老师评价状态查询
#define API_VS_EvaluateCommit              VSApi(VSDomain,@"/v1/vip_student/add_teacher_evaluate")          //提交对老师的评价

#import "DXVipServiceApiRequest.h"

@implementation DXVipServiceApiRequest

#pragma mark     入口状态接口 （包括获取token，查询是否购买服务，分配情况查询，入学测试题目 ）

- (void)postTokenWithUid:(NSString *)uid success:(nullable success)success fail:(nullable failure)failure {
    if (!uid) return;
    NSDictionary *param = @{@"uid":uid};
    [DXVipServiceNetWork post:API_VS_Token paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        [DXVipServiceNetWork setToken:dic[@"data"][@"token"]];
        if (success) success(dic,state);
    } fail:^(NSError * _Nonnull error) {
    } animated:NO];
}
- (void)checkIsBuyVipServicePostWithSuccess:(success)success fail:(failure)failure {
    [DXVipServiceNetWork post:API_VS_IsBuyVS paramaters:nil success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}
- (void)postAlloctInfoWithServiceType:(NSString *)serviceType success:(success)success fail:(failure)failure {
    if (!serviceType) return;
    [DXVipServiceNetWork post:API_VS_Allot paramaters:@{@"service_type":serviceType} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}


#pragma mark     每日计划 （包括 看课，做题，查询是否报考院校，查询院校列表，提交报考院校）

- (void)checkIsAcademyPostWithSuccess:(success)success fail:(failure)failure {
    [DXVipServiceNetWork post:API_VS_IsAcademy paramaters:nil success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}
- (void)postSearchAcademyWithMajor:(NSString *)major success:(success)success fail:(failure)failure {
    if (!major) return;
    [DXVipServiceNetWork post:API_VS_SearchAcademy paramaters:@{@"major":major} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}
- (void)postcommitAcademyWithMajor:(NSString *)major
                           college:(NSString *)college
                         studyType:(NSString *)studyType
                          language:(NSString *)language
                           success:(success)success
                              fail:(failure)failure {
    if (!major||!college||!studyType||!language) return;
    NSDictionary *dic = @{@"major":major,@"college":college,@"study_type":studyType,@"language":language};
    [DXVipServiceNetWork post:API_VS_CommitAcademy paramaters:dic success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}
- (void)postStudyTestWithPaperId:(NSString *)paperId success:(success)success fail:(failure)failure {
    if (!paperId) return;
    [DXVipServiceNetWork post:API_VS_StudyTest paramaters:@{@"paper_id":paperId} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}

- (void)postEveryDayPlanWithDay:(NSString *)day stage:(NSString *)stage success:(success)success fail:(failure)failure {
    if (!day||!stage) return;
    [DXVipServiceNetWork post:API_VS_DayPlan paramaters:@{@"day":day,@"stage":stage} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}
- (void)postHadLook:(NSString *)date success:(success)success fail:(failure)failure {
    if (!date) return;
    [DXVipServiceNetWork post:API_VS_HadLook paramaters:@{@"study_day":date} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
    
}




#pragma mark      日历界面接口

- (void)learnByCalendarPlanWithStage:(NSString *)stage success:(success)success fail:(failure)failure {
    if (!stage) return;
    [DXVipServiceNetWork post:API_VS_CalendarPlan paramaters:@{@"stage":stage} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}
#pragma mark      学习报告 和 学习路径
- (void)learnPathWithStage:(NSString *)stage success:(success)success fail:(failure)failure {
    if (!stage) return;
    [DXVipServiceNetWork post:API_VS_LearnPath paramaters:@{@"stage":stage} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}
- (void)reportWithStage:(NSString *)stage success:(success)success fail:(failure)failure {
    if (!stage) return;
    [DXVipServiceNetWork post:API_VS_Report paramaters:@{@"stage":stage} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}

#pragma mark      笔试老师评价
- (void)evaluateStateStage:(NSString *)stage success:(success)success fail:(failure)failure {
    if (!stage) return;
    [DXVipServiceNetWork post:API_VS_EvaluateState paramaters:@{@"stage":stage} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}
- (void)evaluateCommitStage:(NSString *)stage star:(NSString *)star content:(NSString *)content success:(success)success fail:(failure)failure {
    if (!stage||!star||!content) return;
    [DXVipServiceNetWork post:API_VS_EvaluateCommit paramaters:@{@"stage":stage,@"star":star,@"content":content} success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}


@end

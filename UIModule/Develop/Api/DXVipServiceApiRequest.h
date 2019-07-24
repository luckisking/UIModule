//
//  DXVipServiceApiRequest.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/20.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXVipServiceNetWork.h"

NS_ASSUME_NONNULL_BEGIN
/*集中处理网络请求*/
@interface DXVipServiceApiRequest : NSObject

#pragma mark     入口状态接口 （包括获取token，查询是否购买服务，分配情况查询，入学测试题目 ）
- (void)postTokenWithUid:(NSString *)uid success:(nullable success)success fail:(nullable failure)failure ;
- (void)checkIsBuyVipServicePostWithSuccess:(success)success fail:(failure)failure ;
- (void)postAlloctInfoWithServiceType:(NSString *)serviceType success:(success)success fail:(failure)failure ;

#pragma mark     每日计划 （包括 看课，做题，查询是否报考院校，查询院校列表，提交报考院校）
- (void)checkIsAcademyPostWithSuccess:(success)success fail:(failure)failure ;
- (void)postSearchAcademyWithMajor:(NSString *)major success:(success)success fail:(failure)failure ;
- (void)postcommitAcademyWithMajor:(NSString *)major
                           college:(NSString *)college
                         studyType:(NSString *)studyType
                          language:(NSString *)language
                           success:(success)success
                              fail:(failure)failure ;

- (void)postStudyTestWithPaperId:(NSString *)paperId success:(success)success fail:(failure)failure ;
- (void)postEveryDayPlanWithDay:(NSString *)day stage:(NSString *)stage success:(success)success fail:(failure)failure ;
- (void)postHadLook:(NSString *)date success:(success)success fail:(failure)failure ;



#pragma mark      日历界面接口
- (void)learnByCalendarPlanWithStage:(NSString *)stage success:(success)success fail:(failure)failure ;
#pragma mark      学习报告  和 学习路径
- (void)learnPathWithStage:(NSString *)stage success:(success)success fail:(failure)failure ;
- (void)reportWithStage:(NSString *)stage success:(success)success fail:(failure)failure ;

#pragma mark      笔试老师评价
- (void)evaluateStateStage:(NSString *)stage success:(success)success fail:(failure)failure  ;
- (void)evaluateCommitStage:(NSString *)stage star:(NSString *)star content:(NSString *)content success:(success)success fail:(failure)failure ;
@end

NS_ASSUME_NONNULL_END

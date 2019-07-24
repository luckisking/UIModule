//
//  DXVIPWrittenTestDateController.m
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVIPWrittenTestDateController.h"
#import "DXVipWTDateView.h"
#import "DXVipServiceApiRequest.h"

//跳转类（下一个页面）
#import "DXVipEverydayPlanController.h"
#import "DXVipLearnPathController.h"
#import "DXVipGuidanceEvaluationController.h"
#import "DXVipWebController.h"

@interface DXVIPWrittenTestDateController ()<DXVipServiceBaseViewDelegete>
@property (nonatomic, strong) DXVipWTDateView *wdView;
@property (nonatomic, strong) DXVipServiceApiRequest *apiRequest;
@property (nonatomic, strong)NSMutableDictionary  *data;
//是否有学习报告
@property (nonatomic, assign)BOOL  hasLearnPath;
//是否有学习路径
@property (nonatomic, assign)BOOL  hasLearnReport;
@end

@implementation DXVIPWrittenTestDateController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage: [VipServiceImage(@"顶部通用背景") resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}

- (void)loadView {
    
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP笔试服务";
    _apiRequest = [[DXVipServiceApiRequest alloc] init];
    _data = [NSMutableDictionary dictionary];
    [self requestCalendarPlanWithStage:_stage];
}


#pragma mark 数据请求

//时间处理
- (NSString *)dateWithTimeInterval:(long long)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}

/*浏览阶段学习计划内容日历*/
- (void)requestCalendarPlanWithStage:(NSString *)stage {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
   __block dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self.apiRequest learnByCalendarPlanWithStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
            if ([dic[@"status"] boolValue]) {
                [self checkHasLearnPathAndReportWithStage:stage];
                if ([DXCreateUI judgeEmpty:dic[@"data"]]) return ;
                NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:dic[@"data"]];
                long long  startTime =  [self dateWithTimeInterval:VSStringFormat(data[@"starttime"]).longLongValue].longLongValue;
                long long  endTime =  [self dateWithTimeInterval:VSStringFormat(data[@"endtime"]).longLongValue].longLongValue;
                long long  nowTime =  [self dateWithTimeInterval: ((long long)[[NSDate date] timeIntervalSince1970])].longLongValue;
                NSString *time;
                if (nowTime<startTime) time = @"未开始";
                if (nowTime>endTime) time = @"已结束";
                if (nowTime>startTime&&nowTime<endTime) {
                    time = [NSString stringWithFormat:@"第 %lld 天",nowTime-startTime+1];
                }
                if (nowTime==startTime) {
                    time = @"第 1 天";
                }
                if (nowTime==endTime) {
                    time = [NSString stringWithFormat:@"第 %lld 天",nowTime-startTime+1];
                }
                [self.data addEntriesFromDictionary:dic[@"data"]];
                [self.data setValue:stage forKey:@"stage"];
                [self.data setValue:time forKey:@"myTime"];
                [self.data setValue:[NSString stringWithFormat:@"%lld",startTime] forKey:@"myStartTime"];
                [self.data setValue:[NSString stringWithFormat:@"%lld",endTime] forKey:@"myEndTime"];
                
            }
            dispatch_group_leave(group);
        } fail:^(NSError * _Nonnull error) {
            dispatch_group_leave(group);
        }];
        
    });

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self.apiRequest evaluateStateStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
            if ([dic[@"status"] boolValue]) {
                [self.data setObject:dic[@"data"] forKey:@"teacherData"];
            }
            dispatch_group_leave(group);
        } fail:^(NSError * _Nonnull error) {
            dispatch_group_leave(group);
        }];
    });
    
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.wdView) [self.wdView removeFromSuperview];
            self.wdView =  [[DXVipWTDateView alloc] initWithFrame:self.view.bounds target:self data:self.data];
            [self.view addSubview:self.wdView];
        });
    });
    
}

/**
 切换学习阶段
 */
- (void)myStageClickMethod:(UITapGestureRecognizer *)tap {
    NSInteger index =  tap.view.tag-1600;
    [_data removeAllObjects];
    [self requestCalendarPlanWithStage:VSStringFormatInteger(index)];
}
//检查是否有学习报告和学习路径
- (void)checkHasLearnPathAndReportWithStage:(NSString *)stage {
     self.hasLearnPath = NO;
     self.hasLearnReport = NO;
    [self.apiRequest learnPathWithStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if (![DXCreateUI judgeEmpty:dic[@"data"]])  self.hasLearnPath = YES;
    } fail:^(NSError * _Nonnull error) {
        
    } ];
    [self.apiRequest reportWithStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if (![DXCreateUI judgeEmpty:dic[@"data"]])  self.hasLearnReport = YES;
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark 页面跳转
/**
 点击日期 ---前往看课学习
 */
- (void)clickWithString:(NSString *)param1 string:(NSString *)param2 {
    DXVipEverydayPlanController *edpVC  = [[DXVipEverydayPlanController alloc] init];
    edpVC.day = param1;
    edpVC.stage = param2;
    edpVC.whearFrom = @"日历页面来的";
    [self.navigationController pushViewController:edpVC animated:YES];
}
/**
  ---  前往学习路径图  前往我要评价 前往学习报告
 */
- (void)clickWithDescription:(NSString *)description param:(NSDictionary *)param {
    if ([description isEqualToString:@"学习路径图"]) {
        if (_hasLearnPath) {
            DXVipLearnPathController *lpVC  = [[DXVipLearnPathController alloc] init];
            lpVC.stage = param[@"param1"];
            [self.navigationController pushViewController:lpVC animated:YES];
        }else {
            VSShowMessage(@"还没有生成学习路径图");
        }
     
    }
    if ([description isEqualToString:@"我要评价"]) {
        DXVipGuidanceEvaluationController *geVC  = [[DXVipGuidanceEvaluationController alloc] init];
        geVC.stage = param[@"param1"];
        [self.navigationController pushViewController:geVC animated:YES];
    }
    if ([description isEqualToString:@"学习报告"]) {
        if (_hasLearnReport) {
            DXVipWebController *vc  = [[DXVipWebController alloc] init];
            vc.stage = @"1";
            vc.token = [DXVipServiceNetWork getToken];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            VSShowMessage(@"还没有生成学习报告");
        }
       
    }
}
@end

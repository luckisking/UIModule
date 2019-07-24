//
//  DXVipEverydayPlanController.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/18.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
    每天的计划，包括 看课，做题，其他 
 */
@interface DXVipEverydayPlanController : DXVipServiceBaseViewController
@property (nonatomic, strong) NSString *day;    //某一天，年-月-日（2019-06-04)
@property (nonatomic, strong) NSString *stage;  //所属阶段  0-未安排，1-基础阶段,2-系统阶段,3-强化阶段,4-冲刺阶段

@property (nonatomic, strong) NSString *whearFrom; //从哪里来的（包括日历界面来的 ，学习昨天的和index页面来的）
@end

NS_ASSUME_NONNULL_END

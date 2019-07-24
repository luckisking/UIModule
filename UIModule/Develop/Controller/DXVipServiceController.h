//
//  DXVipServiceController.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/18.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


/**
    未安排计划的主页面（包括，未分配老师，已经分配老师没有安排测试，已经分配老师并且已经安排了测试）
 */
@interface DXVipServiceController : DXVipServiceBaseViewController
@property (nonatomic, strong) NSArray *testPaperArr; //从每日计划过来送过来的测试题数组
+ (void)checkUserIsVipWithUid:(NSInteger)uid callBack:(void(^)(NSInteger flag))callBack ;
@end

NS_ASSUME_NONNULL_END

//
//  DXVipGuidanceEvaluationController.h
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/29.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipServiceBaseViewController.h"
#import "DXCreateUI.h"
NS_ASSUME_NONNULL_BEGIN


/**
    辅导评价（包括笔试和面试）分为已经评价话展示评价内容，没有评价的话填写评价并提交
 */
@interface DXVipGuidanceEvaluationController : DXVipServiceBaseViewController
@property (nonatomic, strong) NSString *stage;
@end

NS_ASSUME_NONNULL_END

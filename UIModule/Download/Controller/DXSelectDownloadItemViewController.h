//
//  DXSelectDownloadItemViewController.h
//  Doxuewang
//
//  Created by Zhang Lei on 2017/8/29.
//  Copyright © 2017年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

typedef void(^closeButtonBlock)(NSMutableArray *selectDownArr);
typedef void(^closeWithNoChoice)(void);

@interface DXSelectDownloadItemViewController : UIViewController

@property (nonatomic, strong) CourseModel *course;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) closeButtonBlock closeButtonBlock;
@property (nonatomic, copy) closeWithNoChoice closeWithNoChoice;
@property(nonatomic, assign) BOOL isVideo;//yes是视频课程,no是直播回放课程
@end

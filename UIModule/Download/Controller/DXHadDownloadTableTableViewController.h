//
//  DXHadDownloadTableTableViewController.h
//  Doxuewang
//
//  Created by Zhang Lei on 16/3/7.
//  Copyright © 2016年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDownloadSessionManager.h"

@class DownCourseModel;
@class DXLivePlaybackModel;
/**
 *  显示已经下载的课程视频列表。
 *  在这个列表中，使用视频标题作为每个table cell的主标题，同时显示视频的图标。在debug模式下，显示
 *  视频的id.
 */
@interface DXHadDownloadTableTableViewController : UIViewController

/**
 *  视频课程的数据信息
 */
@property (nonatomic, strong) DownCourseModel *course;
/**
 *  直播回放课程的下载数据信息
 */
@property(nonatomic, strong) NSMutableArray <DXLivePlaybackModel *> *genseeItems;
@property(nonatomic, strong) NSMutableArray <CCDownloadModel *> *ccItems;
@property(nonatomic, assign) NSInteger videoType;//0是视频课程,1是gensee回放课程,2是cc回放课程
@end

//
//  DownloadCell.h
//  Doxue
//
//  Created by MBAChina-IOS on 15/7/24.
//  Copyright (c) 2015年 MBAChina. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^aIndexBlock)(NSIndexPath *indexPath);

@class DXDownloadItem;


/**
 在下载视图(包含已下载，下载中两个tab)中，显示下载条目的tableview cell。
 */
@interface DownloadCell : UITableViewCell

@property (nonatomic, strong) NSString    * fileSize;//直播回放大小
@property (nonatomic, strong) downItem    * livebackItem;//直播回放model
@property (nonatomic, strong) DXDownloadItem    * item;//视频model
@property (nonatomic, assign) double lastTime;
@property (nonatomic, assign) double writeSize;

@property (nonatomic, strong) UILabel           *remainingTime;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIProgressView    *progressView;
@property (nonatomic, strong) UILabel           *stateLabel;
@property (nonatomic, strong) UILabel           *sizeLabel;

@end

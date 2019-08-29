//
//  DXDownloadManager.h
//  Doxuewang
//
//  Created by Zhang Lei on 15/11/4.
//  Copyright © 2015年 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXDownloadItem.h"
#import "DXApiGetActualUrl.h"

/*
 *  下载管理器。单例对象。
 *  功能：
 *  1、负责管理多个下载线程。
 *  2、下载任务被提交到下载管理器中，离开开始下载。
 *  3、在下载窗口中展示下载进度。
 *  4、在软件重新打开的时候，继续进行未完成的下载。
 */

typedef void (^DXBackgroudSessionCompletionHandlerBlock)(void);

@interface DXDownloadManager : NSObject

@property (nonatomic, strong) NSURLSession *mainSession;

@property (nonatomic, assign, readwrite) BOOL isDownloading;
@property (nonatomic, assign, readwrite) BOOL isSingleDown;

@property (strong, nonatomic) DXDownloadItems *downloadingItems;       //下载目录
@property (strong, nonatomic) DXDownloadItems *downloadFinishItems;    //完成目录

@property (nonatomic, strong) NSMutableArray * dataSource_queue;        //正在下载
@property (nonatomic, strong) NSMutableArray * dataSource_haddown;      //已经下载
@property (nonatomic, strong) NSMutableArray * dataSource_course;       //课程分类

/*  单例  */
+ (DXDownloadManager*)sharedInstance;

- (void)startDownloadAll;

- (void)stopDownloadAll;

- (void)initDownLoadData;

- (void)appendDownloadItems:(NSArray *)items;

- (void)sortVideoByCourse;

- (DXDownloadItem *)downloadingItemAtIndex:(NSInteger)index;

/*  检查已经下载的条目是否有加密状态为“未加密”的。如果有，那么重新加密并修改状态。 */
- (void)updateDownloadedFileEncodedState;

/* 启动下载 */
- (void)startDownloadWithItem:(DXDownloadItem*)item;

/* 暂停下载 */
- (void)stopDownloadingWithItem:(DXDownloadItem*)item;

/* 单线程下载模式下的任务启动方式 */
- (void)continueDownLoad:(DXDownloadItem *)downItem;

@end

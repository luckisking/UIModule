//
//  DXDownloadItem.h
//  Doxue
//
//  Created by MBAChina-IOS on 15/6/11.
//  Copyright (c) 2015年 MBAChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnityDefine.h"
#import "DWDownloadModel.h"


//typedef void(^DownlaodBlock)(DXDownloadItem *model);
//typedef void(^DeleteBlock)(DXDownloadItem *offlineModel,BOOL isDownloading,NSDictionary *dic);
//typedef void(^StartDownloadBlock)(DXDownloadItem *model);

@interface DXDownloadItem : NSObject


@property (nonatomic, strong) DWDownloadModel *downloadModel;

@property (strong, nonatomic)NSString *course_title; //所属课程标题
@property (assign, nonatomic)long long course_id;    //所属课程id
@property (assign, nonatomic)long long Id;           //id
@property (strong, nonatomic)NSString *imageurl;     //封面图片
@property (strong, nonatomic)NSString *duration;     //时长
@property (strong, nonatomic)NSString *video_title;  //视频标题
@property (strong, nonatomic)NSString *video_id;     //视频id  (example:138D0CBACADB87549C33DC5901307461)
@property (strong, nonatomic)NSString *videoPath;    //保存地址
@property (assign, nonatomic)NSInteger videoFileSize;
@property (assign, nonatomic)NSInteger videoDownloadedSize;
@property (assign, nonatomic)int isfree;        //1免费 0收费
@property (strong, nonatomic) NSString *fileTpye;

/* 视频下载来源 */
@property (assign, nonatomic) URLSourceType videoURLSourceTye;

/* 视频下载状态 */
@property (assign, nonatomic) DXDownloadStatus videoDownloadStatus;


// 视频质量
@property (nonatomic,copy) NSString *definition;
// 描述
@property (nonatomic,copy) NSString *desp;
// 播放地址
@property (nonatomic,copy) NSString *playurl;
//加密token  加密必用   非加密可以不用
@property (nonatomic,copy) NSString *token;

@property (nonatomic, copy) NSString *progressText;//下载文字
@property (nonatomic, copy) NSString *finishText;//已完成的文字
@property (nonatomic, assign) CGFloat progress;//进度
@property (nonatomic, assign) DWDownloadState state;//下载状态

@property (strong, nonatomic) NSString * stateString;
@property (nonatomic, assign) NSInteger orderby;
@property (nonatomic, assign) long long uid;
@property (nonatomic, assign) BOOL isJiami;

@property (nonatomic, strong) NSString *sessionIdentifier;
@property (nonatomic, assign) double expireTime;               // 过期时间，从课程中取得

@property (nonatomic, strong) NSData *resumeData;

/* 标记当前的下载条目是否是加密过的。这个标记只是在已经下载的条目中有效！ */
@property (nonatomic, assign, getter=isEncoded) BOOL encoded;

- (NSString *)videoPath;

-(id)initWithItem:(NSDictionary*)item;

-(NSString *)description;

@end

#pragma mark - DXDownloadItems

@interface DXDownloadItems : NSObject

@property (strong, nonatomic) NSMutableArray * items;
@property (assign, atomic) BOOL isBusy;

-(instancetype)initWithPath:(NSString*)path;
-(void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObject:(DXDownloadItem *)item;
-(BOOL)writeToPlistFile:(NSString*)filename;

- (void)appendDownloadItems:(NSArray *)items;
- (DXDownloadItem *)findItemWithVideoID:(NSString *)videoID;

@end

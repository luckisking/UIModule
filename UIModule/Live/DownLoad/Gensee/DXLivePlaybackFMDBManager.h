//
//  DXLivePlaybackFMDBManager.h
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import "DXLivePlaybackModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  直播回放下载,对应小标题,和下载id
 */
@interface DXLivePlaybackFMDBManager : NSObject

+(DXLivePlaybackFMDBManager *)shareManager;
//判断是否存在该条数据
-(BOOL)isExistsWithStrDownloadID:(NSString *)strDownloadID;
//插入数据
-(BOOL)insertLivePlaybackWatchItem:(DXLivePlaybackModel *)item;
//查询数据
-(DXLivePlaybackModel *)selectCurrentModelWithStrDownloadID:(NSString *)strDownloadID;
//删除该条数据
-(BOOL)removeStrDownloadID:(NSString *)strDownloadID;
//删除数据库全部数据
-(BOOL)removeAllobjects;
//关闭数据库
//-(void)closeFMDB;
@end
NS_ASSUME_NONNULL_END

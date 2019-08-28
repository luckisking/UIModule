//
//  DXLivePlaybackFMDBManager.m
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXLivePlaybackFMDBManager.h"
#import <FMDB/FMDB.h>

@interface DXLivePlaybackFMDBManager ()
@property(nonatomic, strong) FMDatabase *fmdb;
@end
@implementation DXLivePlaybackFMDBManager

// 数据库相关操作
+ (DXLivePlaybackFMDBManager *)shareManager{
    static DXLivePlaybackFMDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]initWithPrivate];
        
    });
    return manager;
}

-(instancetype)initWithPrivate{
    if(self = [super init]){
        [self createDataBase];
    }
    return self;
}

-(void)createDataBase{
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"livePlaybackRecord.db"];
    
    if (!_fmdb) {
        _fmdb = [[FMDatabase alloc]initWithPath:dbPath];
    }
    if ([_fmdb open]) {
         NSLog(@"livePlaybackRecord.db--打开成功");
        [_fmdb executeUpdate:@"create table if not exists livePlaybackRecord(PrimaryTitle varchar(256),SecondaryTitle varchar(256),coverImageUrl varchar(256), strDownloadID varchar(256),live_room_id varchar(256),courseID varchar(256))"];
        //由于线上已经有一部分使用了该表(上一个人写的时候并没有把创建表注释，导致点击了下载的用户已经存在该表)，现在需要添加一个表字段
        if (![_fmdb columnExists:@"fileUrl" inTableWithName:@"livePlaybackRecord"]){
            if([_fmdb executeUpdate:@"ALTER TABLE livePlaybackRecord ADD fileUrl varchar(256)"]){
                NSLog(@"插入表字段fileUrl成功");
            }else{
                NSLog(@"插入表字段fileUrl失败");
            }
        }
        
       
    }
}

-(BOOL)isExistsWithStrDownloadID:(NSString *)strDownloadID
{
    FMResultSet * rs  =[_fmdb executeQuery:@"select *from livePlaybackRecord where strDownloadID =?",strDownloadID];
    return [rs next];
}

-(BOOL)insertLivePlaybackWatchItem:(DXLivePlaybackModel *)item{
    BOOL success = NO;
    if (![self isExistsWithStrDownloadID:item.strDownloadID]) {
        success = [_fmdb executeUpdate:@"insert into livePlaybackRecord values(?,?,?,?,?,?,?)",item.PrimaryTitle,item.SecondaryTitle,item.coverImageUrl,item.strDownloadID,item.live_room_id,item.courseID,item.fileUrl];
        
    }else{
        success = [_fmdb executeUpdate:@"update livePlaybackRecord set PrimaryTitle=?,SecondaryTitle=?,coverImageUrl=?,live_room_id=?,courseID=?,fileUrl=? where strDownloadID=?",item.PrimaryTitle,item.SecondaryTitle,item.coverImageUrl,item.live_room_id,item.courseID,item.fileUrl,item.strDownloadID];
        
    }
    return success;
}

-(BOOL)removeStrDownloadID:(NSString *)strDownloadID;
{
    
    BOOL succese =[_fmdb executeUpdate:@"delete from livePlaybackRecord where strDownloadID=?",strDownloadID];
    return succese;
}

-(BOOL)removeAllobjects
{
    BOOL succese = [_fmdb executeUpdate:@"delete from  livePlaybackRecord"];
    return succese;
}

-(DXLivePlaybackModel *)selectCurrentModelWithStrDownloadID:(NSString *)strDownloadID
{
    FMResultSet *rs =[_fmdb executeQuery:@"select *from livePlaybackRecord where strDownloadID = ?",strDownloadID];
    DXLivePlaybackModel *modelItem =[[DXLivePlaybackModel alloc] init];
    while([rs next]){
        modelItem.PrimaryTitle = [rs stringForColumn:@"PrimaryTitle"];
        modelItem.SecondaryTitle = [rs stringForColumn:@"SecondaryTitle"];
        modelItem.coverImageUrl = [rs stringForColumn:@"coverImageUrl"];
        modelItem.strDownloadID = [rs stringForColumn:@"strDownloadID"];
        modelItem.live_room_id = [rs stringForColumn:@"live_room_id"];
        modelItem.courseID = [rs stringForColumn:@"courseID"];
        modelItem.fileUrl = [rs stringForColumn:@"fileUrl"];
    }
    return modelItem;
}

//关闭数据库
-(void)closeFMDB
{
    //关闭数据库
    [_fmdb close];
}
@end

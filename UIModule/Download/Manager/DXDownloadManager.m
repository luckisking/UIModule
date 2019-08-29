//
//  DXDownloadManager.m
//  Doxuewang
//
//  Created by Zhang Lei on 15/11/4.
//  Copyright © 2015年 都学网. All rights reserved.
//

#import "DXDownloadManager.h"
#import "DWSDK.h"
//#import "DWDownloader.h"
#import "DownCourseModel.h"
#import "DXUtility.h"
#import "AppDelegate.h"
#import "DXUserManager.h"
#import "FXKeychain+MBAChina.h"

#define DOWNLOAD_HOST       @"http://dl.doxue.com"
#define MP4_FILE            @"mp4"
#define PCM_FILE            @"pcm"

@interface DXDownloadManager ()

//@property (nonatomic, assign) BOOL canDownload;

@end

@implementation DXDownloadManager

static DXDownloadManager *_downloadManager = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

static dispatch_once_t onceToken;

+ (id)sharedInstance{
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        _downloadManager = [[super allocWithZone:NULL] init];
    });
    return _downloadManager;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (id)copy{
    return [[DXDownloadManager alloc] init];
}

- (id)mutableCopy{
    return [[DXDownloadManager alloc] init];
}

- (id)init{
    if(_downloadManager)
    {
        return _downloadManager;
    }
    if (isFirstAccess)
    {
        [self doesNotRecognizeSelector:_cmd];
    }
    
    self = [super init];
    return self;
}

- (NSMutableArray *)dataSource_queue {
    if (_dataSource_queue) {
        return _dataSource_queue;}
    _dataSource_queue = [NSMutableArray arrayWithCapacity:0];
    return _dataSource_queue;
}

- (NSMutableArray *)dataSource_haddown {
    if (_dataSource_haddown) {
        return _dataSource_haddown;}
    _dataSource_haddown = [NSMutableArray arrayWithCapacity:0];
    return _dataSource_haddown;
}

- (NSMutableArray *)dataSource_course {
    if (_dataSource_course) {
        return _dataSource_course;
    }
    _dataSource_course = [NSMutableArray arrayWithCapacity:0];
    return _dataSource_course;
}

/**
 *  初始化数据
 */

- (void)initDownLoadData
{
    DXDownloadManager *manager  = [DXDownloadManager sharedInstance];
    manager.downloadingItems    = [[DXDownloadItems alloc] initWithPath:DXDownloadingItemPlistFilename];
    manager.downloadFinishItems = [[DXDownloadItems alloc] initWithPath:DXDownloadFinishItemPlistFilename];
    self.dataSource_queue       = manager.downloadingItems.items;
    self.dataSource_haddown     = manager.downloadFinishItems.items;
    
    // 从正在下载（准备下载）列表中，去除掉已经下载过，但是由于数据错误加入到列表中的数据项目
    @synchronized(self) {
        for (DXDownloadItem *downloadedItem in self.dataSource_haddown) {
            NSArray *filteredArray = [self.dataSource_queue filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.video_id = %@", downloadedItem.video_id]];
            if (filteredArray.count != 0) {
                [self.dataSource_queue removeObjectsInArray:filteredArray];
            }
        }
    }
    [manager.downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
    [self sortVideoByCourse];
    NSLog(@"下载队列中有 %lu 条记录等待下载。", (unsigned long)self.dataSource_queue.count);
}

#pragma mark - 按课程分组

- (void)sortVideoByCourse{
    
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    
    for (DXDownloadItem * item in self.dataSource_haddown)
    {
        NSString * key = [NSString stringWithFormat:@"%lld",item.course_id];
        NSMutableArray * valueArr = [NSMutableArray arrayWithArray:mDic[key]];
        [valueArr addObject:item];
        [mDic setValue:valueArr forKey:key];
    }
    
    [self.dataSource_course removeAllObjects];
    
    for(NSString * key in  [mDic allKeys])
    {
        DownCourseModel * co = [DownCourseModel object];
        DXDownloadItem * item = [mDic[key] firstObject];
        co.course_id = [key longLongValue];
        co.course_img = item.imageurl;
        co.course_title = item.course_title;
        co.items = mDic[key];
        [self.dataSource_course addObject:co];
    }
}

- (void)startDownloadAll
{
    if(self.dataSource_queue.count == 0)
    {
        return;
    }
    
    for (DXDownloadItem *item in self.dataSource_queue) {
        if (item.videoDownloadStatus == DXDownloadStatusDownloading) {
            _isDownloading = YES;
            return;
        }
    }
    
    _isDownloading = YES;
    
    NSLog(@"开始下载..., 下载队列中 %ld 条下载任务", self.dataSource_queue.count);
    
    /* 新增判断,避免在下载过程中,新增任务无法自动下载 */
    BOOL isON = [[[NSUserDefaults standardUserDefaults] objectForKey:AUTOMATICALLY_START_DOWNLOAD] boolValue];
    if (_isDownloading && (isON != true)) {return;}
    
    DXDownloadItem *downItem = self.dataSource_queue.firstObject;
    downItem.videoDownloadStatus = DXDownloadStatusWait;
    downItem.playurl = nil;
    
    /* 根据当前item的状态判定是否启动下载 */
    if (downItem.videoDownloadStatus == DXDownloadStatusDownloading)
    {
        
    }
    else
    {
        [self startDownloadWithItem:downItem];
    }
}

- (void)continueDownLoad:(DXDownloadItem *)downItem
{
    if(self.dataSource_queue.count == 0)
    {
        return;
    }
    
    _isDownloading = YES;
    
    DXWeak(self, weakSelf);
    downItem.videoDownloadStatus = DXDownloadStatusWait;
    
    /* 根据当前item的状态判定是否启动下载 */
    if (downItem.videoDownloadStatus == DXDownloadStatusDownloading)
    {
        
    }
    else
    {
        [weakSelf startDownloadWithItem:downItem];
    }
}


- (void)stopDownloadAll{
    
    /*  切换到暂停状态  */
    _isDownloading = NO;
    DXWeak(self, weakSelf);
    [self.dataSource_queue enumerateObjectsUsingBlock:^(DXDownloadItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.videoDownloadStatus == DXDownloadStatusDownloading) {
            item.videoDownloadStatus = DXDownloadStatusUnStart;
            [weakSelf stopDownloadingWithItem:item];
        }
    }];
}

#pragma mark - 从"公司"服务器获取下载资源
- (void)fetchURLFromPraviteServer:(DXDownloadItem *)item{
    
    DXWeak(self, weakSelf);
    DXWeak(item, weakItem);
    
    DXApiGetActualUrl *apiGetActual = [DXApiGetActualUrl excutor];
    
    ApiRequestStateHandler *requestHandle = [ApiRequestStateHandler apiRequestStateHandlerOnSuccess:^(ApiExcutor *apiExcutor, BOOL *cache) {
        
        /* 错误代码:(1) -1: 参数错误   ---> 服务器数据异常导致模型数据错误
         (2) 0 : 不存在文件 ---> 去cc的服务器查询视频地址
         (3) 1 : 请求成功   ---> 用公司服务器下载对应视频  */
        
        if (apiGetActual.flag == 1)
        {
            /* 公司重新开放服务器,确认都是 .pcm格式 */
            weakItem.fileTpye = PCM_FILE;
            weakItem.videoURLSourceTye = URLSourceTypeDX;
            
            weakItem.playurl = apiGetActual.data;
            [weakSelf startDownloadWithItem:weakItem];
        }
        else if (apiGetActual.flag == -1 || apiGetActual.flag == 0)
        {
            weakItem.videoURLSourceTye = URLSourceTypeCC;
            [weakSelf fetchURLFromCCSever:weakItem];
        }
    } onFail:^(ApiExcutor *apiExcutor, NSError *error) {
        
    }];
    
    [apiGetActual apiRequestWithCouseID:item.course_id
                                videoID:item.video_id
                       andRequestHandle:requestHandle];
}

#pragma mark - 从"CC"服务器获取下载资源
- (void)fetchURLFromCCSever:(DXDownloadItem *)item{
    
    // 获取下载地址
    DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:DWACCOUNT_USERID andVideoId:item.video_id key:DWACCOUNT_APIKEY hlsSupport:@"0"];
    
    //网络请求超时时间
    playinfo.timeoutSeconds =20;
    playinfo.errorBlock = ^(NSError *error){
        NSLog(@"playinfo.errorBlock: %@", error.localizedDescription);
    };
    
    DXWeak(self,weakSelf);
    DXWeak(item,weakItem);
    
    playinfo.finishBlock = ^(NSDictionary *response){
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *playUrls =[DXUtility parsePlayInfoResponse:response];
            
            if (!playUrls) {
                //说明 网络资源暂时不可用
            }
            
            //获取PlayInfo 配对url 推送offlineview
            NSArray *videos = [playUrls valueForKey:@"definitions"];
            
            for (NSDictionary * videoInfo in videos) {
                if ([videoInfo[@"definition"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:DownloadVideoQuality] intValue]) {
                    weakItem.definition = videoInfo[@"definition"];
                    weakItem.desp = videoInfo[@"desp"];
                    weakItem.token = playUrls[@"token"];
                    weakItem.playurl = videoInfo[@"playurl"];
                    if ([weakItem.playurl containsString:@".mp4"])
                    {
                        weakItem.fileTpye = MP4_FILE;
                    }
                    else if ([weakItem.playurl containsString:@".pcm"])
                    {
                        weakItem.fileTpye = PCM_FILE;
                    }
                    [weakSelf startDownloadWithItem:weakItem];
                    
                    break;
                }
            }
        }
    };
    [playinfo start];
}


#pragma mark - 下载控制逻辑

/**
 *  开始下载指定的课程条目
 *  @param item 课程下载条目对象
 */

- (void)startDownloadWithItem:(DXDownloadItem*)item{
    
    // 未获取下载的地址的重新获取
    //    if (_canDownload == NO || item.playurl == nil || item.playurl.length == 0)
    //    {
    //        _canDownload = YES;
    //        [self fetchURLFromPraviteServer:item];
    //        return;
    //    }
    
    if (item.playurl == nil || item.playurl.length == 0)
    {
        [self fetchURLFromPraviteServer:item];
        return;
    }
    
    item.videoDownloadStatus = DXDownloadStatusWait;
    
    //非加密 url videoPath必须有值   token userId videoId 均为nil
    DWDownloadModel *loadModel = [[DWDownloadModel alloc]initWithURLString:item.playurl filePath:[item videoPath] responseToken:item.token userId:DWACCOUNT_USERID videoId:item.video_id];
    
    item.downloadModel = loadModel;
    
    //如果有resumeData 说明是URL失效后的断点续传
    if (item.resumeData) {
        loadModel.resumeData = item.resumeData;
    }
    
    if (item.resumeData)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.f)
        {
            item.videoDownloadStatus = DXDownloadStatusWait; /* 等在代理中真正进入执行状态在给 downloading */
        }
        else
        {
            /* 如果无法未查询到ResumeData,系统默认跳到Error */
            item.videoDownloadStatus = DXDownloadStatusWait; /* 等在代理中真正进入执行状态在给 downloading */
        }
    }
    else
    {
        item.videoDownloadStatus = DXDownloadStatusWait;
    }
    
    [self downloadAction:loadModel offlineModel:item];
    
    //通知:开始下载
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger index = [self.dataSource_queue indexOfObject:item];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DXDownloadManger.downloadItemDidStart" object:nil userInfo:@{@"status":@(0), @"text": @"", @"index": @(index),@"courseID":item.video_id,@"videoTitle":item.video_title}];
    });
}

- (void)downloadAction:(DWDownloadModel *)loadModel offlineModel:(DXDownloadItem *)model{
    
    DWDownloadSessionManager *manager =[DWDownloadSessionManager manager];
    
    @weakify(self);
    [manager startWithDownloadModel:loadModel progress:^(DWDownloadProgress *progress,DWDownloadModel *downloadModel) {
        //进度的回调
        if ([downloadModel.downloadURL isEqualToString: model.playurl]) {
            
            //大量开销对象
            @autoreleasepool {
                
                model.progressText =[self detailTextForDownloadProgress:progress];
                model.finishText =[self finishTextForDownloadProgress:progress];
                model.progress =progress.progress;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDownload" object:model];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                float totalBytesExpectedToWrite = [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite];
                float totalBytesWritten = [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesWritten];
                float speed = [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long) progress.speed];
                NSString *fileSizeUnit = [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite];
                NSString *fileSizeTotalBytesWrittenUnit = [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesWritten];
                NSString *speedUnit = [DWDownloadUtility calculateUnit:(unsigned long long)progress.speed];
                NSDictionary *userInfo = @{ @"status":@(1),
                                            @"text": @"",
                                            @"index": @(0),
                                            @"progress": @(model.progress),
                                            @"totalBytesWritten":@(totalBytesWritten),
                                            @"totalBytesExpectedToWrite":@(totalBytesExpectedToWrite),
                                            @"fileSizeUnit": fileSizeUnit,
                                            @"fileSizeWrittenUnit": fileSizeTotalBytesWrittenUnit,
                                            @"speed": @(speed),
                                            @"speedUnit": speedUnit,
                                            @"remainingTime": @(progress.remainingTime),
                                            @"courseID":model.video_id,
                                            @"videoTitle":model.video_title
                                            };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DXDownloadManger.downloading" object:nil userInfo:userInfo];
//                });
            }
        }
        
    } state:^(DWDownloadModel *downloadModel,DWDownloadState state, NSString *filePath, NSError *error) {
        
        @strongify(self);
        //下载状态
        if ([downloadModel.downloadURL isEqualToString: model.playurl]){
            
            @autoreleasepool {
                
                model.state =state;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDownload" object:model];
                
            }
            
            //下载完毕
            if (state ==DWDownloadStateCompleted) {
                
                NSLog(@"%@ - FINISHED", model.video_title);
                
                
                /* 获取到已经下载的课程的下标 */
                NSInteger index = [self.dataSource_queue indexOfObject:model];
                
                /* 从正在下载的数组中移除数据 */
                @synchronized(self) {
                    [self.dataSource_queue removeObject:model];
                }
                
                /* 已完成数据源增加数据 */
                [self.dataSource_haddown addObject:model];
                
                DXDownloadManager *manager = [DXDownloadManager sharedInstance];
                manager.downloadingItems.items    = self.dataSource_queue;
                manager.downloadFinishItems.items = self.dataSource_haddown;
                
                [manager.downloadingItems writeToPlistFile:DXDownloadingItemPlistFilename];
                [manager.downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
                [self sortVideoByCourse];
                
                NSLog(@"    video_id    ：%@", model.video_id);
                NSLog(@"    video_title ：%@", model.video_title);
                NSLog(@"    course_title：%@", model.course_title);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DXDownloadManger.downloadSuccess"
                                                                    object:nil
                                                                  userInfo:@{ @"status":@(3),
                                                                              @"text": @"",
                                                                              @"index": @(index),
                                                                              @"courseID":model.video_id,
                                                                              @"videoTitle":model.video_title }];
                
                
                if (self.dataSource_queue.count == 0)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DXDownloadManger.downloadFinished" object:nil];
                    _isDownloading = NO;
                    //_canDownload = NO;
                }
                else
                {
                    DXDownloadItem *downItem = self.dataSource_queue.firstObject;
                    [self continueDownLoad:downItem];
                }
            }
            else if (state == DWDownloadStateFailed) {
                if (error) {
                    NSLog(@"Error(%@):%@", NSStringFromClass([self class]), error.localizedDescription);
                    if ([error.localizedDescription isEqualToString:@"cancelled"])
                    {
                        
                    }
                    else
                    {
                        DXDownloadItem *errorItem = nil  ;
//                        for (DXDownloadItem *item in self.dataSource_queue) {
//                            if ([item.sessionTask isEqual:task]) {
//                                errorItem = item;
//                                break;
//                            }
//                        }
                        if (errorItem){
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSLog(@"Error-Infomation: %@ ", errorItem.video_title);
                                errorItem.playurl = nil;
                                [self startDownloadWithItem:errorItem];
                            });
                        }
                    }
                }
            }
        }
    }];
}

- (NSString *)detailTextForDownloadProgress:(DWDownloadProgress *)progress{
    
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    
    NSMutableString *detailLabelText = [NSMutableString stringWithFormat:@" %@\: %.2f %@ (%.2f%%)\nSpeed: %.2f %@/sec\nLeftTime: %dsec",fileSizeInUnits,
                                        [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesWritten],
                                        [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesWritten],progress.progress*100,
                                        [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long) progress.speed],
                                        [DWDownloadUtility calculateUnit:(unsigned long long)progress.speed],progress.remainingTime];
    
    
    
    return detailLabelText;
    
}

- (NSString *)finishTextForDownloadProgress:(DWDownloadProgress *)progress{
    
    
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [DWDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [DWDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    
    return fileSizeInUnits;
    
    
    
}



/* - - -  ios.10 寻找ResumeData 的方法  */
- (NSData *)getCorrectResumeData:(NSData *)resumeData
{
    NSData *newData = nil;
    NSString *kResumeCurrentRequest = @"NSURLSessionResumeCurrentRequest";
    NSString *kResumeOriginalRequest = @"NSURLSessionResumeOriginalRequest";
    //获取继续数据的字典
    NSMutableDictionary* resumeDictionary = [NSPropertyListSerialization propertyListWithData:resumeData options:NSPropertyListMutableContainers format:NULL error:nil];
    //重新编码原始请求和当前请求
    resumeDictionary[kResumeCurrentRequest] = [self correctRequestData:resumeDictionary[kResumeCurrentRequest]];
    resumeDictionary[kResumeOriginalRequest] = [self correctRequestData:resumeDictionary[kResumeOriginalRequest]];
    newData = [NSPropertyListSerialization dataWithPropertyList:resumeDictionary format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListMutableContainers error:nil];
    return newData;
}


- (NSData *)correctRequestData:(NSData *)data
{
    NSData *resultData = nil;
    NSData *arData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (arData != nil)
    {
        return data;
    }
    
    NSMutableDictionary *archiveDict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
    
    int k = 0;
    NSMutableDictionary *oneDict = [NSMutableDictionary dictionaryWithDictionary:archiveDict[@"$objects"][1]];
    while (oneDict[[NSString stringWithFormat:@"$%d", k]] != nil) {
        k += 1;
    }
    
    int i = 0;
    while (oneDict[[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%d", i]] != nil) {
        NSString *obj = oneDict[[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%d", i]];
        if (obj != nil) {
            [oneDict setObject:obj forKey:[NSString stringWithFormat:@"$%d", i + k]];
            [oneDict removeObjectForKey:obj];
            archiveDict[@"$objects"][1] = oneDict;
        }
        i += 1;
    }
    
    if (oneDict[@"__nsurlrequest_proto_props"] != nil) {
        NSString *obj = oneDict[@"__nsurlrequest_proto_props"];
        [oneDict setObject:obj forKey:[NSString stringWithFormat:@"$%d", i + k]];
        [oneDict removeObjectForKey:@"__nsurlrequest_proto_props"];
        archiveDict[@"$objects"][1] = oneDict;
    }
    
    NSMutableDictionary *twoDict = [NSMutableDictionary dictionaryWithDictionary:archiveDict[@"$top"]];
    if (twoDict[@"NSKeyedArchiveRootObjectKey"] != nil) {
        [twoDict setObject:twoDict[@"NSKeyedArchiveRootObjectKey"] forKey:[NSString stringWithFormat:@"%@", NSKeyedArchiveRootObjectKey]];
        [twoDict removeObjectForKey:@"NSKeyedArchiveRootObjectKey"];
        archiveDict[@"$top"] = twoDict;}
    resultData = [NSPropertyListSerialization dataWithPropertyList:archiveDict format:NSPropertyListBinaryFormat_v1_0 options:NSPropertyListMutableContainers error:nil];
    return resultData;
}



- (void)stopDownloadingWithItem:(DXDownloadItem*)item
{
    /*  禁止获取完下载地址自动开始  */
    //if (_canDownload == YES) {_canDownload = NO;}
    
    /*  ( 已经下载数据的item ) 备注:终止的item赋临时数据源,会在App强制关闭时候消失  */
    if (item.downloadModel != nil) {
        [[DWDownloadSessionManager manager] suspendWithDownloadModel:item.downloadModel];
        item.videoDownloadStatus = DXDownloadStatusPause;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DXDownloadManger.downloadItemDidStop" object:nil userInfo:@{ @"status":@(2), @"text": @"", @"index": @(0),@"courseID":item.video_id,@"videoTitle":item.video_title}];
    }
    
    /*  ( 还未启动下载的item 的状态设置)  */
    if (item.videoDownloadStatus == DXDownloadStatusWait || item.videoDownloadStatus == DXDownloadStatusUnStart)
    {
        item.playurl = nil;
        item.stateString = @"已暂停";
        item.videoDownloadStatus = DXDownloadStatusWait;
        
        
        NSInteger index = [self.dataSource_queue indexOfObject:item];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DXDownloadManger.downloadItemDidStop" object:nil userInfo:@{ @"status":@(-1), @"text": @"", @"index": @(index),@"courseID":item.video_id,@"videoTitle":item.video_title}];
    }
}

- (DXDownloadItem *)downloadingItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.dataSource_queue.count) {
        return nil;}
    return self.dataSource_queue[index];
}

- (void)updateDownloadedFileEncodedState
{
    BOOL changed = NO;
    DXDownloadManager *manager = [DXDownloadManager sharedInstance];
    manager.downloadFinishItems = [[DXDownloadItems alloc]initWithPath:DXDownloadFinishItemPlistFilename];
    
    NSString * db_path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    for (DXDownloadItem *item in manager.downloadFinishItems.items) {
        if (item.encoded == NO) {
            NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4",db_path, item.video_id];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
                // 尝试解密视频
                const char *filename = [fileName UTF8String];
                const char *password = [[DXUtility UDID] UTF8String];
                encodeNDecodeVideoFile(password, filename);
                item.encoded = YES;
                changed = YES;
            }
        }
    }
    if (changed) {
        [manager.downloadFinishItems writeToPlistFile:DXDownloadFinishItemPlistFilename];
    }
}

#pragma mark - 创建downloadItem时候,创建对应的session和downloadTask

- (void)appendDownloadItems:(NSArray *)items{
    
    @synchronized(self) {
        for (DXDownloadItem *item in items)
        {
            NSArray *filteredArray = [self.dataSource_queue filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.video_id = %@", item.video_id]];
            if (filteredArray.count == 0)
            {
                [self.dataSource_queue addObject:item];
            }
        }
    }
    NSLog(@"DataSource_queue: %lu", (unsigned long)self.dataSource_queue.count);
}


/**
 判断URL是否有效
 *取得时间戳与失效时间戳做比对
 *http://d1-33.play.bokecc.com/flvs/cb/QxhEr/hKboX7hTIY-20.pcm?t=1496894440&key=F458F79EF07944EAAF38AC01A4F49CC9&upid=2625321496887240251
 *t=1496894440为失效时间点
 */
-(void)validate:(DXDownloadItem *)model{
    
    
    NSRange range =[model.playurl rangeOfString:@"t="];
    NSRange timeRang =NSMakeRange(range.location+2, 10);
    NSString *oldStr =[model.playurl substringWithRange:timeRang];
    NSLog(@"时间%@",oldStr);
    
    NSDate *date =[NSDate date];
    NSString *timeString =[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    NSString *nowString =[timeString substringWithRange:NSMakeRange(0, 10)];
    NSLog(@"__%@___%@",oldStr,nowString);
    
    if ([nowString integerValue] >= [oldStr integerValue]) {
        
        NSLog(@"url不可用");
        [self fetchURLFromCCSever:model];
        
    }else{
        
        NSLog(@"url可用");
        //刷新UI 一定要回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self actionModel:model];
            
        });
        
    }
    
    
}

//下载的URL的时效是两小时。两小时后URL失效，因为NSURLSessionDownloadTask的机制问题，只能重新下载。具体详情参见Demo。
- (void)requestPlayInfo:(DXDownloadItem *)model{
    
    
    //请求视频播放信息  获取下载地址 hlsSupport传@"0"
    DWPlayInfo *playinfo = [[DWPlayInfo alloc] initWithUserId:DWACCOUNT_USERID andVideoId:model.video_id key:DWACCOUNT_APIKEY hlsSupport:@"0"];
    //网络请求超时时间
    playinfo.timeoutSeconds =20;
    playinfo.errorBlock = ^(NSError *error){
        
        NSLog(@"请求资源失败");
        
    };
    
    playinfo.finishBlock = ^(NSDictionary *response){
        
        NSDictionary *playUrls =[DWUtils parsePlayInfoResponse:response];
        
        if (!playUrls) {
            //说明 网络资源暂时不可用
        }
        
        NSArray *defArray =[playUrls objectForKey:@"definitions"];
        [defArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([[obj objectForKey:@"definition"] integerValue] ==[model.definition integerValue]) {
                
                *stop =YES;
                //旧的URL
                NSString *downloadUrl =model.playurl;
                //新的URL
                model.playurl =[obj objectForKey:@"playurl"];
                
                
                NSData *resumeData =[[DWDownloadSessionManager manager] resumeDataFromFileWithFilePath:downloadUrl];
                
                // resumeData model.playurl必须有值
                model.resumeData =[[DWDownloadSessionManager manager] newResumeDataFromOldResumeData:resumeData withURLString:model.playurl];
                
                
                model.playurl = downloadUrl;
                
                [self startDownloadWithItem:model];
            }
        }];
    };
    [playinfo start];
}

@end

//
//  DXDownloadItem.m
//  Doxue
//
//  Created by MBAChina-IOS on 15/6/11.
//  Copyright (c) 2015年 MBAChina. All rights reserved.
//

#import "DXDownloadItem.h"
#import "FXKeychain+MBAChina.h"

@implementation DXDownloadItem

-(id)initWithItem:(NSDictionary *)item{
    self = [super init];
    if (self) {
        _video_id = [item objectForKey:@"video_id"];
        _video_title = [item objectForKey:@"video_title"];
        _videoPath = [item objectForKey:@"videoPath"];
        _Id = [[item objectForKey:@"Id"] longLongValue];
        _isfree = [[item objectForKey:@"isfree"] intValue];
        _imageurl = [item objectForKey:@"imageurl"];
        _duration = [item objectForKey:@"duration"];
//        _progress = [[item objectForKey:@"progress"] floatValue];
        _videoFileSize = (NSInteger)[[item objectForKey:@"videoFileSize"] longLongValue];
        _videoDownloadedSize = [self getFileSizeWithPath:_videoPath Error:nil];
        
        _videoDownloadStatus = [[item objectForKey:@"videoDownloadStatus"] intValue];
        _videoURLSourceTye   = [[item objectForKey:@"videoURLSourceTye"] intValue];
        
        
        _course_title = [item objectForKey:@"course_title"];
        _course_id = [[item objectForKey:@"course_id"] longLongValue];
        _orderby = [[item objectForKey:@"orderby"] integerValue];
        _uid = [[item objectForKey:@"uid"] longLongValue];

        _encoded = (item[@"encoded"])?[item[@"encoded"] boolValue]:NO;
    }
    return self;
}
-(NSString *)description{
    return [[self getItemDictionary] description];
}

//获取user信息
- (NSDictionary *)getItemDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    dict[@"video_id"] = _video_id?_video_id:@"";
    dict[@"videoPath"] = _videoPath?_videoPath:@"";
    dict[@"video_title"] = _video_title?_video_title:@"";
    dict[@"duration"] = _duration?_duration:@"";
    dict[@"imageurl"] = _imageurl?_imageurl:@"";
    dict[@"course_title"] = _course_title?_course_title:@"";
    dict[@"orderby"] = @(_orderby);
    dict[@"isfree"] = @(_isfree);
    dict[@"Id"] = @(_Id);
    dict[@"videoFileSize"] = @(_videoFileSize);
    dict[@"videoDownloadedSize"] = @(_videoDownloadedSize);
    dict[@"videoURLSourceTye"] = @(_videoURLSourceTye);
    dict[@"videoDownloadStatus"] = @(_videoDownloadStatus);
    dict[@"course_id"] = @(_course_id);
    dict[@"uid"] = @(_uid);
    NSDictionary *userDict = [[FXKeychain mbachinaKeychain] objectForKey:@"DXUser"];
    if (userDict) {
        DXUser *user = [DXUser userWithDict:userDict];
        if([user.professional isKindOfClass:[NSNull class]]){
            user.professional = @"";
        }
        [DXUserManager sharedManager].user = user?user:nil;
        self.uid = user?user.uid:0;
    }
    else {
        self.uid = 0;
    }
    dict[@"uid"] = @(_uid);
    dict[@"encoded"] = @(_encoded);
    
    return dict;
}

- (NSInteger)getFileSizeWithPath:(NSString *)filePath Error:(NSError **)error
{
    NSFileManager *fileManager = nil;
    NSDictionary *fileAttr = nil;
    NSInteger fileSize;
    
    fileManager = [NSFileManager defaultManager];
    
    fileAttr = [fileManager attributesOfItemAtPath:filePath error:error];
    if (error && *error) {
        return -1;
    }
    
    fileSize = (NSInteger)[[fileAttr objectForKey:NSFileSize] longLongValue];
    
    return fileSize;
}

- (NSString *)videoPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.video_id];

        path = [path stringByAppendingPathExtension:@"pcm"];
        return path;
    }
    
    return @"";
}



@end


@implementation DXDownloadItems

-(instancetype)initWithPath:(NSString *)path{
    self = [super init];
    if (self) {
        NSArray * array = [self readFromPlistFile:path];
        NSMutableArray * items = [NSMutableArray array];
        for (NSDictionary * dict in array) {
            DXDownloadItem * item = [[DXDownloadItem alloc]initWithItem:dict];
            [items insertObject:item atIndex:0];
        }
        _items = items;
    }
    return self;
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    @synchronized(self) {
        DXDownloadItem * item = [self.items objectAtIndex:index];
        NSString *moviePath = [self videoPathForItem:item];
        if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
        }
        [self.items removeObjectAtIndex:index];
    }
}

- (void)removeObject:(DXDownloadItem *)item
{
    @synchronized(self) {
        NSString *moviePath = [self videoPathForItem:item];
        if ([[NSFileManager defaultManager] fileExistsAtPath:moviePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
        }
        [self.items removeObject:item];
    }
}

- (NSString *)videoPathForItem:(DXDownloadItem *)item
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString * moviePath = [NSString stringWithFormat:@"%@/%@.mp4", path, item.video_id];
    BOOL isMp4_Exist = [[NSFileManager defaultManager] fileExistsAtPath:moviePath];
    if (isMp4_Exist)
    {
        return moviePath;
    }
    else
    {
        moviePath = [NSString stringWithFormat:@"%@/%@.pcm", path, item.video_id];
        return moviePath;
    }
}

//此处存在对数组遍历时更改数据源导致的崩溃
-(BOOL)writeToPlistFile:(NSString *)filename{
    @synchronized(self) {
        NSMutableArray * array = [NSMutableArray array];
        [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DXDownloadItem *item = [self.items objectAtIndex:idx];
            NSDictionary *dict  = [item getItemDictionary];
            [array insertObject:dict atIndex:0];}];
        
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * libraryDirectory = [paths objectAtIndex:0];
        NSString * path = [libraryDirectory stringByAppendingPathComponent:filename];
        BOOL didWriteSuccessfull = [data writeToFile:path atomically:YES];
        return didWriteSuccessfull;
    }
}

- (NSArray *)readFromPlistFile:(NSString*)filename{
    
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *path = [libraryDirectory stringByAppendingPathComponent:filename];
        NSLog(@"%@",path);
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return array;}
        return nil;
    }
}

- (void)appendDownloadItems:(NSArray *)items
{
    [self.items addObjectsFromArray:items];
}

- (DXDownloadItem *)findItemWithVideoID:(NSString *)videoID
{
    NSArray *filteredItems = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"video_id = %@", videoID]];
    if (filteredItems.count > 0) {
        return filteredItems.firstObject;}
    return nil;
}


@end

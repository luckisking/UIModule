//
//  DXLiveRequest.m
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/5.
//  Copyright © 2019 都学网. All rights reserved.
//

#define Domain                   @"http://m.doxue.com"
#define getApi(host,api)         [NSString stringWithFormat:@"%@%@",host,api]
#define DXApiFeedback            getApi(Domain,@"/port/comment/do_feedback_add")      //意见反馈
#define DXApiGetNoteInfo         getApi(Domain,@"/port/video2/get_note_list")  //获取全部用户笔记
#define DXGetAllComment          getApi(Domain,@"/port/video/get_comments")     /* 获得关于课程所有评论 */
#define DXApiAddNoteInfo         getApi(Domain,@"/port/video/add_new_note")   //上传新的笔记
#define DXAddNewComment          getApi(Domain,@"/port/video/add_new_comment")  /* 添加新评论 */

#import "DXLiveRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

#import "DXLiveModuleNoteModel.h"

@implementation DXLiveRequest

//退出时候的反馈
- (void)liveFeedbackWithPhone:(NSString *)phone
                        email:(NSString *)email
                          uid:(NSInteger)uid
                          txt:(NSString *)txt
                    courseId:(NSInteger)courseId
                    sectionID:(NSInteger)sectionId
                    success:(nullable success)success
                         fail:(nullable failure)failure {

    /* 软件版本等信息 */
    NSDictionary *dict = @{@"factory_name":@"Apple",
                           @"software_code":@"DXKT",
                           @"device_type":[[UIDevice currentDevice] model],
                           @"os":[[UIDevice currentDevice] systemName],
                           @"os_version": [[UIDevice currentDevice] systemVersion],
                           @"software_version":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"device_type": [[UIDevice currentDevice] name]};
    NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    //上传参数
    NSDictionary *param = @{  @"phone":phone?:@"",
                            @"email":email?:@"",
                            @"uid":uid?@(uid):@(0),
                            @"txt":txt?:@"",
                            @"kid":courseId?@(courseId):@(0),
                            @"section_id":sectionId?@(sectionId):@(0),
                            @"feedback_type":@(2),//直播
                            @"device_info":jsonString
                            };
    [DXLiveApiNetWork post:DXApiFeedback paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        //退出反馈不需要任何返回
    } fail:^(NSError * _Nonnull error) {
    } animated:NO];
}


//获取用户笔记
- (void)getNotelistWithUID:(long long)uid
                  courseID:(long long)courseID
                 chapterID:(long long)chapterID
                     JieID:(long long)JieID
              andPageIndex:(NSInteger)pageIndex
                  PageSize:(NSInteger)pageSize
                   success:(nullable success)success
                      fail:(nullable failure)failure {
    //上传参数
    //目前不需要传uid,原因是 会导致该课程的"公开笔记" 无法显示
    NSDictionary *param = @{ @"kid":courseID?@(courseID):@(0),
                            @"zid":chapterID?@(chapterID):@(0),
                            @"jid":JieID?@(JieID):@(0),
                            @"page":pageIndex?@(pageIndex):@(0),
                            @"pagesize":pageSize?@(pageSize):@(0)
                            };
    [DXLiveApiNetWork get:DXApiGetNoteInfo paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        NSMutableArray *dataSource = [[NSMutableArray alloc]initWithCapacity:0];
        
        NSArray *notes = dic[@"data"][@"notes"];
        if ([notes isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in notes) {
                
                DXLiveModuleNoteModel *noteModel = [[DXLiveModuleNoteModel alloc] init];
                [noteModel setValuesForKeysWithDictionary:dict];
                
                noteModel.noteUserModel = [[DXLiveModuleNoteUserModel alloc]init];
                if (![dict[@"user"] isKindOfClass:[NSNull class]]) {
                    [noteModel.noteUserModel setValuesForKeysWithDictionary:dict[@"user"]];
                    
                }else{
                    noteModel.noteUserModel.uname = @"都学网学员";
                }
                [dataSource insertObject:noteModel atIndex:0];
            }
        }
        
        /* 按时间顺序给笔记排序 */
        [dataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            DXLiveModuleNoteModel *a_noteModel = (DXLiveModuleNoteModel *)obj1;
            DXLiveModuleNoteModel *b_noteModel = (DXLiveModuleNoteModel *)obj2;
            if ([a_noteModel.ctime doubleValue] <= [b_noteModel.ctime intValue]){
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;}
        }];
        if (!dataSource.count) {
            state = NO;
        }
        success((NSDictionary *)dataSource,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];
}

//查询是否评价过本课程
- (void)getCourseComment:(long long)courseID
               pageIndex:(NSInteger)pageIndex
                pageSize:(NSInteger)pageSize
                     uid:(NSInteger)uid
                 success:(nullable success)success
                    fail:(nullable failure)failure {
    //上传参数
    NSDictionary *param = @{@"kid":courseID?@(courseID):@(0),
                            @"uid":uid?@(uid):@(0),
                            @"page_index":pageIndex?@(pageIndex):@(0),
                            @"page_size":pageSize?@(pageSize):@(0)
                            };
    [DXLiveApiNetWork get:DXGetAllComment paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if (state) {
            if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = dic[@"data"];
//                for (id anyObject in dataArray) {
//                    DXCourseCommentModel *model = [DXCourseCommentModel object];
//                    [model setValuesForKeysWithDictionary:anyObject];
//                    [self.dataSource addObject:model];
//                }
                if (!dataArray.count) state = NO;
            }else {
                state = NO;
            }
        }
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:NO];

}
//笔记上传
- (void)uploadNoteWithUID:(long long)uid
                 courseID:(long long)courseID
                chapterID:(long long)chapterID
                    JieID:(long long)JieID
             andNoteTitle:(NSString *)noteTitle
                  Content:(NSString *)content
                 NoteTime:(NSTimeInterval)currentTime
                Thumbnail:(NSString *)imgURL
                andisOpen:(BOOL)isOpen
                imageFile:(nullable NSData *)file
                  success:(nullable success)success
                     fail:(nullable failure)failure {
    //上传参数
    NSDictionary *param = @{ @"uid":uid?@(uid):@(0),
                            @"kid":courseID?@(courseID):@(0),
                            @"zid":chapterID?@(chapterID):@(0),
                            @"jid":JieID?@(JieID):@(0),
                            @"title":noteTitle?:@"",
                            @"note":content?:@"",
                            @"video_time_sec":currentTime?@(currentTime):@"",
                            @"is_open":isOpen?@(isOpen):@"",
                            };
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:param];
    if (file) {
        //有截图
        
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[DXApiAddNoteInfo stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
            [formData appendPartWithFileData:file name:@"thumbnail" fileName:@"photo.png" mimeType:@"image/png"];
        } error:nil];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error){
                failure(error);
            }else{
                NSDictionary * responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                success(responseJson,YES);
                
            }
        }];
        [uploadTask resume];
        
    }else {
        //没有截图
        [mutableDic setValue:@"" forKey:@"thumbnail"];
        [DXLiveApiNetWork post:DXApiAddNoteInfo paramaters:mutableDic success:^(NSDictionary * _Nonnull dic, BOOL state) {
            success(dic,state);
        } fail:^(NSError * _Nonnull error) {
            failure(error);
        } animated:NO];
        
    }
    
  
}

//上传用户评论
- (void)apiAddCommentCourseID:(long long)courseID
                       userID:(long long)uid
                      comment:(NSString *)comment
                        score:(float)score
                    commentID:(NSInteger)commentID
                      success:(nullable success)success
                         fail:(nullable failure)failure {
    //上传参数
    NSDictionary *param = @{ @"uid":uid?@(uid):@(0),
                             @"kid":courseID?@(courseID):@(0),
                             @"comment":commentID?@(commentID):@(0),
                             @"score":score?@(score):@(0),
                             @"commentID":commentID?@(commentID):@(0)
                             };
    [DXLiveApiNetWork post:DXAddNewComment paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        success(dic,state);
    } fail:^(NSError * _Nonnull error) {
        failure(error);
    } animated:YES];
}

//获取CC视频回放下载url
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)getCCPlaybackDownloadUrlUserid:(NSString *)userid
                              recordid:(NSString *)recordid
                               success:(nullable success)success
                                  fail:(nullable failure)failure {
    //上传参数
    NSString *timeString = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString *stringParam = [NSString stringWithFormat:@"recordid=%@&userid=%@&time=%@&salt=6gnTcLBQRuQORaEjkZRk1ThW1vlk5OL2",recordid,userid,timeString];
    const char* original_str= [stringParam UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];
    }
    NSDictionary *param = @{@"recordid":recordid?:@"",
                            @"userid":userid?:@"" ,
                            @"time":timeString ,
                            @"hash":[outPutStr lowercaseString]
                            };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://api.csslcloud.net/api/v2/record/search" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(dictionary,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end

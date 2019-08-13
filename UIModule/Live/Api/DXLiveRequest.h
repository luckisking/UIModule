//
//  DXLiveRequest.h
//  DXLiveSeparation
//
//  Created by doxue_imac on 2019/8/5.
//  Copyright © 2019 都学网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXLiveApiNetWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXLiveRequest : NSObject
//退出时候的反馈
- (void)liveFeedbackWithPhone:(NSString *)phone
                        email:(NSString *)email
                          uid:(NSInteger)uid
                          txt:(NSString *)txt
                     courseId:(NSInteger)courseId
                    sectionID:(NSInteger)sectionId
                      success:(nullable success)success
                         fail:(nullable failure)failure ;
//获取用户笔记
- (void)getNotelistWithUID:(long long)uid
                  courseID:(long long)courseID
                 chapterID:(long long)chapterID
                     JieID:(long long)JieID
              andPageIndex:(NSInteger)pageIndex
                  PageSize:(NSInteger)pageSize
                   success:(nullable success)success
                      fail:(nullable failure)failure ;
//查询是否评价过本课程
- (void)getCourseComment:(long long)courseID
               pageIndex:(NSInteger)pageIndex
                pageSize:(NSInteger)pageSize
                     uid:(NSInteger)uid
                 success:(nullable success)success
                    fail:(nullable failure)failure ;
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
                     fail:(nullable failure)failure ;

//上传用户评论
- (void)apiAddCommentCourseID:(long long)courseID
                       userID:(long long)uid
                      comment:(NSString *)comment
                        score:(float)score
                    commentID:(NSInteger)commentID
                      success:(nullable success)success
                         fail:(nullable failure)failure ;
@end

NS_ASSUME_NONNULL_END

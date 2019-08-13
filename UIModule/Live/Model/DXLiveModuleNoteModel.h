//
//  DXNoteModel.h
//  Doxuewang
//
//  Created by MBAChina-IOS on 16/6/20.
//  Copyright © 2016年 都学网. All rights reserved.
//

//#import "ModelObject.h"

@class DXLiveModuleNoteModel;
@class DXLiveModuleNoteUserModel;
@interface DXLiveModuleNoteModel : NSObject

@property (nonatomic, assign) int noteID;
@property (nonatomic, assign) int pid;
@property (nonatomic, assign) int uid;
@property (nonatomic, assign) int oid;
@property (nonatomic, assign) int zid;
@property (nonatomic, assign) int jid;
@property (nonatomic, strong) NSString *note_title;
@property (nonatomic, strong) NSString *note_description;
@property (nonatomic, strong) NSString *note_source;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *video_time_sec;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *thumbnail_id;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSMutableArray *reply;
@property (nonatomic, strong) NSString *is_open;
@property (nonatomic, strong) NSString *jie_order;
@property (nonatomic, strong) NSString *note_collect_count;
@property (nonatomic, strong) NSString *note_comment_count;
@property (nonatomic, strong) NSString *note_help_count;
@property (nonatomic, strong) NSString *note_vote_count;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *reply_uid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) DXLiveModuleNoteUserModel *noteUserModel;
@property (nonatomic, strong) NSString *video_title;
@property (nonatomic, strong) NSString *zhang_order;
@property (nonatomic, strong) NSString *screenshot;

@end


@interface DXLiveModuleNoteUserModel : NSObject

@property (nonatomic, strong) NSString *headimg;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *uname;

@end




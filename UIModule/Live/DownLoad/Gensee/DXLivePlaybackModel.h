//
//  DXLivePlaybackModel.h
//  Doxuewang
//
//  Created by 侯跃民 on 2019/4/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import <VodSDK/VodSDK.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXLivePlaybackModel : NSObject

@property(nonatomic, copy) NSString *PrimaryTitle;//一级标题,即直播标题
@property(nonatomic, copy) NSString *SecondaryTitle;//二级标题,即直播回放标题
@property(nonatomic, copy) NSString *coverImageUrl;//封面图片
@property(nonatomic,strong)NSString *strDownloadID;//直播回放下载ID
@property(nonatomic,strong)NSString *live_room_id;// 直播房间编号
@property(nonatomic,strong)NSString *courseID;//课程ID
@property(nonatomic,strong)NSString *fileUrl;//资料文件路径
@property (nonatomic,strong)downItem *item;//对应下载的item
@end

NS_ASSUME_NONNULL_END

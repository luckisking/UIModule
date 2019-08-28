//
//  CCDownloadModel.h
//  Demo
//
//  Created by luyang on 2017/4/18.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>

//cc点播sdk把下载功能写在了sdk里面 和这个一模一样，所以都是重复的代码（copy来的） 回放的被摘出来了
// 下载状态
typedef NS_ENUM(NSUInteger, CCPBDownloadState) {
    CCPBDownloadStateNone,        // 未下载 或 下载删除了
    CCPBDownloadStateReadying,    // 等待下载
    CCPBDownloadStateRunning,     // 正在下载
    CCPBDownloadStateSuspended,   // 下载暂停
    CCPBDownloadStateCompleted,   // 下载完成
    CCPBDownloadStateFailed       // 下载失败
};

@class CCDownloadProgress;
@class CCDownloadModel;

// 进度更新block
typedef void (^CCDownloadProgressBlock)(CCDownloadProgress *progress,CCDownloadModel *downloadModel);
// 状态更新block
typedef void (^CCPBDownloadStateBlock)(CCDownloadModel *downloadModel, NSError *error);


/**
 *  下载模型
 */
@interface CCDownloadModel : NSObject

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download info
/// 下载地址
@property (nonatomic, strong, readonly) NSString * downloadURL;
/// 文件名 默认nil 则为下载URL中的文件名
@property (nonatomic, strong, readonly) NSString * fileName;
/// 加密
@property (nonatomic, strong, readonly) NSString * responseToken;
/// 文件类型 1 视频 2 音频
@property (nonatomic, strong, readonly) NSString * mediaType;
/// 文件后缀名
@property (nonatomic ,strong, readonly) NSString * mimeType;
/// 清晰度
@property (nonatomic, strong, readonly) NSString * quality;
/// 清晰度描述
@property (nonatomic, strong, readonly) NSString * desp;
/// VR视频
@property (nonatomic, assign, readonly) BOOL vrMode;
/// 非点播业务不需要关注此值  解压状态 0 未解压  1 解压中 2 解压完成 3 解压失败
@property (nonatomic, assign) NSInteger decompressionState;
//@property (nonatomic, strong) dispatch_queue_t decompressionQueue;

/// URL失效后的断点续传需要设置这个数据
@property (nonatomic, strong, readonly) NSData * resumeData;
/// 自定义字段 根据自己需求适当添加
@property (nonatomic, strong) NSDictionary * othersInfo;

/*
 *用户信息
 *视频videoId
 */
@property (nonatomic, strong, readonly)NSString * userId;

@property (nonatomic, strong, readonly)NSString * videoId;


// >>>>>>>>>>>>>>>>>>>>>>>>>>  task info
/// 下载状态
@property (nonatomic, assign, readonly) CCPBDownloadState state;
/// 下载进度
@property (nonatomic, strong ,readonly) CCDownloadProgress *progress;
/// 存储路径
@property (nonatomic, strong, readonly) NSString * filePath;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download block
/// 下载进度更新block
@property (nonatomic, copy) CCDownloadProgressBlock progressBlock;
/// 下载状态更新block
@property (nonatomic, copy) CCPBDownloadStateBlock stateBlock;


///课程信息
@property(nonatomic, copy) NSString *primaryTitle;//一级标题,即直播标题
@property(nonatomic, copy) NSString *secondaryTitle;//二级标题,即直播回放标题
@property(nonatomic, copy) NSString *sort;//小节,排序标志（不知道原来怎么写的 sectionID?）反正就是小节排序标志，哪个在前哪个在后
@property(nonatomic, copy) NSString *coverImageUrl;//封面图片
@property(nonatomic,strong)NSString *courseID;//课程ID
@property(nonatomic,strong)NSString *fileUrl;//资料文件路径

@end

/**
 *  下载进度
 */
@interface CCDownloadProgress : NSObject

/// 续传大小
@property (nonatomic, assign, readonly) int64_t resumeBytesWritten;
/// 这次写入的数量
@property (nonatomic, assign, readonly) int64_t bytesWritten;
/// 已下载的数量
@property (nonatomic, assign, readonly) int64_t totalBytesWritten;
/// 文件的总大小
@property (nonatomic, assign, readonly) int64_t totalBytesExpectedToWrite;
/// 下载进度
@property (nonatomic, assign, readonly) float progress;
/// 下载速度
@property (nonatomic, assign, readonly) float speed;
/// 下载剩余时间
@property (nonatomic, assign, readonly) int remainingTime;



@end

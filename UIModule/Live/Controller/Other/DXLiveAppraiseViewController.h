//
//  DXLiveAppraiseViewController.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/22.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LiveAppraiseType) {
    LiveAppraiseFinishType,
    LiveAppraiseChooseType,
    PlayBackAppraiseChooseType,
};

@interface DXLiveAppraiseViewController : UIViewController

@property (assign, nonatomic) LiveAppraiseType liveAppraiseType;

// 课程详情界面传过来的课程的Id
@property (nonatomic, assign) NSInteger courseID;

//由于项目分离，需要用户信息（对应主项目中的DXUser类中的属性）
@property (nonatomic, assign) long long  uid;

@end

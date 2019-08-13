
//  DXLiveAppraiseSuccessViewController.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/13.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LiveAppraiseSuccessType) {
    LiveAppraiseSuccessFinishType,
    LiveAppraiseSuccessChooseType,
    PlayBackAppraiseSuccessChooseType,
};

@interface DXLiveAppraiseSuccessViewController : UIViewController

@property (assign, nonatomic) LiveAppraiseSuccessType liveAppraiseSuccessType;

@end

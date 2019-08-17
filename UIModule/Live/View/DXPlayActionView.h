//
//  DXPlayActionView.h
//  Doxuewang
//
//  Created by MBAChina-IOS on 16/10/13.
//  Copyright © 2016年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ActionState) {
    ActionStateBack = 0,
    ActionStateForward ,
    ActionStateCancle
};

@interface DXPlayActionView : UIView

- (void)setItemDuration:(NSInteger)duration;

- (void)setActionStatue:(ActionState)action andSeekTime:(NSInteger)seekTime;

@end

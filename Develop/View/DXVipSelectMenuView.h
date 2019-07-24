//
//  DXVipSelectMenuView.h
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DXCreateUI.h"

@interface DXVipSelectMenuView : UIView
@property (nonatomic, copy) void (^hideHandle)(void);
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        frame:(CGRect)frame
             triangleLocation:(CGPoint)point
                       action:(void(^)(NSInteger index))action
             index:(NSInteger)lastIndex;

+ (void)showWithItems:(NSArray <NSDictionary *>*)array
                 frame:(CGRect)frame
     triangleLocation:(CGPoint)point
               action:(void(^)(NSInteger index))action
    index:(NSInteger)lastIndex;

- (void)show;
- (void)hide;
@end

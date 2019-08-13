//
//  DXLiveInvestigationResultsView.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/17.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface DXLiveInvestigationResultsView : UIView

@property (nonatomic, strong) GSInvestigation *investigation;

@property (nonatomic, strong) NSMutableArray *totalUsersArray;

@property (nonatomic, strong) NSMutableArray *totalArray;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *investigationTableView;

@end

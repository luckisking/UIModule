//
//  DXLiveInvestigationResultsCell.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/17.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface DXLiveInvestigationResultsCell : UITableViewCell

@property (nonatomic, strong) GSInvestigation *investigation;

@property (nonatomic, strong) GSInvestigationQuestion *investigationQuestion;

@property (nonatomic, strong) GSInvestigationOption *investigationOption;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setInvestigationQuestion:(GSInvestigationQuestion *)investigationQuestion options:(GSInvestigationOption *)investigationOption row:(NSInteger)row totalSum:(NSInteger)totalSum totalUsersSum:(NSInteger)totalUsersSum;

@end

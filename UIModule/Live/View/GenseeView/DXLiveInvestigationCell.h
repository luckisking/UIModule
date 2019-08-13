//
//  DXLiveInvestigationCell.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/2.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface DXLiveInvestigationCell : UITableViewCell

@property (nonatomic, strong) GSInvestigation *investigation;

@property (nonatomic, strong) GSInvestigationQuestion *investigationQuestion;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setInvestigationQuestion:(GSInvestigationQuestion *)investigationQuestion row:(NSInteger)row;

@end

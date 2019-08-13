//
//  DXLiveNetworkCell.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/13.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@protocol LiveNetworkSelectedCellDelegate <NSObject>

- (void)handleSelectedButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath;

@end

@interface DXLiveNetworkCell : UITableViewCell

@property (nonatomic, weak) id <LiveNetworkSelectedCellDelegate> delegate;

@property (nonatomic, strong) GSIDCInfo *IDCInfo;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UILabel *contentLabel;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

@end

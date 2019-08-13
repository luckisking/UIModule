//
//  DXLiveShieldView.h
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/22.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol liveShieldViewDelegate <NSObject>

- (void)didSelectShieldButtonTag:(NSInteger)tag index:(NSString *)index;

@end

@interface DXLiveShieldView : UIView

@property (nonatomic, weak) id <liveShieldViewDelegate> delegate;


@end


//cell
@protocol LiveBackSelectedCellDelegate <NSObject>

- (void)handleSelectedBackButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath;

@end

@interface DXLiveBackCell : UITableViewCell

@property (nonatomic, weak) id <LiveBackSelectedCellDelegate> delegate;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UILabel *contentLabel;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

@end

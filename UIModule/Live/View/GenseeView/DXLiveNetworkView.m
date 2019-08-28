//
//  DXLiveNetworkView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/9.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveNetworkView.h"
#import "DXLiveNetworkCell.h"
//#import "UIView+YMTool.h"

static NSString *liveNetworkCellIdentifier = @"DXLiveNetworkCell";

@interface DXLiveNetworkView () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,LiveNetworkSelectedCellDelegate>
{
    NSInteger index;
}
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *closeButton;// 右上角关闭按钮

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *lastSelectedButton;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行

@property (nonatomic, strong) UIView *horizontalLineView;

@property (nonatomic, strong) UIView *verticalLineView;

@end

@implementation DXLiveNetworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(47.5);
            make.right.equalTo(self).offset(-47.5);
            make.centerY.equalTo(self).offset(0);
            make.height.mas_equalTo(340);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.height.mas_equalTo(22);
        }];
        
        [self.contentView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.confirmButton];
        //等间距离布局
        [@[self.cancelButton, self.confirmButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
        [@[self.cancelButton, self.confirmButton] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
            make.height.mas_equalTo(36);
        }];
        
        [self.contentView addSubview:self.tableView];
        [self.tableView registerClass:[DXLiveNetworkCell class] forCellReuseIdentifier:liveNetworkCellIdentifier];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(9.5);
            make.right.equalTo(self.contentView.mas_right).offset(-9.5);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-60);
        }];
        
//        [self.contentView addSubview:self.horizontalLineView];
//        [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.tableView.mas_bottom).offset(0.5);
//            make.left.equalTo(self.contentView);
//            make.right.equalTo(self.contentView);
//            make.height.mas_equalTo(0.5);
//        }];
//
//        [self.contentView addSubview:self.verticalLineView];
//        [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
//            make.left.equalTo(self.cancelButton.mas_right).offset(0);
//            make.right.equalTo(self.confirmButton.mas_left).offset(0);
//            make.height.mas_equalTo(46);
//        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"网络选择";
        _titleLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1/1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGBHex(0x1f1f1f) forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 8;
        _cancelButton.layer.borderColor = RGBHex(0x1f1f1f).CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.tag = 100000;
        [_cancelButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _closeButton.tag = 100000;
        [_closeButton setImage:[UIImage imageNamed:@"circle_close_YM"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:RGBHex(0x1f1f1f) forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _confirmButton.layer.cornerRadius = 8;
        [_confirmButton setBackgroundColor:[UIColor colorWithRed:28/255.0 green:184/255.0 blue:119/255.0 alpha:1/1.0]];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.tag = 110000;
        [_confirmButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)horizontalLineView
{
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = RGBAColor(153, 153, 153, 1) ;
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView
{
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = RGBAColor(153, 153, 153, 1) ;
    }
    return _verticalLineView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DXLiveNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:liveNetworkCellIdentifier];
    if (!cell) {
        cell = [[DXLiveNetworkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveNetworkCellIdentifier];
    }
    cell.delegate = self;
    cell.selectedIndexPath = indexPath;
    [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose"] forState:UIControlStateNormal];
    //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
    if (_selectedIndexPath == indexPath) {
        [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose_selected"] forState:UIControlStateNormal];
        
    }else {
        [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose"] forState:UIControlStateNormal];
        
    }
    cell.IDCInfo = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    index = indexPath.row;
    //之前选中的，取消选择
    DXLiveNetworkCell *celled = [tableView cellForRowAtIndexPath:_selectedIndexPath];
    [celled.selectedButton setImage:[UIImage imageNamed:@"unselected_YM"] forState:UIControlStateNormal];
    celled.delegate = self;
    celled.selectedIndexPath = indexPath;
    //记录当前选中的位置索引
    _selectedIndexPath = indexPath;
    //当前选择的打勾
    DXLiveNetworkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedButton setImage:[UIImage imageNamed:@"selected_YM"] forState:UIControlStateNormal];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)chooseButtonAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectNetworkButtonTag:index:)]) {
        [_delegate didSelectNetworkButtonTag:sender.tag index:index];
    }
}

- (void)handleSelectedButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    DXLiveNetworkCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose"] forState:UIControlStateNormal];
    cell.delegate = self;
    //记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    //当前选择的打勾
    DXLiveNetworkCell *celll = [_tableView cellForRowAtIndexPath:selectedIndexPath];
    [celll.selectedButton setImage:[UIImage imageNamed:@"live_choose_selected"] forState:UIControlStateNormal];
}
@end

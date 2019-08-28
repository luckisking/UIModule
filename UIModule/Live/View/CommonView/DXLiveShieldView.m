//
//  DXLiveShieldView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/22.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveShieldView.h"

static NSString *liveBackCellIdentifier = @"DXLiveBackCell";

@interface DXLiveShieldView () <UITableViewDelegate,UITableViewDataSource,LiveBackSelectedCellDelegate>
{
    NSString *index;
}
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIView *horizontalLineView;

@property (nonatomic, strong) UIView *verticalLineView;

@property (nonatomic, strong) UIButton *watchButton;

@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) UITableView *tableView;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行

@end

@implementation DXLiveShieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = @[@"临时有事",@"播放卡顿严重",@"课程质量差",@"其他"];
        
        NSInteger viewWidth = 280;
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(viewWidth));
            make.height.mas_equalTo(254.5);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.height.mas_equalTo(28);
        }];
        
        [self.contentView addSubview:self.reasonLabel];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16);
            make.right.equalTo(self.contentView.mas_right).offset(-16);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(18.5);
        }];
        
        
        [self.contentView addSubview:self.exitButton];
        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(viewWidth/2-0.25);
        }];
        
        [self.contentView addSubview:self.watchButton];
        [self.watchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.exitButton.mas_right).offset(0.5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(viewWidth/2-0.25);
        }];
        
        [self.contentView addSubview:self.tableView];
        [self.tableView registerClass:[DXLiveBackCell class] forCellReuseIdentifier:liveBackCellIdentifier];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(9.5);
            make.right.equalTo(self.contentView.mas_right).offset(-9.5);
            make.top.equalTo(self.reasonLabel.mas_bottom).offset(4);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-46.5);
        }];
        
        [self.contentView addSubview:self.horizontalLineView];
        [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).offset(0.5);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.contentView addSubview:self.verticalLineView];
        [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.left.equalTo(self.exitButton.mas_right).offset(0);
            make.right.equalTo(self.watchButton.mas_left).offset(0);
            make.height.mas_equalTo(46);
        }];
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
        _titleLabel.font = [UIFont systemFontOfSize:28];
        _titleLabel.text = @"直播进行中";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)reasonLabel
{
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.text = @"您退出的原因是";
        _reasonLabel.textColor = RGBAColor(136, 136, 136, 1);
        _reasonLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _reasonLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DXLiveBackCell *cell = [tableView dequeueReusableCellWithIdentifier:liveBackCellIdentifier];
    if (!cell) {
        cell = [[DXLiveBackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveBackCellIdentifier];
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
    cell.contentLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    index = [NSString stringWithFormat:@"%ld",indexPath.row];
    //之前选中的，取消选择
    DXLiveBackCell *celled = [tableView cellForRowAtIndexPath:_selectedIndexPath];
    [celled.selectedButton setImage:[UIImage imageNamed:@"live_choose"] forState:UIControlStateNormal];
    celled.delegate = self;
    celled.selectedIndexPath = indexPath;
    //记录当前选中的位置索引
    _selectedIndexPath = indexPath;
    //当前选择的打勾
    DXLiveBackCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose_selected"] forState:UIControlStateNormal];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UIButton *)watchButton
{
    if (!_watchButton) {
        _watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_watchButton setImage:[UIImage imageNamed:@"live_continue"] forState:UIControlStateNormal];
        [_watchButton setImage:[UIImage imageNamed:@"live_continue_selected"] forState:UIControlStateHighlighted];
        _watchButton.tag = 50000;
        [_watchButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchButton;
}

- (UIButton *)exitButton
{
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton setImage:[UIImage imageNamed:@"live_exit"] forState:UIControlStateNormal];
        [_exitButton setImage:[UIImage imageNamed:@"live_exit_selected"] forState:UIControlStateHighlighted];
        _exitButton.tag = 60000;
        [_exitButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
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
- (void)chooseButtonAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectShieldButtonTag:index:)]) {
        [_delegate didSelectShieldButtonTag:sender.tag index:index];
    }
}

- (void)handleSelectedBackButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    DXLiveBackCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    [cell.selectedButton setImage:[UIImage imageNamed:@"live_choose"] forState:UIControlStateNormal];
    cell.delegate = self;
    //记录当前选中的位置索引
    _selectedIndexPath = selectedIndexPath;
    //当前选择的打勾
    DXLiveBackCell *celll = [_tableView cellForRowAtIndexPath:selectedIndexPath];
    [celll.selectedButton setImage:[UIImage imageNamed:@"live_choose_selected"] forState:UIControlStateNormal];
}
@end













#pragma mark 退出cell的实现

@implementation DXLiveBackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _selectedButton = [[UIButton alloc] init];
        _selectedButton.userInteractionEnabled = NO;
        [_selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
            make.top.equalTo(self).offset(10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBAColor(51, 51, 51, 1);
        _contentLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedButton.mas_right).offset(12);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self).offset(6.5);
        }];
    }
    return self;
}

- (void)selectedButtonAction:(UIButton *)selectedButton {
    [self.delegate handleSelectedBackButtonActionWithSelectedIndexPath:self.selectedIndexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

@end

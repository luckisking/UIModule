//
//  DXLiveEnteringInvestigationView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/12.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveEnteringInvestigationView.h"

@interface DXLiveEnteringInvestigationView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *investigationImageView;

@end

@implementation DXLiveEnteringInvestigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(47.5);
            make.right.equalTo(self).offset(-47.5);
            make.top.equalTo(self).offset(124);
            make.height.mas_equalTo(254.5);
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(40);
            make.right.equalTo(self.contentView.mas_right).offset(-40);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.height.mas_equalTo(28);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(100);
            make.right.equalTo(self.contentView.mas_right).offset(-100);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(92.5);
        }];
        
        [self.contentView addSubview:self.investigationImageView];
        [self.investigationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(42.5);
            make.right.equalTo(self.contentView.mas_right).offset(-42.5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-19);
            make.height.mas_equalTo(139.5);
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
        _titleLabel.text = @"正在进入答题卡";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:66.0];
        _timeLabel.textColor = RGBAColor(178, 178, 178, 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIImageView *)investigationImageView
{
    if (!_investigationImageView) {
        _investigationImageView = [[UIImageView alloc] init];
        _investigationImageView.image = [UIImage imageNamed:@"live_EnteringInvestigation"];
    }
    return _investigationImageView;
}

@end

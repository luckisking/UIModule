//
//  DXLiveConnectShieldView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/22.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveConnectShieldView.h"

@interface DXLiveConnectShieldView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation DXLiveConnectShieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@280);
            make.height.mas_equalTo(254.5);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(28);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self.contentView).offset(28);
        }];
        
        [self.contentView addSubview:self.contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(0);
            make.left.mas_equalTo(24.5);
            make.right.mas_equalTo(-24.5);
            make.top.equalTo(self.contentLabel).offset(11);
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

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:20];;
        _contentLabel.text = @"正在进入直播间";
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView
{
    if (!_contentImageView){
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"live_content1.png"],
                                                   [UIImage imageNamed:@"live_content2.png"],
                                                   [UIImage imageNamed:@"live_content3.png"],
                                                   [UIImage imageNamed:@"live_content4.png"],
                                                   [UIImage imageNamed:@"live_content5.png"],
                                                   [UIImage imageNamed:@"live_content6.png"],
                                                   [UIImage imageNamed:@"live_content7.png"],
                                                   [UIImage imageNamed:@"live_content8.png"],
                                                   [UIImage imageNamed:@"live_content9.png"],
                                                    nil];
        _contentImageView.animationDuration = 1.0f;
        _contentImageView.animationRepeatCount = 0;
        [_contentImageView startAnimating];
    }
    return _contentImageView;
}

@end

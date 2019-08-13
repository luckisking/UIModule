//
//  DXLiveNetworkCell.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/13.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveNetworkCell.h"

@implementation DXLiveNetworkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _selectedButton = [[UIButton alloc] init];
        _selectedButton.userInteractionEnabled = NO;
        [_selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(36);
            make.top.bottom.equalTo(self).offset(0);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = dominant_BlockColor;
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedButton.mas_right).offset(0);
            make.right.equalTo(self.mas_right).offset(-8.0);
            make.top.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
    }
    return self;
}

- (void)setIDCInfo:(GSIDCInfo *)IDCInfo
{
    _IDCInfo = IDCInfo;
    _contentLabel.text = _IDCInfo.Name;
}
- (void)selectedButtonAction:(UIButton *)selectedButton {
    [self.delegate handleSelectedButtonActionWithSelectedIndexPath:self.selectedIndexPath];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end

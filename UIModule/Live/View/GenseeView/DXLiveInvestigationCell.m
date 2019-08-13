//
//  DXLiveInvestigationCell.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/2.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveInvestigationCell.h"

@interface DXLiveInvestigationCell ()

@property (nonatomic, strong) NSArray *letterArray;
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation DXLiveInvestigationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = dominant_bgColor;
        
        self.letterArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(IPHONE_WIDTH - 60);
        }];
        
    }
    return self;
}

- (void)setInvestigationQuestion:(GSInvestigationQuestion *)investigationQuestion row:(NSInteger)row
{
    _investigationQuestion = investigationQuestion;

    self.titleLabel.text = [NSString stringWithFormat:@"%@. %@",self.letterArray[row],_investigationQuestion.content];
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = CFontColorMore;
    }
    return _titleLabel;
}

@end

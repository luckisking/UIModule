//
//  DXLiveInvestigationResultsCell.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/17.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveInvestigationResultsCell.h"

@interface DXLiveInvestigationResultsCell ()

@property (nonatomic, strong) NSArray *letterArray;

@end

@implementation DXLiveInvestigationResultsCell

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

- (void)setInvestigationQuestion:(GSInvestigationQuestion *)investigationQuestion options:(GSInvestigationOption *)investigationOption row:(NSInteger)row totalSum:(NSInteger)totalSum totalUsersSum:(NSInteger)totalUsersSum
{
    _investigationQuestion = investigationQuestion;
    _investigationOption = investigationOption;
    
    if ([investigationOption isCorrectItem] && [investigationOption isSelected]) {
        
        self.titleLabel.textColor = dominant_GreenColor;
    }
    else if (![investigationOption isCorrectItem] && [investigationOption isSelected])
    {
        self.titleLabel.textColor = RGBAColor(206, 0, 12, 1);
    }
    else
    {
        self.titleLabel.textColor = CFontColorMore;
    }
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

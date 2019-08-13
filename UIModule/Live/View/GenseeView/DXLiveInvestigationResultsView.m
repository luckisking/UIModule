//
//  DXLiveInvestigationResultsView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/17.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveInvestigationResultsView.h"
#import "DXLiveInvestigationResultsCell.h"
#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式
static NSString *liveInvestigationResultsCellIdentifier = @"DXLiveInvestigationResultsCell";

@interface DXLiveInvestigationResultsView () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGFloat height;
}
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITextView *investigationTextView;
@property (nonatomic, strong) DXLiveInvestigationResultsCell *liveInvestigationResultsCell;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) UILabel *topicLabel;
@property (strong, nonatomic) UIButton *progressBtn;
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation DXLiveInvestigationResultsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.navigationView];
        
        [self.navigationView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navigationView.mas_bottom).offset(-6.5);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(26.5);
        }];
        [self.navigationView addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navigationView.mas_bottom).offset(-12);
            make.right.equalTo(self.navigationView.mas_right).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.investigationTableView];
        
        [self.investigationTableView registerClass:[DXLiveInvestigationResultsCell class] forCellReuseIdentifier:liveInvestigationResultsCellIdentifier];
        
    }
    return self;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
        _navigationView.backgroundColor = [UIColor whiteColor];
        if (IS_IPHONE_X) {
            _navigationView.frame = CGRectMake(0, 0, IPHONE_WIDTH, 88);
        }
        else
        {
            _navigationView.frame = CGRectMake(0, 0, IPHONE_WIDTH, 64);
        }
    }
    return _navigationView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:19.0];
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_backButton setTitleColor:CFontColorMore forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UITableView *)investigationTableView
{
    if (!_investigationTableView) {
        _investigationTableView = [[UITableView alloc] init];
        if (IS_IPHONE_X) {
            _investigationTableView.frame = CGRectMake(0, 88, IPHONE_WIDTH, IPHONE_HEIGHT - 88);
        }
        else
        {
            _investigationTableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_HEIGHT - 64);
        }
        _investigationTableView.delegate = self;
        _investigationTableView.dataSource = self;
        _investigationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _investigationTableView.estimatedRowHeight = 50;
        _investigationTableView.rowHeight = UITableViewAutomaticDimension;
        _investigationTableView.tableFooterView = [[UIView alloc] init];
    }
    return _investigationTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.investigation.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GSInvestigationQuestion *question = self.investigation.questions[section];
    if (question.questionType == GSInvestigationQuestionTypeEssay) {
        return 1;
    }
    else
    {
        return question.options.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    self.liveInvestigationResultsCell = [tableView dequeueReusableCellWithIdentifier:liveInvestigationResultsCellIdentifier];
    
    if (!cell) {
        self.liveInvestigationResultsCell = [[DXLiveInvestigationResultsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveInvestigationResultsCellIdentifier];
    }
    GSInvestigationQuestion *investigationQuestion = self.investigation.questions[indexPath.section];
    if (investigationQuestion.questionType == GSInvestigationQuestionTypeEssay) {
        self.liveInvestigationResultsCell.contentView.backgroundColor = dominant_bgColor;
        self.investigationTextView = [[UITextView alloc] init];
        self.investigationTextView.font = [UIFont systemFontOfSize:14];
        self.investigationTextView.textColor = dominant_BlockColor;
        self.investigationTextView.layer.borderWidth = 0.5;
        self.investigationTextView.layer.masksToBounds = YES;
        self.investigationTextView.layer.cornerRadius = 5.6;
        self.investigationTextView.layer.borderColor = live_bottomViewBorderColor.CGColor;
        self.investigationTextView.delegate = self;
        self.investigationTextView.userInteractionEnabled = NO;
        self.investigationTextView.text = investigationQuestion.essayAnswer;
        [self.liveInvestigationResultsCell.contentView addSubview:self.investigationTextView];
        [self.investigationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liveInvestigationResultsCell.contentView).offset(0);
            make.width.mas_equalTo(IPHONE_WIDTH - 30);
            make.left.mas_equalTo(15);
            make.bottom.equalTo(self.liveInvestigationResultsCell.contentView).offset(0);
        }];
        self.liveInvestigationResultsCell.titleLabel.hidden = YES;
    }
    else
    {
        self.liveInvestigationResultsCell.titleLabel.hidden = NO;
        NSLog(@"%ld,%ld",[investigationQuestion.options[indexPath.row] totalSumOfUsers],[self.totalArray[indexPath.section] integerValue]);
        self.progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.progressBtn.titleLabel.font = [UIFont systemFontOfSize:7.0];
        [self.progressBtn setTitleColor:dominant_GreenColor forState:UIControlStateNormal];
        [self.liveInvestigationResultsCell addSubview:self.progressBtn];
        [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liveInvestigationResultsCell.mas_top).offset(5);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-40);
        }];
        _bgLayer = [self buildShapeLayerColor:RGBAColor(216, 216, 216, 1) lineWidth:1];
        [_progressBtn.layer addSublayer:_bgLayer];
        _progressLayer = [self buildShapeLayerColor:dominant_GreenColor lineWidth:1];
        _progressLayer.strokeEnd = 0;
        [_bgLayer addSublayer:_progressLayer];
        
        UILabel *totalLabel = [[UILabel alloc] init];
        totalLabel.textColor = RGBAColor(136, 136, 136, 1);
        totalLabel.font = [UIFont systemFontOfSize:10];
        [self.liveInvestigationResultsCell addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressBtn.mas_right).offset(8);
            make.right.equalTo(self.liveInvestigationResultsCell.mas_right).offset(6);
            make.top.mas_equalTo(6);
            make.height.mas_equalTo(14);
        }];
        
        totalLabel.text = [NSString stringWithFormat:@"%ld人",[investigationQuestion.options[indexPath.row] totalSumOfUsers]];
        CGFloat studyProgress = [investigationQuestion.options[indexPath.row] totalSumOfUsers]/[self.totalArray[indexPath.section] floatValue] * 100;
        NSLog(@"%f",studyProgress);
        [self updateProgressWithNumber:studyProgress];
        [_progressBtn setTitle:[NSString stringWithFormat:@"%ld%%",(long)studyProgress] forState:UIControlStateNormal];
                
        GSInvestigationMyAnswer *myAnswer = [[GSInvestigationMyAnswer alloc] init];
        [self.liveInvestigationResultsCell setInvestigationQuestion:investigationQuestion.options[indexPath.row] options:investigationQuestion.options[indexPath.row] row:indexPath.row  totalSum:[self.totalArray[indexPath.section] integerValue] totalUsersSum:[investigationQuestion.options[indexPath.row] totalSumOfUsers]];
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version < 11.0f){
        [self tableView:self.investigationTableView heightForHeaderInSection:indexPath.section];
    }else
    {
        
    }
    return self.liveInvestigationResultsCell;
}

- (CAShapeLayer *)buildShapeLayerColor:(UIColor *)color lineWidth:(CGFloat)width  {
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 设置path
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 10) radius:10 startAngle:degressToRadius(-85) endAngle:degressToRadius(270) clockwise:YES];
    layer.path = path.CGPath;
    // 设置layer
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = width;
    layer.lineCap = kCALineCapSquare;
    return layer;
}
//更新进度条进度(带动画)
- (void)updateProgressWithNumber:(NSUInteger)number{
    CABasicAnimation * progressAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnima.duration = 1.;
    progressAnima.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    //    progressAnima.repeatCount = HUGE_VALF;//无限次
    progressAnima.fromValue = @0.0;
    progressAnima.toValue   = @(number / 100.0f);
    progressAnima.fillMode = kCAFillModeForwards;
    progressAnima.removedOnCompletion = YES;
    
    [_progressLayer addAnimation:progressAnima forKey:@"progressAnimation"];
    _progressLayer.strokeEnd = number / 100.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.topicView = [[UIView alloc] init];
    self.topicView.backgroundColor = dominant_bgColor;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.5)];
    lineView.backgroundColor = live_segmentLineColor;
    [self.topicView addSubview:lineView];
    GSInvestigationQuestion *investigationQuestion = self.investigation.questions[section];
    self.topicLabel = [[UILabel alloc] init];
    [self.topicLabel sizeToFit];
    self.topicLabel.numberOfLines = 0;
    NSString *content = [NSString stringWithFormat:@"  %ld.%@",section + 1,investigationQuestion.content];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,
                                   dominant_BlockColor,NSForegroundColorAttributeName,nil];
    [attributeStr addAttributes:attributeDict range:NSMakeRange(0, attributeStr.length)];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    if (investigationQuestion.questionType == GSInvestigationQuestionTypeSingleChoice) {
        attach.image = [UIImage imageNamed:@"live_radio"];
    }
    else if (investigationQuestion.questionType == GSInvestigationQuestionTypeMultiChoice) {
        attach.image = [UIImage imageNamed:@"live_multi"];
    }
    else
    {
        attach.image = [UIImage imageNamed:@"live_question_answer"];
    }
    attach.bounds = CGRectMake(0, -2, 34, 18);
    NSAttributedString *attributeStr1 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr insertAttributedString:attributeStr1 atIndex:0];
    self.topicLabel.attributedText = attributeStr;
    [self.topicView addSubview:self.topicLabel];
    
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicView).offset(16);
        make.width.mas_equalTo(IPHONE_WIDTH - 39);
        make.left.mas_equalTo(19.5);
        make.bottom.equalTo(self.topicView).offset(10);
    }];
    height = [self.topicView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = self.topicView.bounds;
    frame.size.height = height;
    self.topicView.frame = frame;
    return self.topicView;
}

- (CGFloat)getTextHeightWithString:(NSString *)string{
    CGSize constraint = CGSizeMake(IPHONE_WIDTH - 90, MAXFLOAT);
    NSAttributedString* attributedText = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGRect rect = [attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    CGFloat height = MAX(size.height, 20);
    return height+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSInvestigationQuestion *investigationQuestion = self.investigation.questions[indexPath.section];
    if (investigationQuestion.questionType == GSInvestigationQuestionTypeEssay) {
        return 194.5;
    }
    else
    {
        return [self getTextHeightWithString:[investigationQuestion.options[indexPath.row] content]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 126;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 100;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)backButtonAction:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

//
//  DXLiveInvestigationView.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/17.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveInvestigationView.h"
#import "DXLiveInvestigationCell.h"

static NSString *liveInvestigationCellIdentifier = @"liveInvestigationCell";

@interface DXLiveInvestigationView () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGFloat height;
}
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, assign) CGFloat keyboardHeight; /* 键盘高度 */
@property (nonatomic, strong) NSMutableArray *myAnswersArray; /* 答案数组 */
@property (nonatomic, strong) UITextView *investigationTextView;
@property (nonatomic, strong) DXLiveInvestigationCell *liveInvestigationCell;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *progessButton;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) UILabel *topicLabel;

@end

@implementation DXLiveInvestigationView

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
        
        [self addSubview:self.footView];
        [self.footView addSubview:self.submitButton];
        
        //键盘的frame即将发生变化时立刻发出该通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
       
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
        [_backButton setTitleColor:RGBAColor(102,102,102,1) forState:UIControlStateNormal];
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
            _investigationTableView.frame = CGRectMake(0, 88, IPHONE_WIDTH, IPHONE_HEIGHT - 152);
        }
        else
        {
            _investigationTableView.frame = CGRectMake(0, 64, IPHONE_WIDTH, IPHONE_HEIGHT - 128);
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

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 64, IPHONE_WIDTH, 64);
        _footView.backgroundColor = RGBAColor(247, 247, 247, 0.75);
    }
    return _footView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(20, 10, IPHONE_WIDTH - 40, 44);
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.backgroundColor =  RGBAColor(28, 184, 119, 1);
        _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 5;
        [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (NSMutableArray *)myAnswersArray
{
    if (!_myAnswersArray) {
        _myAnswersArray = [[NSMutableArray alloc] init];
    }
    return _myAnswersArray;
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
    self.liveInvestigationCell = [tableView dequeueReusableCellWithIdentifier:liveInvestigationCellIdentifier];
    if (!self.liveInvestigationCell) {
        self.liveInvestigationCell = [[DXLiveInvestigationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveInvestigationCellIdentifier];
    }
    else
    {
        //删除cell的所有子视图
        while ([self.liveInvestigationCell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[self.liveInvestigationCell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    GSInvestigationQuestion *investigationQuestion = self.investigation.questions[indexPath.section];
    if (investigationQuestion.questionType == GSInvestigationQuestionTypeEssay) {
        self.liveInvestigationCell.contentView.backgroundColor = RGBAColor(242, 242, 242, 1) ;
        self.investigationTextView = [[UITextView alloc] init];
        self.investigationTextView.font = [UIFont systemFontOfSize:14];
        self.investigationTextView.textColor = RGBAColor(51, 51, 51, 1);
        self.investigationTextView.layer.borderWidth = 0.5;
        self.investigationTextView.layer.masksToBounds = YES;
        self.investigationTextView.layer.cornerRadius = 5.6;
        self.investigationTextView.layer.borderColor = RGBAColor(199, 199, 204, 1).CGColor;
        self.investigationTextView.delegate = self;
        self.investigationTextView.text = investigationQuestion.essayAnswer;
        
        [self.liveInvestigationCell.contentView addSubview:self.investigationTextView];
        [self.investigationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liveInvestigationCell.contentView).offset(0);
            make.width.mas_equalTo(IPHONE_WIDTH - 30);
            make.left.mas_equalTo(15);
            make.bottom.equalTo(self.liveInvestigationCell.contentView).offset(0);
        }];
        self.liveInvestigationCell.titleLabel.hidden = YES;
    }
    else
    {
            self.liveInvestigationCell.titleLabel.hidden = NO;
        NSLog(@"%ld,%ld",(long)[self.totalUsersArray[indexPath.row] integerValue],(long)[self.totalArray[indexPath.section] integerValue]);
            [self.liveInvestigationCell setInvestigationQuestion:investigationQuestion.options[indexPath.row] row:indexPath.row];
//        }
    }

    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version < 11.0f){
        [self tableView:self.investigationTableView heightForHeaderInSection:indexPath.section];
    }else
    {

    }
    return self.liveInvestigationCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.topicView = [[UIView alloc] init];
    self.topicView.backgroundColor = RGBAColor(242, 242, 242, 1) ;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 0.5)];
    lineView.backgroundColor = RGBAColor(233, 233, 233, 1);
    [self.topicView addSubview:lineView];
    GSInvestigationQuestion *investigationQuestion = self.investigation.questions[section];
    self.topicLabel = [[UILabel alloc] init];
    [self.topicLabel sizeToFit];
    self.topicLabel.numberOfLines = 0;
    NSString *content = [NSString stringWithFormat:@"  %ld.%@",section + 1,investigationQuestion.content];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,
                                   RGBAColor(51, 51, 51, 1),NSForegroundColorAttributeName,nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        GSInvestigationQuestion *question = self.investigation.questions[indexPath.section];
        
        if (question.questionType == GSInvestigationQuestionTypeMultiChoice) {
            
            GSInvestigationOption *option = question.options[indexPath.row];
            
            if (!option.isSelected) {
                
                option.isSelected = YES;
                self.liveInvestigationCell = [tableView cellForRowAtIndexPath:indexPath];
                self.liveInvestigationCell.titleLabel.textColor =  RGBAColor(28, 184, 119, 1);
                
                
            }
            else
            {
                
                option.isSelected = NO;
                self.liveInvestigationCell = [tableView cellForRowAtIndexPath:indexPath];
                self.liveInvestigationCell.titleLabel.textColor = RGBAColor(102,102,102,1);
                
            }
        }
        else if (question.questionType == GSInvestigationQuestionTypeSingleChoice) {
            
            GSInvestigationOption *option = question.options[indexPath.row];
            
            if (option.isSelected) {
                
                option.isSelected = NO;
                
                self.liveInvestigationCell = [tableView cellForRowAtIndexPath:indexPath];
                self.liveInvestigationCell.titleLabel.textColor = RGBAColor(102,102,102,1);
                
            }
            else
            {
                
                // 单选题，只能同时选择一个答案
                for (int i = 0; i < question.options.count; i++) {
                    
                    GSInvestigationOption *tempOption = question.options[i];
                    
                    if (i == indexPath.row) {
                        
                        tempOption.isSelected = YES;
                        self.liveInvestigationCell = [tableView cellForRowAtIndexPath:indexPath];
                        self.liveInvestigationCell.titleLabel.textColor =  RGBAColor(28, 184, 119, 1);
                        NSLog(@"cell %d  checked.", i);
                        
                    }
                    else
                    {
                        tempOption.isSelected = NO;
                        
                        NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                        
                        self.liveInvestigationCell = [tableView cellForRowAtIndexPath:otherIndexPath];
                        self.liveInvestigationCell.titleLabel.textColor = RGBAColor(102,102,102,1);
                        
                        NSLog(@"cell %d  unChecked.", i);
                        
                    }
                }
                
            }
        }
}

#pragma mark -- 键盘监听方法
- (void)keyboardChanged:(NSNotification *)notification{

    CGRect frame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect currentFrame;
    currentFrame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        if (frame.origin.y == IPHONE_HEIGHT) {
            resultFrame = CGRectMake(currentFrame.origin.x, IPHONE_HEIGHT - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=0;
            if (IS_IPHONE_X) {
                self.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
            }
            else
            {
                self.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
            }
        }else{
            resultFrame = CGRectMake(currentFrame.origin.x,IPHONE_HEIGHT - currentFrame.size.height - frame.size.height , currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight = frame.size.height;
            if (IS_IPHONE_X) {
                self.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - self.keyboardHeight);
            }
            else
            {
                self.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT - self.keyboardHeight);
            }
            self.frame = resultFrame;
        }
    }];
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    self.inputText = textView.text;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return

        [textView resignFirstResponder];

        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}
- (void)submitClick:(UIButton *)button
{
    for (int i = 0; i < self.investigation.questions.count; i ++)
    {
        GSInvestigationQuestion *que = self.investigation.questions[i];
        for (int j = 0; j < que.options.count; j++) {
            GSInvestigationOption *option = que.options[j];
            if (option.isSelected) {
                GSInvestigationMyAnswer *myAnswer = [[GSInvestigationMyAnswer alloc] init];
                myAnswer.questionID = que.ID;
                myAnswer.optionID = option.ID;
                myAnswer.essayAnswer = self.investigationTextView.text;
                [self.myAnswersArray addObject:myAnswer];
            }
        }
    }
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([self.broadcastManager submitInvestigation:self.investigation.ID answers:self.myAnswersArray]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [self removeFromSuperview];
}

- (void)backButtonAction:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end



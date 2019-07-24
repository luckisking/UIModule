//
//  DXVipGuidanceEvaluationController.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/29.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipGuidanceEvaluationController.h"
#import "DXVipServiceApiRequest.h"

@interface DXVipGuidanceEvaluationController ()

@property (nonatomic, strong) DXVipServiceApiRequest *apiRequest;
@property (nonatomic, strong) UILabel *timeLabel;//显示时间的label
@property (nonatomic, strong) UILabel *scoreLabel;//显示评分的label
@property (nonatomic, strong) NSMutableArray *starArr;//小星星数组
@property (nonatomic, strong) UITextView *textView;//textView
@property (nonatomic, assign) NSInteger index;//小星星的数量

@end

@implementation DXVipGuidanceEvaluationController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.shadowImage = nil;
    
}

- (void)loadView {
    
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"辅导评价";
    _apiRequest = [[DXVipServiceApiRequest alloc] init];
    [self requestEvaluateStateWithStage:_stage];
}



#pragma mark 数据请求

/**查询评价状态*/
- (void)requestEvaluateStateWithStage:(NSString *)stage {
    [_apiRequest evaluateStateStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dic[@"status"] boolValue]) {
            unsigned int star =   (unsigned int)[VSStringFormat(dic[@"data"][@"star_average"]) intValue];
            NSDictionary *studentEvaluate = [dic[@"data"][@"student_evaluate"] isKindOfClass:[NSDictionary class]]?dic[@"data"][@"student_evaluate"]:@{};
            if (![DXCreateUI judgeEmpty:VSStringFormat(studentEvaluate[@"content"]] )) {
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                NSString * dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:VSStringFormat(studentEvaluate[@"ctime"]).longLongValue]];
                dateString = [NSString stringWithFormat:@"个人笔试辅导：%@",dateString];
                 [self setupUIWithTime:dateString star:star content:VSStringFormat(studentEvaluate[@"content"])];
            }else {
                 self.title = @"来为老师做一个评价吧~";
                 [self setupUIWithTime:@"" star:star content:nil];
            }
           
        }
        
    });

    } fail:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark 布局
- (void)setupUIWithTime:(nullable NSString *)time star:(unsigned int)star content:(nullable NSString *)content {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _timeLabel =  [DXCreateUI initLabelWithText:time textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview: _timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?98:74);
        make.left.mas_equalTo(self.view.mas_left).offset(12);
    }];
    _scoreLabel =  [DXCreateUI initLabelWithText:@"评分" textColor:RGBHex(0x333333) font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview: _scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(22);
        make.left.mas_equalTo(self.view.mas_left).offset(14);
    }];
    //小星星
    UIView *starView = [[UIView alloc] init];
    [self.view addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.scoreLabel);
        make.right.mas_equalTo(self.view.mas_right).offset(-14);
    }];
    NSMutableArray *starArr = [NSMutableArray array];
    _starArr = starArr;
    for (int i=0; i<5; i++) {
        UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"大星星未填充"]];
        [starView addSubview:imv];
        [starArr addObject:imv];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.mas_equalTo(starView);
            if (i==0) make.left.mas_equalTo(starView.mas_left).offset(0);
            else make.left.mas_equalTo(((UIImageView *)starArr[i-1]).mas_right).offset(12);
            make.top.mas_equalTo(starView.mas_top);
            make.bottom.mas_equalTo(starView.mas_bottom);
            if (i==4) make.right.mas_equalTo(starView.mas_right);
        }];
        imv.tag = 1000+i;
        if (!content) {
              imv.userInteractionEnabled = YES;
             [imv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:VSAction(self, starClick:)]];
        }
    }
    if (!content) {
        [self setStarNumber:5];//需求要求 默认五颗星亮着
    }else {
        [self setStarNumber:star];
    }

    //横线
    UIView *lineView=  [DXCreateUI initLineViewWithBackgroundColor:RGBHex(0xE6E6E6)];
    [self.view addSubview:lineView];
    lineView.tag = 12306;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scoreLabel.mas_bottom).offset(22);
        make.left.mas_equalTo(self.view.mas_left).offset(14);
        make.right.mas_equalTo(self.view.mas_right).offset(-14);
        make.height.mas_equalTo(1);
    }];
    
    UITextView* textView = [[UITextView alloc] init];
    _textView = textView;
    [self.view addSubview:textView];
    textView.text =  content; //@"老师很好很棒，一直很耐心的讲解，对于很多问题分析的很透彻，同时老师也很幽默，好评";
    textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = RGBHex(0x6A4D31);

    //用户交互
    textView.userInteractionEnabled = YES; ///
    textView.scrollEnabled = YES;//滑动
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(22);
        make.right.mas_equalTo(self.view.mas_right).offset(-14);
        make.left.mas_equalTo(self.view.mas_left).offset(14);
        make.height.mas_equalTo(200);
    }];
    //站位符
    UILabel *placeholderLabel = [DXCreateUI initLabelWithText:@"请及时发表您的评价奥" textColor:RGBHex(0xDDB372) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentLeft];
    [textView addSubview:placeholderLabel];
    if (content) {
        textView.editable = NO;
    }else {
        textView.editable = YES;
        [textView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    }
  
    
    //背景色
    UIView *backView  = [[UIView alloc] init];
    [self.view addSubview:backView];
    backView.backgroundColor =RGBHex(0xF8F9FA);
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    UIButton *button = [DXCreateUI initButtonWithTitle:content?@"关闭":@"提交评价" titleColor:RGBHex(0x6A4D31) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:20];
    [self.view addSubview:button];
    button.layer.borderColor = RGBHex(0xDDB272).CGColor;
    button.layer.borderWidth = 1;
    [self.view bringSubviewToFront:button];
    [DXCreateUI addBackgroundColorShadowWidth:IPHONE_WIDTH-37*2 height:40 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:13 superView:button];
    [button addTarget:self action:@selector(commtiClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setAccessibilityIdentifier:content?@"关闭":@"提交评价"];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-37);
        make.left.mas_equalTo(self.view.mas_left).offset(37);
        make.height.mas_equalTo(40);
    }];
    
    if (!content) {
        [self hidenTimeLabel];
    }
}
                
      
                

- (void)hidenTimeLabel {
    _timeLabel.hidden = YES;
    [_scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?98+17:74+17);
        make.left.mas_equalTo(self.view.mas_left).offset(14);
    }];
    [[self.view viewWithTag:12306] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scoreLabel.mas_bottom).offset(27);
        make.left.mas_equalTo(self.view.mas_left).offset(14);
        make.right.mas_equalTo(self.view.mas_right).offset(-14);
        make.height.mas_equalTo(1);
    }];
}
- (void)setStarNumber:(NSInteger )number {
    for (int i = 0; i<_starArr.count; i++) {
        [((UIImageView *)_starArr[i]) setImage:[UIImage imageNamed:@"大星星未填充"]];
    }
    for (int i = 0; i<number; i++) {
        [((UIImageView *)_starArr[i]) setImage:[UIImage imageNamed:@"大星星"]];
    }
}
#pragma mark  提交评价
- (void) commtiClick:(UIButton *)button {
    if ([button.accessibilityIdentifier isEqualToString:@"提交评价"]) {
        if ([DXCreateUI judgeEmpty:_textView.text]) {
            VSShowMessage(@"请填写评价内容");
            return;
        }
        if (!_index) {
            _index = 5;
        }
        [_apiRequest evaluateCommitStage:_stage star:VSStringFormatInteger(_index) content:_textView.text success:^(NSDictionary * _Nonnull dic, BOOL state) {
              VSShowMessage(dic[@"message"]);
        } fail:^(NSError * _Nonnull error) {
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)starClick:(UITapGestureRecognizer *)tap {
    _index =  tap.view.tag-999;
    [self setStarNumber:_index];
}
                
                
@end

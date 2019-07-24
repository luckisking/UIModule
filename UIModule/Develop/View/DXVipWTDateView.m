//
//  DXVipWTDateView.m
//  Doxuewang
//
//  Created by xjq on 2019/6/10.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipWTDateView.h"
#import <FSCalendar/FSCalendar.h>
#import "DXVipServiceNetWork.h"

@interface DXVipWTDateView ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

@property (nonatomic,strong) UILabel *dateLeftlabel;//显示今天是第几天
@property (nonatomic,strong) UIScrollView *scrollView;//背景可以滑动的的视图

@property (nonatomic,strong) NSDictionary *data;//数据

@end
@implementation DXVipWTDateView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target data:(NSDictionary *)data {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = target;
        _data = data;
        [self setupUI];
    }
    return self;
    
}

#pragma mark 简单处理数据



#pragma mark 布局
- (void)setupUI {
    
    self.backgroundColor = RGBHex(0xF8F9FA);
    

    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, iPhoneX?34:0, 0));
    }];
    [self layoutIfNeeded];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
  
    #pragma mark 第一行(显示阶段)
    CGFloat LabelWidth = (self.frame.size.width-14*5)/4;
    CGFloat LabelHeight = IPHONE_HEIGHT>667?26*1.1:26;
    UILabel *label1 =  [DXCreateUI initLabelWithText:@"基础阶段" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentCenter];
        [self.scrollView addSubview: label1];
        [self setBgcLabel:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView.mas_top).offset(iPhoneX?108:84);
            make.left.mas_equalTo(self.scrollView.mas_left).offset(14);
            make.size.mas_equalTo(CGSizeMake(LabelWidth, LabelHeight));
        }];
    UIImageView *imv1 = [[UIImageView alloc] initWithImage:VipServiceImage(@"向右箭头")];
        [self.scrollView addSubview:imv1];
        [imv1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label1.mas_right).offset(4);
            make.centerY.mas_equalTo(label1);
            make.width.mas_equalTo(6);
        }];
    UILabel *label2 =  [DXCreateUI initLabelWithText:@"系统阶段" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentCenter];
        [self.scrollView addSubview: label2];
         [self setBgcLabel:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label1);
            make.left.mas_equalTo(imv1.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(LabelWidth, LabelHeight));
        }];
    UIImageView *imv2 = [[UIImageView alloc] initWithImage:VipServiceImage(@"向右箭头")];
        [self.scrollView addSubview:imv2];
        [imv2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label2.mas_right).offset(4);
            make.centerY.mas_equalTo(label1);
            make.width.mas_equalTo(6);
        }];
    UILabel *label3 =  [DXCreateUI initLabelWithText:@"强化阶段" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentCenter];
        [self.scrollView addSubview: label3];
        [self setBgcLabel:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label1);
            make.left.mas_equalTo(imv2.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(LabelWidth, LabelHeight));
        }];
    UIImageView *imv3 = [[UIImageView alloc] initWithImage:VipServiceImage(@"向右箭头")];
        [self.scrollView addSubview:imv3];
        [imv3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label3.mas_right).offset(4);
            make.centerY.mas_equalTo(label1);
            make.width.mas_equalTo(6);
        }];
    UILabel *label4 =  [DXCreateUI initLabelWithText:@"冲刺阶段" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentCenter];
        [self.scrollView addSubview: label4];
        [self setBgcLabel:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label1);
            make.left.mas_equalTo(imv3.mas_right).offset(4);
            make.size.mas_equalTo(CGSizeMake(LabelWidth, LabelHeight));
        }];
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    label1.userInteractionEnabled = YES;
    label2.userInteractionEnabled = YES;
    label3.userInteractionEnabled = YES;
    label4.userInteractionEnabled = YES;
    label1.tag = 1601;
    label2.tag = 1602;
    label3.tag = 1603;
    label4.tag = 1604;
    [label1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, myStageClickMethod:)]];
    [label2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, myStageClickMethod:)]];
    [label3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, myStageClickMethod:)]];
    [label4 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, myStageClickMethod:)]];
    NSInteger stage =  [_data[@"stage"] integerValue];
    if (stage==1)   [label1.layer addSublayer:[self getBackgroundColorShadowWidth:LabelWidth height:LabelHeight superView:label1]];
    if (stage==2)   [label2.layer addSublayer:[self getBackgroundColorShadowWidth:LabelWidth height:LabelHeight superView:label2]];
    if (stage==3)   [label3.layer addSublayer:[self getBackgroundColorShadowWidth:LabelWidth height:LabelHeight superView:label3]];
    if (stage==4)   [label4.layer addSublayer:[self getBackgroundColorShadowWidth:LabelWidth height:LabelHeight superView:label4]];
    NSArray * arr = [_data[@"months"] isKindOfClass:[NSArray class]]?_data[@"months"]:@[];
    if (!arr.count) {
        [self addNonePlanViewWithTopView:label1];
        return;
    }
    
    #pragma mark 第二行（显示第几天）
    UILabel *dateRightlabel =  [DXCreateUI initLabelWithText:@"点击日期进入当日计划" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentRight];
        [self.scrollView addSubview: dateRightlabel];
        [dateRightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label1.mas_bottom).offset(40);
            make.right.mas_equalTo(self.mas_right).offset(-14);
        }];
    _dateLeftlabel =  [DXCreateUI initLabelWithText:_data[@"myTime"] textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview: _dateLeftlabel];
        [_dateLeftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(dateRightlabel);
            make.left.mas_equalTo(self.scrollView.mas_left).offset(14);
        }];
        if ([_dateLeftlabel.text hasPrefix:@"第"]) [self setdateLabelText:_dateLeftlabel.text];
      

    #pragma mark 第三行（显示颜色标志说明）
    UIView *colorSymbolView =  [self getColorSymbolView];
        [self.scrollView addSubview: colorSymbolView];
        [colorSymbolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dateRightlabel.mas_bottom).offset(11);
            make.right.mas_equalTo(self.mas_right);
        }];
     #pragma mark 第四行(日历控件)
    UIView*calenderView =  [self getFSCalendarView];
        [calenderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(colorSymbolView.mas_bottom).offset(10);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
        }];
    
      #pragma mark 第五行(学习路径和学习报告)
    UIView *towBtn = [self getTwoButtonView];
        [towBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(calenderView.mas_bottom).offset(0);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
        }];
      #pragma mark 第六行(底部老师信息)
    UIView *bottomView = [self getBottomView];
         bottomView.backgroundColor = RGBHex(0xF8F9FA);
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(towBtn.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
        }];
    [_scrollView layoutIfNeeded];
    UIView *bottomBackView = [[UIView alloc] init];
    [self.scrollView addSubview:bottomBackView];
    bottomBackView.backgroundColor =  RGBHex(0xF8F9FA);
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
        if (CGRectGetMaxY(bottomView.frame)>self.scrollView.frame.size.height) {
            make.height.mas_equalTo(0);
        }else {
            make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneX?-34:0);
            
        };
    }];
    [_scrollView layoutIfNeeded];
    CGFloat iPhoneHeight = iPhoneX?-34:0;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width,CGRectGetMaxY(bottomBackView.frame)>self.frame.size.height+iPhoneHeight?CGRectGetMaxY(bottomBackView.frame):self.frame.size.height+iPhoneHeight);
}

/**
 Description
没有阶段计划安排
 @param  TopView 布局使用，
 @return view
 */
- (UIView *)addNonePlanViewWithTopView:(UILabel *)TopView {
    //
    UIView *view = [[UIView alloc] init];
    [self.scrollView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TopView.mas_bottom).offset(66);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    UIImageView *imv = [[UIImageView alloc] initWithImage:VipServiceImage(@"无学习计划")];
    [view addSubview:imv];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top).offset(50);
        make.centerX.mas_equalTo(view);
    }];
    UILabel *label = [DXCreateUI initLabelWithText:@"暂未安排此阶段学习计划\n请等待班主任为您定制" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:(NSTextAlignmentCenter)];
    [view addSubview:label];
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imv.mas_bottom).offset(30);
        make.centerX.mas_equalTo(view);
    }];
    return view;
}


- (void)setBgcLabel:(UILabel *)label {
        label.layer.cornerRadius =  13;
        label.backgroundColor = RGBHex(0xE6E6E6);
        label.layer.masksToBounds = YES;
}
- (CAGradientLayer *)getBackgroundColorShadowWidth:(CGFloat)width height:(CGFloat)height superView:(UILabel *)label {
        label.textColor = RGBHex(0x392816);
        label.layer.borderWidth = 1;
        label.layer.borderColor = RGBHex(0xDDB272).CGColor;
        label.backgroundColor = [UIColor clearColor];
        label.layer.cornerRadius = height/2;
        label.layer.masksToBounds = NO;
        //设置渐变色
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, width, height);
        gradient.colors = [NSArray arrayWithObjects:(id)RGBHex(0xFFF5E4 ).CGColor,(id)RGBHex(0xE8C998).CGColor,nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        gradient.cornerRadius = height/2;
        return gradient;
}
//颜色说明View
- (UIView *)getColorSymbolView {
    UIView *baseView = [[UIView alloc] init];

    UILabel *label1 = [DXCreateUI initLabelWithText:@"未开始" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] textAlignment:(NSTextAlignmentCenter)];
        [baseView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(baseView.mas_right).offset(-14);
            //撑开父视图
            make.top.mas_equalTo(baseView.mas_top);
            make.bottom.mas_equalTo(baseView.mas_bottom);
        }];
    UIView *circleView1 = [self getCircleView:RGBHex(0xE6E6E6)];
        [baseView addSubview:circleView1];
        [circleView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(label1.mas_left).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    UILabel *label2 = [DXCreateUI initLabelWithText:@"未完成" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] textAlignment:(NSTextAlignmentCenter)];
        [baseView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(circleView1.mas_left).offset(-8);
        }];
    UIView *circleView2 = [self getCircleView:RGBHex(0x999999)];
        [baseView addSubview:circleView2];
        [circleView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(label2.mas_left).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    UILabel *label3 = [DXCreateUI initLabelWithText:@"延期完成" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] textAlignment:(NSTextAlignmentCenter)];
        [baseView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(circleView2.mas_left).offset(-8);
        }];
    UIView *circleView3 = [self getCircleView:RGBHex(0xFBB152)];
        [baseView addSubview:circleView3];
        [circleView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(label3.mas_left).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    UILabel *label4 = [DXCreateUI initLabelWithText:@"按时完成" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:11] textAlignment:(NSTextAlignmentCenter)];
        [baseView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(circleView3.mas_left).offset(-8);
        }];
    UIView *circleView4 = [self getCircleView:RGBHex(0x1CB877)];
        [baseView addSubview:circleView4];
        [circleView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(baseView);
            make.right.mas_equalTo(label4.mas_left).offset(-4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(baseView.mas_left);
        }];
    return  baseView;
}
- (UIView *)getCircleView:(UIColor *)color {
      UIView *circleView = [[UIView alloc] init];
            circleView.backgroundColor  = color;
            circleView.layer.masksToBounds = YES;
            circleView.layer.cornerRadius = 5;
    return  circleView;
}

- (void)setdateLabelText:(NSString *)string {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        //设置字号
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:36] range:NSMakeRange(2, string.length-3)];
        //设置文字颜色
//        [str addAttribute:NSForegroundColorAttributeName value:RGBHex(0x6A4D31) range:NSMakeRange(2, string.length-3)];
        _dateLeftlabel.attributedText = str;
}


#pragma mark 日历控件父视图
- (UIView *)getFSCalendarView {
    UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
    UIView *weekView = [[UIView alloc] init];
        [view addSubview:weekView];
        [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.right.mas_equalTo(view.mas_right);
            make.left.mas_equalTo(view.mas_left);
            make.height.mas_equalTo(26);
        }];
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
    NSMutableArray *weeklabelArr = [NSMutableArray array];
    for (int i=0; i<7; i++) {
        UILabel *label = [DXCreateUI initLabelWithText:arr[i] textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] textAlignment:(NSTextAlignmentCenter)];
            [weekView addSubview:label];
            [weeklabelArr addObject:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(weekView);
                make.width.mas_equalTo(self.frame.size.width/7);
                if (i==0) make.left.mas_equalTo(weekView.mas_left).offset(0);
                else make.left.mas_equalTo(((UIImageView *)weeklabelArr[i-1]).mas_right);
            }];
    }
    //横线
    UIView *lineView=  [DXCreateUI initLineViewWithBackgroundColor:RGBHex(0xDDB372)];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weekView.mas_bottom).offset(8);
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.right.mas_equalTo(view.mas_right).offset(-15);
            make.height.mas_equalTo(1);
        }];
    //日历控件
    NSMutableArray *fscArr = [NSMutableArray array];
    NSArray *dateArray =   _data[@"months"];
    for (int i=0; i<dateArray.count; i++) {
        NSString *dateString = [NSString stringWithFormat:@"%@年%@月",dateArray[i][@"year"] ,dateArray[i][@"month"]];
        if (dateString.length<7) continue;
        UIView *fscView = [self getFSCalendarViewSubView:i date:dateString];
            [view addSubview:fscView];
            [fscArr addObject:fscView];
            [fscView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i==0) make.top.mas_equalTo(lineView.mas_bottom).offset(9);
                else make.top.mas_equalTo(((UIView *)fscArr[i-1]).mas_bottom);
                make.left.mas_equalTo(view.mas_left);
                make.right.mas_equalTo(view.mas_right);
                if (i==dateArray.count-1) make.bottom.mas_equalTo(view.mas_bottom);
                
            }];
    }
    return view;
}
#pragma mark 日历控件初始化
- (UIView *)getFSCalendarViewSubView:(NSInteger)months date:(NSString *)dateString{
    UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
    UILabel* FirstYearLabel = [DXCreateUI initLabelWithText:@"" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"DINAlternate-Bold" size:12] textAlignment:(NSTextAlignmentLeft)];
        [view addSubview:FirstYearLabel];
        [FirstYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.left.mas_equalTo(view.mas_left).offset(11);
            make.height.mas_equalTo(17);
        }];
    FSCalendar *fsc = [[FSCalendar alloc] init];
        fsc.delegate = self;
        fsc.dataSource = self;
        [view addSubview:fsc];
        fsc.scrollEnabled = NO;
        [fsc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(FirstYearLabel.mas_bottom).offset(0);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width,216));
            make.left.mas_equalTo(view.mas_left);
        }];
        fsc.firstWeekday = 2;     //设置周一为第一天
        fsc.headerHeight = 0.0f; // 当不显示头的时候设置
        fsc.weekdayHeight = 0.0f;// 当不显示周的时候设置
        fsc.rowHeight = 25;
        fsc.placeholderType = FSCalendarPlaceholderTypeNone; //月份模式时，只显示当前月份
        //    fsc.appearance.weekdayTextColor = RGBHex(0x6A4D31);//没使用
        //    fsc.appearance.weekdayFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];//没使用
        //   fsc.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];  // 设置周次是中文显示
        //    fsc.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;  // 设置周次为一,二（没用上）
        //设置具体的月份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
//    if (months!=0) {
//        NSCalendar *nsc = [NSCalendar currentCalendar];
//        NSDate *nextMonth = [nsc dateByAddingUnit:NSCalendarUnitMonth value:months toDate:fsc.currentPage options:0];
//            [fsc setCurrentPage:nextMonth animated:YES];
//        NSLog(@"======%@",nextMonth);
//            FirstYearLabel.text = [formatter stringFromDate:nextMonth];
//    }else{
//            FirstYearLabel.text = [formatter stringFromDate:[NSDate date]];
//    }
    //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
    [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
    NSDate *stringDate = [formatter dateFromString:[NSString stringWithFormat:@"%@08日",dateString]];
    [fsc setCurrentPage:stringDate animated:YES];
    FirstYearLabel.text = dateString;
    return view;
    
}
- (UIView *)getTwoButtonView {
    UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
    UIView *lineView=  [DXCreateUI initLineViewWithBackgroundColor:RGBHex(0xDDB372)];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(20);
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.right.mas_equalTo(view.mas_right).offset(-15);
            make.height.mas_equalTo(1);
        }];
    CGFloat labelHeight = iPhoneX?32*1.1:32;
    UILabel *learnMapLabel =  [DXCreateUI initLabelWithText:@"学习路径图" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:NSTextAlignmentCenter];
        [view addSubview: learnMapLabel];
        [self setBgcLabel:learnMapLabel];
        [learnMapLabel.layer addSublayer:[self getBackgroundColorShadowWidth:110 height:labelHeight superView:learnMapLabel]];
        learnMapLabel.textColor = RGBHex(0x6A4D31);
        [learnMapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_top).offset(20);
            make.bottom.mas_equalTo(view.mas_bottom).offset(-20);
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(110, labelHeight));
        }];
        learnMapLabel.userInteractionEnabled = YES;
        [learnMapLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:VSAction(self, learnPathlickMethod)]];
    UILabel *learnReportLabel =  [DXCreateUI initLabelWithText:@"学习报告" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:NSTextAlignmentCenter];
        [view addSubview: learnReportLabel];
        [self setBgcLabel:learnReportLabel];
        [learnReportLabel.layer addSublayer:[self getBackgroundColorShadowWidth:95 height:labelHeight superView:learnReportLabel]];
        learnReportLabel.textColor = RGBHex(0x6A4D31);
        [learnReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_top).offset(20);
            make.bottom.mas_equalTo(view.mas_bottom).offset(-20);
            make.right.mas_equalTo(view.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(95, labelHeight));
        }];
        learnReportLabel.userInteractionEnabled = YES;
        [learnReportLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:VSAction(self, reportClickMethod)]];
    return view;
}

- (UIView *)getBottomView {
    UIView *bottonBackView = [[UIView alloc] init];
        [self.scrollView addSubview:bottonBackView];
    NSDictionary *dic = [_data[@"teacherData"][@"teacher_info"] isKindOfClass:[NSDictionary class]]?_data[@"teacherData"][@"teacher_info"] :@{};
    UIView *view = [[UIView alloc] init];
        [bottonBackView addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottonBackView.mas_top).offset(10);
            make.right.mas_equalTo(bottonBackView.mas_right);
            make.left.mas_equalTo(bottonBackView.mas_left);
            make.bottom.mas_equalTo(bottonBackView.mas_bottom).offset(-30);
        }];
    CGFloat labelpadding = -2;//字体内边距与设计图的差异
    UIImageView *imv = [[UIImageView alloc] init];
    [imv setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
        [view addSubview:imv];
        imv.layer.cornerRadius = 30;
        imv.layer.masksToBounds = YES;
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(view.mas_left).offset(14);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    UILabel *nameLabel = [DXCreateUI initLabelWithText:dic[@"name"] textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] textAlignment:NSTextAlignmentLeft];
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(14+labelpadding);
            make.left.mas_equalTo(imv.mas_right).offset(11);
        }];
    UILabel *iphoneLabel = [DXCreateUI initLabelWithText:dic[@"phone"] textColor:RGBHex(0xDDB372) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:NSTextAlignmentLeft];
        [view addSubview:iphoneLabel];
        [iphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4+labelpadding);
            make.left.mas_equalTo(imv.mas_right).offset(11);
        }];
    UIView *starView = [self getStarView];
        [view addSubview:starView];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iphoneLabel.mas_bottom).offset(11+labelpadding-5);
            make.height.mas_equalTo(15);
            make.bottom.mas_equalTo(view.mas_bottom).offset(-18);//撑开父视图
            make.left.mas_equalTo(imv.mas_right).offset(11);
        }];
    CGFloat labelHeight = iPhoneX?32*1.1:32;
    UILabel *evaluateLabel =  [DXCreateUI initLabelWithText:@"我要评价" textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] textAlignment:NSTextAlignmentCenter];
        [view addSubview: evaluateLabel];
        [self setBgcLabel:evaluateLabel];
        [evaluateLabel.layer addSublayer:[self getBackgroundColorShadowWidth:95 height:labelHeight superView:evaluateLabel]];
        evaluateLabel.textColor = RGBHex(0x6A4D31);
        [evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.right.mas_equalTo(view.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(95, labelHeight));
        }];
        evaluateLabel.userInteractionEnabled = YES;
        [evaluateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:VSAction(self, evaluateClickMethod)]];
    return bottonBackView;
}
- (UIView *)getStarView {

    UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
    NSMutableArray *starArr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIImageView *imv = [[UIImageView alloc] initWithImage:VipServiceImage(@"大星星")];
            [view addSubview:imv];
            [starArr addObject:imv];
            [imv mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(14, 14));
                make.width.mas_equalTo(15);
                make.centerY.mas_equalTo(view);
                if (i==0) make.left.mas_equalTo(view.mas_left).offset(0);
                else make.left.mas_equalTo(((UIImageView *)starArr[i-1]).mas_right).offset(6);
                make.top.mas_equalTo(view.mas_top);
                make.bottom.mas_equalTo(view.mas_bottom);
                if (i==4) make.right.mas_equalTo(view.mas_right);
            }];
        
    }
    return view;
}

#pragma mark 点击事件传递回ViewController

#pragma mark 日历控件的代理方法
//设置今天
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date {
    if (NSOrderedSame == [self compareFirstDate:date secondDate:[NSDate date]]){
        return @"今";
    }else{
        return nil;
    }
}
//设置字体颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    //不在阶段区间内黑色  在阶段区间内白色
    for (NSDictionary *month in _data[@"months"]) {
        NSArray *days = [month[@"days"] isKindOfClass:[NSArray class]]?month[@"days"]:@[];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
        for (NSDictionary *day in days) {
            NSDate *dayDate = [formatter dateFromString:day[@"day"]];
            if (NSOrderedSame==[self compareFirstDate:date secondDate:dayDate]) {
                 return  RGBHex(0xFFFFFF);
            }
        }
    }
    return RGBHex(0x666666);

}
//设置背景色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    
    //在阶段区间内设置相应的颜色 不在为白色背景
    for (NSDictionary *month in _data[@"months"]) {
        NSArray *days = [month[@"days"] isKindOfClass:[NSArray class]]?month[@"days"]:@[];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
        [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
//        NSDate *startDate = [formatter dateFromString:_data[@"myStartTime"]];
//        NSDate *endDate = [formatter dateFromString:_data[@"myEndTime"]];
//        if (NSOrderedAscending==[self compareFirstDate:date secondDate:startDate]) {
//            return RGBHex(0xFFFFFF);//小（不在开始和结束区间）
//        }
//        if (NSOrderedDescending==[self compareFirstDate:date secondDate:endDate]) {
//            return RGBHex(0xFFFFFF);//大 （不在开始和结束区间）
//        }
        
        for (NSDictionary *day in days) {
                NSDate *dayDate = [formatter dateFromString:day[@"day"]];
                if (NSOrderedSame==[self compareFirstDate:date secondDate:dayDate]) {
                    NSInteger finishState = [day[@"finish_state"] integerValue];
                    //0-未完成，1-正常完成，2-延期完成，3-未开始
                    if (finishState==0)   return RGBHex(0x999999);
                    if (finishState==1)   return RGBHex(0x1CB877);
                    if (finishState==2)   return RGBHex(0xFBB152);
                    if (finishState==3)   return RGBHex(0xE6E6E6);
                }
        }
    }
    return RGBHex(0xFFFFFF);
}
//选中某一天进行相关操作
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {

    FSCalendarCell *cell = [calendar cellForDate:date atMonthPosition:monthPosition];
        //去掉选中时候的背景色
        cell.selected = NO;
        [cell performSelecting];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    [formatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
 
    BOOL contain = NO;
    for (NSDictionary *month in _data[@"months"]) {
        NSArray *days = [month[@"days"] isKindOfClass:[NSArray class]]?month[@"days"]:@[];
        for (NSDictionary *day in days) {
            NSDate *dayDate = [formatter dateFromString:day[@"day"]];
            if (NSOrderedSame==[self compareFirstDate:date secondDate:dayDate]) {
                contain = YES;
            }
        }
    }
    if (!contain) {
//        VSShowMessage(@"当天没有学习计划");
        return;
    }
    if ([self.delegate respondsToSelector:@selector(clickWithString:string:)]) {
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString =  [formatter stringFromDate:date];
            NSLog(@"%@", dateString);
            [self.delegate clickWithString:dateString string:_data[@"stage"]];
    }
    
   
}
- (NSComparisonResult)compareFirstDate:(NSDate *)date1 secondDate:(NSDate *)date2 {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMdd"];
    return [[formatter dateFromString:[formatter stringFromDate:date1]]compare:[formatter dateFromString:[formatter stringFromDate:date2]]];
}


#pragma mark 回传代理方法
- (void)learnPathlickMethod {
    
    if ([self.delegate respondsToSelector:@selector(clickWithDescription:param:)]) {
        [self.delegate clickWithDescription:@"学习路径图" param:@{@"param1":_data[@"stage"]}];
    }
}
- (void)reportClickMethod {
    
    if ([self.delegate respondsToSelector:@selector(clickWithDescription:param:)]) {
        [self.delegate clickWithDescription:@"学习报告" param:@{@"param1":_data[@"stage"]}];
    }
}
- (void)evaluateClickMethod {

    if ([self.delegate respondsToSelector:@selector(clickWithDescription:param:)]) {
        [self.delegate clickWithDescription:@"我要评价" param:@{@"param1":_data[@"stage"]}];
    }
}
@end

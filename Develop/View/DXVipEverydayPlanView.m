//
//  DXVipEverydayPlanView.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/14.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipEverydayPlanView.h"
#import <SPPageMenu/SPPageMenu.h>


/**
  每天计划的主页面
 */
@interface DXVipEverydayPlanView ()<SPPageMenuDelegate>

//显示今天是第几天
@property (nonatomic,strong) UILabel *dateLeftlabel;
//显示年月日
@property (nonatomic,strong) UILabel *timelabel;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat scrollViewContentWidth;

//学习对话框
@property (nonatomic, strong) UIView *bgStudyView;
//院校对话框
@property (nonatomic, strong) UIView *bgAcademyView;


@end

@implementation DXVipEverydayPlanView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = target;
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark  弹出学习提示对话框

/**
  弹出学习提示对话框
 */
- (void)promptStudyDialogBox {
    _bgStudyView = [[UIView alloc] initWithFrame:self.bounds];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_bgStudyView];
    _bgStudyView.backgroundColor = [RGBHex(0x000000) colorWithAlphaComponent:0.5];
    UIView *boxView = [[UIView alloc] init];
    [_bgStudyView addSubview:boxView];
    boxView.layer.cornerRadius = 12;
    boxView.backgroundColor = [UIColor whiteColor];
    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(window);
        make.width.mas_equalTo(IPHONE_WIDTH-36*2);
    }];
    UILabel * titleLabel  = [DXCreateUI initLabelWithText:@"亲爱的同学，您有以前的课程还未看\n完，是否接着上次的课程继续学习？" textColor:RGBHex(0x101010) font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textAlignment:(NSTextAlignmentCenter)];
    [boxView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxView.mas_top).offset(20);
        make.left.mas_equalTo(boxView.mas_left).offset(20);
        make.right.mas_equalTo(boxView.mas_right).offset(-20);
    }];
    UIButton *yesButton = [DXCreateUI initButtonWithTitle:@"好，接着上次学" titleColor:RGBHex(0x6A4D31) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:19];
    yesButton.layer.borderColor = RGBHex(0xDDB272).CGColor;
    yesButton.layer.borderWidth = 1;
    [boxView addSubview:yesButton];
    [DXCreateUI addBackgroundColorShadowWidth:140 height:38 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:19 superView:yesButton];
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    [yesButton addTarget:self.delegate action:VSAction(self.delegate, thePreviousDay) forControlEvents:(UIControlEventTouchUpInside)];
    [yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(24);
        make.centerX.mas_equalTo(boxView);
        make.size.mas_equalTo(CGSizeMake(140, 38));
    }];
    UIButton *noButton = [DXCreateUI initButtonWithTitle:@"不，就学今天的" titleColor:RGBHex(0xDDB372) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:0];
    [boxView addSubview:noButton];
    [noButton addTarget:self action:@selector(noClick) forControlEvents:(UIControlEventTouchUpInside)];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yesButton.mas_bottom).offset(12);
        make.centerX.mas_equalTo(boxView);
        make.bottom.mas_equalTo(boxView.mas_bottom).offset(-20);
    }];
    
}


/**
  弹出院校对话框
 */
- (void)promptAcademyDialogBox {
    _bgAcademyView = [[UIView alloc] initWithFrame:self.bounds];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_bgAcademyView];
    _bgAcademyView.backgroundColor = [RGBHex(0x000000) colorWithAlphaComponent:0.5];
    UIView *boxView = [[UIView alloc] init];
    [_bgAcademyView addSubview:boxView];
    boxView.layer.cornerRadius = 12;
    boxView.backgroundColor = [UIColor whiteColor];
    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(window);
        make.width.mas_equalTo(IPHONE_WIDTH-25*2);
    }];
    UILabel * titleLabel  = [DXCreateUI initLabelWithText:@"请您填写报考院校" textColor:RGBHex(0x101010) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] textAlignment:(NSTextAlignmentCenter)];
    [boxView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(boxView);
        make.top.mas_equalTo(boxView.mas_top).offset(20);
        
    }];
    NSMutableArray *lineCellArr = [NSMutableArray array];
    NSArray *lineCellLeftTextArr = @[@"报考专业：",@"目标院校：",@"培养方式：",@"语言："];
    for (int i=0; i<lineCellLeftTextArr.count; i++) {
        UIView *cellView = [self getLineCellViewWihtString:lineCellLeftTextArr[i] tag:1500+i];
        [boxView addSubview:cellView];
        [lineCellArr addObject:cellView];
        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
            else make.top.mas_equalTo(((UIView *)lineCellArr[i-1]).mas_bottom).offset(15);
            make.left.mas_equalTo(boxView.mas_left);
            make.right.mas_equalTo(boxView.mas_right);
            make.height.mas_equalTo(38);
        }];
    }
    UIButton *yesButton = [DXCreateUI initButtonWithTitle:@"提交" titleColor:RGBHex(0x6A4D31) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:19];
    yesButton.layer.borderColor = RGBHex(0xDDB272).CGColor;
    yesButton.layer.borderWidth = 1;
    [boxView addSubview:yesButton];
    [DXCreateUI addBackgroundColorShadowWidth:140 height:38 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:19 superView:yesButton];
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    [yesButton addTarget:self.delegate action:VSAction(self.delegate, commitAcademyClick) forControlEvents:(UIControlEventTouchUpInside)];
    [yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(((UIView *)[lineCellArr lastObject]).mas_bottom).offset(24);
        make.centerX.mas_equalTo(boxView);
        make.size.mas_equalTo(CGSizeMake(140, 38));
    }];
    UIButton *noButton = [DXCreateUI initButtonWithTitle:@"下次再填" titleColor:RGBHex(0xDDB372) backgroundColor:[UIColor clearColor] font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:0];
    [boxView addSubview:noButton];
    [noButton addTarget:self action:@selector(noClick) forControlEvents:(UIControlEventTouchUpInside)];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yesButton.mas_bottom).offset(12);
        make.centerX.mas_equalTo(boxView);
        make.bottom.mas_equalTo(boxView.mas_bottom).offset(-20);
    }];
    UIImageView *quitImage = [[UIImageView alloc] initWithImage:VipServiceImage(@"关闭-灰色")];
    [boxView addSubview:quitImage];
    quitImage.userInteractionEnabled  = YES;
    [quitImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noClick)]];
    [quitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxView.mas_top).offset(10);
        make.right.mas_equalTo(boxView.mas_right).offset(-10);
    }];
    
}
- (UIView *)getLineCellViewWihtString:(NSString *)leftString  tag:(NSInteger )tag{
    UIView *view = [[UIView alloc] init];
    UILabel * leftLabel  = [DXCreateUI initLabelWithText:leftString textColor:RGBHex(0x101010) font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textAlignment:(NSTextAlignmentRight)];
    [view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(view.mas_left);
        make.width.mas_equalTo(93);
    }];
    UIView *rightView = [[UIView alloc] init];
    [view addSubview:rightView];
    [rightView setAccessibilityIdentifier:@"rightView"];
    rightView.layer.borderColor = RGBHex(0x6A4D31).CGColor;
    rightView.layer.borderWidth = 0.5;
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(leftLabel.mas_right);
        make.right.mas_equalTo(view.mas_right).offset(-20);
        make.top.mas_equalTo(view.mas_top);
        make.bottom.mas_equalTo(view.mas_bottom);
    }];
    UILabel * rightLabel  = [DXCreateUI initLabelWithText:@"--请选择--" textColor:RGBHex(0x101010) font:[UIFont fontWithName:@"PingFangSC-Regular" size:15] textAlignment:(NSTextAlignmentLeft)];
    [rightView addSubview:rightLabel];
    [rightLabel setAccessibilityIdentifier:@"rightLabel"];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightView);
        make.left.mas_equalTo(rightView.mas_left).offset(10);
    }];
    UIImageView * rightImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"向下小箭头")];
    [rightImv setAccessibilityIdentifier:@"向下小箭头"];
    [rightView addSubview:rightImv];
    [rightImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightView);
        make.right.mas_equalTo(rightView.mas_right).offset(-8);
    }];
    #pragma GCC diagnostic ignored "-Wundeclared-selector"
    rightView.tag = tag;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, academySelect:)];
    [rightView addGestureRecognizer:tap];
    return  view;
}




/**
 * time 左边的时间； date 日期；needDateLabel 是否需要显示日期； needMyvipView是否需要显示：我的vip ；needLineView 底部是否需要横线
 * 根据UI要求 一共有3种情况
 * 只需要显示 time (从日期vc点进来)
 * 需要显示 time date (从计划详情点击进来)经过沟通和上面显示一样
 * 全部要显示 (笔试服务首页过来的)
 */
- (UIView *)addTopViewWithTime:(nullable NSString *)time
                          date:(nullable NSString *)date
                 needDateLabel:(BOOL)needDateLabel
                 needMyvipView:(BOOL)needMyvipView
                  needLineView:(BOOL)needLineView {

    UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(iPhoneX?88:64);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(60);
        }];
        _dateLeftlabel =  [DXCreateUI initLabelWithText:time textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:NSTextAlignmentLeft];
        [view addSubview: _dateLeftlabel];
        [_dateLeftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(view.mas_left).offset(12);
        }];
        if (!time) {
             _dateLeftlabel.hidden = YES;
        }else {
             [self setdateLabelText:time];
        }
    
    if (needDateLabel) {
        UILabel *dateLabel = [DXCreateUI initLabelWithText:date textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:(NSTextAlignmentCenter)];
        [view addSubview:dateLabel];
        dateLabel.layer.borderColor = RGBHex(0xDDB272).CGColor;
        dateLabel.layer.borderWidth = 1;
        dateLabel.layer.cornerRadius = 13;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            if (!time) {
                 make.left.mas_equalTo(view.mas_left).offset(12);
            }else {
                  make.left.mas_equalTo(self.dateLeftlabel.mas_right).offset(8);
            }
            make.size.mas_equalTo(CGSizeMake(106, 26));
        }];
        //由于非汉字有bug，只能给背景view，否则dateLabel的日期将不能显示
        UIView *backView = [[UIView alloc] init];
        [view addSubview:backView];
        [view bringSubviewToFront:dateLabel];
        [DXCreateUI addBackgroundColorShadowWidth:106 height:26 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:13 superView:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(dateLabel);
            make.size.mas_equalTo(dateLabel);
        }];
    }
    
    if (needMyvipView) {
        UIView *rightView = [[UIView alloc] init];
        [view addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).offset(-12);
            make.centerY.mas_equalTo(view);
        }];
        UIImageView *imv = [[UIImageView alloc] initWithImage:VipServiceImage(@"向右箭头")];
        [rightView addSubview:imv];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightView.mas_right);
            make.centerY.mas_equalTo(rightView);
            make.width.mas_equalTo(6);
        }];
        UILabel *myVipLabel = [DXCreateUI initLabelWithText:@"我的VIP" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:(NSTextAlignmentCenter)];
        [rightView addSubview:myVipLabel];
        [myVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(rightView);
            make.right.mas_equalTo(imv.mas_left).offset(-6);
            make.left.mas_equalTo(rightView.mas_left);
            make.top.mas_equalTo(rightView.mas_top);
            make.bottom.mas_equalTo(rightView.mas_bottom);
            
        }];
        #pragma GCC diagnostic ignored "-Wundeclared-selector"
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self.delegate action:VSAction(self.delegate, myVipClickMethod)];
        [rightView addGestureRecognizer:tap];
    }
   
    if (needLineView) {
        //横线
        UIView *lineView =  [DXCreateUI initLineViewWithBackgroundColor:RGBHex(0xE6E6E6)];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
        }];
    }
    _topView = view;
    return view;
    
}
/**
 *  显示第几天
 */
- (void)setdateLabelText:(NSString *)string {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        //设置字号
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(1, string.length-2)];
        //设置文字颜色
//        [str addAttribute:NSForegroundColorAttributeName value:RGBHex(0x6A4D31) range:NSMakeRange(1, string.length-2)];
        _dateLeftlabel.attributedText = str;
    
}

/**
 Description
 添加看课 ，做题，作业视图
 @param  superView 没有，今天没有计划安排 superView有，看课和做题其中一项没有安排计划
 @return view
 */
- (UIView *)addNonePlanViewWithSuperView:(nullable UIView *)superView text:(NSString *)text{
    //
    UIView *view = [[UIView alloc] init];
    if (!superView)  [self addSubview:view];
    else  [superView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!superView) {
                if (self.topView) make.top.mas_equalTo(self.topView.mas_bottom).offset(1);
                else make.top.mas_equalTo(IPHONE_WIDTH?148:124);
                make.left.mas_equalTo(self.mas_left);
                make.right.mas_equalTo(self.mas_right);
                make.bottom.mas_equalTo(self.mas_bottom);
            }else {
                make.top.mas_equalTo(superView.mas_top).offset(1);
                make.left.mas_equalTo(superView.mas_left);
                make.right.mas_equalTo(superView.mas_right);
                make.bottom.mas_equalTo(superView.mas_bottom);
            }
        
        }];
    UIImageView *imv = [[UIImageView alloc] initWithImage:VipServiceImage(@"无学习计划")];
        [view addSubview:imv];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).offset(50);
            make.centerX.mas_equalTo(view);
        }];
    UILabel *label = [DXCreateUI initLabelWithText:text textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:(NSTextAlignmentCenter)];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imv.mas_bottom).offset(30);
            make.centerX.mas_equalTo(view);
        }];
    return view;
}
/**
 *  type 为真 有三列 看课，做题 作业 ； 为假 只有两列 看课，做题
 *  isNone 1 看课为空； 2 做题为空  其他都不为空
 *  text 作业的描述 一段文本
 */
- (UIView *)addMenuViewHasVideo:(BOOL)video hasPaper:(BOOL)paper text:(nullable NSString *)text look:(void(^)(void))look{
    self.notictLooking  = look;
    //需求改变 必须显示三列
    //video 是有视频或者直播任务  paper是否有做题的任务
//    _scrollViewContentWidth = type?IPHONE_WIDTH*3:IPHONE_WIDTH*2;
    _scrollViewContentWidth = IPHONE_WIDTH*3;
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
        [self addSubview:pageMenu];
        [pageMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.topView) {
                make.top.mas_equalTo(self.topView.mas_bottom).offset(1);
            }else {
                make.top.mas_equalTo(IPHONE_WIDTH?148:124);
            }
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(54);
        }];
        // 传递数组，默认选中第1个
        [pageMenu setItems:@[@"看课", @"做题", @"作业"] selectedItemIndex:0];
        pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        pageMenu.trackerWidth = 20;
        pageMenu.needTextColorGradients = NO;
        pageMenu.selectedItemTitleColor = RGBHex(0x6A4D31);
        pageMenu.unSelectedItemTitleColor = RGBHex(0xDDB372);
        pageMenu.tracker.backgroundColor = RGBHex(0x6A4D31);
        pageMenu.itemTitleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        pageMenu.dividingLine.hidden = YES;
        // 设置代理
        pageMenu.delegate = self;
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pageMenu.mas_bottom);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(iPhoneX?-34:0);
        }];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.scrollEnabled = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView = scrollView;
        pageMenu.bridgeScrollView = scrollView;
    
  
        //看课
    _lcView =  [[DXVipLookCourseView alloc] initWithFrame:CGRectZero target:nil];
          [scrollView addSubview:_lcView];
        _lcView.delegate = self.delegate;
        [_lcView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scrollView.mas_top).offset(12);
            make.left.mas_equalTo(scrollView.mas_left);
            make.size.mas_equalTo(scrollView);
        }];
        if (!video) {
            [self addNonePlanViewWithSuperView:_lcView text:@"今日暂无看课计划..."];
        }
        //做题
    _dwView =  [[DXVipDoWorkView alloc] initWithFrame:CGRectZero target:nil];
          [scrollView addSubview:_dwView];
        _dwView.delegate = self.delegate;
        [_dwView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scrollView.mas_top).offset(12);
            make.left.mas_equalTo(self.lcView.mas_right);
            make.size.mas_equalTo(scrollView);
        }];
        if (!paper) {
            [self addNonePlanViewWithSuperView:_dwView text:@"今日暂无做题计划..."];
        }
    
        //作业
        UIView *view = [[UIView alloc] init];
            [scrollView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scrollView.mas_top);
                make.left.mas_equalTo(self.dwView.mas_right);
                make.size.mas_equalTo(scrollView);
            }];
        if (text) {
            UIView *bcView = [[UIView alloc] init];
            [view addSubview:bcView];
            bcView.layer.borderColor = RGBHex(0xDDB372).CGColor;
            bcView.layer.borderWidth = 1;
            bcView.layer.cornerRadius = 8;
            [bcView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view.mas_top).offset(12);
                make.right.mas_equalTo(view.mas_right).offset(-12);
                make.left.mas_equalTo(view.mas_left).offset(12);
                
            }];
            //@"根据最新考纲，精讲MBA、MPAcc等管理类联考数学所有考点，短期迅速掌握完整知识体系，数学课程妙语横生绝不干涩难懂，学会独特解题技巧，形成系统、高效做题思路！"
            UILabel *detailLabel = [DXCreateUI initLabelWithText:text textColor:RGBHex(0x6A4D31) font:[UIFont fontWithName:@"PingFangSC-Medium" size:14] textAlignment:(NSTextAlignmentLeft)];
            [bcView addSubview:detailLabel];
            detailLabel.numberOfLines = 0 ;
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
                
            }];
        }else {
            [self addNonePlanViewWithSuperView:view text:@"今日暂无作业计划..."];
        }
    

    [self layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(_scrollViewContentWidth,IPHONE_HEIGHT - CGRectGetMaxY(pageMenu.frame));

    
    return pageMenu;
    
}
/**
 *底部提示去做入学测试的view
 *
 */
- (UIView *)addBottomTestView {
    CGFloat bottom = iPhoneX?34:0;//底部安全区域
    UIView *backView =  [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50-22-bottom, self.frame.size.width, 50+22)];
        [self addSubview:backView];
        [self bringSubviewToFront:backView];
        UIImageView *closeImv = [[UIImageView alloc] initWithImage:VipServiceImage(@"关闭-灰色")];
            closeImv.frame = CGRectMake(backView.frame.size.width-22-6, 0, 22, 22);
            [backView addSubview:closeImv];
            closeImv.userInteractionEnabled = YES;
        [closeImv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)]];
        UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 22, self.frame.size.width, 50)];
            [backView addSubview:view];
            UILabel *label =  [DXCreateUI initLabelWithText:@"入学测试便于老师更好的为您服务" textColor:RGBHex(0x392816) font:[UIFont fontWithName:@"PingFangSC-Medium" size:15] textAlignment:NSTextAlignmentLeft];
                [view addSubview: label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view);
                    make.left.mas_equalTo(view.mas_left).offset(12);
                    make.right.mas_equalTo(view.mas_right).offset(-120);
                }];
            UIButton *botton = [DXCreateUI initButtonWithTitle:@"入学测试" titleColor:RGBHex(0x6A4D31 ) backgroundColor:[UIColor clearColor] font: [UIFont fontWithName:@"PingFangSC-Semibold" size:15] controlStateNormal:(UIControlStateNormal) controlStateHighlighted:(UIControlStateNormal) cornerRadius:18];
                [view addSubview: botton];
                botton.layer.borderColor = RGBHex(0xDDB272).CGColor;
                botton.layer.borderWidth = 1;
                [botton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view);
                    make.right.mas_equalTo(view.mas_right).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(110, 36));
                }];
                [DXCreateUI addBackgroundColorShadowWidth:110 height:36 fromeColor:RGBHex(0xFFF5E4) toColor:RGBHex(0xD9AD6A) cornerRadius:18 superView:botton];
                [botton addTarget:self.delegate action:@selector(goTest) forControlEvents:(UIControlEventTouchUpInside)];
    
            //添加view顶部的阴影
            view.layer.shadowColor = RGBHex(0x000000).CGColor;
            view.layer.shadowOffset = CGSizeMake(0,-3);
            view.layer.shadowOpacity = 0.04;
            view.layer.shadowRadius = 2;
            // 单边阴影 顶边
            float shadowPathWidth = view.layer.shadowRadius;
            CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, view.bounds.size.width, shadowPathWidth);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
            view.layer.shadowPath = path.CGPath;
    return backView;
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(IPHONE_WIDTH* toIndex, 0) animated:YES];
        }
    }
    if (toIndex==2) {
        if (self.notictLooking) {
            self.notictLooking();//通知后台 用户看过了作业
        }
    }
}


#pragma mark - 点击事件方法
- (void)noClick {
    if (_completeSelect) {
        self.completeSelect();
//        self.completeSelect = nil;
    }
    [_bgStudyView removeFromSuperview];
    [_bgAcademyView removeFromSuperview];
}
- (void)closeAction:(UITapGestureRecognizer *)tap {
    [tap.view.superview removeFromSuperview];
}
@end

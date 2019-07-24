//
//  DXVipEverydayPlanController.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/18.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipEverydayPlanController.h"
#import "DXVipEverydayPlanView.h"
#import "DXVipSelectMenuView.h"
#import "DXVipServiceApiRequest.h"
#import "DXVIPWrittenTestDateController.h"
#import "DXVipServiceController.h"

@interface DXVipEverydayPlanController ()<DXVipServiceBaseViewDelegete>
@property (nonatomic, strong) DXVipEverydayPlanView *edpView;         //主页面
@property (nonatomic, strong) DXVipSelectMenuView *selectMenuView; //选择院校的列表view
@property (nonatomic, strong) UIImageView *selectImv;               //选择院校的列表小箭头切换
@property (nonatomic, strong) DXVipServiceApiRequest *apiRequest;

@property (nonatomic, strong) NSArray *academyList;         //院校列表
@property (nonatomic, strong) NSMutableArray *academyData; //院校的4项数据

@property (nonatomic, strong) NSString *prevDay;    //上一次学习的时间
@property (nonatomic, strong) NSString *prevStage; //上一次学习的阶段

@property (nonatomic, assign) BOOL testFlag; //是否有入学测试需要去做
@property (nonatomic, strong) UIView *bottomView; //是否有入学测试需要去做
@property (nonatomic, strong) NSArray *paperArray; //测试题数据

@property (nonatomic, assign) BOOL hadLook;    //用户已经看过作业了

@property (nonatomic, assign) BOOL prompt; //每天弹出一次提示，需要根据多个条件 （包括 上次学习 院校选择 入学测试）
//这个页面特殊，会在页面app启动，登录，个人中心登录的时候就会被创建，所以希望，如果界面不是在显示状态不要显示弹窗(并且弹窗，只会出现一次)
@property(nonatomic,copy)void(^promptBox)(void);
@property(nonatomic,assign) BOOL promptBoxNormal; //正常情况下，会先出现视图，然后才会返回数据，这个标志是表示 这个视图创建的时候是正常状态的 对比上面的非正常状态

@end

@implementation DXVipEverydayPlanController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [self.navigationController.navigationBar setBackgroundImage: [VipServiceImage(@"顶部通用背景") resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self adjustmentRightButtonSubViewPositionWithRightFromScreen:0 topFromButton:0 width:83 height:28];
    
    //这个页面特殊，(需求就是这样)会在页面app启动，登录，个人中心登录的时候就会被创建，所以希望，如果界面不是在显示状态不要显示弹窗(并且弹窗，只会出现一次)
    self.promptBoxNormal = YES;
    if (self.promptBox) {
        self.promptBox();
        self.promptBox = nil;
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self adjustmentRightButtonSubViewPositionWithRightFromScreen:0 topFromButton:0 width:83 height:28];

}
- (void)loadView {
    
    [super loadView];
    self.view =  _edpView =  [[DXVipEverydayPlanView alloc] initWithFrame:self.view.bounds target:self];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_whearFrom isEqualToString:@"日历页面来的"]) {
          self.title = @"计划详情";
    }else {
          self.title = @"VIP笔试服务";
    }
    //设置右边的button
    UIButton  *rightButton = [self getRightButtonWithWidth:83 height:28 backImage:VipServiceImage(@"进入面试") label:nil];
    rightButton.frame = CGRectMake(16, 0, 83, 28);//距离右边的右16和20两种
    [rightButton addTarget:self action:@selector(interviewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //暂时隐藏面试入口
    rightButton.hidden = YES;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString * dateString = [formatter stringFromDate:[NSDate date]];
    if (!_day) {
        _day = dateString;
    }
    _apiRequest = [[DXVipServiceApiRequest alloc] init];
    //获取每日计划
    [self requestEveryDayPlanWithDay:self.day stage:self.stage?:@""];
    
    
    self.prompt = [self setpromptDialogBoxRule];//多个地方需要使用
    if (self.prompt) {
        //获取入学测试列表 ，如果有没有提交的测试 ，弹出底部提示，去完成测试（每天提示一次）
        [self requestAllotInfo];
    }
}

#pragma mark 设置弹窗一天只能弹出一次
- (BOOL)setpromptDialogBoxRule {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *agoDate = [userDefault objectForKey:@"VipServicePromptRule"];
    if ([DXCreateUI judgeEmpty:agoDate]) {
        [userDefault setObject: [dateFormatter stringFromDate:now] forKey:@"VipServicePromptRule"];
        [userDefault synchronize];
        return YES;
    }else {
      
        if ([agoDate isEqualToString:[dateFormatter stringFromDate:now]]) {
            return NO;
        }else {
            [userDefault setObject: [dateFormatter stringFromDate:now] forKey:@"VipServicePromptRule"];
            [userDefault synchronize];
            return YES;
        }
        
    }
}
//时间处理
- (NSString *)dateWithTimeInterval:(long long)timeInterval{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
#pragma mark 数据请求
/*查询院校列表*/
- (void)requestAcademyListWithMajor:(NSString *)major {
    [_apiRequest postSearchAcademyWithMajor:major  success:^(NSDictionary * _Nonnull dic, BOOL state) {
       self.academyList = [dic[@"data"] isKindOfClass:[NSArray class]]?dic[@"data"]:@[];
    } fail:^(NSError * _Nonnull error) {
    }];
}
/*查看某一天计划安排*/
- (void)requestEveryDayPlanWithDay:(NSString *)day stage:(NSString *)stage {
    if (!day||!stage) return;
    [_apiRequest postEveryDayPlanWithDay:(NSString *)day stage:(NSString *)stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if ([dic[@"status"] boolValue]) {
            if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) return ;
            DXVipServiceStudyMode * studyMode = [DXVipServiceStudyMode mj_objectWithKeyValues:dic[@"data"]];
            NSDictionary *data =  dic[@"data"];
            self.stage = studyMode.stage;
            BOOL valid = NO;//不在阶段内则不显示天数 （数据是错误的），后台的接口，坑，非要返回这种错误数据，增加一堆代码判断错误数据，直接返回空不好吗，沟通无效
            if ([self.whearFrom isEqualToString:@"日历页面来的"]) {
                //日历页面过来的  一定要显示
                  valid = YES;
            }else {
                long long time =   (long long)[[NSDate date] timeIntervalSince1970];
                if (studyMode.startTime.longLongValue<time&&studyMode.endTime.longLongValue>time) {
                    valid = YES;
                }
                //时间有一天的范围摆动 ，如果刚好是结束和开始的日子 也需要显示
                NSString *stringTime = [self dateWithTimeInterval:time];
                BOOL start = [[self dateWithTimeInterval:studyMode.startTime.longLongValue] isEqualToString:stringTime];
                BOOL end = [[self dateWithTimeInterval:studyMode.endTime.longLongValue] isEqualToString:stringTime];
                if (start||end){
                    valid = YES;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.whearFrom isEqualToString:@"日历页面来的"]) {
                    [self.edpView addTopViewWithTime:valid?VSStringFormatWithMid(@"第", studyMode.theDay?:@"", @"天"):nil  date:day needDateLabel:YES needMyvipView:NO needLineView:NO];
                }else {
                    [self.edpView addTopViewWithTime:valid?VSStringFormatWithMid(@"第", studyMode.theDay?:@"", @"天"):nil  date:day needDateLabel:YES needMyvipView:YES needLineView:YES];
                }
            });
            NSArray *video = studyMode.video;
            NSArray *paper = studyMode.paper;
            NSString *eventDesc = studyMode.eventDesc;
            BOOL eventDescType = ![DXCreateUI judgeEmpty:eventDesc];
            //按需要加载视图
            if ([studyMode.is_task isEqualToString:@"1"]) self.hadLook = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                 __weak typeof(self) weakSelf = self;
                [self.edpView addMenuViewHasVideo:(BOOL)video.count hasPaper:(BOOL)paper.count text:eventDescType?eventDesc:nil look:^{
                    if (!weakSelf.hadLook) {
                        //如果用户没看过，通知后台现在用户在查看作业界面
                         __strong typeof(self) strongSelf = weakSelf;
                        [strongSelf userHadLookWork:day];
                    }
                }];
                if (video.count)   [self.edpView.lcView refreshData:video];
                if (paper.count)   [self.edpView.dwView refreshData:paper];
                if (!video.count&&!paper.count&&!eventDescType) [self.edpView addNonePlanViewWithSuperView:nil text:@"今日暂无学习计划，去放松一下吧~"];
                if (self.bottomView) [self.edpView bringSubviewToFront:self.bottomView];
            });
             __weak typeof(self) weakSelf = self;
            self.promptBox = ^(){
                 __strong typeof(self) strongSelf = weakSelf;
                //弹出学习对话框
                if (![DXCreateUI judgeEmpty:data[@"prev_day_state"]]) {
                    
                    if (![strongSelf.whearFrom isEqualToString:@"这次学习"]&&self.prompt) {
                        NSDictionary *preDic = data[@"prev_day_state"];
                        strongSelf.prevStage =   VSStringFormat(preDic[@"stage"]);
                        NSString * prevDay  =  VSStringFormat(preDic[@"prev_day"]);
                        if (prevDay.length==8) {
                            prevDay = [NSString stringWithFormat:@"%@-%@-%@",[prevDay substringWithRange:NSMakeRange(0, 4)],[prevDay substringWithRange:NSMakeRange(4, 2)],[prevDay substringWithRange:NSMakeRange(6, 2)]];
                        }
                        strongSelf.prevDay = prevDay;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.edpView promptStudyDialogBox];
                        });
                    }
                }
                //弹出院校对话框
                if ([VSStringFormat(data[@"apply_exam"]) isEqualToString:@"0"]) {
                    if (![strongSelf.whearFrom isEqualToString:@"这次学习"]&&self.prompt) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf.edpView noClick];//如果这个时候弹出了上次学习对话框，直接取消
                            [strongSelf.edpView promptAcademyDialogBox];
                        });
                    }
                    
                }
            };
            if (self.promptBoxNormal) {
                self.promptBox();
                self.promptBox = nil;
            }
          
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.edpView addNonePlanViewWithSuperView:nil text:@"今日暂无学习计划，去放松一下吧~"];
            });
            if (self.bottomView) [self.edpView bringSubviewToFront:self.bottomView];
        }
        

    } fail:^(NSError * _Nonnull error) {
    }];
}
- (void)userHadLookWork:(NSString *)date {
    //用户查看了作业
    [_apiRequest postHadLook:date success:^(NSDictionary * _Nonnull dic, BOOL state) {
        self.hadLook = YES;
        NSLog(@"看了哈哈哈哈哈");
    } fail:^(NSError * _Nonnull error) {
    }];
}

/*获取分配情况,从而拿到入学测试列表的paperId,在去请求入学测试相关信息*/
- (void)requestAllotInfo {
    
    //要获取服务类型：1-笔试，2-面试
    [_apiRequest postAlloctInfoWithServiceType:@"1" success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if ([dic[@"status"] boolValue]) {
                NSDictionary *data = dic[@"data"];
                NSString *papers =  data[@"written_student"][@"papers"];
                if (![DXCreateUI judgeEmpty:papers]) {
                   [self requestStudyTestWithPaperId:papers];
                }
        }
        
    } fail:^(NSError * _Nonnull error) {
    }];
}
/*获取入学测试列表*/
- (void)requestStudyTestWithPaperId:(NSString *)paperId {
    [self.apiRequest postStudyTestWithPaperId:paperId success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if ([dic[@"status"] boolValue]) {
            for (NSDictionary *data in dic[@"data"]) {
                if (![VSStringFormat(data[@"submit_state"]) isEqualToString:@"1"]) {
                    self.testFlag = YES;//需要去完成入学测试
                }
            }
        }
        if (self.testFlag) {
           self.paperArray = dic[@"data"];
           self.bottomView =  [self.edpView addBottomTestView];
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}


#pragma mark 点击事件
- (void)interviewAction {
    NSLog(@"进入面试或进入笔试");
    [self.navigationController pushViewController:[[DXVIPWrittenTestDateController alloc] init] animated:YES];

}
//去做测试题
- (void)goTest {
    DXVipServiceController *vc  = [[DXVipServiceController alloc] init] ;
    vc.testPaperArr = self.paperArray;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 Description
 去我的vip页面（日历页面）
 */
- (void)myVipClickMethod {
        NSLog(@"我的vip");
    DXVIPWrittenTestDateController *vc  = [[DXVIPWrittenTestDateController alloc] init];
    vc.stage = _stage;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
    去上一次学习
 */
- (void)thePreviousDay {
    DXVipEverydayPlanController *edpVC  = [[DXVipEverydayPlanController alloc] init];
    edpVC.day = _prevDay;
    edpVC.stage = _prevStage;
    edpVC.whearFrom = @"这次学习";
    [self.edpView noClick];
    [self.navigationController pushViewController:edpVC animated:YES];
}


/**
 院校选择
 */
- (void)academySelect:(UITapGestureRecognizer *)tap {
    
    if (_selectMenuView) {
        [_selectMenuView hide];
        [_selectImv  setImage:VipServiceImage(@"向下小箭头")];
        [_selectImv  setAccessibilityIdentifier:@"向下小箭头"];
    }
    UILabel *label = nil;
    for (UIView *rightSubView in [tap.view subviews]) {
        if ([rightSubView isKindOfClass:[UILabel class]]) {
            label =  (UILabel *)rightSubView ;
        }
    }
    CGRect rect =[tap.view convertRect: tap.view.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
    NSArray *arr;
    NSInteger category = tap.view.tag-1500;
    if (category==0) arr  = @[@"MBA",@"EMBA",@"MEM",@"MTA",@"MPA",@"MPAcc",@"MAud",@"MLIS"];
    if (category==1) {
        if (!_academyList.count) {
            VSShowMessage(@"请先选择专业");
            return;
        }else {
            NSMutableArray *academyArr = [NSMutableArray array];
            for (NSDictionary *dic in _academyList) {
                [academyArr addObject:dic[@"name"]];
            }
            arr = academyArr;
        }
    }
    if (category==2) arr  = @[@"全日制",@"非全日制"];
    if (category==3) arr  = @[@"中文",@"国际"];
    
    for (UIView *rightSubView in [tap.view subviews]) {
        if ([rightSubView isKindOfClass:[UIImageView class]]) {
            UIImageView *imv  = (UIImageView *)rightSubView;
            if ([_selectImv isEqual:imv]) {
                _selectImv = nil;
                return;
            }else {
                _selectImv = imv;
            }
            if ([imv.accessibilityIdentifier isEqualToString:@"向下小箭头"]) {
                [imv  setImage:VipServiceImage(@"向上箭头")];
                [imv  setAccessibilityIdentifier:@"向上箭头"];
                _selectMenuView = [[DXVipSelectMenuView alloc]  initWithItems:arr
                                                                        frame:rect
                                                             triangleLocation:CGPointZero
                                                                       action:^(NSInteger index) {
                       if (label)  label.text = arr[index];
                       self.selectImv = nil;
                       [imv  setImage:VipServiceImage(@"向下小箭头")];
                       [imv  setAccessibilityIdentifier:@"向下小箭头"];
                       if (category==0) {
                           [self requestAcademyListWithMajor:VSStringFormatInteger(index+1)];
                           self.academyData[category] = VSStringFormatInteger(index+1);
                       }else {
                           self.academyData[category] = arr[index];
                       }
 
                } index:0];
                [_selectMenuView show];
                 __weak typeof(self) weakSelf = self;
                self.edpView.completeSelect = ^(){
                        [weakSelf.selectMenuView hide];
                };
            }else {
                [imv  setImage:VipServiceImage(@"向下小箭头")];
                [imv  setAccessibilityIdentifier:@"向下小箭头"];
            }
            
        }
    }

}
/**
 提交院校选择
 */
- (void)commitAcademyClick {
    NSLog(@"提交院校信息");
    for (int i = 0 ; i<_academyData.count; i++) {
        if ([DXCreateUI judgeEmpty:_academyData[i]] ) {
            if (i==0)  VSShowMessage(@"请选择专业");
            if (i==1)  VSShowMessage(@"请选择院校");
            if (i==2)  VSShowMessage(@"请选择培养方式");
            if (i==3)  VSShowMessage(@"请选择语言");
            return;
        }
    }
    
    [_apiRequest postcommitAcademyWithMajor:_academyData[0]
                                    college:_academyData[1]
                                  studyType:_academyData[2]
                                   language:_academyData[3]
                                    success:^(NSDictionary * _Nonnull dic, BOOL state) {
                                        if ([dic[@"status"] boolValue]) {
                                            VSShowMessage(dic[@"message"]);
                                            [self.edpView noClick];
                                        }else {
                                            VSShowMessage(dic[@"message"]);
                                        }
                                       
                                    }
                                       fail:^(NSError * _Nonnull error) {
                                           
                                       }];
    
}


- (NSMutableArray *)academyData {
    if (!_academyData) {
        _academyData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",nil];
    }
    return _academyData;
}

/**
 *去看课和去做试题
 *
 */
- (void)clickWithDescription:(NSString *)description param:(nonnull NSDictionary *)param {
    NSLog(@"param==%@" ,param);
    if ([description isEqualToString:@"paperId"]) {
        UIViewController *DXQuestionPaperDetailViewController = [self getTargetController:@"DXQuestionPaperDetailViewController" param:@{@"paperID":param[@"paperID"]}];
        if (DXQuestionPaperDetailViewController) {
            [self.navigationController pushViewController:DXQuestionPaperDetailViewController animated:YES];
        }
    }
    
    if ([description isEqualToString:@"视频或直播"]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"CourseDetailViewController"];
        if (vc) {
            BOOL isTaocan = [param[@"kctype"] isEqualToString:@"5"];
            [vc setValue:param[@"courseId"] forKey:@"courseId"];
            [vc setValue:@(isTaocan) forKey:@"isTaocan"];
            [vc setValue:param[@"kctype"] forKey:@"kctype"];
            
            [vc setValue:@(YES) forKey:@"isFromVipService"];
            if (param[@"zhangId"]) [vc setValue:param[@"zhangId"] forKey:@"zhangId"];
            if (param[@"jieId"]) [vc setValue:param[@"jieId"] forKey:@"jieId"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSLog(@"未找到 CourseDetailViewController 控制器");
        }
    }
}

@end

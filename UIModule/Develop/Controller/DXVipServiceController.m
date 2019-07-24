//
//  DXVipServiceController.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/18.
//  Copyright © 2019 都学网. All rights reserved.
//


#import "DXVipServiceController.h"
#import "DXVipServiceView.h"
#import "DXVipServiceApiRequest.h"


@interface DXVipServiceController ()<DXVipServiceBaseViewDelegete>

@property (nonatomic, strong) DXVipServiceView *serviceView;
@property (nonatomic, strong) DXVipServiceApiRequest *apiRequest;

@end

@implementation DXVipServiceController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView {
    [super loadView];
    self.view =  _serviceView  =   [[DXVipServiceView alloc] initWithFrame:self.view.bounds type:1 target:self];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (_testPaperArr.count>0) {
        //每日计划过来的
        [self.serviceView addTestViewWithDataArray:_testPaperArr];
    }else {
        //首页过来的
        _apiRequest = [[DXVipServiceApiRequest alloc] init];
        [self requestAllotInfo];
    }
 

}

#pragma mark 数据请求

/*获取分配情况*/
- (void)requestAllotInfo {
    
    //要获取服务类型：1-笔试，2-面试
    [_apiRequest postAlloctInfoWithServiceType:@"1" success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if ([dic[@"status"] boolValue]) {
            NSDictionary *data = dic[@"data"];
            if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) return;
            if (![[NSString stringWithFormat:@"%@",data[@"written_student"][@"stage_plan"]] isEqualToString:@"0"]) {
                return ;
            };
            NSDictionary *teacher = data[@"teacher"];
            if ([DXCreateUI judgeEmpty:teacher]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                  
                     [self.serviceView addWaiForTeacherView];
                });
            }else {
                NSString *papers =  data[@"written_student"][@"papers"];
                if ([DXCreateUI judgeEmpty:papers]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.serviceView addTeacherViewWithHeadImv:teacher[@"image"] detail:[NSString stringWithFormat:@"%@ %@",teacher[@"name"] ,teacher[@"phone"] ]];
                    });
                }else {
                    [self requestStudyTestWithPaperId:papers];
                }
            }
           
        }

    } fail:^(NSError * _Nonnull error) {
    }];
}

/*获取入学测试列表*/
- (void)requestStudyTestWithPaperId:(NSString *)paperId {
    [self.apiRequest postStudyTestWithPaperId:paperId success:^(NSDictionary * _Nonnull dic, BOOL state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.serviceView addTestViewWithDataArray:dic[@"data"]];
        });
    } fail:^(NSError * _Nonnull error) {
    }];
}

- (void)dealloc {
    NSLog(@"我被销毁了。。。。。。。。。。。。。。。。");
}

#pragma mark 点击事件 click events

- (void)clickWithDescription:(NSString *)description {
    if ([description isEqualToString:@"返回"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //paperId
    if ([description isEqualToString:@"paperId"]) {
        NSLog(@"去做测试题");
        UIViewController *DXQuestionPaperDetailViewController = [self getTargetController:@"DXQuestionPaperDetailViewController" param:@{@"paperID":@""}];
        if (DXQuestionPaperDetailViewController) {
            [self.navigationController pushViewController:DXQuestionPaperDetailViewController animated:YES];
        }
    }
}

#pragma mark - Lazy loading

#pragma mark - 供主页面访问
+ (void)checkUserIsVipWithUid:(NSInteger)uid callBack:(void(^)(NSInteger flag))callBack {
    //flag 表示 0 没有购买 1 购买了笔试 2 购买了面试 3 都购买了
    if (!uid) {
        callBack(0);
        return;
    }
    NSDictionary *param = @{@"uid":@(uid)};
    //需要先获取token才能查询服务
    [DXVipServiceNetWork post:@"https://api.doxue.com/v1/vip_student/token" paramaters:param success:^(NSDictionary * _Nonnull dic, BOOL state) {
        [DXVipServiceNetWork setToken:dic[@"data"][@"token"]];
        [DXVipServiceNetWork post:@"https://api.doxue.com/v1/vip_student/check_student_service" paramaters:nil success:^(NSDictionary * _Nonnull dic, BOOL state) {
            if (![dic[@"status"] respondsToSelector:@selector(boolValue)]) {
                callBack(0);
                return;
            }
            if ([dic[@"status"] boolValue]) {
                if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                    callBack(0);
                    return;
                }
                BOOL writer = [[NSString stringWithFormat:@"%@",dic[@"data"][@"written_service"]] isEqualToString:@"1"];
                BOOL interView = [[NSString stringWithFormat:@"%@",dic[@"data"][@"interview_service"]] isEqualToString:@"1"];
                if (writer&&interView) {
                    callBack(3);
                    return;
                }else if (writer){
                    callBack(1);
                    return;
                }else if (interView){
                    callBack(2);
                    return;
                }else {
                    callBack(0);
                }
            }
        } fail:^(NSError * _Nonnull error) {
            callBack(0);
        } animated:NO];
        
    } fail:^(NSError * _Nonnull error) {
           callBack(0);
    } animated:NO];
    
}
@end

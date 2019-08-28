//
//  DXLiveAppraiseSuccessViewController.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/4/13.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveAppraiseSuccessViewController.h"
#import "DXLiveViewController.h"
#import "DXLivePlayBackViewController.h"

@interface DXLiveAppraiseSuccessViewController ()

@end

@implementation DXLiveAppraiseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationController];
    
    [self creatUI];
    
}

- (void)setupNavigationController
{
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [backButton setImage:[UIImage imageNamed:@"arrowblack"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)popself{
    
//    if (self.liveAppraiseSuccessType == LiveAppraiseSuccessFinishType) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else if (self.liveAppraiseSuccessType == LiveAppraiseSuccessChooseType) {
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[DXLiveViewController class]]) {
//                DXLiveViewController *liveVC =(DXLiveViewController *)controller;
//                [self.navigationController popToViewController:liveVC animated:YES];
//            }
//        }
//    }
//    else if (self.liveAppraiseSuccessType == PlayBackAppraiseSuccessChooseType)
//    {
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[DXLivePlayBackViewController class]]) {
//                DXLivePlayBackViewController *playBackVC =(DXLivePlayBackViewController *)controller;
//                [self.navigationController popToViewController:playBackVC animated:YES];
//            }
//        }
//    }
}

- (void)creatUI
{
    UIImageView *successImageView = [[UIImageView alloc] init];
    if (IS_IPHONE_X) {
        successImageView.frame = CGRectMake(141, 160, IPHONE_WIDTH - 282, 93);
    }
    else if (IS_IPHONE_5)
    {
        successImageView.frame = CGRectMake(93, 136, IPHONE_WIDTH - 186, 93);
    }
    else
    {
        successImageView.frame = CGRectMake(141, 136, IPHONE_WIDTH - 282, 93);
    }
    successImageView.image = [UIImage imageNamed:@"live_evaluationComplete"];
    if (IS_IPHONE_6_PLUS || IS_IPHONE_5) {
        successImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self.view addSubview:successImageView];
    
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.frame = CGRectMake(0, CGRectGetMaxY(successImageView.frame) + 15, IPHONE_WIDTH, 26);
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.text = @"提交成功";
    successLabel.font = [UIFont boldSystemFontOfSize:18];
    successLabel.textColor = RGBAColor(51, 51, 51, 1);
    [self.view addSubview:successLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(0, CGRectGetMaxY(successLabel.frame) + 2, IPHONE_WIDTH, 21);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"感谢您的评价！";
    contentLabel.font = [UIFont boldSystemFontOfSize:15];
    contentLabel.textColor = RGBAColor(136, 136, 136, 1);
    [self.view addSubview:contentLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

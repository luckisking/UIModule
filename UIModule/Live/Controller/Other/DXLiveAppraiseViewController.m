//
//  DXLiveAppraiseViewController.m
//  Doxuewang
//
//  Created by doxue_ios on 2018/3/22.
//  Copyright © 2018年 都学网. All rights reserved.
//

#import "DXLiveAppraiseViewController.h"
#import "XHStarRateView.h"
#import "DXLiveRequest.h"                     /* 上传评论 */
#import "DXLiveAppraiseSuccessViewController.h"

@interface DXLiveAppraiseViewController () <UITextViewDelegate,XHStarRateViewDelegate>

@property (nonatomic, strong) UITextView *appraiseTextView;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UILabel *wordLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (assign, nonatomic) float userScore;

@property (strong, nonatomic) DXLiveRequest *request;

@end

@implementation DXLiveAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _request = [[DXLiveRequest alloc] init];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = live_tableViewBgColor;
    
    self.title = @"评价";
    
    [self setupNavigationController];
    
    [self createUI];
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
    
    if (self.liveAppraiseType == LiveAppraiseChooseType || self.liveAppraiseType == PlayBackAppraiseChooseType) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)createUI
{
    UILabel *titleLabel = [[UILabel alloc] init];
    if (IS_IPHONE_X) {
        titleLabel.frame = CGRectMake(20, 105, IPHONE_WIDTH - 40, 37);
    }
    else
    {
        titleLabel.frame = CGRectMake(20, 81, IPHONE_WIDTH - 40, 37);
    }
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = RGBAColor(136, 136, 136, 1);
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    if (self.liveAppraiseType == LiveAppraiseChooseType) {
        titleLabel.text = @"感谢您的观看，请对本次课程进行评价，以便于为您提供更好的服务";
    }
    else if (self.liveAppraiseType == PlayBackAppraiseChooseType)
    {
        titleLabel.text = @"感谢您的观看，请对本次课程进行评价，以便于为您提供更好的服务";
    }
    else
    {
        titleLabel.text = @"直播已结束，感谢您的观看，请对本次课程进行评价，以便为您提供更好的服务";
    }
    [self.view addSubview:titleLabel];
    
    UILabel *appraiseLabel = [[UILabel alloc] init];
    appraiseLabel.frame = CGRectMake(22.5, CGRectGetMaxY(titleLabel.frame) + 14.5, 65, 21);
    appraiseLabel.font = [UIFont systemFontOfSize:15.0];
    appraiseLabel.text = @"整体评价";
    appraiseLabel.textColor = dominant_BlockColor;
    [self.view addSubview:appraiseLabel];
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(appraiseLabel.frame), CGRectGetMaxY(titleLabel.frame) + 14.5, 180, 20) numberOfStar:5 rateStyle:XHStarRateViewRateStyeHalfStar isAnimation:YES delegate:self];
    starRateView.currentRating = 5.0;
    self.userScore = starRateView.currentRating;
    [self.view addSubview:starRateView];
    
    self.appraiseTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(starRateView.frame) + 15, IPHONE_WIDTH - 40, 100)];
    self.appraiseTextView.layer.masksToBounds = YES;
    self.appraiseTextView.font = [UIFont systemFontOfSize:15];
    self.appraiseTextView.layer.cornerRadius = 10;
    self.appraiseTextView.layer.borderWidth = 0.5;
    self.appraiseTextView.layer.borderColor = RGBAColor(0, 0, 0, 0.2).CGColor;
    self.appraiseTextView.delegate = self;
    [self.view addSubview:self.appraiseTextView];
    
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, IPHONE_WIDTH - 60, 21)];
    self.placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    self.placeHolderLabel.text = @"请输入您对本课程的评价，300字以内";
    self.placeHolderLabel.textColor = RGBAColor(136, 136, 136, 1);
    [self.appraiseTextView addSubview:self.placeHolderLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH/2, CGRectGetMaxY(self.appraiseTextView.frame) + 10, IPHONE_WIDTH/2 - 20, 18.5)];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.text = @"评价内容不能为空";
    self.contentLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.contentLabel];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, CGRectGetMaxY(self.contentLabel.frame) + 10, IPHONE_WIDTH - 40, 47);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = 5;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    submitButton.backgroundColor = dominant_GreenColor;
    [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    self.wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPHONE_WIDTH - 95, CGRectGetMaxY(self.appraiseTextView.frame) - 20, 70, 21)];
    self.wordLabel.textAlignment = NSTextAlignmentRight;
    self.wordLabel.font = [UIFont systemFontOfSize:14];
    self.wordLabel.text = @"0/300";
    self.wordLabel.textColor = RGBAColor(136, 136, 136, 1);
    [self.view addSubview:self.wordLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0)
    {
        self.placeHolderLabel.text = @"请输入您对本课程的评价，300字以内";
        self.contentLabel.text = @"评价内容不能为空";
    }
    else if (textView.text.length > 300)
    {
        self.contentLabel.text = @"评价字数超出限制";
        self.contentLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.placeHolderLabel.text = @"";
        self.contentLabel.text = @"";
    }
    //不让显示负数
    self.wordLabel.text = [NSString stringWithFormat:@"%d/300",MAX(0,0 +(int)textView.text.length)];
}

-(void)starRateView:(XHStarRateView *)starRateView ratingDidChange:(CGFloat)currentRating {
    self.userScore = currentRating;
    NSLog(@"%f",self.userScore);
}

- (void)viewTapped:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)submitButtonAction:(UIButton *)button {
    
    
    
    
    if (self.appraiseTextView.text.length == 0) {
//        [self showHint:@"评价内容不能为空"];
        return;}
    [_request apiAddCommentCourseID:self.courseID
                             userID:  _uid
                            comment:self.appraiseTextView.text
                              score:self.userScore
                          commentID:0      /* 0-新加评论  非0-二级评论  */
                            success:^(NSDictionary * _Nonnull dic, BOOL state) {
                                if (state) {
//                                    [self showHint:@"评论成功!"];
                                    [self.appraiseTextView resignFirstResponder];
                                    
                                    DXLiveAppraiseSuccessViewController *appraiseSuccessVC = [[DXLiveAppraiseSuccessViewController alloc] init];
                                    if (self.liveAppraiseType == LiveAppraiseChooseType) {
                                        appraiseSuccessVC.liveAppraiseSuccessType = LiveAppraiseSuccessChooseType;
                                    }
                                    else if (self.liveAppraiseType == PlayBackAppraiseChooseType) {
                                        appraiseSuccessVC.liveAppraiseSuccessType = PlayBackAppraiseSuccessChooseType;
                                    }
                                    else if (self.liveAppraiseType == LiveAppraiseFinishType)
                                    {
                                        appraiseSuccessVC.liveAppraiseSuccessType = LiveAppraiseSuccessFinishType;
                                    }
                                    [self.navigationController pushViewController:appraiseSuccessVC animated:YES];
                                    
                                    /* 重置评分系数 */
                                    self.userScore = 0.0f;
                                }
                          } fail:^(NSError * _Nonnull error) {
                              
                          }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

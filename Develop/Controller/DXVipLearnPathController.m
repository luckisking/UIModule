//
//  DXVipLearnPathController.m
//  Doxuewang
//
//  Created by doxue_imac on 2019/6/29.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "DXVipLearnPathController.h"
#import "DXVipServiceApiRequest.h"

@interface DXVipLearnPathController ()

@property (nonatomic, strong) DXVipServiceApiRequest *apiRequest;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DXVipLearnPathController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage: [VipServiceImage(@"顶部通用背景") resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}

- (void)loadView {
    
    [super loadView];
    self.view.backgroundColor = RGBHex(0xF8F9FA);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习路径图";
    
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _apiRequest = [[DXVipServiceApiRequest alloc] init];
    [self requestLearnPathWithStage:_stage];
    
}


#pragma mark 数据请求

/**学习路径图*/
- (void)requestLearnPathWithStage:(NSString *)stage {
    [_apiRequest learnPathWithStage:stage success:^(NSDictionary * _Nonnull dic, BOOL state) {
        if ([dic[@"status"] boolValue]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                NSArray *dataArr = [dic[@"data"] isKindOfClass:[NSArray class]]?dic[@"data"]:@[];
              UILabel *label =  [self topLabelWithText:[NSString stringWithFormat:@"共%ld页",dataArr.count]];
                [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(label.mas_bottom);
                    make.left.mas_equalTo(self.view.mas_left);
                    make.right.mas_equalTo(self.view.mas_right);
                    make.bottom.mas_equalTo(self.view.mas_bottom).offset(iPhoneX?-34:0);
                }];
                UIView *preView ;
                for (int i=0; i<dataArr.count; i++) {
                    NSDictionary *dataDic = [dataArr[i] isKindOfClass:[NSDictionary class]]?dataArr[i]:@{};
                    UIView *view  =  [self cellUIWithTitle:dataDic[@"title"] image:dataDic[@"path"]];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (i==0) {
                               make.top.mas_equalTo(self.scrollView.mas_top);
                        }else {
                               make.top.mas_equalTo(preView.mas_bottom).offset(12);
                        }
                        make.left.mas_equalTo(self.view.mas_left);
                        make.right.mas_equalTo(self.view.mas_right);
                        make.height.mas_equalTo(280);
                    }];
                    preView = view;
                    
                }
                [self.scrollView layoutIfNeeded];
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, preView.frame.size.height*dataArr.count+30);

         
            });
        
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark 布局
- (UILabel *)topLabelWithText:(NSString *)text {
    UILabel *topLabel  = [DXCreateUI initLabelWithText:text textColor:RGBHex(0x666666) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:18] textAlignment:(NSTextAlignmentCenter)];
        [self.view addSubview:topLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(iPhoneX?88:64);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.height.mas_equalTo(45);
        }];
    return topLabel;
}
- (UIView *)cellUIWithTitle:(NSString *)title image:(NSString *)image {
    UIView *view = [[UIView alloc] init];
        [self.scrollView addSubview:view];
    UILabel *titileLabel  = [DXCreateUI initLabelWithText:title textColor:RGBHex(0x333333) font:[UIFont fontWithName:@"PingFangSC-Semibold" size:16] textAlignment:(NSTextAlignmentCenter)];
        [view addSubview:titileLabel];
        [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top);
            make.left.mas_equalTo(view.mas_left);
            make.right.mas_equalTo(view.mas_right);
            make.height.mas_equalTo(52);
        }];
    UIImageView *imv = [[UIImageView alloc] init];
        [view addSubview:imv];
        [imv setImageWithURL:[NSURL URLWithString:VSStringFormatWithFront([image hasPrefix:@"https"]?@"":@"https:", image)]];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(52, 20, 12, 20));
        }];
    
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

@end

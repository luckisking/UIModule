//
//  ViewController.m
//  UIModule
//
//  Created by doxue_imac on 2019/7/24.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "ViewController.h"
#import "JQPopSelectMenuView.h"

@interface ViewController ()<JQPopSelectMenuViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
}
- (void)addUI {
    [self.view setBackgroundColor:[UIColor cyanColor]];
    UIButton *btn3 =  [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn3 setTitle:@"什么情况啊，这么费劲呢 啊" forState:(UIControlStateNormal)];
    [btn3 addTarget:self action:@selector(action3) forControlEvents:(UIControlEventTouchUpInside)];
    [btn3.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self .view addSubview:btn3];
    btn3.titleLabel.numberOfLines =  0;
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(360);
        make.left.mas_equalTo(100);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    [btn3.titleLabel mas_makeConstraints:^(MASConstraintMaker *make)   {
        make.edges.equalTo(btn3).insets(UIEdgeInsetsMake(10, 10, 10,   10));
    }];
    btn3.backgroundColor = [UIColor blueColor];
}
- (void)action3 {
//        JQPopSelectMenuView *view =  [[JQPopSelectMenuView alloc] initSelectWithFrame:CGRectMake(20, 100, 200, 50)
//                                                                                items:@[@{@"image":@"",@"title":@"管理类联考"},
//                                                                                        @{@"image":@"",@"title":@"第二学士学位"},
//                                                                                        @{@"image":@"",@"title":@"在线商学院"},
//                                                                                        @{@"image":@"",@"title":@"基金从业考试"},
//                                                                                        @{@"image":@"",@"title":@"会计职称"}]
//                                                                               action:^(NSInteger index) {
//                                                                                   NSLog(@"点击了");
//                                                                               }];
//        view.backgroundColor = [UIColor blueColor];
//        view.delegate = self;
//        [self.view addSubview:view];
//
//
//
//    JQPopSelectMenuView *view1 = [[JQPopSelectMenuView alloc] initPopWithFrame:CGRectMake(20, 500, 200, 50)
//                                                                         items:@[@{@"image":@"",@"title":@"管理类联考"},
//                                                                                 @{@"image":@"",@"title":@"第二学士学位"},
//                                                                                 @{@"image":@"",@"title":@"在线商学院"},
//                                                                                 @{@"image":@"",@"title":@"基金从业考试"},
//                                                                                 @{@"image":@"",@"title":@"会计职称"}]
//                                                                        action:^(NSInteger index) {
//                                                                            NSLog(@"点击了");
//                                                                        }];
//
//    view1.delegate = self;
//    view1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view1];

    
    [JQPopSelectMenuView showPopWithFrame:CGRectMake(0, 0, 200, 50)
                                    items:@[@{@"image":@"",@"title":@"管理类联考"},
                                            @{@"image":@"",@"title":@"第二学士学位"},
                                            @{@"image":@"",@"title":@"在线商学院"},
                                            @{@"image":@"",@"title":@"基金从业考试"},
                                            @{@"image":@"",@"title":@"会计职称"}]
                            triangleFrame:CGRectMake(150, -9, 10, 10)
                                fillColor:[UIColor whiteColor]
                              strokeColor:[UIColor whiteColor]
                                 delegate:self
                                   action:^(NSInteger index) {
                                       NSLog(@"点击了");
                                   }];
}

- (void)JQPopSelectMenuViewCell:(JQPopSelectMenuTableViewCell *)cell setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}
//- (void)JQPopSelectMenuViewshowCustom:(UITableView *)tableView view:(JQPopSelectMenuView *)view {
//
//}

- (void)JQPopSelectMenuViewAppearanceConfigTableView:(UITableView *)tableView view:(JQPopSelectMenuView *)view {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(200);
            make.left.mas_offset(50);
            make.right.mas_offset(-50);
            make.height.mas_offset(100);
        }];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_bottom);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.height.mas_offset(500);
        }];
    
}

@end

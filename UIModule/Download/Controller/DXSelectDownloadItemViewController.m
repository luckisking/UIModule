//
//  DXSelectDownloadItemViewController.m
//  Doxuewang
//
//  Created by Zhang Lei on 2017/8/29.
//  Copyright © 2017年 都学网. All rights reserved.
//

#import "DXSelectDownloadItemViewController.h"
#import "DXSelectDownView.h"

@interface DXSelectDownloadItemViewController ()

@end

@implementation DXSelectDownloadItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height-22);
    DXSelectDownView *selectView = [[DXSelectDownView alloc]initWithFrame:frame];
    selectView.courseModel = self.course;
    selectView.dataSource = self.dataArray;
    selectView.isVideo = self.isVideo;
    [selectView initilizeDataSource:self.course.Id];
    
    @weakify(self);
    selectView.tapMyCloseBtn = ^(NSMutableArray *selectDownArr) {
        
        @strongify(self);

        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (self.closeButtonBlock) {
            self.closeButtonBlock(selectDownArr);
        }
    };
    
    selectView.tapNoChoiceBtn = ^(){
        
        @strongify(self);
        
        if (self.closeWithNoChoice) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            self.closeWithNoChoice();
        }
    };

    
    [self.view addSubview:selectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

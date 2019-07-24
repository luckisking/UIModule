//
//  ViewController.m
//  UIModule
//
//  Created by doxue_imac on 2019/7/24.
//  Copyright © 2019 都学网. All rights reserved.
//

#import "ViewController.h"
#import "Test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   Test *view =  [[Test alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor cyanColor];
    self.view = view;
}


@end

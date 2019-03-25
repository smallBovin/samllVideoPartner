//
//  MBServiceCenterViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/2/3.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBServiceCenterViewController.h"

@interface MBServiceCenterViewController ()

@end

@implementation MBServiceCenterViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"帮助中心";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}

@end

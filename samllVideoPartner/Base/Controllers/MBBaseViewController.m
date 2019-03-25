//
//  MBBaseViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

@interface MBBaseViewController ()

/** 返回按钮*/
@property (nonatomic, strong) UIBarButtonItem * backBarItem;

@end

@implementation MBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.backBarButtonItem = nil;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count>1) {
        self.navigationItem.leftBarButtonItem = self.backBarItem;
    }
}

- (UIBarButtonItem *)backBarButtonItem {
    return self.backBarItem;
}

- (void)back {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark--publish method--
/** 设置加载*/
- (void)setRefreshFunctionToScrollView:(UIScrollView *)scrollView refreshType:(MBRefreshType)type {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    footer.ignoredScrollViewContentInsetBottom = SAFE_INDICATOR_BAR;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"亲，已经到底了！" forState:MJRefreshStateNoMoreData];
    
    if (MBRefreshTypeOnlyHeader == type) {
        scrollView.mj_header = header;
    }else if (MBRefreshTypeOnlyFooter == type){
        scrollView.mj_footer = footer;
    }else {
        scrollView.mj_header = header;
        scrollView.mj_footer = footer;
    }
}

- (void)headerRefreshing{
    
}
- (void)footerRefreshing {
    
}


#pragma mark--控制器旋转控制----------
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark--lazy---
/** 导航f左侧返回按钮*/
- (UIBarButtonItem *)backBarItem {
    if (!_backBarItem) {
        _backBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dark_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _backBarItem;
}

- (void)dealloc {
    self.backBarItem = nil;
}

@end

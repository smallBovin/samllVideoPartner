//
//  MBBaseNavigationController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseNavigationController.h"

@interface MBBaseNavigationController () <UINavigationControllerDelegate>

/** 返回按钮*/
@property (nonatomic, strong) UIBarButtonItem * backBarItem;
@end

@implementation MBBaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark----UINavigationControllerDelegate----
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = (navigationController.viewControllers.count >= 2);
    }
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

/** 导航f左侧返回按钮*/
- (UIBarButtonItem *)backBarItem {
    if (!_backBarItem) {
        _backBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dark_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _backBarItem;
}
@end

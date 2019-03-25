//
//  UINavigationBar+Setting.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UINavigationBar+Setting.h"

@implementation UINavigationBar (Setting)

- (void)mb_setNavigationBarStyle:(MBNavigationBarStyle)style {
    if (style == MBNavigationBarStyleWhite) {
        [self setTranslucent:NO];
        [self setBarTintColor:[UIColor whiteColor]];
        [self setTintColor:[UIColor colorWithHexString:@"#333333"]];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        [self setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FC5F30" alpha:0.1]]];
    }else if (style == MBNavigationBarStyleDark) {
        [self setTranslucent:NO];
        [self setBarTintColor:[UIColor colorWithHexString:@"#232323"]];
        [self setTintColor:[UIColor whiteColor]];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        [self setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#232323"]]];
    }else {
        [self setTranslucent:YES];
        [self setBarTintColor:[UIColor clearColor]];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
        [self setTintColor:[UIColor whiteColor]];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    }
}


@end

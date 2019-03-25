//
//  AppDelegate.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/17.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Wechat.h"
#import "MBMainViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /** 微信授权登录、分享、支付处理*/
    [self registerWechatHandleApplication:application didFinishLaunchingWithOptions:launchOptions];
    /** 初始化IQKeyboardManager*/
    [self initlizationIQKeyboardManager];
    /** 初始化全局配置*/
    [self globalConfig];
    /** 初始化蓝松*/
    [LanSongEditor initSDK:@"xiaoshi_LanSongSDK_ios.key"];
    
    [Bugly startWithAppId:@"7ba8500ef9"];
//    [self registerMeiqiaSDK];
    
    self.window = [[UIWindow alloc]initWithFrame:kMainScreenBounds];
    MBMainViewController *mainVC = [MBMainViewController new];
    MBBaseNavigationController *nav = [[MBBaseNavigationController alloc]initWithRootViewController:mainVC];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [MQManager closeMeiqiaService];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [MQManager openMeiqiaService];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [MQManager registerDeviceToken:deviceToken];
}

//- (void)registerMeiqiaSDK {
//    [MQManager initWithAppkey:@"572c177a1721849c5ad668e58e6696a3" completion:^(NSString *clientId, NSError *error) {
//        if (!error) {
//            NSLog(@"美洽 SDK：初始化成功");
//        } else {
//            NSLog(@"error:%@",error);
//        }
//    }];
//}


#pragma mark--init Config
/** 初始化IQKeyboardManager*/
- (void)initlizationIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    Class videoMakeClass = NSClassFromString(@"MBVideoMakeViewController");
    Class previousNextView = NSClassFromString(@"MBPreviousNextView");
    Class musicSeacrhVC = NSClassFromString(@"MBSearchMusicViewController");
    [[IQKeyboardManager sharedManager].toolbarPreviousNextAllowedClasses addObjectsFromArray:@[[previousNextView class]]];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObjectsFromArray:@[[videoMakeClass class],[musicSeacrhVC class]]];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)globalConfig {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    [reach startNotifier];
    
    [UIButton appearance].exclusiveTouch = YES;
    if (kAPIVersion11Later) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [[MBAppEnviromentConfig shareConfig] setCurrentEnviromentType:MBEnviromentTypeProduct];
    [MBUserManager manager];
}

@end

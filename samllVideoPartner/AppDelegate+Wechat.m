//
//  AppDelegate+Wechat.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "AppDelegate+Wechat.h"
#import "MBWechatApiManager.h"      //微信功能封装类

@implementation AppDelegate (Wechat)

- (void)registerWechatHandleApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /** 应用启动时注册*/
    [[MBWechatApiManager shareManager]registerAppToWechatOauthList];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[MBWechatApiManager shareManager]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        
    }else {
        return  [WXApi handleOpenURL:url delegate:[MBWechatApiManager shareManager]];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        
    }else {
        return  [WXApi handleOpenURL:url delegate:[MBWechatApiManager shareManager]];
    }
    return YES;
}

@end

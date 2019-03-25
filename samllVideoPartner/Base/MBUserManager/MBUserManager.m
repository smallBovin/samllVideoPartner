//
//  MBUserManager.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBUserManager.h"



@interface MBUserManager ()
/** 系统配置信息model*/
@property (nonatomic, strong) MBAppConfigInfo * configModel;
/** 微信授权登录信息*/
@property (nonatomic, strong) MBWechatInfoModel * wechatModel;
/** 用户信息model*/
@property (nonatomic, strong) MBUserInfo * userInfoModel;

@end

@implementation MBUserManager

+ (instancetype)manager {
    static MBUserManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBUserManager alloc]init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getAllApplicationConfigInfo];
        if ([self isLogin]) {
            [self loadOrUpdateUserInfo];
        }
    }
    return self;
}

#pragma mark--getter---
- (NSString *)token {
    NSString *userToken = nil;
    userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    if (!userToken || [userToken isKindOfClass:[NSNull class]]) {
        if (self.wechatModel != nil && self.wechatModel.token.length>0) {
            userToken = self.wechatModel.token;
        }
    }
    return userToken;
}
- (NSString *)openid {
    NSString *userOpenid = nil;
    userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    if (!userOpenid || [userOpenid isKindOfClass:[NSNull class]]) {
        if (self.wechatModel != nil && self.wechatModel.openid.length>0) {
            userOpenid = self.wechatModel.openid;
        }
    }
    return userOpenid;
}
- (MBAppConfigInfo *)configInfo {
    return self.configModel;
}
- (MBUserInfo *)userInfo {
    return self.userInfoModel;
}
- (UIImage *)shareImage {
    NSString *url = [NSString stringWithFormat:@"%@%@",self.configModel.img_prefix,self.configModel.share_pic];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:imageData];
}
- (BOOL)isLogin {
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    if (userToken.length>0 && userOpenid.length>0 && [self.wechatModel.is_mobile isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isVip {
    if ([self isLogin]) {
        BOOL isVip = [[NSUserDefaults standardUserDefaults]boolForKey:kUserOpenVip];
        return isVip;
    }
    return NO;
}

- (BOOL)isUnderReview {
    if (![self.configModel.is_wxpay isEqualToString:@"1"] && ![self.configModel.is_alipay isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (void)loginOut {
    if ([self isLogin]) {
        self.wechatModel = nil;
        self.userInfoModel = nil;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserToken];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUserOpenid];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kUserOpenVip];
    }
}

#pragma mark--private method---
- (void)saveUserInfo {
    [[NSUserDefaults standardUserDefaults]setObject:self.wechatModel.token forKey:kUserToken];
    [[NSUserDefaults standardUserDefaults]setObject:self.wechatModel.openid forKey:kUserOpenid];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark--请求接口处理----
/** 获取系统配置*/
- (void)getAllApplicationConfigInfo {
    
    [RequestUtil POST:APPLICATION_CONFIG_API parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.configModel = [MBAppConfigInfo mj_objectWithKeyValues:responseObject[@"datalist"]];
        }else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"102"]){
            [self loginOut];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
/** 微信授权登录*/
- (void)WechatAuthLoginWithCode:(NSString *)code complement:(nonnull void (^)(BOOL))complement {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:code forKey:@"code"];
    [RequestUtil GET:WECHAT_LOGIN_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.wechatModel = [MBWechatInfoModel mj_objectWithKeyValues:responseObject];
            //保存用户信息
            [self saveUserInfo];
            if ([self.wechatModel.is_mobile isEqualToString:@"1"]) { //已绑定
                if (complement) {
                    complement(NO);
                }
                //刷新用户信息
                [self loadOrUpdateUserInfo];
            }else { //未绑定，需要绑定
                if (complement) {
                    complement(YES);
                }
            }
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
/** 获取验证码*/
- (void)getVerifyCodeWithMobilePhone:(NSString *)mobile success:(void (^)(BOOL))success {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"mobile"] = mobile.length>0?mobile:@"";
    [RequestUtil POST:SEND_VERIFY_CODE_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            if (success) {
                success(YES);
            }
        }else {
            if (success) {
                success(NO);
            }
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) {
            success(NO);
        }
    }];
}

/** 绑定手机号*/
- (void)userBindingMobilePhone:(NSString *)mobile verifyCode:(NSString *)verifyCode bindSuccess:(nonnull void (^)(BOOL))success {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"tokens"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"mobile"] = mobile.length>0?mobile:@"";
    dict[@"code"] = verifyCode.length>0?verifyCode:@"";
    [RequestUtil POST:BINDING_MOBILE_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self saveUserInfo];
            //刷新用户信息
            [self loadOrUpdateUserInfo];
            if (success) {
                success(YES);
            }
        }else {
            if (success) {
                success(NO);
            }
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) {
            success(NO);
        }
    }];
}

/** 获取或更新用户信息*/
- (void)loadOrUpdateUserInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    [RequestUtil POST:USER_INFO_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.userInfoModel = [MBUserInfo mj_objectWithKeyValues:responseObject[@"datalist"]];
            if ([self.userInfoModel.is_vip isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kUserOpenVip];
            }else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kUserOpenVip];
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
            //用户信息刷新完成/登录完成
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserInfoUpdateCompleteNotification object:nil];
        }else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"102"]){
            [self loginOut];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)addRecommendPersonWithID:(NSString *)recommendId complement:(nonnull void (^)(NSString * _Nonnull))complement {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"code"] = recommendId;
    [RequestUtil POST:SET_REFERRER_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            if (complement) {
                complement(@"success");
            }
        }else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"102"]) {
            [[MBUserManager manager]loginOut];
            if (complement) {
                complement(@"102");
            }
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
@end

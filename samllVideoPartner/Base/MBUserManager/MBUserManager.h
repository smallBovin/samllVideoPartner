//
//  MBUserManager.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 微信登录成功返回的信息*/
#import "MBWechatInfoModel.h"
/** 应用配置信息*/
#import "MBAppConfigInfo.h"
/** 用户个人信息*/
#import "MBUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBUserManager : NSObject

/** 用户请求令牌*/
@property (nonatomic, copy ,readonly) NSString * token;
/** 用户的openid*/
@property (nonatomic, copy ,readonly) NSString * openid;
/** 应用配置信息*/
@property (nonatomic, strong ,readonly) MBAppConfigInfo * configInfo;
/** 用户信息*/
@property (nonatomic, strong ,readonly) MBUserInfo * userInfo;
/** 分享图片*/
@property (nonatomic, strong ,readonly) UIImage * shareImage;

+ (instancetype)manager;

/** 微信授权登录*/
- (void)WechatAuthLoginWithCode:(NSString *)code complement:(void(^)(BOOL isNeedBind))complement;
/** 获取验证码*/
- (void)getVerifyCodeWithMobilePhone:(NSString *)mobile success:(void(^)(BOOL isSend))success;
/** 用户绑定手机号码*/
- (void)userBindingMobilePhone:(NSString *)mobile verifyCode:(NSString *)verifyCode bindSuccess:(void(^)(BOOL isBind))success;
/** 获取或者更新用户信息*/
- (void)loadOrUpdateUserInfo;
/** 添加推荐人*/
- (void)addRecommendPersonWithID:(NSString *)recommendId complement:(void(^)(NSString *recommendName))complement;

- (BOOL)isLogin;

- (BOOL)isVip;

- (void)loginOut;

- (BOOL)isUnderReview;

@end

NS_ASSUME_NONNULL_END

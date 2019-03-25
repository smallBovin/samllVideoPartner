//
//  MBWechatApiManager.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
#import <WXApiObject.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MBWechatApiManagerDelegate <NSObject>

@optional
/** 微信授权回调方法*/
- (void)weChatAuthSuccessWithCode:(NSString *)code;  //授权成功
- (void)weChatAuthDeny;     //授权失败
- (void)cancelWechatAuth;   //用户取消授权



@end

@interface MBWechatApiManager : NSObject <WXApiDelegate>

/** 微信回调处理*/
@property (nonatomic, weak) id<MBWechatApiManagerDelegate> delegate;

+ (instancetype)shareManager;

/** 应用启动时向微信终端程序注册应用（需要登录一次才能完成注册）*/
- (void)registerAppToWechatOauthList;

/** 是否安装微信客户端*/
- (BOOL)isInstallWeChat;

/** 用户点击微信授权登录*/
- (void)sendAuthRequestWithController:(UIViewController *)controller delegate:(id<MBWechatApiManagerDelegate>)delegate;

/** ====微信分享api=====*/

/**
 往微信中分享网页链接

 @param urlString 网页链接的url
 @param title 分享网页标题描述
 @param description 具体详细描述
 @param thumbImage 分享时携带的缩略图
 @param scence 分享到微信的场景
 */
- (BOOL)shareLinkContent:(NSString *)urlString
                   title:(NSString *)title
             description:(NSString *)description
              thumbImage:(UIImage *)thumbImage
                atScence:(enum WXScene)scence;

/**
 往微信分享文件

 @param fileData 文件的二进制数据
 @param extension 文件后缀描述
 @param title 文件标题
 @param description 文件详情描述
 @param thumbImage 分享时携带的缩略图
 @param scence 分享场景
 */
- (BOOL)shareFileData:(NSData *)fileData
        fileExtension:(NSString *)extension
                title:(NSString *)title
          description:(NSString *)description
           thumbImage:(UIImage *)thumbImage
             atScence:(enum WXScene)scence;

- (void)openVipWithWechatPay;



/** 支付宝的支付接口，测试用iOS目前不对接*/
- (void)openVipWithAlipay;


@end

NS_ASSUME_NONNULL_END

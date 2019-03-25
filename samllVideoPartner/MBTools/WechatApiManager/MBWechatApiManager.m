//
//  MBWechatApiManager.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBWechatApiManager.h"

#define kWechatPlatformAppKey       @"wx9a6ffd254917aaed"

@interface MBWechatApiManager (){
    
    NSString *authCode;
}



@end

@implementation MBWechatApiManager

+ (instancetype)shareManager {
    static MBWechatApiManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
    });
    return _manager;
}
/** 是否安装微信客户端*/
- (BOOL)isInstallWeChat {
    return [WXApi isWXAppInstalled];
}

- (void)registerAppToWechatOauthList {
    if ([NSThread currentThread].isMainThread) {
        [WXApi registerApp:kWechatPlatformAppKey];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [WXApi registerApp:kWechatPlatformAppKey];
        });
    }
}

- (void)sendAuthRequestWithController:(UIViewController *)controller delegate:(id<MBWechatApiManagerDelegate>)delegate {
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    authCode = req.state = [NSString randomKey];
    self.delegate = delegate;
    [WXApi sendAuthReq:req viewController:controller delegate:self];
}

- (BOOL)shareLinkContent:(NSString *)urlString title:(NSString *)title description:(NSString *)description thumbImage:(nonnull UIImage *)thumbImage atScence:(enum WXScene)scence {
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    message.thumbData = UIImageJPEGRepresentation(thumbImage, 0.6);
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scence;
    return [WXApi sendReq:req];
}

- (BOOL)shareFileData:(NSData *)fileData fileExtension:(NSString *)extension title:(NSString *)title description:(NSString *)description thumbImage:(UIImage *)thumbImage atScence:(enum WXScene)scence {
   
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scence;
    
    return [WXApi sendReq:req];
}

- (void)openVipWithWechatPay {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"pay_type"] = @(1);
    [RequestUtil POST:VIP_PAY_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            
            if (![self isInstallWeChat]) {
                [MBProgressHUD showOnlyTextMessage:@"请先安装微信客户端"];
            }
            NSDictionary *dict = responseObject[@"datalist"][@"wx_data"];
            //调起微信支付
            PayReq *req = [[PayReq alloc] init];
            
            req.openID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"appid"]];//应用ID  微信开放平台审核通过的应用APPID
            req.partnerId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"partnerid"]];//商户号  微信支付分配的商户号
            req.prepayId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"prepayid"]];//预支付交易会话ID  微信返回的支付交易会话ID
            req.nonceStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"noncestr"]];//随机字符串
            req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];//时间戳
            req.package = [NSString stringWithFormat:@"%@",[dict objectForKey:@"package"]];//扩展字段
            req.sign = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sign"]];//签名
            NSLog(@"微信支付下单 ==== %@ ",req);
            [WXApi sendReq:req];
            
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)openVipWithAlipay {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"pay_type"] = @(2);
    [RequestUtil POST:VIP_PAY_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
//            NSString *rsult = responseObject[@"datalist"][@"ali_data"];
//            NSURL *AliPay_APPURL = [NSURL URLWithString:@"alipay:"];
//            [[AlipaySDK defaultService] payOrder:rsult fromScheme:@"smallVidoePartner" callback:^(NSDictionary *resultDic) {
//
//                if (![[UIApplication sharedApplication] canOpenURL:AliPay_APPURL]) {
//
//                    NSArray *array = [[UIApplication sharedApplication] windows];
//
//                    UIWindow* win=[array objectAtIndex:0];
//
//                    [win setHidden:NO];
//                }
//            }];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark--WXApiDelegate--
/** 收到微信的回应信息*/
-(void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        [self authStateHandlerWithResp:authResp];
    }else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        NSLog(@"response.errCode = %d",response.errCode);
        [[NSNotificationCenter defaultCenter] postNotificationName:MBWechatPayResponseNotification object:[NSString stringWithFormat:@"%d",response.errCode]];
    }
}
#pragma mark--微信授权回调信息处理---
/** 授权登录的信息回调处理*/
- (void)authStateHandlerWithResp:(SendAuthResp*)authResp {
    if (![authResp.state isEqualToString:authCode]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weChatAuthDeny)])
            [self.delegate weChatAuthDeny];
        return;
    }
    switch (authResp.errCode) {
        case WXSuccess:
            NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
            if (self.delegate && [self.delegate respondsToSelector:@selector(weChatAuthSuccessWithCode:)])
                [self.delegate weChatAuthSuccessWithCode:authResp.code];
            break;
        case WXErrCodeAuthDeny:
            if (self.delegate && [self.delegate respondsToSelector:@selector(weChatAuthDeny)])
                [self.delegate weChatAuthDeny];
            break;
        case WXErrCodeUserCancel:
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWechatAuth)])
                [self.delegate cancelWechatAuth];
        default:
            break;
    }
}

@end

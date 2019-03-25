//
//  MBConst.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#ifndef MBConst_h
#define MBConst_h

/** 相册中最新视频缩略图key*/
#define kNewestVideoThum    @"MBNewestVideoThum"

/** 用户信息*/
#define kUserToken      @"MBUserToken"
#define kUserOpenid     @"MBUserOpenid"
#define kUserOpenVip    @"MBUserOpenVip"


/** 阿里云语音识别*/
#define aliyunToken     @"MBAliyunRecogniseToken"
#define aliyunTokenExpireTime @"MBAliyunTokenExpireTime"

/** 登录登出开通VIP等用户信息发生改变刷新界面*/
#define kUserInfoUpdateCompleteNotification  @"MBUserInfoUpdateCompleteNotification"

/** 微信支付结果回调*/
#define MBWechatPayResponseNotification     @"MBWechatPayResponseNotification"
/** 支付宝支付结果回调*/
#define MBAlipayResponseNotification    @"MBAlipayResponseNotification"


#endif /* MBConst_h */

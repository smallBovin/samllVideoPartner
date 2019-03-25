//
//  MBAppConfigInfo.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAppConfigInfo : NSObject
/** 平台协议*/
@property (nonatomic, copy) NSString * introduce;
/** 用户协议*/
@property (nonatomic, copy) NSString * protocol;
/** 代理商提现门槛*/
@property (nonatomic, copy) NSString * agent_requirement;
/** 分销提现门槛*/
@property (nonatomic, copy) NSString * dis_requirement;
/** 客服电话*/
@property (nonatomic, copy) NSString * phone;
/** 客服微信*/
@property (nonatomic, copy) NSString * wx;
/** 客服二维码*/
@property (nonatomic, copy) NSString * qrcode;
/** vip价格*/
@property (nonatomic, copy) NSString * vip_price;
/** 分享标题*/
@property (nonatomic, copy) NSString * share_title;
/** 分享标题*/
@property (nonatomic, copy) NSString * share_content;
/** 分享图片*/
@property (nonatomic, copy) NSString * share_pic;
/** 是否开启微信支付*/
@property (nonatomic, copy) NSString * is_wxpay;
/** 是否开启支付宝支付*/
@property (nonatomic, copy) NSString * is_alipay;
/** 代理提现费率*/
@property (nonatomic, copy) NSString * agent_tax;
/** 分销提现费率*/
@property (nonatomic, copy) NSString * dis_tax;
/** 图片位置*/
@property (nonatomic, copy) NSString * img_prefix;




@end

NS_ASSUME_NONNULL_END

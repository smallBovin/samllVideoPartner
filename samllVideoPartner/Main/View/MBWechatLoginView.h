//
//  MBWechatLoginView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CloseLoginAlertAction)(void);
typedef void(^WechatAuthLoginBlock)(void);
typedef void(^SeeUserProtocolAction)(void);
typedef void(^SeeUserPrivacyPolicyAction)(void);

@interface MBWechatLoginView : UIView

/** 关闭弹框按钮*/
@property (nonatomic, copy) CloseLoginAlertAction closeAction;
/** 微信授权登录*/
@property (nonatomic, copy) WechatAuthLoginBlock  loginAction;
/** 点击用户协议*/
@property (nonatomic, copy) SeeUserProtocolAction  protocolAction;
/** 隐私政策协议*/
@property (nonatomic, copy) SeeUserPrivacyPolicyAction  privacyAction;



@end

NS_ASSUME_NONNULL_END

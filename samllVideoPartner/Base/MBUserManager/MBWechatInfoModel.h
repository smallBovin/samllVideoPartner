//
//  MBWechatInfoModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBWechatInfoModel : NSObject

/** 用户id*/
@property (nonatomic, copy) NSString * userId;
/** 用户头像*/
@property (nonatomic, copy) NSString * avatar;
/** 用户昵称*/
@property (nonatomic, copy) NSString * nickname;
/** openid*/
@property (nonatomic, copy) NSString * openid;
/** 用户令牌*/
@property (nonatomic, copy) NSString * token;
/** 是否绑定手机号*/
@property (nonatomic, copy) NSString * is_mobile;

@end

NS_ASSUME_NONNULL_END

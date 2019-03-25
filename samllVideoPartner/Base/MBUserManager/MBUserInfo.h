//
//  MBUserInfo.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBUserInfo : NSObject

/** 用户id*/
@property (nonatomic, copy) NSString * userId;
/** 用户头像*/
@property (nonatomic, copy) NSString * avatar;
/** 用户昵称*/
@property (nonatomic, copy) NSString * nickname;
/** 推荐人*/
@property (nonatomic, copy) NSString * fid;
/** 是否开通VIP（1 vip  2 普通用户）*/
@property (nonatomic, copy) NSString * is_vip;
/** 是否分销（1 是 2 否）*/
@property (nonatomic, copy) NSString * is_distribution;
/** 是否代理（1 是 2 否）*/
@property (nonatomic, copy) NSString * is_agent;
/** vip 到期时间*/
@property (nonatomic, copy) NSString * over_time;
/** 用户绑定的电话*/
@property (nonatomic, copy) NSString * mobile;
/** 用户推荐码*/
@property (nonatomic, copy) NSString * code;



@end

NS_ASSUME_NONNULL_END

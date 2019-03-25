//
//  MBPerformanceModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBPerformanceModel : NSObject

/** 可提现余额*/
@property (nonatomic, copy) NSString * balance;
/** 冻结余额*/
@property (nonatomic, copy) NSString * freezing;
/** 所有的余额*/
@property (nonatomic, copy) NSString * total;
/** 代理省份*/
@property (nonatomic, copy) NSString * agent_province;
/** 代理市*/
@property (nonatomic, copy) NSString * agent_city;
/** 代理人数*/
@property (nonatomic, copy) NSString * agent_user;

/** ===分销专有属性===*/
/** 分销标题*/
@property (nonatomic, copy) NSString * dis_level;
/** 已使用分销人数*/
@property (nonatomic, copy) NSString * dis_out;
/** 总共可分销人数*/
@property (nonatomic, copy) NSString * dis_total;



@end

NS_ASSUME_NONNULL_END

//
//  MBWithdrawModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/14.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBWithdrawModel : NSObject


/** 状态类型*/
@property (nonatomic, copy) NSString * status;
/** 提现金额*/
@property (nonatomic, copy) NSString * price;
/** 到账金额*/
@property (nonatomic, copy) NSString * money;
/** 手续费*/
@property (nonatomic, copy) NSString * poundage;
/** 申请提现时间*/
@property (nonatomic, copy) NSString * apply_time;

@end

NS_ASSUME_NONNULL_END

//
//  MBApplyWithdrawViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/5.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"
#import "MBPerformanceHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBApplyWithdrawViewController : MBBaseViewController

/** 类型*/
@property (nonatomic, assign) MBPerformanceType  type;
/** 可提现金额*/
@property (nonatomic, copy) NSString * canWithdrawMoney;

@end

NS_ASSUME_NONNULL_END

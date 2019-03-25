//
//  MBWithdrawBaseViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

#import "MBPerformanceHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBWithdrawStatus) {
    MBWithdrawStatusAll = 0,
    MBWithdrawStatusWaitPay = 1,
    MBWithdrawStatusDenied = 3,
    MBWithdrawStatusRejected = 4,
    MBWithdrawStatusFinished = 2,
};

@interface MBWithdrawBaseViewController : MBBaseViewController

/** 提现状态*/
@property (nonatomic, assign) MBWithdrawStatus  status;

/** 请求数据类型*/
@property (nonatomic, assign) MBPerformanceType  type;

@end

NS_ASSUME_NONNULL_END

//
//  MBPerformanceHeaderView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBPerformanceHeader.h"

@class MBPerformanceModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBHeaderWithdrawAction)(void);

@interface MBPerformanceHeaderView : UIView

/** 类型*/
@property (nonatomic, assign) MBPerformanceType  headerType;

/** 界面的数据*/
@property (nonatomic, strong) MBPerformanceModel * model;

/** 提现*/
@property (nonatomic, copy) MBHeaderWithdrawAction  withdrawAction;

@end

NS_ASSUME_NONNULL_END

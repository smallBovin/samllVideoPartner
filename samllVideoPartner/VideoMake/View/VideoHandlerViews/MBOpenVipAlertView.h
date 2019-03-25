//
//  MBOpenVipAlertView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBOpenVipBlock)(void);
@interface MBOpenVipAlertView : UIView

/** 开通VIP*/
@property (nonatomic, copy) MBOpenVipBlock  openVip;


@end

NS_ASSUME_NONNULL_END

//
//  MBVipPayAlertView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBPayType) {
    MBPayTypeWecahtPay,
    MBPayTypeAlipay,
};

typedef void(^MBOpenVIPPayBlock)(MBPayType payType);

@interface MBVipPayAlertView : UIView

/** 支付*/
@property (nonatomic, copy) MBOpenVIPPayBlock  payBlock;
@end

NS_ASSUME_NONNULL_END

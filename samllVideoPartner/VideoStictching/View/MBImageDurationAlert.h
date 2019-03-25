//
//  MBImageDurationAlert.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/17.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBCancelSetImageDurationBlock)(void);
typedef void(^MBSetImageDurationSuccessBlock)(float duration);

@interface MBImageDurationAlert : UIView

/** 取消*/
@property (nonatomic, copy) MBCancelSetImageDurationBlock  cancelBlock;
/** 确定*/
@property (nonatomic, copy) MBSetImageDurationSuccessBlock  successBlock;


@end

NS_ASSUME_NONNULL_END

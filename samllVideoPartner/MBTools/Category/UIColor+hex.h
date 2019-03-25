//
//  UIColor+hex.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIColor (hex)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END

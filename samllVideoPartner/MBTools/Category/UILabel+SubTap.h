//
//  UILabel+SubTap.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SubTap)

- (CGRect)boundingRectForCharacterRange:(NSRange)range;

//快速创建label
+(instancetype)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color  font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  lines:(CGFloat)lines;

@end

NS_ASSUME_NONNULL_END

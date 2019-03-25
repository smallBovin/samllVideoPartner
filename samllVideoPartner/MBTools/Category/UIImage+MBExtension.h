//
//  UIImage+MBExtension.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MBExtension)

/**返回一个纯色的图片*/
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 返回固定尺寸的纯色图片

 @param color 图片的颜色
 @param size 设置需要返回图片的尺寸
 @return 返回固定尺寸的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 返回固定尺寸的纯色半透明图片

 @param color 图片的颜色
 @param size 设置需要返回图片的尺寸
 @param alpha 图片的透明度
 @return 返回固定尺寸的纯色半透明图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha;


/**
 返回一张圆形的图片

 @param image 需要裁剪的图片
 @return 返回裁剪过的圆形的图片
 */
+ (UIImage *)clipCircleImageWithImage:(UIImage *)image;

/**
 缩放图片到一个固定的尺寸

 @param size 固定的尺寸
 @return 返回固定尺寸的图片
 */
- (UIImage *)imageScaleToSize:(CGSize)size;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END

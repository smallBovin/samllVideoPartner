//
//  UIImage+MBExtension.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UIImage+MBExtension.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (MBExtension)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1) alpha:1.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    return [self imageWithColor:color size:size alpha:1.0];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha {
    if (alpha<0) {
        alpha = 0;
    }
    if (alpha>1) {
        alpha = 1.0;
    }
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)clipCircleImageWithImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width+2, image.size.height+2);
    //图片上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO , [UIScreen mainScreen].scale);
    //  UIBezierPath 在上下文添加一个圆形裁剪区域
    UIBezierPath *boardPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    [[UIColor whiteColor]set];
    [boardPath fill];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1.0, 1.0, image.size.width, image.size.height)];
    [path addClip];
    //绘制图片到上下文
    [image drawAtPoint:CGPointMake(1.0, 1.0)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageScaleToSize:(CGSize)size {
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

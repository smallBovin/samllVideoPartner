//
//  UIView+MBExtension.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UIView+MBExtension.h"

@implementation UIView (MBExtension)

-(void)setCs_origin:(CGPoint)cs_origin {
    
    CGRect frame = self.frame;
    frame.origin = cs_origin;
    self.frame = frame;
}
-(CGPoint)cs_origin {
    return self.frame.origin;
}

-(void)setCs_x:(CGFloat)cs_x {
    CGRect frame = self.frame;
    frame.origin.x = cs_x;
    self.frame = frame;
}
-(CGFloat)cs_x {
    return self.frame.origin.x;
}

-(void)setCs_y:(CGFloat)cs_y {
    CGRect frame = self.frame;
    frame.origin.y = cs_y;
    self.frame = frame;
}
-(CGFloat)cs_y {
    return self.frame.origin.y;
}
-(void)setCs_width:(CGFloat)cs_width {
    CGRect frame = self.frame;
    frame.size.width = cs_width;
    self.frame = frame;
}
-(CGFloat)cs_width {
    return self.frame.size.width;
}

-(void)setCs_height:(CGFloat)cs_height {
    
    CGRect frame = self.frame;
    frame.size.height = cs_height;
    self.frame = frame;
}
-(CGFloat)cs_height {
    return self.frame.size.height;
}
-(void)setCs_size:(CGSize)cs_size {
    CGRect frame = self.frame;
    frame.size = cs_size;
    self.frame = frame;
}
-(CGSize)cs_size {
    return self.frame.size;
}

-(void)setCs_centerX:(CGFloat)cs_centerX{
    CGPoint center = self.center;
    center.x = cs_centerX;
    self.center = center;
}
-(CGFloat)cs_centerX {
    return self.center.x;
}

-(void)setCs_centerY:(CGFloat)cs_centerY {
    
    CGPoint center = self.center;
    center.y = cs_centerY;
    self.center = center;
}

-(CGFloat)cs_centerY {
    return self.center.y;
}

-(void)setCs_borderColor:(UIColor *)cs_borderColor{
    self.layer.borderColor = cs_borderColor.CGColor;
}

- (UIColor *)cs_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
-(void)setCs_borderWidth:(CGFloat)cs_borderWidth {
    self.layer.borderWidth = cs_borderWidth;
}
-(CGFloat)cs_borderWidth {
    return self.layer.borderWidth;
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
}

- (void)setCornerRadius:(CGFloat)radius rectCornerType:(UIRectCorner)cornerType {
    
    CGSize radiusSize = CGSizeMake(radius, radius);
    UIBezierPath *cornerBezil = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:cornerType cornerRadii:radiusSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = cornerBezil.CGPath;
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = cornerBezil.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = self.layer.borderColor;
    borderLayer.lineWidth = self.layer.borderWidth;
    borderLayer.frame = self.bounds;
    [self.layer addSublayer:borderLayer];
    
}

-(void)addSingleTapGestureTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (UIViewController *)locationViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    
    return nil;
}
- (UIImage *)snapshotImage {
    return [self snapshotImageClipped:self.bounds];
}

- (UIImage*) snapshotImageClipped: (CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    if (!CGRectEqualToRect (self.bounds, rect))
    {
        CGImageRef resized = CGImageCreateWithImageInRect (snapshot.CGImage, rect);
        snapshot = [UIImage imageWithCGImage: resized];
        CGImageRelease(resized);
    }
    
    return snapshot;
}
@end

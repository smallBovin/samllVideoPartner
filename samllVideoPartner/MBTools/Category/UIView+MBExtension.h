//
//  UIView+MBExtension.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (MBExtension)
/**设置*/
@property (nonatomic,assign) CGSize cs_size;
/**设置*/
@property (nonatomic,assign) CGPoint cs_origin;
/**设置*/
@property (nonatomic,assign) CGFloat cs_width;
/**设置*/
@property (nonatomic,assign) CGFloat cs_height;
/**设置*/
@property (nonatomic,assign) CGFloat cs_x;
/**设置*/
@property (nonatomic,assign) CGFloat cs_y;
/**设置*/
@property (nonatomic,assign) CGFloat cs_centerX;
/**设置*/
@property (nonatomic,assign) CGFloat cs_centerY;
/**设置边线颜色*/
@property (nonatomic,strong,nullable) UIColor *cs_borderColor;
/**设置边线宽度*/
@property (nonatomic,assign) CGFloat cs_borderWidth;

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

- (void)setCornerRadius:(CGFloat)radius rectCornerType:(UIRectCorner)cornerType;

- (void)addSingleTapGestureTarget:(nonnull id)target action:(nonnull SEL)action;

- (UIViewController *_Nullable)locationViewController;

- (UIImage *)snapshotImage;
@end

NS_ASSUME_NONNULL_END

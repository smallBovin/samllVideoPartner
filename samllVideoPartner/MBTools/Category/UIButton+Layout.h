//
//  UIButton+Layout.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//按钮图片与标题位置枚举
typedef NS_ENUM(NSUInteger, MBButtonType) {
    MBButtonTypeNone,                   //默认状态下不调用重新布局
    MBButtonTypeTopImageBottomTitle,    //图上标题下
    MBButtonTypeLeftImageRightTitle,    //图左标题右
    MBButtonTypeBottomImageTopTitle,    //图下标题上
    MBButtonTypeRightImageLeftTitle,    //图右标题左
};

typedef NS_ENUM(NSUInteger, MBButtonAlignment) {
    MBButtonAlignmentLeft,       //内容居左显示
    MBButtonAlignmentCenter,     //内容居中显示
    MBButtonAlignmentRight,      //内容居右显示
};

@interface UIButton (Layout)

//按钮图片与标题的位置类型
@property (nonatomic, assign) MBButtonType type;
//内容显示的方式
@property (nonatomic, assign) MBButtonAlignment textAlignment;
//图片与标题之间的距离,默认为5
@property (nonatomic, assign) CGFloat spaceMargin;
//横向布局时,调整文字或图片的边距，默认均为10;
@property (nonatomic, assign) CGFloat edgeMargin;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font image:(UIImage *)image type:(MBButtonType)type textAlignment:(MBButtonAlignment)textAlignment action:(void(^)(UIButton *btn))action;

@end

NS_ASSUME_NONNULL_END

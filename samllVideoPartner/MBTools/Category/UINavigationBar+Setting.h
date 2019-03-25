//
//  UINavigationBar+Setting.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MBNavigationBarStyle) {
    MBNavigationBarStyleWhite,  //纯白
    MBNavigationBarStyleDark,   //纯黑
    MBNavigationBarStyleClear,  //透明
};

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (Setting)

- (void)mb_setNavigationBarStyle:(MBNavigationBarStyle)style;

@end

NS_ASSUME_NONNULL_END

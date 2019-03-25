//
//  MBStyleTemplateModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBStyleTemplateModel : NSObject

/** 风格模板*/
@property (nonatomic, copy) NSString * cid;
/** 是否是VIP（1. vip  2,普通用户）*/
@property (nonatomic, copy) NSString * author;
/** 文件名*/
@property (nonatomic, copy) NSString * title;
/** 字体*/
@property (nonatomic, copy) NSString * font_size;
/** 背景图*/
@property (nonatomic, copy) NSString * bg_pic;
/** 颜色1*/
@property (nonatomic, copy) NSString * color1;
/** 颜色2*/
@property (nonatomic, copy) NSString * color2;
/** 颜色3*/
@property (nonatomic, copy) NSString * color3;
/** 颜色4*/
@property (nonatomic, copy) NSString * color4;
/** 使用几种颜色*/
@property (nonatomic, copy) NSString * number;



@end

NS_ASSUME_NONNULL_END

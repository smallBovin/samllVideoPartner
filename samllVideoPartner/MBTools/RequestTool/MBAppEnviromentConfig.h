//
//  MBAppEnviromentConfig.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBEnviromentType) {
    MBEnviromentTypeTesting,        //测试环境
    MBEnviromentTypePrepareRelease, //预发布环境
    MBEnviromentTypeProduct,        //发布环境
};

@interface MBAppEnviromentConfig : NSObject

/**
 初始化一个网络环境配置类
 
 @return 网络环境管理对象
 */
+ (instancetype)shareConfig;
/**
 设置当前应用的网络环境类型
 
 @param type 网络环境类型（eg.MBEnviromentTypeTesting..）
 */
- (void)setCurrentEnviromentType:(MBEnviromentType)type;

/**
 获取当前的网络环境类型
 
 @return 当期的网络类型
 */
- (MBEnviromentType)currentEnviromentType;

/**
 获取当前网络环境的服务器url
 
 @return 当前服务器的url
 */
- (NSString *)currentServiceHostUrl;
@end

NS_ASSUME_NONNULL_END

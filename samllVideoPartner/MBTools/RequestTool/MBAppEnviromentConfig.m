//
//  MBAppEnviromentConfig.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBAppEnviromentConfig.h"
/** 正式环境网络域名配置*/
static NSString *const kEnviromentProductHost = @"https://m.ixiaoshi.top";
/** 预发环境网络域名配置*/
static NSString *const kEnviromentPrepareReleaseHost = @"http://m.ixiaoshi.top";
/** 测试环境网络域名配置*/
static NSString *const kEnviromentTestingHost = @"https://xshb.zhanxiantech.com";

@interface MBAppEnviromentConfig ()

@property (nonatomic, assign) MBEnviromentType enviromentType;

@end

@implementation MBAppEnviromentConfig

+ (instancetype)shareConfig {
    static MBAppEnviromentConfig *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[MBAppEnviromentConfig alloc]init];
    });
    return _config;
}

- (void)setCurrentEnviromentType:(MBEnviromentType)type {
    _enviromentType = type;
}

- (MBEnviromentType)currentEnviromentType {
    return self.enviromentType;
}

- (NSString *)currentServiceHostUrl {
    switch (self.enviromentType) {
        case MBEnviromentTypeTesting:
            return kEnviromentTestingHost;
        case MBEnviromentTypePrepareRelease:
            return kEnviromentPrepareReleaseHost;
        case MBEnviromentTypeProduct:
            return kEnviromentProductHost;
        default:
            break;
    }
    return @"";
}


@end

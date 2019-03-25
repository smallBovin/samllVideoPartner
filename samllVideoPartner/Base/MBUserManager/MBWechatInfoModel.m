//
//  MBWechatInfoModel.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBWechatInfoModel.h"

@implementation MBWechatInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId":@"id"};
}

@end

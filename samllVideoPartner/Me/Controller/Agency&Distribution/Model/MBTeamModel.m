//
//  MBTeamModel.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/14.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBTeamModel.h"

@implementation MBTeamModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userId" : @"id"};
}
@end

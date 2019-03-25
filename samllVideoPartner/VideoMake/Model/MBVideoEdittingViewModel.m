//
//  MBVideoEdittingViewModel.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVideoEdittingViewModel.h"
/** 风格模板model*/
#import "MBStyleTemplateModel.h"
/** 音乐分类model*/
#import "MBMusicTypeModel.h"
/** 贴图，背景图，音乐列表通用model*/
#import "MBMapsModel.h"


@implementation MBVideoEdittingViewModel

- (void)getStyleTemplateDataComplement:(void (^)(NSMutableArray<MBStyleTemplateModel *> * _Nullable))complement{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    
    [RequestUtil POST:EDITTING_STYLE_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tmp = [MBStyleTemplateModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"]];
            [array addObjectsFromArray:tmp];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
        if (complement) {
            complement(array);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complement) {
            complement(nil);
        }
    }];
    
}

- (void)getMapsTemplateDataComplement:(void (^)(NSMutableArray<MBMapsModel *> * _Nullable))complement {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"type"] = @(2);
    
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tmp = [MBMapsModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            [array addObjectsFromArray:tmp];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
        if (complement) {
            complement(array);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complement) {
            complement(nil);
        }
    }];
}

- (void)getMusicTypeDataComplement:(void (^)(NSMutableArray<MBMusicTypeModel *> * _Nullable))complement {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    
    [RequestUtil POST:MUSIC_TYPE_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tmp = [MBMusicTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"]];
            [array addObjectsFromArray:tmp];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
        if (complement) {
            complement(array);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complement) {
            complement(nil);
        }
    }];
}

@end

//
//  MBCommossionModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/14.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBCommossionModel : NSObject

/** 数据id*/
@property (nonatomic, copy) NSString * ID;
/** 用户id*/
@property (nonatomic, copy) NSString * uid;
/** 佣金类型*/
@property (nonatomic, copy) NSString * status;
/** 产生金额*/
@property (nonatomic, copy) NSString * price;
/** 产生时间*/
@property (nonatomic, copy) NSString * createtime;
/** 创建者id*/
@property (nonatomic, copy) NSString * from_id;
/** 创建者头像*/
@property (nonatomic, copy) NSString * from_avatar;
/** 创建者昵称*/
@property (nonatomic, copy) NSString * from_nickname;

@end

NS_ASSUME_NONNULL_END

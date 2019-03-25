//
//  MBTeamModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/14.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBTeamModel : NSObject

/** 用户id*/
@property (nonatomic, copy) NSString * userId;
/** 昵称*/
@property (nonatomic, copy) NSString * nickname;
/** 头像*/
@property (nonatomic, copy) NSString * avatar;
/** 创建时间*/
@property (nonatomic, copy) NSString * createtime;
/** 等级*/
@property (nonatomic, copy) NSString * children;


@end

NS_ASSUME_NONNULL_END

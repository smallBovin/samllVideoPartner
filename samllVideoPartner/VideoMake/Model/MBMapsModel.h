//
//  MBMapsModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/11.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBMapsModel : NSObject

/** 文件id*/
@property (nonatomic, copy) NSString * cid;
/** 是否是VIP（1. vip  2,普通用户）*/
@property (nonatomic, copy) NSString * author;
/** 文件名*/
@property (nonatomic, copy) NSString * title;
/** 文件路径*/
@property (nonatomic, copy) NSString * path;
/** 缩略图*/
@property (nonatomic, copy) NSString * thumb;
/** 歌手*/
@property (nonatomic, copy) NSString * singer;


/** 背景图专用*/
@property (nonatomic, assign) BOOL  isDownload;

@end

NS_ASSUME_NONNULL_END

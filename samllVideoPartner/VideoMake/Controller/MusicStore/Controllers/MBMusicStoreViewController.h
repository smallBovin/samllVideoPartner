//
//  MBMusicStoreViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"
@class MBMusicTypeModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^MBChooseMusicCompletion)(void);

@interface MBMusicStoreViewController : MBBaseViewController

/** 音乐的类型*/
@property (nonatomic, strong) NSMutableArray<MBMusicTypeModel *> *musicTypeArray;

/** 选择音乐完成*/
@property (nonatomic, copy) MBChooseMusicCompletion  completeBlock;

@end

NS_ASSUME_NONNULL_END

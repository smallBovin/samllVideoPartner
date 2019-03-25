//
//  MBBackgroundThemeController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBBackgroundSelectCompletion)(UIImage *image);

@interface MBBackgroundThemeController : MBBaseViewController

/** 背景图选择完成*/
@property (nonatomic, copy) MBBackgroundSelectCompletion  bgCompleteAction;

@end

NS_ASSUME_NONNULL_END

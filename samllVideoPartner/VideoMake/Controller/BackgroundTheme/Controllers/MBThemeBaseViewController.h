//
//  MBThemeBaseViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBThemeBaseViewController : MBBaseViewController

/** 父控制器*/
@property (nonatomic, weak) UIViewController * superVC;

/** 选中的图片*/
@property (nonatomic, strong) UIImage * selectImage;


@end

NS_ASSUME_NONNULL_END

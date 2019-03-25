//
//  MBPhotoEditingViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/9.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MBPhotoEditingViewController : MBBaseViewController

/** 传入要编辑model*/
@property (nonatomic,strong) TZAssetModel *model;

@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);

@end

NS_ASSUME_NONNULL_END

//
//  MBBackgroundCollectionCell.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBMapsModel;
NS_ASSUME_NONNULL_BEGIN

@interface MBBackgroundCollectionCell : UICollectionViewCell

/** model*/
@property (nonatomic, strong) MBMapsModel * model;

@end

NS_ASSUME_NONNULL_END

//
//  MBMeTableViewCell.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBMeTableViewCell : UITableViewCell

/** cell的信息数据*/
@property (nonatomic, strong) NSDictionary * dict;
/** 详细信息*/
@property (nonatomic, copy) NSString * descString;

@end

NS_ASSUME_NONNULL_END

//
//  MBTeamTableViewCell.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBTeamModel;

NS_ASSUME_NONNULL_BEGIN

@interface MBTeamTableViewCell : UITableViewCell

@property (nonatomic, strong) MBTeamModel *model;

@end

NS_ASSUME_NONNULL_END

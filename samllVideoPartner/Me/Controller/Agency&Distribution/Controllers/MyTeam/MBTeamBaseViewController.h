//
//  MBTeamBaseViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBTeamRank) {
    MBTeamRankFirst,
    MBTeamRankSecond,
    MBTeamRankThird,
};

@interface MBTeamBaseViewController : MBBaseViewController

/** 级别类型*/
@property (nonatomic, assign) MBTeamRank  rankType;

@end

NS_ASSUME_NONNULL_END

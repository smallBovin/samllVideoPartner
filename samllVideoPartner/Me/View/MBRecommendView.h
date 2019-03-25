//
//  MBRecommendView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/11.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBRecommendView : UIView

@property (nonatomic, copy) void(^CommitRecommendIDBlock)(NSString *recommengId);

@end

NS_ASSUME_NONNULL_END

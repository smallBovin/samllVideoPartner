//
//  UIButton+block.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN




@interface UIButton (block)

@property (nonatomic,copy) void(^block)(UIButton *sender);




-(void)addTapBlock:(void(^)(UIButton * btn) )block;

- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END

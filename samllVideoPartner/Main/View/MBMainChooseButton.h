//
//  MBMainChooseButton.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBActionCompletion)(void);

@interface MBMainChooseButton : UIView

@property (nonatomic, copy) NSString *logoName;

@property (nonatomic, copy) NSString *titleName;

/** 点击时调用*/
@property (nonatomic, copy) MBActionCompletion  actionBlock;

+ (instancetype)chooseBtnWithFrame:(CGRect)frame logoName:(NSString *)logoName titleName:(NSString *)titleName action:(MBActionCompletion)action;

@end

NS_ASSUME_NONNULL_END

//
//  MBWordEditBottomBar.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBWordEditBottomBarDelegate <NSObject>

@optional

- (void)chooseFontAction:(UIButton *)fontBtn;

- (void)chooseColorAction:(UIButton *)colorBtn;

@end

@interface MBWordEditBottomBar : UIView

/** 代理*/
@property (nonatomic, weak) id<MBWordEditBottomBarDelegate> delegate;
/**   */
@property (nonatomic , copy)NSString *colorName;


@end

NS_ASSUME_NONNULL_END

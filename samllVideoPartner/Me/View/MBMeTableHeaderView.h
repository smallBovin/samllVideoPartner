//
//  MBMeTableHeaderView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBMeTableHeaderViewDelegate <NSObject>

@optional

- (void)wecahtAuthlogin;
- (void)changeUserHeadImage:(UIButton *)headBtn;
- (void)goToOpenVip;

@end

@interface MBMeTableHeaderView : UIView

/** 代理*/
@property (nonatomic, weak) id<MBMeTableHeaderViewDelegate> delegate;

/** 用户信息model*/
@property (nonatomic, strong) MBUserInfo * userInfo;

@end

NS_ASSUME_NONNULL_END

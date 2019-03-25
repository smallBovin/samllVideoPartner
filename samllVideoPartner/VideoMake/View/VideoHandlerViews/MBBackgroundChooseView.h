//
//  MBBackgroundChooseView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBBackgroundChooseViewDelegate <NSObject>

@optional

- (void)closeBackgroundChooseView;

- (void)finishChooseBackground;

- (void)chooseBackgroundOnStore;

- (void)uploadBackgroundFromLocal;

- (void)bgImageAlphaWithProgress:(CGFloat)progress;


@end

@interface MBBackgroundChooseView : UIView

/** 代理*/
@property (nonatomic, weak) id<MBBackgroundChooseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

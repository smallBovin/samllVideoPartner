//
//  MBBaseViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBRefreshType) {
    MBRefreshTypeBoth,
    MBRefreshTypeOnlyHeader,
    MBRefreshTypeOnlyFooter,
};

@interface MBBaseViewController : UIViewController

/** 返回按钮*/
@property (nonatomic, strong ,readonly) UIBarButtonItem * backBarButtonItem;

- (void)back;

/** 添加刷新状态*/
- (void)setRefreshFunctionToScrollView:(UIScrollView *)scrollView refreshType:(MBRefreshType)type;
/** 加载新数据*/
- (void)headerRefreshing;
/** 加载更多数据*/
- (void)footerRefreshing;
@end

NS_ASSUME_NONNULL_END

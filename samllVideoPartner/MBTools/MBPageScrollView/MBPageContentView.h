//
//  MBPageContentView.h
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBSegmentScrollView;

@interface MBPageContentView : UIView

// 所有的子控制器
@property (strong, nonatomic) NSArray *childVcs;

- (instancetype)initWithFrame:(CGRect)frame segmentView:(MBSegmentScrollView *)segmentView childVCs:(NSArray *)childVCs parentViewController:(UIViewController *)parentViewController;

- (void)setSelectItemIndex:(NSInteger)index;

@end

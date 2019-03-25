//
//  MBRateSettingView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/16.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBRateSettingView.h"

#define kRateLabelTag  3000

@interface MBRateSettingView ()

/** 速率选项*/
@property (nonatomic, strong) NSArray * rateArray;
/** 速率的容器*/
@property (nonatomic, strong) UIScrollView * rateScrollView;

/** 用数组盛放内部控件再点击的时候改变颜色*/
@property (nonatomic, strong) NSMutableArray * labelsArray;


@end

@implementation MBRateSettingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rateArray = @[@"0.8x",@"1.0x",@"1.05x",@"1.08x",@"1.1x",@"1.2x",@"1.5x",@"2.0x"];
        self.rateArray = [[self.rateArray reverseObjectEnumerator]allObjects];
        self.layer.masksToBounds = YES;
        [self.labelsArray removeAllObjects];
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
        [self addSubview:self.rateScrollView];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat height = kAdapt(32);
    CGFloat width = kAdapt(57);
    for (int i = 0; i< self.rateArray.count; i++) {
        NSString *text = self.rateArray[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, i*height, width, height)];
        label.text = text;
        label.tag = kRateLabelTag+i;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        [label addSingleTapGestureTarget:self action:@selector(selectVideoRate:)];
        [self.rateScrollView addSubview:label];
        [self.labelsArray addObject:label];
        if ([text isEqualToString:@"1.0x"]) {
            label.textColor = [UIColor colorWithHexString:@"#FD4539"];
        }
        if (i == self.rateArray.count-1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), width, height)];
            line.backgroundColor = [UIColor whiteColor];
            [self.rateScrollView addSubview:line];
        }
    }
    self.rateScrollView.contentSize = CGSizeMake(width, self.rateArray.count*height+1);
    
}
#pragma mark--action---
- (void)selectVideoRate:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    for (UILabel *lb in self.labelsArray) {
        if ([lb isEqual:label]) {
            lb.textColor = [UIColor colorWithHexString:@"#FD4539"];
        }else {
            lb.textColor = [UIColor whiteColor];
        }
    }
    NSInteger index = label.tag - kRateLabelTag;
    NSString *rate = self.rateArray[index];
    rate = [rate stringByReplacingOccurrencesOfString:@"x" withString:@""];
    if (self.complement) {
        self.complement(rate);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rateScrollView.frame = self.bounds;
}

#pragma mark--lazy---
/** 容器*/
- (UIScrollView *)rateScrollView {
    if (!_rateScrollView) {
        _rateScrollView = [[UIScrollView alloc]init];
        _rateScrollView.bounces = NO;
    }
    return _rateScrollView;
}
/** label存放数组*/
- (NSMutableArray *)labelsArray {
    if (!_labelsArray) {
        _labelsArray = [NSMutableArray array];
    }
    return _labelsArray;
}
@end

//
//  MBShareView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/3.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBShareView.h"

#define kPlatformTag    2000

NSString *const MBSharePlatformIcon = @"MBSharePlatform_Icon";
NSString *const MBSharePlatformName = @"MBSharePlatform_Name";

@interface MBShareView ()

/** 平台类型*/
@property (nonatomic, assign) MBSharePlatformType  platformType;
/** 分享平台数组*/
@property (nonatomic, strong) NSArray<NSDictionary *> * platformArray;
/** 分享平台的container*/
@property (nonatomic, strong) UIScrollView * containerView;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;
/** 取消*/
@property (nonatomic, strong) UIButton * cancelBtn;

@end

@implementation MBShareView

+ (instancetype)shareViewFrame:(CGRect)frame platformArrays:(NSArray<NSDictionary *> *)platforms {
    MBShareView *shareView = [[MBShareView alloc]initWithFrame:frame];
    shareView.platformArray = platforms;
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        [self addSubview:self.sepLine];
        [self addSubview:self.cancelBtn];
    }
    return self;
}
- (void)setPlatformArray:(NSMutableArray<NSDictionary *> *)platformArray {
    _platformArray = platformArray;
    [self setupSubviews];
}

- (void)setupSubviews {
    NSAssert(self.platformArray.count > 0, @"分享平台数据为不能为空");
    
    CGFloat width = kAdapt(60);
    CGFloat height = kAdapt(80);
    CGFloat edgeMargin = kAdapt(77);
    CGFloat spaceMargin = kAdapt(120);
    for (int i = 0; i < self.platformArray.count; i++) {
        NSDictionary *dic = self.platformArray[i];
        NSAssert([dic isKindOfClass:[NSDictionary class]], @"分享平台数据格式为不正确");
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(edgeMargin+i*(width+spaceMargin), kAdapt(8), width, height);
        [button setImage:[UIImage imageNamed:[dic objectForKey:MBSharePlatformIcon]] forState:UIControlStateNormal];
        [button setTitle:[dic objectForKey:MBSharePlatformName] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#323232"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = kPlatformTag+i;
        button.spaceMargin = 8;
        button.type = MBButtonTypeTopImageBottomTitle;
        [button addTarget:self action:@selector(sharePlamformType:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
    }
}

#pragma mark--action--
- (void)sharePlamformType:(UIButton *)button {
    NSInteger index = button.tag;
    switch (index) {
        case 2000:
            self.platformType = MBSharePlatformTypeWechat;
            break;
        case 2001:
            self.platformType = MBSharePlatformTypeWechatTimeline;
            break;
            
        default:
            break;
    }
    if (self.shareBlock) {
        self.shareBlock(self.platformType);
    }
}
/** 取消分享*/
- (void)cancelShareView {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
#pragma mark--lazy--
/** 分享平台的容器*/
- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kAdapt(20), self.frame.size.width, kAdapt(95))];
    }
    return _containerView;
}
/** 分割线*/
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.containerView.frame), self.frame.size.width, 1)];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    }
    return _sepLine;
}
/** 取消*/
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.sepLine.frame), self.frame.size.width, kAdapt(60));
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FF3657"] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor] state:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#F1F1F1"] state:UIControlStateHighlighted];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(cancelShareView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (void)dealloc {
    NSLog(@"%@",[self description]);
}
@end

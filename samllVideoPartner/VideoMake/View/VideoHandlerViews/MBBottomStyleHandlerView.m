//
//  MBBottomStyleHandlerView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBottomStyleHandlerView.h"

#define kStyleTag   1000

@interface MBBottomStyleHandlerView ()

/** 存放按钮图片与标题的数组*/
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) MBSelectButtonType type;

@end

@implementation MBBottomStyleHandlerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = @[@{@"image":@"video_make_style",@"title":@"风格"},@{@"image":@"video_make_font",@"title":@"文字"},@{@"image":@"video_make_tags",@"title":@"贴图"},@{@"image":@"video_make_music",@"title":@"音乐"},@{@"image":@"video_make_bgimag",@"title":@"背景"}];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat topMargin = 3;
    CGFloat edgeMargin = kAdapt(14);
    CGFloat width = (SCREEN_WIDTH-2*edgeMargin)/self.dataArray.count;
    CGFloat height = self.frame.size.height-SAFE_INDICATOR_BAR-topMargin;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        NSString *imageName = dic[@"image"];
        NSString *title = dic[@"title"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(edgeMargin+i*width, topMargin, width, height);
        button.tag = kStyleTag+i;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#1D1D1D"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.type = MBButtonTypeTopImageBottomTitle;
        button.spaceMargin = 5;
        [button addTarget:self action:@selector(styleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)styleBtnAction:(UIButton *)button {
    switch (button.tag) {
        case 1000:
            self.type = MBSelectButtonTypeStyle;
            break;
        case 1001:
            self.type = MBSelectButtonTypeFont;
            break;
        case 1002:
            self.type = MBSelectButtonTypeMaps;
            break;
        case 1003:
            self.type = MBSelectButtonTypeMusic;
            break;
        case 1004:
            self.type = MBSelectButtonTypeBackground;
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomStyleHandlerViewButtonType:)]) {
        [self.delegate bottomStyleHandlerViewButtonType:self.type];
    }
}

- (void)dealloc {
    NSLog(@"%@==== 释放了",[self description]);
}

@end

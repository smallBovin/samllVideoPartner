//
//  MBMainChooseButton.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMainChooseButton.h"

@interface MBMainChooseButton ()

/** logo*/
@property (nonatomic, strong) UIImageView * logo;
/** 标题*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 向右的箭头*/
@property (nonatomic, strong) UIImageView * rightArrow;

@end

@implementation MBMainChooseButton

- (void)dealloc {
    NSLog(@"%@==选择按钮释放",[self description]);
}

+ (instancetype)chooseBtnWithFrame:(CGRect)frame logoName:(NSString *)logoName titleName:(NSString *)titleName action:(MBActionCompletion)action {
    MBMainChooseButton *chooseBtn = [[MBMainChooseButton alloc]initWithFrame:frame];
    chooseBtn.logoName = logoName;
    chooseBtn.titleName = titleName;
    chooseBtn.actionBlock = action;
    return chooseBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        self.layer.cornerRadius = 5;
        [self setupSubviewsAndConstraints];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipTargetModule)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark--setter----
- (void)setLogoName:(NSString *)logoName {
    _logoName = logoName;
    self.logo.image = [UIImage imageNamed:[logoName stringByReplacingOccurrencesOfString:@" " withString:@""]];
}
- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.nameLabel.text = titleName;
}

#pragma mark--action---
/** 跳转到相应的模块*/
- (void)skipTargetModule {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.logo];
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightArrow];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kAdapt(22));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(kAdapt(44));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logo.mas_right).offset(kAdapt(15));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(- kAdapt(18));
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(24);
    }];
}


#pragma mark--lazy---
/** logo*/
- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc]init];
        _logo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logo;
}
/** 名称*/
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:24];
    }
    return _nameLabel;
}
/** 向右的箭头*/
- (UIImageView *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_rightArrow"]];
    }
    return _rightArrow;
}
@end

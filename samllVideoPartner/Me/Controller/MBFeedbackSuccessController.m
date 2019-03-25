//
//  MBFeedbackSuccessController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/3.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBFeedbackSuccessController.h"


@interface MBFeedbackSuccessController ()

/** 保存成功标志*/
@property (nonatomic, strong) UIImageView * successLogo;
/** 保存成功*/
@property (nonatomic, strong) UILabel * msgLabel;
/** 详细的描述*/
@property (nonatomic, strong) UILabel * descLabel;

@end

@implementation MBFeedbackSuccessController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈成功";
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_interactivePopDisabled = YES;
    [self setupSubviews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}

- (void)setupSubviews {
    [self.view addSubview:self.successLogo];
    [self.view addSubview:self.msgLabel];
    [self.view addSubview:self.descLabel];
    [self.successLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATION_BAR_HEIGHT+48);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(64);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.successLogo.mas_bottom).offset(23);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.msgLabel.mas_bottom).offset(27);
        make.width.mas_equalTo(kAdapt(290));
    }];
}
#pragma mark--重写返回事件--
- (void)back {
    Class class = NSClassFromString(@"MBMineViewController");
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[class class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark--lazy---
/** 成功标志*/
- (UIImageView *)successLogo {
    if (!_successLogo) {
        _successLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_feedback_success"]];
    }
    return _successLogo;
}
/** 成功提示*/
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:16];
        _msgLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _msgLabel.text = @"反馈成功";
        [_msgLabel sizeToFit];
    }
    return _msgLabel;
}
/** 感谢反馈提示*/
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:13];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _descLabel.text = @"感谢您对我们的关注和支持，我们会认真处理您的建议，尽快修复和完善相关功能。";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_descLabel.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByCharWrapping;
        style.lineSpacing = kAdapt(30);
        [attr setAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0,[attr.string length])];
        _descLabel.attributedText = attr;
    }
    return _descLabel;
}
@end

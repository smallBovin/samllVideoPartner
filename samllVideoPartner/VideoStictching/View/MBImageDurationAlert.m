//
//  MBImageDurationAlert.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/17.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBImageDurationAlert.h"

@interface MBImageDurationAlert ()<UITextFieldDelegate>
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 输入框*/
@property (nonatomic, strong) UITextField * textfield;
/** 取消*/
@property (nonatomic, strong) UIButton * cancelBtn;
/** 确定*/
@property (nonatomic, strong) UIButton * sureBtn;



@end

@implementation MBImageDurationAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kAdapt(13);
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.textfield];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(14));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kAdapt(25));
        make.width.mas_equalTo(kAdapt(204));
        make.height.mas_equalTo(kAdapt(35));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textfield.mas_left);
        make.top.equalTo(self.textfield.mas_bottom).offset(kAdapt(25));
        make.width.mas_equalTo(kAdapt(80));
        make.height.mas_equalTo(kAdapt(34));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textfield.mas_right);
        make.top.equalTo(self.textfield.mas_bottom).offset(kAdapt(25));
        make.width.mas_equalTo(kAdapt(80));
        make.height.mas_equalTo(kAdapt(34));
    }];
}

#pragma mark--action---
- (void)cancelAction {
    if (self.cancelBtn) {
        self.cancelBlock();
    }
}
- (void)sureAction {
    if (self.textfield.text.length<=0) {
        [MBProgressHUD showOnlyTextMessage:@"请设置图片的显示时长"];
        return;
    }
    float duration = [self.textfield.text floatValue];
    if (self.successBlock) {
        self.successBlock(duration);
    }
}

#pragma mark--UITextFieldDelegate---
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:textField.text];
    [mutableStr replaceCharactersInRange:range withString:string];
    if ([mutableStr containsString:@"."]) {
        if (mutableStr.length == 2 && [mutableStr isEqualToString:@"00"]) {
            return NO;
        }
        if (mutableStr.length == 2 && [mutableStr isEqualToString:@".."]) {
            return NO;
        }
        if (mutableStr.length == 2 && [mutableStr containsString:@".0"]) {
            return NO;
        }
        if (mutableStr.length == 3 && [mutableStr isEqualToString:@"0.."]) {
            return NO;
        }
        if (mutableStr.length == 3 && [mutableStr isEqualToString:@"0.0"]) {
            return NO;
        }
        if (mutableStr.length == 3 && ![mutableStr containsString:@"0"]) {
            if ([[mutableStr substringToIndex:1] isEqualToString:@"."]) {
                return NO;
            }
        }
        if (mutableStr.length>3) {
            return NO;
        }
    }else {
        if (mutableStr.length == 3) {
            return NO;
        }
    }
    return YES;
}

#pragma mark--lazy--
/** 标题*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1C172F"];
        _titleLabel.text = @"请设置图片显示时长";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
/** 输入框*/
- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.borderStyle = UITextBorderStyleNone;
        _textfield.placeholder = @"可输入小数后一位，单位为秒";
        _textfield.font = [UIFont systemFontOfSize:12];
        _textfield.keyboardType = UIKeyboardTypeDecimalPad;
        _textfield.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAdapt(15), kAdapt(35))];
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        _textfield.textColor = [UIColor colorWithHexString:@"#333333"];
        _textfield.layer.borderColor = [UIColor colorWithHexString:@"#FD4539"].CGColor;
        _textfield.delegate = self;
        _textfield.layer.borderWidth = 1;
        _textfield.layer.cornerRadius = kAdapt(5);
        _textfield.layer.masksToBounds = YES;
    }
    return _textfield;
}
/** 取消按钮*/
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#999999"] state:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.layer.cornerRadius = kAdapt(8);
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
/** 确定按钮*/
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.layer.cornerRadius = kAdapt(8);
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end

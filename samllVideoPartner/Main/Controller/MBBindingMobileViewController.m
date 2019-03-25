//
//  MBBindingMobileViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBindingMobileViewController.h"
#import "MBWechatInfoModel.h"

#define kInputRightMobileMsg    @"请输入正确的手机号"
#define kVerityCodeErrorMsg     @"你输入的验证码错误"

@interface MBBindingMobileViewController ()<UITextFieldDelegate>

/** 提示信息*/
@property (nonatomic, strong) UILabel * tipsLabel;
/** 输入信息的container*/
@property (nonatomic, strong) UIView * containerView;
/** 手机输入框*/
@property (nonatomic, strong) UITextField * mobileTF;
/** 获取验证码按钮*/
@property (nonatomic, strong) MBVerigiyButton * verifyBtn;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;
/** 验证码输入框*/
@property (nonatomic, strong) UITextField * verificationTF;
/** 确定按钮*/
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation MBBindingMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4F3F8"];
    self.navigationItem.title = @"绑定手机号码";
    
    [self setupSubviewsAndConstraints];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}

- (void)setupSubviewsAndConstraints {
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.mobileTF];
    [self.containerView addSubview:self.verifyBtn];
    [self.containerView addSubview:self.sepLine];
    [self.containerView addSubview:self.verificationTF];
    [self.view addSubview:self.sureBtn];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATION_BAR_HEIGHT+21);
        make.left.equalTo(self.view.mas_left).offset(13);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(21);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(95);
    }];
    [self.mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(12);
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.verifyBtn.mas_left).offset(-12);
        make.height.mas_equalTo(47);
    }];
    [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mobileTF.mas_right).offset(12);
        make.right.equalTo(self.containerView.mas_right).offset(-12);
        make.centerY.equalTo(self.mobileTF.mas_centerY);
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.mobileTF.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    [self.verificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sepLine.mas_bottom);
        make.left.equalTo(self.containerView.mas_left).offset(12);
        make.right.equalTo(self.containerView.mas_right).offset(-12);
        make.height.mas_equalTo(47);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.containerView.mas_bottom).offset(82);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark--绑定手机号---
/** 获取验证码*/
- (void)getVerifyCode {
    [self checkIsMobilePhone];
    [[MBUserManager manager]getVerifyCodeWithMobilePhone:self.mobileTF.text success:^(BOOL isSend) {
        if (isSend) {
            [self.verifyBtn countingSeconds:60];
        }
    }];
}

- (void)sureBindingUserMobile {
    if (self.mobileTF.text.length != 11) {
        [MBProgressHUD showOnlyTextMessage:kInputRightMobileMsg];
        return;
    }
    if (self.verificationTF.text.length != 4) {
        [MBProgressHUD showOnlyTextMessage:kVerityCodeErrorMsg];
        return;
    }
    [[MBUserManager manager]userBindingMobilePhone:self.mobileTF.text verifyCode:self.verificationTF.text bindSuccess:^(BOOL isBind) {
        if (isBind) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)checkIsMobilePhone {
    if (11 == self.mobileTF.text.length) {
        if (![NSString checkIsMobilePhone:self.mobileTF.text]) {
            [MBProgressHUD showOnlyTextMessage:kInputRightMobileMsg];
            return;
        }
    }
}

#pragma mark--UITextFieldDelegate---
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMutableStr replaceCharactersInRange:range withString:string];
    if (textField == self.mobileTF) {
        if (11<resultMutableStr.length) {
            return NO;
        }
    }
    if (textField == self.verificationTF) {
        
    }
    return YES;
}

#pragma mark--lazy---
/** 提示文字*/
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.text = @"需要验证你的身份信息";
        _tipsLabel.backgroundColor = [UIColor clearColor];
    }
    return _tipsLabel;
}
/** 容器*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
/** 手机输入框*/
- (UITextField *)mobileTF {
    if (!_mobileTF) {
        _mobileTF = [[UITextField alloc]init];
        _mobileTF.keyboardType = UIKeyboardTypePhonePad;
        _mobileTF.borderStyle = UITextBorderStyleNone;
        _mobileTF.textColor = [UIColor colorWithHexString:@"#666666"];
        _mobileTF.textAlignment = NSTextAlignmentLeft;
        _mobileTF.font = [UIFont systemFontOfSize:15];
        _mobileTF.tintColor = [UIColor colorWithHexString:@"#FD4539"];
        _mobileTF.placeholder = @"请输入手机号码";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_mobileTF.placeholder];
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AAAAAA"]} range:NSMakeRange(0, string.length)];
        _mobileTF.attributedPlaceholder = string;
        _mobileTF.delegate = self;
        [_mobileTF addTarget:self action:@selector(checkIsMobilePhone) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileTF;
}
/** 获取验证码按钮*/
- (MBVerigiyButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn = [MBVerigiyButton buttonWithType:UIButtonTypeCustom];
        [_verifyBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        __weak typeof(self) weakSelf = self;
        [_verifyBtn addTapBlock:^(UIButton * _Nonnull btn) {
            NSLog(@"sdfsfds");
            if (11 == weakSelf.mobileTF.text.length) {
                [weakSelf getVerifyCode];
                [weakSelf.mobileTF resignFirstResponder];
                [weakSelf.verificationTF becomeFirstResponder];
            }else {
                [MBProgressHUD showOnlyTextMessage:kInputRightMobileMsg];
            }
        }];
    }
    return _verifyBtn;
}
/** 分割线*/
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    }
    return _sepLine;
}
/** 验证码*/
- (UITextField *)verificationTF {
    if (!_verificationTF) {
        _verificationTF = [[UITextField alloc]init];
        _verificationTF.keyboardType = UIKeyboardTypePhonePad;
        _verificationTF.borderStyle = UITextBorderStyleNone;
        _verificationTF.textColor = [UIColor colorWithHexString:@"#666666"];
        _verificationTF.textAlignment = NSTextAlignmentLeft;
        _verificationTF.tintColor = [UIColor colorWithHexString:@"#FD4539"];
        _verificationTF.placeholder = @"请输入验证码";
        _verificationTF.font = [UIFont systemFontOfSize:15];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_verificationTF.placeholder];
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AAAAAA"]} range:NSMakeRange(0, string.length)];
        _verificationTF.attributedPlaceholder = string;
        _verificationTF.delegate = self;
    }
    return _verificationTF;
}
/** 确定按钮*/
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setBackgroundColor:[UIColor whiteColor]];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#FD4539"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _sureBtn.layer.cornerRadius = kAdapt(8);
        __weak typeof(self) weakSelf = self;
        [_sureBtn addTapBlock:^(UIButton * _Nonnull btn) {
            [weakSelf.view endEditing:YES];
            [weakSelf sureBindingUserMobile];
        }];
    }
    return _sureBtn;
}

@end

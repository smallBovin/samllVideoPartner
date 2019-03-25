//
//  MBApplyWithdrawViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/5.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBApplyWithdrawViewController.h"
/** 用于有多个只有一个textField/textView 的容器视图*/
#import "MBPreviousNextView.h"

#define kTextFieldTag   2500

static NSString *const MBWithdrawItemTypeName = @"MBWithdrawItemTypeName";
static NSString *const MBWithdrawItemPlaceholderName = @"MBWithdrawItemPlaceholderName";

@interface MBApplyWithdrawViewController ()<UITextFieldDelegate>

/** 可提现余额*/
@property (nonatomic, strong) UILabel * canWithdrawLabel;
/** container*/
@property (nonatomic, strong) MBPreviousNextView * containerView;
/** 手续费*/
@property (nonatomic, strong) UILabel * serviceChargeLabel;
/** 验证码按钮*/
@property (nonatomic, strong) MBVerigiyButton * verifyBtn;
/** 类型与占位符数据*/
@property (nonatomic, strong) NSArray * dataArray;
/** 提现按钮*/
@property (nonatomic, strong) UIButton * withdrawBtn;

/** 支付宝账号*/
@property (nonatomic, copy) NSString * alipayAccount;
/** 确认支付宝账号*/
@property (nonatomic, copy) NSString * sureAlipayAccount;
/** 提现金额*/
@property (nonatomic, copy) NSString * withdrawMoney;
/** 手机号码*/
@property (nonatomic, copy) NSString * mobilePhone;
/** 验证码*/
@property (nonatomic, copy) NSString * verifyCode;

/**用户申请提现令牌*/
@property (nonatomic, copy) NSString * applayToken;


@end

@implementation MBApplyWithdrawViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请提现";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = @[@{MBWithdrawItemTypeName:@"输入支付宝姓名",MBWithdrawItemPlaceholderName:@"请输入支付宝姓名"},@{MBWithdrawItemTypeName:@"请输入支付宝账号",MBWithdrawItemPlaceholderName:@"请输入支付宝账号"},@{MBWithdrawItemTypeName:@"输入提现金额(元)",MBWithdrawItemPlaceholderName:@"请输入提现金额"}
//                       ,@{MBWithdrawItemTypeName:@"验证手机号码",MBWithdrawItemPlaceholderName:@"请输入绑定的手机号码"},@{MBWithdrawItemTypeName:@"输入验证码",MBWithdrawItemPlaceholderName:@"请输入手机收到的验证码"}
                       ];
    [self setupSubviews];
    
}

- (void)setupSubviews {
    [self.view addSubview:self.canWithdrawLabel];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.withdrawBtn];
    [self.canWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kAdapt(20)+NAVIGATION_BAR_HEIGHT);
        make.left.equalTo(self.view.mas_left).offset(kAdapt(22));
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.canWithdrawLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(kAdapt(22));
        make.right.equalTo(self.view.mas_right).offset(-kAdapt(22));
        make.height.mas_equalTo(kAdapt(82)*self.dataArray.count);
    }];
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kAdapt(41));
        make.right.equalTo(self.view.mas_right).offset(-kAdapt(41));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdapt(37)-SAFE_INDICATOR_BAR);
        make.height.mas_equalTo(kAdapt(47));
    }];

    CGFloat Width = SCREEN_WIDTH-kAdapt(44);
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, i*kAdapt(82), Width, kAdapt(82))];
        [self.containerView addSubview:contentView];
        UILabel *typeLabel = [[UILabel alloc]init];
        typeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        typeLabel.text = [dic objectForKey:MBWithdrawItemTypeName];
        typeLabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(contentView.mas_top).offset(kAdapt(20));
        }];
        UITextField *textField = [[UITextField alloc]init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.placeholder = [dic objectForKey:MBWithdrawItemPlaceholderName];
        textField.textColor = [UIColor colorWithHexString:@"#333333"];
        textField.font = [UIFont systemFontOfSize:12];
        textField.tintColor = [UIColor colorWithHexString:@"#FA3C3C"];
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.tag = kTextFieldTag+i;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        [contentView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(kAdapt(25));
            make.bottom.equalTo(contentView.mas_bottom).offset(-1);
            make.height.mas_equalTo(kAdapt(44));
        }];
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"#EDEEEE"];
        [contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(contentView);
            make.height.mas_equalTo(1);
        }];
//        if (3 == i) {
//            UILabel *serviceLabel = [[UILabel alloc]init];
//            serviceLabel.textColor = [UIColor colorWithHexString:@"#292929" alpha:0.8];
//            serviceLabel.textAlignment = NSTextAlignmentRight;
//            serviceLabel.font = [UIFont systemFontOfSize:12];
//            serviceLabel.text = @"实际到账：298.00 扣除手续费2.00元";
//            [contentView addSubview:serviceLabel];
//            self.serviceChargeLabel = serviceLabel;
//            [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(contentView.mas_top).offset(kAdapt(5));
//                make.right.equalTo(contentView.mas_right);
//            }];
//            MBVerigiyButton *veriBtn = [MBVerigiyButton buttonWithType:UIButtonTypeCustom];
//            [veriBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//            [veriBtn setTitleColor:[UIColor colorWithHexString:@"#FA3C3C" alpha:0.8] forState:UIControlStateNormal];
//            veriBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//            [veriBtn addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
//            [contentView addSubview:veriBtn];
//            self.verifyBtn = veriBtn;
//            [veriBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(contentView.mas_right);
//                make.centerY.equalTo(textField.mas_centerY);
//            }];
//        }
    }
    UILabel *serviceLabel = [[UILabel alloc]init];
    serviceLabel.textColor = [UIColor colorWithHexString:@"#292929" alpha:0.8];
    serviceLabel.textAlignment = NSTextAlignmentRight;
    serviceLabel.font = [UIFont systemFontOfSize:12];
//    serviceLabel.text = @"实际到账：298.00 扣除手续费2.00元";
    [self.view addSubview:serviceLabel];
    self.serviceChargeLabel = serviceLabel;
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(kAdapt(5));
        make.right.equalTo(self.containerView.mas_right);
    }];}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
    /**请求提现的信息*/
    [self getWithdrawApplayInfo];
}
- (void)getWithdrawApplayInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    if (self.type == MBPerformanceTypeDistribution) {
        dict[@"type"] = @(1);
    }else {
        dict[@"type"] = @(2);
    }
    [RequestUtil POST:WITHDRAW_APPLY_TABLE_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.applayToken = responseObject[@"token"];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}


#pragma mark--编辑框编辑时回调
- (void)textFieldValueChange:(UITextField *)textField {
    NSInteger index = textField.tag;
    switch (index) {
        case 2500:      //支付宝账号
            self.alipayAccount = textField.text;
            break;
        case 2501:      //再次输入支付宝的账号
//            if ([self.alipayAccount isEqualToString:textField.text]) {
                self.sureAlipayAccount = textField.text;
//            }else {
//                [MBProgressHUD showOnlyTextMessage:@"你输入的支付宝账号不正确"];
//                textField.text = @"";
//            }
            break;
        case 2502:      //提现金额
        {
            self.withdrawMoney = textField.text;
            CGFloat totalMoney = [textField.text floatValue];
            if (self.type == MBPerformanceTypeDistribution) {
                CGFloat serviceCost = totalMoney*[[MBUserManager manager].configInfo.dis_tax floatValue]/100;
                CGFloat realMoney = totalMoney-serviceCost;
                self.serviceChargeLabel.text = [NSString stringWithFormat:@"实际到账：%0.2f 扣除手续费%0.2f元",realMoney,serviceCost];
            }else {
                CGFloat serviceCost = totalMoney*[[MBUserManager manager].configInfo.agent_tax floatValue]/100;
                CGFloat realMoney = totalMoney-serviceCost;
                self.serviceChargeLabel.text = [NSString stringWithFormat:@"实际到账：%0.2f 扣除手续费%0.2f元",realMoney,serviceCost];
            }
        }
            break;
        case 2503:      //绑定的手机号
//            self.mobilePhone = textField.text;
            break;
        case 2504:      //验证码
//            self.verifyCode = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark--UITextFieldDelegate---
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger index = textField.tag;
    switch (index) {
        case 2500:      //支付宝账号
            
            break;
        case 2501:      //再次输入支付宝的账号
            
            break;
        case 2502:      //提现金额
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 2503:      //绑定的手机号
            textField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case 2504:      //验证码
            textField.keyboardType = UIKeyboardTypePhonePad;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *mutableStr = [[NSMutableString alloc]initWithString:textField.text];
    [mutableStr replaceCharactersInRange:range withString:string];
    if (mutableStr.length == 1 && [mutableStr isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

#pragma mark--action--
- (void)getVerifyCode {
    [[MBUserManager manager]getVerifyCodeWithMobilePhone:@"" success:^(BOOL isSend) {
        
    }];
}
- (void)commitWithdraw {
    if (self.applayToken.length<=0) {
        [MBProgressHUD showOnlyTextMessage:@"提交令牌失效，请稍后再试"];
        [self getWithdrawApplayInfo];
        return;
    }
    if (self.alipayAccount.length<=0) {
        [MBProgressHUD showOnlyTextMessage:@"请输入支付宝姓名"];
        return;
    }
    if (self.sureAlipayAccount.length<=0) {
        [MBProgressHUD showOnlyTextMessage:@"请输入支付宝账号"];
        return;
    }
    if (self.withdrawMoney.length<=0) {
        [MBProgressHUD showOnlyTextMessage:@"请输提现金额"];
        return;
    }
//    if (self.mobilePhone.length<=0) {
//        [MBProgressHUD showOnlyTextMessage:@"请输入手机号码"];
//        return;
//    }
//    if (self.verifyCode.length<=0) {
//        [MBProgressHUD showOnlyTextMessage:@"请输入手机验证码"];
//        return;
//    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"tokens"] = self.applayToken;
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    if (self.type == MBPerformanceTypeDistribution) {
        dict[@"type"] = @"1";
    }else {
        dict[@"type"] = @"2";
    }
    dict[@"price"] = self.withdrawMoney;
    dict[@"alipay_name"] = self.alipayAccount;
    dict[@"alipay_account"] = self.sureAlipayAccount;
    [RequestUtil POST:SUBMIT_WITHDRAW_APLLY_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



#pragma mark--lazy--
/** 可提现余额*/
- (UILabel *)canWithdrawLabel {
    if (!_canWithdrawLabel) {
        _canWithdrawLabel = [[UILabel alloc]init];
        _canWithdrawLabel.textAlignment = NSTextAlignmentLeft;
        _canWithdrawLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:0.6];
        _canWithdrawLabel.font = [UIFont systemFontOfSize:14];
        _canWithdrawLabel.numberOfLines = 0;
        _canWithdrawLabel.text = [NSString stringWithFormat:@"提现到支付宝\n可提现金额(元)：%0.2f",self.canWithdrawMoney.length>0?[self.canWithdrawMoney floatValue]:0.00];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_canWithdrawLabel.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = kAdapt(10);
        style.alignment = NSTextAlignmentLeft;
        [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSParagraphStyleAttributeName:style} range:[attr.string rangeOfString:@"提现到支付宝"]];
        _canWithdrawLabel.attributedText = attr;
    }
    return _canWithdrawLabel;
}
/** 选项容器*/
- (MBPreviousNextView *)containerView {
    if (!_containerView) {
        _containerView = [[MBPreviousNextView alloc]init];
    }
    return _containerView;
}
/** 提现按钮*/
- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawBtn setBackgroundColor:[UIColor colorWithHexString:@"#FA3C3C"] state:UIControlStateNormal];
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _withdrawBtn.layer.cornerRadius = kAdapt(8);
        _withdrawBtn.layer.masksToBounds = YES;
        [_withdrawBtn addTarget:self action:@selector(commitWithdraw) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawBtn;
}
@end

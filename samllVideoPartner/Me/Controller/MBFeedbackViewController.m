//
//  MBFeedbackViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/3.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBFeedbackViewController.h"
/** 占位符富文本*/
#import "MBPTextView.h"
/** 反馈成功界面*/
#import "MBFeedbackSuccessController.h"

#define kWordsLimitNumber       500

@interface MBFeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>

/** 意见容器*/
@property (nonatomic, strong) UIView * containerView;
/** 意见*/
@property (nonatomic, strong) MBPTextView * opinionTextView;
/** 允许输入的字符数提示*/
@property (nonatomic, strong) UILabel * wordsTipLabel;
/** 手机输入框*/
@property (nonatomic, strong) UITextField * mobileTF;
/** 提交按钮*/
@property (nonatomic, strong) UIButton * commitBtn;

@end

@implementation MBFeedbackViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)setupSubviews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.opinionTextView];
    [self.containerView addSubview:self.wordsTipLabel];
    [self.view addSubview:self.mobileTF];
    [self.view addSubview:self.commitBtn];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(18+NAVIGATION_BAR_HEIGHT);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(160);
    }];
    [self.wordsTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right).offset(-12);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-9);
    }];
    [self.opinionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.containerView);
        make.left.equalTo(self.containerView.mas_left).offset(5);
        make.bottom.equalTo(self.wordsTipLabel.mas_top).offset(-5);
    }];
    [self.mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    [self.mobileTF editingRectForBounds:CGRectMake(10, 0, kAdapt(350)-20, 46)];
    [self.mobileTF textRectForBounds:CGRectMake(10, 0, kAdapt(350)-20, 46)];
    [self.mobileTF placeholderRectForBounds:CGRectMake(10, 0, kAdapt(350)-20, 46)];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mobileTF.mas_bottom).offset(38);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.mobileTF.mas_left).offset(31);
        make.right.equalTo(self.mobileTF.mas_right).offset(-31);
        make.height.mas_equalTo(47);
    }];
    
}

#pragma mark--UITextViewDelegate--
- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        return;
    }
    NSString *tmp = @"";
    if (textView.text.length>kWordsLimitNumber) {
        tmp = [textView.text substringToIndex:kWordsLimitNumber];
    }else {
        tmp = textView.text;
    }
    self.wordsTipLabel.text = [NSString stringWithFormat:@"%ld/500",tmp.length];
    [textView setText:tmp];}
/** 限制字数*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < kWordsLimitNumber) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = kWordsLimitNumber - comcatstr.length;
    
    if (caninputlen >= 0) {
        self.wordsTipLabel.text = [NSString stringWithFormat:@"%ld/500",caninputlen];
        return YES;
    }else{
        return NO;
    }
    return YES;
}
#pragma mark--UITextFieldDelegate--
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *mutableStr = [NSMutableString stringWithString:textField.text];
    [mutableStr replaceCharactersInRange:range withString:string];
    if (11<mutableStr.length) {
        return NO;
    }
    return YES;
}

- (void)checkIsMobilePhone {
    if (11 == self.mobileTF.text.length) {
        if (![NSString checkIsMobilePhone:self.mobileTF.text]) {
            [MBProgressHUD showOnlyTextMessage:@"您输入的手机号码不正确"];
            return;
        }
    }
}
/** 提交反馈意见*/
- (void)commitUserOpinion {
    if (self.opinionTextView.text.length <= 0) {
        [MBProgressHUD showOnlyTextMessage:@"请填写您的反馈意见"];
        return;
    }
    if (self.mobileTF.text.length != 11 || ![NSString checkIsMobilePhone:self.mobileTF.text]) {
        [MBProgressHUD showOnlyTextMessage:@"您输入的手机号码不正确"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"content"] = [self.opinionTextView.text filterWithoutEmoji];
    dict[@"mobile"] = self.mobileTF.text;
    [RequestUtil POST:USER_FEEDBACK_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LOCK
                MBFeedbackSuccessController *successVC = [MBFeedbackSuccessController new];
                [self.navigationController pushViewController:successVC animated:YES];
                UNLOCK
            });
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark--lazy---
/** 容器view*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
        _containerView.layer.cornerRadius = 5;
        _containerView.cs_borderColor = [UIColor colorWithHexString:@"#999999"];
        _containerView.cs_borderWidth = 1;
    }
    return _containerView;
}
/** 意见*/
- (MBPTextView *)opinionTextView {
    if (!_opinionTextView) {
        _opinionTextView = [[MBPTextView alloc]init];
        _opinionTextView.backgroundColor = [UIColor clearColor];
        _opinionTextView.tintColor = [UIColor colorWithHexString:@"#FF0000"];
        _opinionTextView.textAlignment = NSTextAlignmentLeft;
        _opinionTextView.textColor = [UIColor colorWithHexString:@"#333333"];
        _opinionTextView.font = [UIFont systemFontOfSize:13];
        _opinionTextView.placeHolder = @"请输入您的建议";
        _opinionTextView.placeHolderColor = [UIColor colorWithHexString:@"#999999"];
        _opinionTextView.delegate = self;
    }
    return _opinionTextView;
}
/** 输入文字字数提示*/
- (UILabel *)wordsTipLabel {
    if (!_wordsTipLabel) {
        _wordsTipLabel = [[UILabel alloc]init];
        _wordsTipLabel.backgroundColor = [UIColor clearColor];
        _wordsTipLabel.textAlignment = NSTextAlignmentRight;
        _wordsTipLabel.font = [UIFont systemFontOfSize:13];
        _wordsTipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _wordsTipLabel.text = @"0/500";
        [_wordsTipLabel sizeToFit];
    }
    return _wordsTipLabel;
}
/** 手机输入框*/
- (UITextField *)mobileTF {
    if (!_mobileTF) {
        _mobileTF = [[UITextField alloc]init];
        _mobileTF.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
        _mobileTF.keyboardType = UIKeyboardTypePhonePad;
        _mobileTF.borderStyle = UITextBorderStyleNone;
        _mobileTF.textColor = [UIColor colorWithHexString:@"#333333"];
        _mobileTF.textAlignment = NSTextAlignmentLeft;
        _mobileTF.font = [UIFont systemFontOfSize:13];
        _mobileTF.tintColor = [UIColor colorWithHexString:@"#FD4539"];
        _mobileTF.placeholder = @"请留下您的手机号";
        _mobileTF.cs_borderColor = [UIColor colorWithHexString:@"#999999"];
        _mobileTF.cs_borderWidth = 1;
        _mobileTF.layer.cornerRadius = 5;
        _mobileTF.layer.masksToBounds = YES;
        _mobileTF.delegate = self;
        [_mobileTF addTarget:self action:@selector(checkIsMobilePhone) forControlEvents:UIControlEventEditingChanged];
        _mobileTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 46)];
        _mobileTF.leftViewMode = UITextFieldViewModeAlways;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_mobileTF.placeholder];
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, string.length)];
        _mobileTF.attributedPlaceholder = string;
    }
    return _mobileTF;
}
/** 提交按钮*/
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FA3C3C"]] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _commitBtn.layer.cornerRadius = 8;
        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn addTarget:self action:@selector(commitUserOpinion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
@end

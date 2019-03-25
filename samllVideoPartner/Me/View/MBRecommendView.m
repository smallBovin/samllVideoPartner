//
//  MBRecommendView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/11.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBRecommendView.h"

@interface MBRecommendView ()

/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 描述*/
@property (nonatomic, strong) UILabel * desLabel;
/** 输入框*/
@property (nonatomic, strong) UITextField * textField;
/** 确定*/
@property (nonatomic, strong) UIButton * sureBtn;
/** 按钮view*/
@property (nonatomic, strong) UIView * textView;

@end

@implementation MBRecommendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

-(void)showKeyBoard{
    [self.textField becomeFirstResponder];
}

-(void)numberChanged:(UITextField *)textField{
    if (textField.text.length>6) {
        textField.text = [textField.text substringToIndex:6];
        return;
    }
    
    for (NSInteger i=0; i<textField.text.length; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:1000+i];
        label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    
    for (NSInteger i = textField.text.length; i<6; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:1000+i];
        label.text = @"";
    }
}

-(void)sureBtnAction{
    [self.textField resignFirstResponder];
    if (self.textField.text.length == 6) {
        if (self.CommitRecommendIDBlock) {
            self.CommitRecommendIDBlock(self.textField.text);
        }
    }else{
        [MBProgressHUD showOnlyTextMessage:@"请输入完整的推荐人ID"];
    }
}

#pragma mark -- 懒加载
-(void)creatSubView{
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textField];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.textView];
    [self addSubview:self.sureBtn];
    for (NSInteger i=0; i<6; i++) {
        UILabel *label = [UILabel lableWithFrame:CGRectMake(kAdapt(51)*i, kAdapt(19), kAdapt(42), kAdapt(47)) text:@"" textColor:[UIColor colorWithHexString:@"1C172F"] font:20 textAlignment:NSTextAlignmentCenter lines:1];
        label.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
        label.layer.cornerRadius = 8.0;
        label.clipsToBounds = YES;
        label.tag = 1000+i;
        [self.textView addSubview:label];
    }
    
}
/** <#description#>*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel lableWithFrame:CGRectMake(kAdapt(22), kAdapt(14), kAdapt(150), kAdapt(20)) text:@"填写推荐人" textColor:[UIColor colorWithHexString:@"333333"] font:20 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _titleLabel;
}

- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel lableWithFrame:CGRectMake(kAdapt(22), kAdapt(45), kAdapt(290), kAdapt(15)) text:@"请填写推荐人的ID号码，填写后不可更改。" textColor:[UIColor colorWithHexString:@"333333"] font:14 textAlignment:NSTextAlignmentLeft lines:1];
    }
    return _desLabel;
}

/** <#description#>*/
- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc]initWithFrame:CGRectMake(kAdapt(22), kAdapt(65), kAdapt(290), kAdapt(80))];
        [_textView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showKeyBoard)]];
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

/** <#description#>*/
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(kAdapt(22), kAdapt(170), kAdapt(293), kAdapt(47));
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:@"FA3C3C"] state:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.layer.cornerRadius = 8.0;
        _sureBtn.clipsToBounds = YES;
        
    }
    return _sureBtn;
}

/** <#description#>*/
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.tintColor = [UIColor whiteColor];
        [_textField resignFirstResponder];
        _textField.hidden = YES;
        [_textField addTarget:self action:@selector(numberChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
@end

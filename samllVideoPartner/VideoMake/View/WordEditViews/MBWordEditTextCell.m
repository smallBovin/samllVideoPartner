//
//  MBWordEditTextCell.m
//  samllVideoPartner
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBWordEditTextCell.h"
#import "UITextField+MBExtension.h"

@interface MBWordEditTextCell()<UITextFieldDelegate>
/**   */
@property (nonatomic , strong)UIButton *selectBtn;

/** 删除行*/
@property (nonatomic, assign)NSInteger  textLength;

@end

@implementation MBWordEditTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}


-(void)setFontName:(NSString *)fontName{
    _fontName = fontName;
    self.contentTF.font = [UIFont fontWithName:fontName size:16];
}

-(void)setModel:(LSOOneLineText *)model{
    _model = model;
    self.contentTF.text = model.text;
    self.selectBtn.selected = model.isSelected;
    self.contentTF.textColor = model.textColor;
    self.contentTF.tintColor = model.textColor;
    self.textLength = model.text.length-1;
    if (model.isSelected == YES) {
        [self.selectBtn setBackgroundColor:model.textColor state:UIControlStateNormal];
        self.selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        [self.selectBtn setBackgroundColor:[UIColor clearColor] state:UIControlStateNormal];
        self.selectBtn.layer.borderColor = [UIColor colorWithHexString:@"f2f2f2"].CGColor;
    }
}

-(void)selectBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeWordSelect:index:)]) {
        [self.delegate changeWordSelect:!sender.selected index:self.index];
    }
}


- (void)textFieldDidDeleteBackward:(UITextField *)textField{
    NSLog(@">>>???>>>DeleteBackward");
    if (self.textLength == -1 && textField.text.length<=0 && self.delegate && [self.delegate respondsToSelector:@selector(deleteLineWithIndex:)]) {
        [self.delegate deleteLineWithIndex:self.index];
    }
    self.textLength = textField.text.length-1;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeWordFinish:index:)]) {
        [self.delegate changeWordFinish:textField.text index:self.index];
    }
}
-(void)textFieldEditingChanged:(UITextField *)textField{
    NSLog(@">>>???>>>EditingChanged");
    if (textField.text.length>0) {
        self.textLength = textField.text.length;
    }
//    if (textField.text.length<=0) {
//        self.isAllowDelete = YES;
//    }else{
//        self.isAllowDelete = NO;
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(addLineWithIndex:location:)]) {
            [self.delegate addLineWithIndex:self.index location:range.location];
        }
//         [textField resignFirstResponder];
        return NO;
    }
    
    NSMutableString *resultMutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [resultMutableStr replaceCharactersInRange:range withString:string];
    if (8<resultMutableStr.length) {
        return NO;
    }
    return YES;
}


-(void)creatSubView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectBtn];
    [self addSubview:self.contentTF];
    __weak typeof(self) weakSelf = self;
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(kAdapt(15));
        make.width.height.equalTo(@(kAdapt(18)));
    }];
    
    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.selectBtn.mas_right).offset(kAdapt(10));
        make.right.equalTo(weakSelf).offset(kAdapt(20));
    }];
}

-(UITextField *)contentTF{
    if(!_contentTF){
        _contentTF = [[UITextField alloc]init];
        _contentTF.font = [UIFont systemFontOfSize:16];
        _contentTF.textAlignment = NSTextAlignmentLeft;
        _contentTF.delegate = self;
        [_contentTF addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _contentTF;
}

-(UIButton *)selectBtn{
    if(!_selectBtn){
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.layer.borderWidth = 1.0;
        _selectBtn.layer.cornerRadius = 4.0;
        _selectBtn.clipsToBounds = YES;
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end

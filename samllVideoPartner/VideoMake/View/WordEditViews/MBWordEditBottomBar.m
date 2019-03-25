//
//  MBWordEditBottomBar.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBWordEditBottomBar.h"

@interface MBWordEditBottomBar ()
/** 字体选择*/
@property (nonatomic, strong)UIButton *fontBtn;

/** 颜色选择*/
@property (nonatomic, strong)UIButton *colorBtn;
@property (nonatomic , strong)UIView *colorView;
@property (nonatomic , strong)UIView *lineView;
@property (nonatomic , strong)UILabel *colorLabel;

@end

@implementation MBWordEditBottomBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView];
    }
    return self;
}


-(void)setColorName:(NSString *)colorName{
    _colorName = colorName;
    UIColor *color = [UIColor colorWithHexString:colorName];
    self.colorView.backgroundColor = color;
    if ([colorName containsString:@"ffffff"] || [colorName containsString:@"FFFFFF"]) {
        self.lineView.layer.borderWidth = 1.0;
        self.colorView.layer.borderWidth = 1.0;
        self.colorView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        self.lineView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    }else{
        self.lineView.layer.borderWidth = 3.0;
        self.colorView.layer.borderWidth = 0.0;
        self.colorView.layer.borderColor = [UIColor clearColor].CGColor;
        self.lineView.layer.borderColor = color.CGColor;
    }
}

#pragma mark--懒加载
-(void)creatSubView{
    [self addSubview:self.fontBtn];
    [self addSubview:self.colorBtn];
//    [self.colorBtn addSubview:self.lineView];
//    [self.lineView addSubview:self.colorView];
//    [self.colorBtn addSubview:self.colorLabel];
//    __weak typeof(self) weakSelf = self;
    [self.fontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(3);
        make.left.equalTo(self.mas_left).offset(kAdapt(65));
        make.height.mas_equalTo(kAdapt(70));
    }];
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(3);
        make.right.equalTo(self.mas_right).offset(-kAdapt(65));
        make.height.mas_equalTo(kAdapt(70));
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.colorBtn);
//        make.top.equalTo(weakSelf.colorBtn).offset(5);
//        make.width.height.equalTo(@(kAdapt(30)));
//    }];
//
//    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(weakSelf.lineView);
//        make.width.height.equalTo(@(kAdapt(20)));
//    }];
//
//    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.colorBtn);
//        make.top.equalTo(weakSelf.lineView.mas_bottom).offset(3.0);
//    }];
}


/** 字体*/
- (UIButton *)fontBtn {
    if (!_fontBtn) {
        _fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fontBtn setImage:[UIImage imageNamed:@"choose_font_nomal"] forState:UIControlStateNormal];
        [_fontBtn setImage:[UIImage imageNamed:@"choose_font_select"] forState:UIControlStateSelected];
        [_fontBtn setTitle:@"文字字体" forState:UIControlStateNormal];
        [_fontBtn setTitleColor:[UIColor colorWithHexString:@"#373639"] forState:UIControlStateNormal];
        _fontBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _fontBtn.type = MBButtonTypeTopImageBottomTitle;
        _fontBtn.spaceMargin = 5;
        _fontBtn.exclusiveTouch = YES;
        __weak typeof(self) weakSelf = self;
        [_fontBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chooseFontAction:)]) {
                [weakSelf.delegate chooseFontAction:btn];
            }
        }];
    }
    return _fontBtn;
}

/** 颜色选择*/
- (UIButton *)colorBtn{
    if (!_colorBtn) {
        _colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colorBtn setImage:[UIImage imageNamed:@"choose_color_normal"] forState:UIControlStateNormal];
        [_colorBtn setImage:[UIImage imageNamed:@"choose_color_select"] forState:UIControlStateSelected];
        [_colorBtn setTitle:@"文字颜色" forState:UIControlStateNormal];
        [_colorBtn setTitleColor:[UIColor colorWithHexString:@"#373639"] forState:UIControlStateNormal];
        _colorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _colorBtn.type = MBButtonTypeTopImageBottomTitle;
        _colorBtn.spaceMargin = 5;
        _colorBtn.exclusiveTouch = YES;
        __weak typeof(self) weakSelf = self;
        [_colorBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chooseColorAction:)]) {
                [weakSelf.delegate chooseColorAction:btn];
            }
        }];
    }
    return _colorBtn;
}
-(UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.layer.borderWidth = 3.0;
        _lineView.layer.cornerRadius = 2.0;
        _lineView.clipsToBounds = YES;
        _lineView.userInteractionEnabled = NO;
    }
    return _lineView;
}
-(UIView *)colorView{
    if(!_colorView){
        _colorView = [[UIView alloc]init];
        _colorView.userInteractionEnabled = NO;
    }
    return _colorView;
}


-(UILabel *)colorLabel{
    if(!_colorLabel){
        _colorLabel = [UILabel lableWithFrame:CGRectZero text:@"文字颜色" textColor:[UIColor colorWithHexString:@"373639"] font:13 textAlignment:NSTextAlignmentCenter lines:1];
    }
    return _colorLabel;
}

@end

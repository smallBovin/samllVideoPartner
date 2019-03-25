//
//  MBPTextView.m
//  DFJC_201609
//
//  Created by charling on 2018/4/10.
//  Copyright © 2018年 汪泽煌. All rights reserved.
//

#import "MBPTextView.h"

//自定义占位文字的边距
#define kPlaceHolderTextMargin          5.0f

@implementation MBPTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置占位符默认颜色
        self.placeHolderColor = [UIColor lightGrayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mbp_textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}



- (void)mbp_textDidChange:(NSNotification *)noti {
    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

#pragma mark---drawRect------
- (void)drawRect:(CGRect)rect {
    //如果有内容，不展示占位符号
    if (self.hasText) return;
    //如果没有内容，展示占位符号，并设置占位符的的属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeHolderColor;
    
    
    CGFloat placeHolderMaxWidth = rect.size.width-2*kPlaceHolderTextMargin;
    //获取占位文字的最大宽度
    CGRect placeHolderRect = [self.placeHolder boundingRectWithSize:CGSizeMake(placeHolderMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
   //根据textView内容的排列，自动适配占位符的展示位置
    if (self.textAlignment == NSTextAlignmentLeft||self.textAlignment == NSTextAlignmentCenter) {
        rect.origin.x = kPlaceHolderTextMargin;
        rect.origin.y = kPlaceHolderTextMargin;
        rect.size.width -= 2*kPlaceHolderTextMargin;
    }else if (self.textAlignment == NSTextAlignmentRight) {
    
        if (placeHolderRect.size.width<placeHolderMaxWidth) {   //不足一行时占位符位置
            rect.origin.x = rect.size.width - placeHolderRect.size.width-kPlaceHolderTextMargin;
            rect.origin.y = kPlaceHolderTextMargin;
            rect.size.width = placeHolderRect.size.width;
        }else {    //占位符有多行时，与左对齐展示效果类似
            rect.origin.x = kPlaceHolderTextMargin;
            rect.origin.y = kPlaceHolderTextMargin;
            rect.size.width -= 2*kPlaceHolderTextMargin;
        }
    }
    //绘制占位符内容
    [self.placeHolder drawInRect:rect withAttributes:attrs];
        
}


- (void)dealloc {
    NSLog(@"%@ has dealloc",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

@end

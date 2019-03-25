//
//  UILabel+SubTap.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UILabel+SubTap.h"

@implementation UILabel (SubTap)


- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

+(instancetype)lableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment  lines:(CGFloat)lines{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    label.numberOfLines = lines;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    return label;
}

@end

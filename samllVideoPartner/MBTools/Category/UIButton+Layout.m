//
//  UIButton+Layout.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UIButton+Layout.h"
#import <objc/runtime.h>

@implementation UIButton (Layout)

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font image:(UIImage *)image type:(MBButtonType)type textAlignment:(MBButtonAlignment)textAlignment action:(void (^)(UIButton * btn))action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    button.type = type;
    button.textAlignment = textAlignment;
    [button addTapBlock:^(UIButton * _Nonnull btn) {
        if (action) {
            action(btn);
        }
    }];
    return button;
}

- (void)setupButtonLayout {
    if (MBButtonTypeNone == self.type) {
        return;
    }
    
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    
    CGFloat title_w = self.titleLabel.bounds.size.width;
    CGFloat title_h = self.titleLabel.bounds.size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        title_w = self.titleLabel.intrinsicContentSize.width;
        title_h = self.titleLabel.intrinsicContentSize.height;
    }
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    if (self.spaceMargin == 0.0) {
        self.spaceMargin = 5.0;
    }
    if (self.edgeMargin == 0.0) {
        self.edgeMargin = 10.0;
    }
    switch (self.type) {
        case MBButtonTypeLeftImageRightTitle:
        {
            if (MBButtonAlignmentLeft == self.textAlignment) {
                titleEdge = UIEdgeInsetsMake(0, self.spaceMargin + self.edgeMargin, 0, 0);
                imageEdge = UIEdgeInsetsMake(0, self.edgeMargin, 0, 0);
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else if (MBButtonAlignmentRight == self.textAlignment){
                imageEdge = UIEdgeInsetsMake(0, 0, 0, self.spaceMargin + self.edgeMargin);
                titleEdge = UIEdgeInsetsMake(0, 0, 0, self.edgeMargin);
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }else {
                titleEdge = UIEdgeInsetsMake(0, self.spaceMargin, 0, 0);
                imageEdge = UIEdgeInsetsMake(0, 0, 0, self.spaceMargin);
            }
        }
            break;
        case MBButtonTypeRightImageLeftTitle:
        {
            if (MBButtonAlignmentLeft == self.textAlignment) {
                titleEdge = UIEdgeInsetsMake(0, -image_w+self.edgeMargin, 0, 0);
                imageEdge = UIEdgeInsetsMake(0, title_w+self.spaceMargin+self.edgeMargin, 0, 0);
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else if (MBButtonAlignmentRight == self.textAlignment) {
                titleEdge = UIEdgeInsetsMake(0, 0, 0, image_w + self.spaceMargin + self.edgeMargin);
                imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.edgeMargin);
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }else {
                titleEdge = UIEdgeInsetsMake(0, -image_w-self.spaceMargin, 0, 0);
                imageEdge = UIEdgeInsetsMake(0, title_w+self.spaceMargin, 0, -title_w);
            }
        }
            break;
        case MBButtonTypeTopImageBottomTitle:
        {
            titleEdge = UIEdgeInsetsMake(image_h+self.spaceMargin, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(-title_h-self.spaceMargin, 0, 0, -title_w);
        }
            break;
        case MBButtonTypeBottomImageTopTitle:
        {
            titleEdge = UIEdgeInsetsMake(-image_h - self.spaceMargin, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.spaceMargin, -title_w);
        }
            break;
            
        default:
            break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
}


- (void)setType:(MBButtonType)type {
    objc_setAssociatedObject(self, @selector(type), @(type), OBJC_ASSOCIATION_ASSIGN);
    [self setupButtonLayout];
}
- (MBButtonType)type {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setTextAlignment:(MBButtonAlignment)textAlignment {
    objc_setAssociatedObject(self, @selector(textAlignment), @(textAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}
- (MBButtonAlignment)textAlignment {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setSpaceMargin:(CGFloat)spaceMargin {
    objc_setAssociatedObject(self, @selector(spaceMargin), @(spaceMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}
- (CGFloat)spaceMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setEdgeMargin:(CGFloat)edgeMargin {
    objc_setAssociatedObject(self, @selector(edgeMargin), @(edgeMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setupButtonLayout];
}
- (CGFloat)edgeMargin {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setupButtonLayout];
}
@end

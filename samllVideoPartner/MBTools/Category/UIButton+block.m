//
//  UIButton+block.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UIButton+block.h"
#import<objc/runtime.h>
@implementation UIButton (block)

-(void)setBlock:(void(^)(UIButton*))block {
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}

-(void(^)(UIButton*))block {
    return objc_getAssociatedObject(self,@selector(block));
}

-(void)addTapBlock:(void(^)(UIButton*))block {
    self.block= block;
    [self addTarget: self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
}

-(void)click:(UIButton*)btn {
    if(self.block) {
        self.block(btn);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor state:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

//可以扩大点击的范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat extWidth =  20;
    CGFloat extHeight = 20;
    CGRect bounds = CGRectMake(-10, -10, self.bounds.size.width+extWidth, self.bounds.size.height+extHeight);
    return CGRectContainsPoint(bounds, point);
}

@end

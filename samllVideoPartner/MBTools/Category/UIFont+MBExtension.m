//
//  UIFont+MBExtension.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "UIFont+MBExtension.h"
#import <objc/runtime.h>

@implementation UIFont (MBExtension)

+ (void)load {
    SEL originalSelector = @selector(systemFontOfSize:);
    SEL swizzledSelector = @selector(mb_CustomFontSize:);
    Method originalMethod = class_getClassMethod([self class], originalSelector);
    Method swizzledMethod = class_getClassMethod([self class], swizzledSelector);
    BOOL didAdd = class_addMethod([self class], swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (!didAdd) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

+ (UIFont *)mb_CustomFontSize:(CGFloat)size {
    CGFloat fontSize;
    if (SCREEN_WIDTH < 375.0) {
        fontSize = (size-2);
    }else if (SCREEN_WIDTH == 375.0){
        fontSize = size;
    }else{
        fontSize = (size+1);
    }
    return [UIFont fontWithName:@"MicrosoftYaHei" size:fontSize];
}

@end

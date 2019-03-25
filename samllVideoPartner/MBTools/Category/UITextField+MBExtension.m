//
//  UITextField+MBExtension.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/2/15.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "UITextField+MBExtension.h"

#import <objc/runtime.h>

NSString * const MBTextFieldDidDeleteBackwardNotification = @"textfield_did_notification";

@implementation UITextField (MBExtension)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(sp_deleteBackward));
    method_exchangeImplementations(method1, method2);
}
- (void)sp_deleteBackward {
    [self sp_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <MBTextFieldDelegate> delegate  = (id<MBTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBTextFieldDidDeleteBackwardNotification object:self];
}


@end

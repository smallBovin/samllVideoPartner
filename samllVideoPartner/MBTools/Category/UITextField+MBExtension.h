//
//  UITextField+MBExtension.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/2/15.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBTextFieldDelegate <UITextFieldDelegate>

@optional

- (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end


@interface UITextField (MBExtension)

@property (weak, nonatomic) id<MBTextFieldDelegate> delegate;

@end

/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const MBTextFieldDidDeleteBackwardNotification;

NS_ASSUME_NONNULL_END

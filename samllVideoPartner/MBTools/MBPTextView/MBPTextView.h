//
//  MBPTextView.h
//  DFJC_201609
//
//  Created by charling on 2018/4/10.
//  Copyright © 2018年 汪泽煌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义带占位符的textView
 */
@interface MBPTextView : UITextView
//占位符的内容
@property (nonatomic, copy) NSString *placeHolder;
//占位符字体颜色
@property (nonatomic, strong) UIColor *placeHolderColor;


@end

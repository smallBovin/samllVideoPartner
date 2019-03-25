//
//  MBWordEditModel.h
//  samllVideoPartner
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBWordEditModel : NSObject
/**  内容 */
@property (nonatomic , copy)NSString *text;
/** 字体大小*/
@property (nonatomic , assign)CGFloat  originFontSize;
/**  内容 */
@property (nonatomic , copy)NSString *content;
/**  普通颜色 */
@property (nonatomic , strong)UIColor *normalColor;

/**  是否选中 */
@property (nonatomic , assign)BOOL isSelect;
/** 字体大小*/
@property (nonatomic , assign)CGFloat  fontSize;
// 当前行json中的图片的宽度
@property (nonatomic , assign)int  imageWidth;

// 当前行json总的图片的高度
@property (nonatomic , assign)int  imageHeight;

@end

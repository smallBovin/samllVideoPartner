//
//  MBWordFontColorModel.h
//  samllVideoPartner
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBWordFontColorModel : NSObject
/**   */
@property (nonatomic , copy)NSString *tempId;
/**  使用权限 1:vip 2:普通 */
@property (nonatomic , copy)NSString *author;
/**  是否被选中 */
@property (nonatomic , assign)BOOL isSelect;

/**  字体 */
@property (nonatomic , copy)NSString *path;
@property (nonatomic , copy)NSString *thumb;
@property (nonatomic , copy)NSString *title;

/**  颜色 */
@property (nonatomic , copy)NSString *name;
@property (nonatomic , copy)NSString *color;


/** 自己添加的字体名称*/
@property (nonatomic , copy)NSString *fontName;
/** 字体自定义属性，是否下载*/
@property (nonatomic , assign) BOOL isDownload;

@end

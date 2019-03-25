//
//  MBWordEditViewController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBWordEditViewController : MBBaseViewController
/**   */
@property (nonatomic , strong)NSMutableArray *dataArry;
/**   */
@property (nonatomic , strong)NSMutableArray *titleArry;
/**   */
@property (nonatomic , copy)NSString *fontName;
/** */
@property (nonatomic , copy) NSString *fontTitle;
/** aeview*/
@property (nonatomic , strong)LSOAeView *aeView;
/** 编辑完成*/
@property (nonatomic, copy)  void(^MBWordEditingCompletion)(NSMutableArray *textArray,NSString *fongName,NSString *fontTitle,NSMutableArray *titleArry);

@end

NS_ASSUME_NONNULL_END

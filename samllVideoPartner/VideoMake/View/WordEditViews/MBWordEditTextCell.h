//
//  MBWordEditTextCell.h
//  samllVideoPartner
//
//  Created by mac on 2019/1/16.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MBWordEditDelegate <NSObject>

-(void)changeWordSelect:(BOOL)select index:(NSInteger)index;
-(void)changeWordFinish:(NSString *)content index:(NSInteger)index;
-(void)changeLineWithIndex:(NSInteger)index;
-(void)deleteLineWithIndex:(NSInteger)index;
-(void)addLineWithIndex:(NSInteger)index location:(NSInteger)location;

@end

@interface MBWordEditTextCell : UITableViewCell
/**   */
@property (nonatomic , weak)id <MBWordEditDelegate> delegate;
/**   */
@property (nonatomic , strong)LSOOneLineText *model;
/**   */
@property (nonatomic , strong)UITextField *contentTF;
/**   */
@property (nonatomic , copy)NSString *fontName;
/**   */
@property (nonatomic , assign)NSInteger index;

@end

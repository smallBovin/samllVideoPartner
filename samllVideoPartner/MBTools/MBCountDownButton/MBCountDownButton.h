//
//  MBCountDownButton.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/22.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MBCountDownButton;

// delegate
@protocol MBCountDownButtonDelegate <NSObject>

@optional

//** 倒计时完成时调用 */
- (void)countdownSuccess:(MBCountDownButton *)button;
//** 倒计时开始时调用 */
- (void)countdownBegin:(MBCountDownButton *)button;

@end

//** 倒计时完成时调的block */
typedef void(^CountdownSuccessBlock)(MBCountDownButton *button);
//** 倒计时开始时调的block */
typedef void(^CountdownBeginBlock)(MBCountDownButton *button);

@interface MBCountDownButton : UIButton

//** delegate */
@property (nonatomic, weak) id<MBCountDownButtonDelegate> delegate;
//** 隐藏 */
+ (void)hidden;
//** 全是默认值的play方法 */
+ (instancetype)play;

//** number : 倒计时开始数字 */
+ (instancetype)playWithNumber:(NSInteger)number;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符 */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle;
//** number : 倒计时开始数字；success : 倒计时完成回调 */
+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；success : 倒计时完成回调； */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；begin : 倒计时开始回调；success : 倒计时完成回调；*/
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success;

//** number : 倒计时开始数字；begin : 倒计时开始回调；success : 倒计时完成回调；*/
+ (instancetype)playWithImages:(NSArray *)images begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success;

+ (instancetype)playWithImages:(NSArray *)images duration:(NSTimeInterval)duration begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success;

//** 绑定代理 */
+ (void)addDelegate:(id<MBCountDownButtonDelegate>)delegate;
//** 倒计时完成时的block监听 */
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success;
//** 倒计时开始时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin;
//** 倒计时开始时和结束时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success;

@end

NS_ASSUME_NONNULL_END

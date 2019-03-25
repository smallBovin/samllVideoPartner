//
//  MBCountDownButton.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/22.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBCountDownButton.h"
#import "AppDelegate.h"

#define WZBAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define WZBSetWidth(frame, w) frame = CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height)
#define WZBStringWidth(string, font) [string sizeWithAttributes:@{NSFontAttributeName : font}].width

typedef NS_ENUM(NSInteger, MBCountDownType) {
    MBCountDownTypeNumber = 0, // 数字倒计时
    MBCountDownTypeImage       // 图片倒计时
};

@interface MBCountDownButton ()

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *endTitle;
@property (nonatomic, copy) CountdownSuccessBlock countdownSuccessBlock;
@property (nonatomic, copy) CountdownBeginBlock countdownBeginBlock;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, assign) MBCountDownType countDownType;


@end

@implementation MBCountDownButton


static BOOL isAnimationing;

#pragma mark - lazy
- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] init];
        [self addSubview:_mainImageView];
        _mainImageView.hidden = YES;
    }
    return _mainImageView;
}

+ (instancetype)share {
    static MBCountDownButton *button = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        button = [[MBCountDownButton alloc] init];
        isAnimationing = NO;
        button.enabled = NO;
    });
    return button;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isAnimationing = NO;
    }
    return self;
}
+ (void)hidden {
    isAnimationing = NO;
    // 复原button状态，这句话必须写，不然有问题
    [MBCountDownButton share].transform = CGAffineTransformIdentity;
    [MBCountDownButton share].delegate = nil;
    [MBCountDownButton share].countdownSuccessBlock = nil;
    [MBCountDownButton share].countdownBeginBlock = nil;
    [MBCountDownButton share].hidden = YES;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success {
    // isAnimationing 用来判断目前是否在动画
    if (isAnimationing) return nil;
    MBCountDownButton *button = [MBCountDownButton share];
    button.hidden = NO;
    // 给全局属性赋值
    // 默认三秒
    button.number = 3;
    if (number && number > 0) button.number = number;
    if (endTitle) button.endTitle = endTitle;
    if (success) button.countdownSuccessBlock = success;
    if (begin) button.countdownBeginBlock = begin;
    
    [self setupButtonBase:button];
    
    // 动画倒计时部分
    [self scaleActionWithBeginBlock:begin andSuccessBlock:success button:button];
    return button;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success{
    return [self playWithNumber:number endTitle:endTitle begin:[MBCountDownButton share].countdownBeginBlock success:success];
}

// button的基本属性
+ (void)setupButtonBase:(MBCountDownButton *)button {
    button.hidden = NO;
    button.frame = (CGRect){0, 0, SCREEN_WIDTH, SCREEN_HEIGHT};
//    button.transform = CGAffineTransformScale(button.transform, 5, 5);
    button.alpha = 0;
    if (button.countDownType != MBCountDownTypeImage) {
        [button setTitle:[NSString stringWithFormat:@"%zd", button.number] forState:UIControlStateNormal];
    } else {
        button.transform = CGAffineTransformIdentity;
        button.transform = CGAffineTransformMakeScale(5, 5);
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:150];
    //    WZBSetWidth(label.frame, WZBStringWidth(label.endTitle, label.font));
    [[button getCurrentView] addSubview:button];
    button.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

// 动画倒计时部分
+ (void)scaleActionWithBeginBlock:(CountdownBeginBlock)begin andSuccessBlock:(CountdownSuccessBlock)success button:(MBCountDownButton *)button {
    if (!isAnimationing) { // 如果不在动画, 才走开始的代理和block
        if (begin) begin(button);
        if ([button.delegate respondsToSelector:@selector(countdownBegin:)]) [button.delegate countdownBegin:button];
    }
    
    if (button.countDownType == MBCountDownTypeImage) {
        [self setAnimationImage:button];
    } else {
        [self setAnimationNumber:button];
    }
    [[button getCurrentView] bringSubviewToFront:button];
}

// 播放倒计时图片
+ (void)setAnimationImage:(MBCountDownButton *)button {
    if (button.images.count > 0) {
        isAnimationing = YES;
        [button setImage:[UIImage imageNamed:button.images.firstObject] forState:UIControlStateNormal];
        [UIView animateWithDuration:1.0f animations:^{
//            button.transform = CGAffineTransformIdentity;
            button.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                button.alpha = 0;
//                button.transform = CGAffineTransformMakeScale(5, 5);
                if (button.images.count > 0) {
                    [button.images removeObjectAtIndex:0];
                    [self scaleActionWithBeginBlock:button.countdownBeginBlock andSuccessBlock:button.countdownSuccessBlock button:button];
                }
            }
        }];
    } else {
        // 调用倒计时完成的代理和block
        if ([button.delegate respondsToSelector:@selector(countdownSuccess:)]) [button.delegate countdownSuccess:button];
        
        if (button.countdownSuccessBlock) button.countdownSuccessBlock(button);
        [self hidden];
    }
}

+ (void)setAnimationNumber:(MBCountDownButton *)button {
    // 这个判断用来表示有没有结束语
    if (button.number >= (button.endTitle ? 0 : 1)) {
        isAnimationing = YES;
        [button setTitle:button.number == 0 ? button.endTitle : [NSString stringWithFormat:@"%zd", button.number] forState:UIControlStateNormal];
        button.alpha = 1;
        [UIView animateWithDuration:1 animations:^{
            button.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            if (finished) {
                button.number--;
                button.alpha = 0;
                button.transform = CGAffineTransformMakeScale(1, 1);
                [self scaleActionWithBeginBlock:button.countdownBeginBlock andSuccessBlock:button.countdownSuccessBlock button:button];
            }
        }];
    } else {
        // 调用倒计时完成的代理和block
        if ([button.delegate respondsToSelector:@selector(countdownSuccess:)]) [button.delegate countdownSuccess:button];
        
        if (button.countdownSuccessBlock) button.countdownSuccessBlock(button);
        [self hidden];
    }
}

#pragma mark - play methods
+ (instancetype)play {
    return [self playWithNumber:0];
}

+ (instancetype)playWithNumber:(NSInteger)number {
    return [self playWithNumber:number endTitle:[MBCountDownButton share].endTitle];
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle {
    return [self playWithNumber:number endTitle:endTitle success:[MBCountDownButton share].countdownSuccessBlock];
}

+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success {
    return [self playWithNumber:number endTitle:[MBCountDownButton share].endTitle success:success];
}

#pragma mark - add block
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success {
    [MBCountDownButton share].countdownSuccessBlock = success;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin {
    [MBCountDownButton share].countdownBeginBlock = begin;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success {
    [MBCountDownButton share].countdownSuccessBlock = success;
    [MBCountDownButton share].countdownBeginBlock = begin;
}

#pragma mark - add delegate
+ (void)addDelegate:(id<MBCountDownButtonDelegate>)delegate {
    [MBCountDownButton share].delegate = delegate;
}

+ (instancetype)playWithImages:(NSArray *)images begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success {
    return [self playWithImages:images duration:images.count begin:begin success:success];
}

+ (instancetype)playWithImages:(NSArray *)images duration:(NSTimeInterval)duration begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success {
    MBCountDownButton *countDownButton = [MBCountDownButton share];
    countDownButton.countdownBeginBlock = begin;
    countDownButton.countdownSuccessBlock = success;
    countDownButton.countDownType = MBCountDownTypeImage;
    countDownButton.images = [NSMutableArray arrayWithArray:images];
    [self setupButtonBase:countDownButton];
    [self scaleActionWithBeginBlock:begin andSuccessBlock:success button:countDownButton];
    return countDownButton;
}
/// 这个方法是拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到，相信很多项目会用到。拿去不谢！
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

// 拿到当前显示的控制器的View。不建议直接放到window上，这样的话，如果倒计时不结束视图就跳转，倒计时不会停止移除
- (UIView *)getCurrentView {
    return [self getVisibleViewControllerFrom:(UIViewController *)WZBAppDelegate.window.rootViewController].view;
}

@end

//
//  MBVerigiyButton.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVerigiyButton.h"

@interface MBVerigiyButton (){
    NSInteger   _count;
    NSTimer     *_timer;
}


- (void)setupVerifyBtn;
- (void)refresh:(NSTimer *)timer;
- (void)updateDynamicTitle;

@end

@implementation MBVerigiyButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupVerifyBtn];
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    return [[self alloc]init];
}
+ (instancetype)new {
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupVerifyBtn];
    }
    return self;
}
- (BOOL)isRunning {
    return [_timer isValid];
}
- (void)countingSeconds:(NSInteger)seconds {
    _count = seconds;
    
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    self.enabled = NO;
    _count--;
    [self updateDynamicTitle];
}
#pragma mark--overwrite---
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (![[self titleForState:UIControlStateNormal] isEqualToString:@"重新发送"]) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitle:@"获取验证码" forState:UIControlStateDisabled];
    }
}

#pragma mark - private method
- (void)setupVerifyBtn {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (void)updateDynamicTitle {
    NSString *title = [NSString stringWithFormat:@"%ds", (int)_count]; // 获取验证码
    [UIView setAnimationsEnabled:NO];
    [self setTitle:title forState:UIControlStateDisabled];
    [UIView setAnimationsEnabled:YES];
}


- (void)refresh:(NSTimer *)timer
{
    if(--_count > 0) {
        [self updateDynamicTitle];
    } else {
        [_timer invalidate];
        _timer = nil;
        self.enabled = YES;
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}
@end

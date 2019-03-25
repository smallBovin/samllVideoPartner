//
//  MBRecordProgressView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBRecordProgressView.h"

#define kPadding 10     //  最小刻度之间的宽度，像素
#define kMinScale 1    //  最小刻度值


@interface MBRecordProgressView ()<UIScrollViewDelegate>

/** 记录时间的label*/
@property (nonatomic, strong) UILabel * timeLabel;
/** 存放录音声音的振幅数组*/
@property (nonatomic, strong) NSMutableArray * recorderLevels;
/** 刻度条与音波条*/
@property (nonatomic, strong) UIScrollView * scrollView;
/** 开始的指引线*/
@property (nonatomic, strong) UIView * markLine;

@property (nonatomic, assign) CGFloat scrollWidth;

/** 记录上一次画图是指引线的frame*/
@property (nonatomic, assign) CGRect  lastFrame;

@end

@implementation MBRecordProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#1C2131"];
        [self addSubview:self.timeLabel];
        [self resetProgressView];
    }
    return self;
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

- (void)setMaxValue:(float)maxValue {
    _maxValue = maxValue;
    [self createTimeRule];
}

- (void)createTimeRule {
    for (NSUInteger i = 0, j = 0; i <= self.maxValue; i+=kMinScale, j++) {
        _scrollWidth += kPadding;
        [self drawSegmentWithValue:i idx:j];
    }
    self.scrollView.contentSize = CGSizeMake(_scrollWidth+kPadding, CGRectGetHeight(self.scrollView.frame));
    self.markLine.frame = CGRectMake(kPadding*2, 40, 1, CGRectGetHeight(self.scrollView.frame)-40);
    self.lastFrame = self.markLine.frame;
}
- (void)drawSegmentWithValue:(NSUInteger)value idx:(NSUInteger)idx {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat x = kPadding*2 + kPadding*idx;
    [path moveToPoint:CGPointMake(x, 20)];
    
    if (value % (kMinScale*10) == 0 || value == 0) { //每10个刻度，处理时间显示
        [path addLineToPoint:CGPointMake(x, 40)];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(x-40*0.5, 0, 40, 15)];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor colorWithHexString:@"#A4A4A4"];
        if (value<100) {
            numLabel.text = [NSString stringWithFormat:@"00:0%ld", value/10];
        }else if (value == 600) {
            numLabel.text = [NSString stringWithFormat:@"01:00"];
        }else {
            numLabel.text = [NSString stringWithFormat:@"00:%ld", value/10];
        }
        [self.scrollView addSubview:numLabel];
    }else if (value % (kMinScale*5) == 0) {
        [path addLineToPoint:CGPointMake(x, 40)];
    }else{
        [path addLineToPoint:CGPointMake(x, 30)];
    }
    
    CAShapeLayer *line = [[CAShapeLayer alloc] init];
    line.lineWidth = 1;
    line.strokeColor = [UIColor colorWithHexString:@"#A4A4A4"].CGColor;
    line.path = path.CGPath;
    
    [self.scrollView.layer addSublayer:line];
}

- (void)resetProgressView {
    [self.recorderLevels removeAllObjects];
    
    self.timeLabel.text = @"00:00:00";
    self.scrollView.contentOffset = CGPointZero;
    [self.markLine removeFromSuperview];
    self.markLine = nil;
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.markLine];
    
    if ([MBUserManager manager].isVip) {
        self.maxValue = 600;
    }else {
        self.maxValue = 150;
    }
    self.markLine.frame = CGRectMake(kPadding*2, 40, 1, CGRectGetHeight(self.scrollView.frame)-40);
    self.lastFrame = self.markLine.frame;
}

- (void)addRecorderLevels:(NSNumber *)value {
    [self.recorderLevels addObject:value];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (self.recorderLevels.count>0) {
        float level = [[self.recorderLevels lastObject] floatValue];
        NSLog(@"current level  %f",level);
        CGFloat sampleHeight = level * self.markLine.frame.size.height;
        
        self.markLine.frame = CGRectMake(_lastFrame.origin.x+kPadding/2, _lastFrame.origin.y, _lastFrame.size.width, _lastFrame.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(_lastFrame.origin.x, (self.markLine.frame.size.height-sampleHeight)/2+_lastFrame.origin.y, 1, sampleHeight)];
        CAShapeLayer *line = [[CAShapeLayer alloc] init];
        line.lineWidth = 1;
        line.strokeColor = [UIColor colorWithHexString:@"#C82F2F"].CGColor;
        line.path = path.CGPath;
        [self.scrollView.layer addSublayer:line];
        self.lastFrame = self.markLine.frame;
        if (self.markLine.center.x>=SCREEN_WIDTH/2) {
            CGFloat offsetX = self.scrollView.contentOffset.x;
            self.scrollView.contentOffset = CGPointMake(offsetX+kPadding/2, 0);
        }
    }
}


#pragma mark--lazy------
/** 录音时间计时*/
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2, 5, 100, 20)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}
/** 录音的声音振幅大小*/
- (NSMutableArray *)recorderLevels {
    if (!_recorderLevels) {
        _recorderLevels = [NSMutableArray array];
    }
    return _recorderLevels;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, CGRectGetHeight(self.frame)-30)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)markLine {
    if (!_markLine) {
        _markLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, 40, 1, CGRectGetHeight(self.scrollView.frame)-40)];
        _markLine.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    }
    return _markLine;
}
@end

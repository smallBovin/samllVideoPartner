//
//  MBBottomStyleHandlerView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBSelectButtonType) {
    MBSelectButtonTypeStyle,        //风格
    MBSelectButtonTypeFont,         //文字
    MBSelectButtonTypeMaps,         //贴图
    MBSelectButtonTypeMusic,        //音乐
    MBSelectButtonTypeBackground,   //背景
};

@protocol MBBottomStyleHandlerViewDelegate <NSObject>

- (void)bottomStyleHandlerViewButtonType:(MBSelectButtonType)buttonType;

@end

@interface MBBottomStyleHandlerView : UIView

/** 代理*/
@property (nonatomic, weak) id<MBBottomStyleHandlerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

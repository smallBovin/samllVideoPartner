//
//  MBRateSettingView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/16.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBSelectVideoRateComplement)(NSString *rate);

@interface MBRateSettingView : UIView

/** 选择播放速度*/
@property (nonatomic, copy) MBSelectVideoRateComplement  complement;


@end

NS_ASSUME_NONNULL_END

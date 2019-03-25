//
//  MBVerigiyButton.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBVerigiyButton : UIButton

@property (nonatomic, readonly) BOOL isRunning;

- (void)countingSeconds:(NSInteger)seconds;
@end

NS_ASSUME_NONNULL_END

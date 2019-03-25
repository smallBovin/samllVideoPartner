//
//  MBTools.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/23.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBTools : NSObject

+ (unsigned long long)getFileSizeWithPath:(NSString *)filePath;

+ (void)clearAllChcheDataCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END

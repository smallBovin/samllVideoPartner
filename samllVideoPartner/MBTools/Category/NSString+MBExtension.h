//
//  NSString+MBExtension.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/19.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MBExtension)

+ (NSString *)getDocumentPath;

+ (NSString *)randomKey;

- (NSString *)MD5String;

+ (NSString *)timestamp;

+ (BOOL)checkIsMobilePhone:(NSString *)mobile;

+ (BOOL)isContainsEmoji:(NSString *)string;

- (NSString *)filterWithoutEmoji;

- (NSString *)replaceEmojiByString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

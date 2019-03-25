//
//  MBURLSessionManager.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBURLSessionManager : NSObject

+ (instancetype)shareManager;



- (AFHTTPSessionManager *)createSessionManagerWithUrlString:(NSString *)urlString;

- (BOOL)requestTaskIsExist;

- (void)addToRequestManagerTool;

- (void)deleteFromRequestManagerTool;

@end

NS_ASSUME_NONNULL_END

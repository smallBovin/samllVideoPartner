//
//  RequestUtil.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface RequestUtil : NSObject

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


/** 上传*/
+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


+ (void)downloadFileWithRequestUrl:(NSString *)url
                  downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                           success:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath))success
                           failure:(nullable void (^)(NSURLResponse * _Nonnull response, NSError * _Nullable error))failure;
+ (void)downloadFontWithRequestUrl:(NSString *)url
                  downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                           success:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath))success
                           failure:(nullable void (^)(NSURLResponse * _Nonnull response, NSError * _Nullable error))failure;
@end

NS_ASSUME_NONNULL_END

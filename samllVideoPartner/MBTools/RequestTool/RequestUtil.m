//
//  RequestUtil.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "RequestUtil.h"
#import "MBAppEnviromentConfig.h"
#import "MBURLSessionManager.h"

@interface RequestUtil ()


@end

@implementation RequestUtil

+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    if (![Reachability reachabilityForInternetConnection].isReachable) {
        [MBProgressHUD showOnlyTextMessage:@"网络连接异常"];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[[MBAppEnviromentConfig shareConfig]currentServiceHostUrl],URLString];
    NSLog(@"Get==  %@",url);
    AFHTTPSessionManager *manager = [[MBURLSessionManager shareManager]createSessionManagerWithUrlString:URLString];
    if (nil == parameters) {
        parameters = [NSDictionary dictionary];
    }
    NSURLSessionDataTask *task = [manager GET:url parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"URLString API %@ response info %@== ",URLString,responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URLString API %@ error info %@== ",URLString,error.debugDescription);
        if (failure) {
            failure(task,error);
        }
    }];
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    if (![Reachability reachabilityForInternetConnection].isReachable) {
        [MBProgressHUD showOnlyTextMessage:@"网络连接异常"];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[[MBAppEnviromentConfig shareConfig]currentServiceHostUrl],URLString];
    NSLog(@"POST==  %@",url);
    if (nil == parameters) {
        parameters = [NSDictionary dictionary];
    }
    AFHTTPSessionManager *manager = [[MBURLSessionManager shareManager]createSessionManagerWithUrlString:url];
    NSURLSessionDataTask *task = [manager POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URLString API %@ response info %@== ",URLString,responseObject);
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URLString API %@ error info %@== ",URLString,error.debugDescription);
        if (failure) {
            failure(task,error);
        }
    }];
    return task;
}

+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    if (![Reachability reachabilityForInternetConnection].isReachable) {
        [MBProgressHUD showOnlyTextMessage:@"网络连接异常"];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[[MBAppEnviromentConfig shareConfig]currentServiceHostUrl],URLString];
    NSLog(@"UPload==  %@",url);
    if (nil == parameters) {
        parameters = [NSDictionary dictionary];
    }
    AFHTTPSessionManager *manager = [[MBURLSessionManager shareManager]createSessionManagerWithUrlString:URLString];
    NSURLSessionDataTask *task = [manager POST:url parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URLString API %@ response info %@== ",URLString,responseObject);
        if (success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URLString API %@ error info %@== ",URLString,error.debugDescription);
        if (failure) {
            failure(task,error);
        }
    }];
    return task;
}

+ (void)downloadFileWithRequestUrl:(NSString *)url downloadProgress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath))success failure:(void (^)(NSURLResponse * _Nonnull response, NSError * _Nullable error))failure {
    
    NSString *extension = url.pathExtension;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURL *downloadUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadUrl];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *savePath = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [savePath URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[url MD5String],extension]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (response && filePath) {
            if (success) {
                success(response,filePath);
            }
        }else {
            if (failure) {
                failure(response,error);
            }
        }
    }];
    [task resume];
}

//下载字体
+ (void)downloadFontWithRequestUrl:(NSString *)url downloadProgress:(void (^)(NSProgress * _Nonnull))progress success:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath))success failure:(void (^)(NSURLResponse * _Nonnull response, NSError * _Nullable error))failure {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURL *downloadUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadUrl];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *savePath = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [savePath URLByAppendingPathComponent:[url lastPathComponent]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (response && filePath) {
            if (success) {
                success(response,filePath);
            }
        }else {
            if (failure) {
                failure(response,error);
            }
        }
    }];
    [task resume];
}


@end

//
//  MBTools.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/23.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBTools.h"

@implementation MBTools

+ (unsigned long long)getFileSizeWithPath:(NSString *)filePath {
    //注释 ios的文件大小以1000为单位,不是以1024作为单位.
    unsigned long long folderSize = 0 ;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //文件是否存在
    BOOL isExist;
    //是否文件夹
    BOOL isFolder;
    isExist  = [fileManager fileExistsAtPath:filePath isDirectory:&isFolder ];
    if (!isExist) {
        return 0;
    }
    if (isFolder) {
        //是文件夹
        NSEnumerator * childFileEnumerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
        NSString * fileName;
        while ((fileName = [childFileEnumerator nextObject]) != nil) {
            NSString * fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
            folderSize += [[fileManager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
            NSLog(@"%@",fileAbsolutePath);
        }
    }else{ //不是文件夹
        folderSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    NSLog(@"%.2llu",folderSize);
    return folderSize;
}

+ (void)clearAllChcheDataCompletion:(void (^)(void))completion {
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    if (completion) {
        completion();
    }
}

@end

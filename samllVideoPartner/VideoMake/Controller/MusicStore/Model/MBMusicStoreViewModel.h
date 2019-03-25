//
//  MBMusicStoreViewModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/28.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBMapsModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^MBDirectChooseMusicComplete)(NSURL *totalAudioPath,MBMapsModel *model);
typedef void(^MBUseCropMusicBlock)(NSString *cropPath,MBMapsModel *model);

@interface MBMusicStoreViewModel : NSObject

/** 直接使用*/
@property (nonatomic, copy) MBDirectChooseMusicComplete  directBlock;
/** 剪辑过*/
@property (nonatomic, copy) MBUseCropMusicBlock  cropBlock;

SINGLETON_INTERFACE(Instance)
/** 注册ViewModel*/
- (void)registerViewModelToController:(UIViewController *)controller;
/** 当前可见的tableview*/
- (void)currentVisiableTableView:(UITableView *)tableView;
/**
 点击试听处理
 @param tableView 当前试听音乐类型的tableview
 @param model 当前音乐的model
 */
- (void)downloadMusicTableView:(UITableView *)tableView withModel:(MBMapsModel *)model;

- (void)hideMusicAuditionView;

@end

NS_ASSUME_NONNULL_END

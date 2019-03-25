//
//  MBVideoEdittingViewModel.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBStyleTemplateModel,MBMusicTypeModel,MBMapsModel;

NS_ASSUME_NONNULL_BEGIN

@interface MBVideoEdittingViewModel : NSObject

- (void)getStyleTemplateDataComplement:(void(^)(NSMutableArray<MBStyleTemplateModel *> * _Nullable array))complement;

- (void)getMapsTemplateDataComplement:(void(^)(NSMutableArray<MBMapsModel *> *_Nullable array))complement;

- (void)getMusicTypeDataComplement:(void(^)(NSMutableArray<MBMusicTypeModel *> *_Nullable array))complement;

@end

NS_ASSUME_NONNULL_END

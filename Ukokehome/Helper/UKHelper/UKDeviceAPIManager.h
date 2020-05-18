//
//  UKDeviceAPIManager.h
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKDeviceAPIManager : NSObject
//获取设备信息
+ (void)getDeviceWithModel:(UKDeviceModel *)model success:(void (^)(UKDeviceModel *model)) success failure:(void(^)(NSString *error)) failure;

//设置设备状态
+ (void)setDeviceWithKey:(NSString *) key andValue:(NSString *) value withModel:(UKDeviceModel *)model success:(void (^)(UKDeviceModel *model)) success failure:(void(^)(NSString *error)) failure;

@end

NS_ASSUME_NONNULL_END

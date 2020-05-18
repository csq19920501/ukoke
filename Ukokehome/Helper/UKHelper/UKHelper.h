//
//  UKHelper.h
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLAnimatedImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface UKHelper : NSObject

+ (FLAnimatedImage *)getGifImageByName:(NSString *)name;

+ (NSString *)timeIntByDateString:(NSString *)dateString;

+ (NSString *)getDeviceClassByModel:(UKDeviceModel *)model;

+ (BOOL)judgePassWordLegal:(NSString *)pass;

+ (BOOL)judgeNumText:(NSString *)str;

//是否是国际手机号
+ (BOOL)judgePhoneNum:(NSString *)str;
    
+ (BOOL)judgeEmailLegal:(NSString *)email;

+ (NSString *)timeByDateString:(NSString *)dateString;

+ (void)storeUserInfoByDic:(NSDictionary *) responseObject;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;
@end

NS_ASSUME_NONNULL_END

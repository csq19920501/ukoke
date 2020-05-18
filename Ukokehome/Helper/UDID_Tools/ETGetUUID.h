//
//  ETGetUUID.h
//  EthomeHD
//
//  Created by ethome on 2017/6/23.
//  Copyright © 2017年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETGetUUID : NSObject

+ (NSString *)getDeviceId;

+ (void)setPhone:(NSString *)phone;

+ (NSString *)getPhone;

+ (void)setPwd:(NSString *)pwd;

+ (NSString *)getPwd;

+ (void)cleanPhoneAndPwd;

@end

//
//  ETGetUUID.m
//  EthomeHD
//
//  Created by ethome on 2017/6/23.
//  Copyright © 2017年 ethome. All rights reserved.
//

#import "ETGetUUID.h"
#import "SAMKeychain.h"

@implementation ETGetUUID

+ (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.ethome.EthomeHD"account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@"com.ethome.EthomeHD"account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

+ (void)setPhone:(NSString *)phone{
    
    [SAMKeychain setPassword:phone forService:@"phoneNum"account:@"phone"];
    
}

+ (NSString *)getPhone{
    
    return [SAMKeychain passwordForService:@"phoneNum"account:@"phone"];
    
}

+ (void)setPwd:(NSString *)pwd{
    
    [SAMKeychain setPassword:pwd forService:@"password"account:@"pwd"];
    
}

+ (NSString *)getPwd{
    
    return [SAMKeychain passwordForService:@"password"account:@"pwd"];
    
}

+ (void)cleanPhoneAndPwd{
    
    [SAMKeychain setPassword:@"" forService:@"phoneNum"account:@"phone"];
    
    [SAMKeychain setPassword:@"" forService:@"password"account:@"pwd"];
    
}

@end

//
//  NSString+DeviceType.m
//  Ukokehome
//
//  Created by ethome on 2018/12/12.
//  Copyright © 2018 ethome. All rights reserved.
//

#import "NSString+DeviceType.h"

@implementation NSString (DeviceType)

//AirConditioner
- (BOOL)isAirConditioner{
    
    if ([self hasPrefix:@"038"]) {
        
        return YES;
    }
    
    return NO;
}

//WaterFilter
- (BOOL)isWaterFilter{
    
    if ([self hasPrefix:@"039"]) {
        
        return YES;
    }
    
    return NO;
}
@end

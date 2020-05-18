//
//  NSString+DeviceType.h
//  Ukokehome
//
//  Created by ethome on 2018/12/12.
//  Copyright © 2018 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DeviceType)

//AirConditioner
- (BOOL)isAirConditioner;
//WaterFilter
- (BOOL)isWaterFilter;

@end

NS_ASSUME_NONNULL_END

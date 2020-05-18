//
//  UKBaseDeviceViewController.h
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKBaseDeviceViewController : UIViewController

@property (nonatomic, strong) UKDeviceModel *model;

@property (nonatomic, assign) BOOL isFromHome;

@property (nonatomic, assign) BOOL isPaning;

- (void)setDeviceKey:(NSString *)key andValue:(NSString *) value;

- (void)gotoSetting;



@end

NS_ASSUME_NONNULL_END

 //
//  AppDelegate.h
//  Ukokehome
//
//  Created by ethome on 2018/9/25.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic,assign)BOOL hasNewOne;
@property (nonatomic,assign)BOOL hasNew;
@end


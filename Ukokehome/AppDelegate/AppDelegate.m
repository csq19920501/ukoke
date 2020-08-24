//
//  AppDelegate.m
//  Ukokehome
//
//  Created by ethome on 2018/9/25.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "JDStatusBarNotification.h"
#import <ShareSDK/ShareSDK.h>
#import <Bugly/Bugly.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <TwitterKit/TWTRKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger zone = [systemTimeZone secondsFromGMT]/60/60;
//    NSLog(@"systemTimeZone.name = %@",systemTimeZone.name);
//    NSLog(@"zone = %@",@(zone));
//    NSLog(@"zone = %ld",(long)zone);
    
    [NSThread sleepForTimeInterval:2];
    
    [self configureKeyboardManager];
    
    [self setRootWindow];
    
    [Bugly startWithAppId:BuglyAppID];

    [ETLMKSOCKETMANAGER connectSocket];
    
    [self checkNetIsContented];
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupFacebookWithAppkey:FacebookKey appSecret:FacebookSecret displayName:@"Ukoke"];
        
        [platformsRegister setupTwitterWithKey:TwitterKey secret:TwitterSecret redirectUrl:@"https://ukoke.com/"];
        
        [platformsRegister setupGooglePlusByClientID:GoogleKey clientSecret:@"" redirectUrl:@"http://localhost"];
        
        [platformsRegister setupInstagramWithClientId:InstagramKey clientSecret:InstagramSecret redirectUrl:@"https://ukoke.com/"];
//        [platformsRegister setupTwitterWithKey:TwitterKey secret:TwitterSecret redirectUrl:@"https://ukoke.com/"];
    }];

    
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
   
    [GIDSignIn sharedInstance].clientID = GoogleKey;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [FBSDKSettings setAppID:FacebookKey];
    
    [[Twitter sharedInstance] startWithConsumerKey:TwitterKey consumerSecret:TwitterSecret];
   
    return YES;
}

- (void)setRootWindow{
    
    if (![GlobalKit shareKit].token) {
        
        UINavigationController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
        
        [self.window setRootViewController:loginVC];
        
    }else{
        
        UITabBarController *homeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]  instantiateViewControllerWithIdentifier:@"UKHomeTabBarController"];
        
        [self.window setRootViewController:homeVC];
    }
    
    [self.window makeKeyAndVisible];
}

//键盘设置
- (void)configureKeyboardManager
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

-(void)checkNetIsContented
{
    
    [ETAFNetworking setLMK_ReachabilityStatusChangeBlock:^(ReachabilityStatus status) {
        
        if (status == ReachabilityStatusNotReachable) {
            
            [ETLMKSOCKETMANAGER disconnectSocket];
            
        }else{
            
            if (ETLMKSOCKETMANAGER.connectState == LMKConnectStateDisConnected && [UIApplication sharedApplication].applicationState !=UIApplicationStateBackground) {
                
                [ETLMKSOCKETMANAGER connectSocket];
            }
        }
    }];
    
}



/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//
    
    NSUInteger len = [deviceToken length];
    char *chars = (char*)[deviceToken bytes];
    NSMutableString * hexString = [[NSMutableString alloc]init];
    for(NSUInteger i = 0; i<len;i++){
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", hexString);
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:hexString];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    
    if (clientId) {
        [GlobalKit shareKit].clientId = clientId;
    }
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    NSDictionary *userInfo = nil;

    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        userInfo = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];

    }
    
    UKMessageModel *model = [[UKMessageModel alloc] init];
    
    [model setValuesForKeysWithDictionary:userInfo];
        
    model.userId = [GlobalKit shareKit].userId;
    
    model.createDate = [UKHelper timeIntByDateString:model.createDate];
    
    NSString *otherInfo = model.otherInfo;
    if (otherInfo && [otherInfo containsString:@"login invalid"])
    {
        if (![GlobalKit shareKit].isInLogin) {
            
            [[GlobalKit shareKit] clearSession];
            
            [ETLMKSOCKETMANAGER disconnected];
            
            UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
            controller.modalPresentationStyle = 0;
            [[UKHelper getCurrentVC] presentViewController:controller animated:YES completion:nil];
        }
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState ==UIApplicationStateBackground) {
        
        [JDStatusBarNotification showWithStatus:model.messageInfo dismissAfter:2.0 styleName:@"style"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageNotification" object:nil userInfo:userInfo];
        
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

- (void)HandlerRemoteNotification:(NSDictionary *)launchOptions
{
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        //        //角标清0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    
    
    NSString *urlStr = url.absoluteString;
    if([urlStr containsString:@"google"]){
        return [[GIDSignIn sharedInstance] handleURL:url];
    }
    else if([urlStr containsString:@"twitter"] || [urlStr containsString:@"Twitter"])
    {
        
        return [[Twitter sharedInstance] application:app openURL:url options:options];
    }
    else if([urlStr containsString:@"fb"])
    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        return handled;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [ETLMKSOCKETMANAGER disconnectSocket];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [ETLMKSOCKETMANAGER connectSocket];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

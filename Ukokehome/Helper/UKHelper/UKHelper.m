//
//  UKHelper.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKHelper.h"
#import "UIImage+GIF.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberUtil.h"

@implementation UKHelper

+ (FLAnimatedImage *)getGifImageByName:(NSString *)name{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    return animatedImage;
}

+ (NSString *)timeIntByDateString:(NSString *)dateString
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss 'UTC' yyyy"];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate *formatterDate = [inputFormatter dateFromString:dateString];
    NSTimeInterval time = formatterDate.timeIntervalSince1970;
    
    NSString *newDateString = [NSString stringWithFormat:@"%f",time];
    return newDateString;
}

+ (NSString *)getDeviceClassByModel:(UKDeviceModel *)model{
    
    NSString *typeId = model.actualDeviceTypeId;
    
    NSString *deviceTypeId = [typeId substringToIndex:3];
    
    NSDictionary *classDic = @{@"038":@"UKACViewController",@"039":@"UKFilterViewController"};
    
    return classDic[deviceTypeId];
}


+ (BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result ;
    
    // 判断长度大于6位后再接着判断是否同时包含数字和大小写字母(可包含特殊字符)
    
    NSString * regex =@"^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])[~`!@#$%^&*()_+0-9A-Za-z]{6,}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:pass];
    
    return result;

}

//是否是纯数字
+ (BOOL)judgeNumText:(NSString *)str{
    
    BOOL result ;

    NSString * regex = @"[0-9]*";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:str];
    
    return result;
}

//是否是国际手机号
+ (BOOL)judgePhoneNum:(NSString *)str{
    
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSError *error = nil;
    NBPhoneNumber *phoneNumberUS =
    [phoneUtil parse:str defaultRegion:@"US" error:&error];
    
    return [phoneUtil isValidNumber:phoneNumberUS];
}

+ (BOOL)judgeEmailLegal:(NSString *)email{
    
    BOOL result ;
    
    NSString * regex =@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    result = [pred evaluateWithObject:email];
    
    return result;
    
}

+ (NSString *)timeByDateString:(NSString *)dateString
{
    NSDate *formatterDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:formatterDate];
    return newDateString;
}


+ (void)storeUserInfoByDic:(NSDictionary *) responseObject{
    
    [GlobalKit shareKit].token = responseObject[@"token"]?responseObject[@"token"]:[GlobalKit shareKit].token;
    
    [GlobalKit shareKit].passport = responseObject[@"passport"]?responseObject[@"passport"]:[GlobalKit shareKit].passport;
    
    [GlobalKit shareKit].userName = responseObject[@"userName"]?responseObject[@"userName"]:[GlobalKit shareKit].userName;
    
    [GlobalKit shareKit].userId = responseObject[@"id"]?responseObject[@"id"]:[GlobalKit shareKit].userId;
    
    [GlobalKit shareKit].email = responseObject[@"email"]?responseObject[@"email"]:[GlobalKit shareKit].email;
    
    [GlobalKit shareKit].phoneNumber = responseObject[@"phoneNum"]?responseObject[@"phoneNum"]:[GlobalKit shareKit].phoneNumber;
    
    [GlobalKit shareKit].address = responseObject[@"address"]?responseObject[@"address"]:[GlobalKit shareKit].address;
    
    if (responseObject[@"birthday"]) {
        NSTimeInterval tempMilli =[responseObject[@"birthday"] longLongValue];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempMilli/1000.0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle  = NSDateFormatterMediumStyle;
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *birthdayStr = [dateFormatter stringFromDate:confromTimesp];
        
        [GlobalKit shareKit].birthday = birthdayStr;

    }else{
        
        [GlobalKit shareKit].birthday = nil;
    }

    [GlobalKit shareKit].loginType = responseObject[@"loginType"]?responseObject[@"loginType"]:[GlobalKit shareKit].loginType;

    [GlobalKit shareKit].gender = responseObject[@"gender"]?responseObject[@"gender"]:[GlobalKit shareKit].gender;
    
    [GlobalKit shareKit].devicePush = responseObject[@"userSet"][@"devicePush"]?responseObject[@"userSet"][@"devicePush"]:[GlobalKit shareKit].devicePush;

    [GlobalKit shareKit].dnd = responseObject[@"userSet"][@"dnd"]?responseObject[@"userSet"][@"dnd"]:[GlobalKit shareKit].dnd;

    [GlobalKit shareKit].emailPush = responseObject[@"userSet"][@"email"]?responseObject[@"userSet"][@"email"]:[GlobalKit shareKit].emailPush;

    [GlobalKit shareKit].storeMsg = responseObject[@"userSet"][@"storeMsg"]?responseObject[@"userSet"][@"storeMsg"]:[GlobalKit shareKit].storeMsg;
    
    [GlobalKit shareKit].homeName = responseObject[@"userSet"][@"homeName"]?responseObject[@"userSet"][@"homeName"]:[GlobalKit shareKit].homeName;

    [GlobalKit shareKit].region = responseObject[@"userSet"][@"region"]?responseObject[@"userSet"][@"region"]:[GlobalKit shareKit].region;

    [GlobalKit shareKit].sms = responseObject[@"userSet"][@"sms"]?responseObject[@"userSet"][@"sms"]:[GlobalKit shareKit].sms;

    [GlobalKit shareKit].push = responseObject[@"userSet"][@"push"]?responseObject[@"userSet"][@"push"]:[GlobalKit shareKit].push;

    [GlobalKit shareKit].dndStart = responseObject[@"userSet"][@"dndStart"]?responseObject[@"userSet"][@"dndStart"]:[GlobalKit shareKit].dndStart;
    
    [GlobalKit shareKit].dndEnd = responseObject[@"userSet"][@"dndEnd"]?responseObject[@"userSet"][@"dndEnd"]:[GlobalKit shareKit].dndEnd;

}

//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentVC{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController* currentViewController = window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication].delegate window];
//    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    id  nextResponder = nil;
//    UIViewController *appRootVC=window.rootViewController;
//    //    如果是present上来的appRootVC.presentedViewController 不为nil
//    if (appRootVC.presentedViewController) {
//        //多层present
//        while (appRootVC.presentedViewController) {
//            appRootVC = appRootVC.presentedViewController;
//            if (appRootVC) {
//                nextResponder = appRootVC;
//            }else{
//                break;
//            }
//        }
//        //        nextResponder = appRootVC.presentedViewController;
//    }else{
//
//        // 如果当前UIViewController顶层不是UIView，那就需要循环获取到该UIViewController对应的UIView，
//        // 才能跳出循环
//        int i= 0;
//        UIView *frontView = [[window subviews] objectAtIndex:i];
//        nextResponder = [frontView nextResponder];
//        while (![nextResponder isKindOfClass:[UIViewController class]]) {
//            i++;
//            if([window subviews].count > i){
//            frontView = [[window subviews]objectAtIndex:i];
//            nextResponder = [frontView nextResponder];
//            }
//        }
//
//
//
//    }
//
//    if ([nextResponder isKindOfClass:[UITabBarController class]]){
//        UITabBarController * tabbar = (UITabBarController *)nextResponder;
//        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
//        result=nav.childViewControllers.lastObject;
//
//    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
//        UIViewController * nav = (UIViewController *)nextResponder;
//        result = nav.childViewControllers.lastObject;
//    }else{
//        result = nextResponder;
//    }
//    return result;
}

@end

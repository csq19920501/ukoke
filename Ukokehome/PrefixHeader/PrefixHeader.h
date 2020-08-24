//
//  PrefixHeader.h
//  Ukokehome
//
//  Created by ethome on 2018/9/25.
//  Copyright © 2018年 ethome. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h
#ifdef  __OBJC__

#import "YYLRefreshRequestErrorView.h"
#import "YYLRefreshNoNetworkView.h"
#import "YYLRefreshNoDataView.h"
#import "UIScrollView+Refresh.h"
#import "GlobalKit.h"
#import "AFNetworking.h"
#import "ETAFNetworking.h"
#import "HUD.h"
#import "UKAPIList.h"
#import "ETLMKSocketManager.h"
#import "NSString+CC.h"
#import "AppDelegate.h"
#import <MJExtension/MJExtension.h>
#import "ETGetUUID.h"
#import "UKDeviceModel.h"
#import "UKMessageModel.h"
#import "UKDeviceAPIManager.h"
#import "UKBaseDeviceViewController.h"
#import "UKHelper.h"
#import "WZLBadgeImport.h"
#import "NSString+DeviceType.h"
#import "UITextField+HYBPlaceHolder.h"
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define LBXScan_Define_ZXing   //包含ZXing库
#define LBXScan_Define_UI     //包含界面库
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define ISIPHONE 4
#define ISIPHONEX (SCREEN_HEIGHT >= 812.0f) ? YES : NO
#define NETERROR @"Net Error"

// buglyKey
#define BuglyAppID @"dfff75e6f2"

////测试服务器
//#define SERVER TESTSERVER
//#define HOST @"47.110.33.242"
//#define PORT 16166
//
//#define APP_KEY @"2CB602D60C06AE2C1CE503A6B31CF1AC"
//#define APP_SECRET @"m4w0bfzj02368jf3oqpfvy4hmfw4wyy8"
//
//// 测试个推信息
//#define kGtAppId           @"CKwKeutASr91aiiCmZOns7"
//#define kGtAppKey          @"X00MhPYdgT8ezUE3iW49j3"
//#define kGtAppSecret       @"C5Pqvbp2Ar9OQLfhd9KCu5"
//
//// 测试三方登录需要的key
//#define FacebookKey @"2007022789589683"
//#define FacebookSecret @"fe0536217f340053c2bcee0ed8c810ff"
//#define GoogleKey @"830075960333-ljgin8ijvp1vsn65jo0npgcfphbfpaom.apps.googleusercontent.com"
//#define InstagramKey @"fb30212dd6e449899a3e85aad706502d"
//#define InstagramSecret @"f5672972213b4488aec1663529da1f4d"
//#define TwitterKey @"iNE2KccfBYwWiZu9vDBkVmbPe"
//#define TwitterSecret @"Qvlfech11ZgOOephjDbzjXpGOw6DUYQOlOt8RQRuwswGO1RhW4"

//正式服务器
#define SERVER ONLINESERVER
#define HOST @"18.144.54.219"
#define PORT 16166
#define Socket @"ukpush.wifizg.com"

#define APP_KEY @"EA41E377D8AEA07FE435E2A77FD1E84B"
#define APP_SECRET @"znj9xiwmy28628462jklygq65uoxih1i"

// 正式个推信息
#define kGtAppId           @"CeUeDo0b1sAHQVpbjLq7B8"
#define kGtAppKey          @"26HMhSBeL87h3BIkXQDi05"
#define kGtAppSecret       @"DHtBi1g36qAuIO6ddskXJ"

// 正式三方登录需要的key
#define FacebookKey @"577612059338261"
#define FacebookSecret @"3648c2588bba2562392e2850ece81bbd"
#define GoogleKey @"792739011441-qep9n7lupttao5sfinvolrk4ijgur8p6.apps.googleusercontent.com"
//#define InstagramKey @"590614245226079"
//#define InstagramSecret @"a4cd5b86f5bce7654babd5e7d5f70b87"
#define InstagramKey @"154ba017b84b4c92af207e4962a9dd59"
#define InstagramSecret @"97b8f319bb2c4fc491c97a8158fba5a5"

#define TwitterKey @"iNE2KccfBYwWiZu9vDBkVmbPe"
#define TwitterSecret @"Qvlfech11ZgOOephjDbzjXpGOw6DUYQOlOt8RQRuwswGO1RhW4"


//服务器地址
#define LOCALSERVER_WANG @"http://192.168.17.177"
#define TESTSERVER @"http://47.110.33.242:8181"
#define ONLINESERVER @"https://ukoke.wifizg.com/"

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#endif

#endif /* PrefixHeader_h */


//
//  UKEnteWiFiViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKEnteWiFiViewController.h"
#import "UKConnectDeviceViewController.h"
#import "EasyLink.h"
#import <CoreLocation/CoreLocation.h>
//#import <SystemConfiguration/CaptiveNetwork.h>

@interface UKEnteWiFiViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) CLLocationManager *locationMagager;
@end

@implementation UKEnteWiFiViewController

#pragma--mark   csq Fit ios13

//- (CLLocationManager *)locationMagager {
//    if (!_locationMagager) {
//        _locationMagager = [[CLLocationManager alloc] init];
//        _locationMagager.delegate = self;
//    }
//    return _locationMagager;
//}
-(void)addText:(NSString*)text{
    self.textView.text = [NSString stringWithFormat:@"%@\n%@\n",self.textView.text,text];
    
    [self.textView scrollRectToVisible:CGRectMake(0, self.textView.contentSize.height-15, self.textView.contentSize.width, 10) animated:YES];
}
-(void)setWiFiName{
    if (@available(iOS 13, *)) {
        
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {//开启了权限，直接搜索
            NSLog(@"setWiFiName_权限ok");
            [self addText:@"已经获取定位权限 kCLAuthorizationStatusAuthorizedWhenInUse"];
            _ssidTextField.text = [self ssidForConnectedNetwork];
            
        } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {//如果用户没给权限，则提示
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Remind"
                                                                           message:@"Location permission has not been opened, please go to the Settings page to get SSID"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"I Know" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     //响应事件
                                                                     NSLog(@"action = %@", action);
                                                                 }];
            
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            _ssidTextField.text = @"";
            
            [self addText:@"已经拒绝定位权限 kCLAuthorizationStatusDenied"];
            NSLog(@"setWiFiName权限no");
        } else {//请求权限
            NSLog(@"setWiFiName请求权限");
            [_locationMagager requestWhenInUseAuthorization];
             [self addText:[NSString stringWithFormat:@"正在请求定位权限  %d",CLLocationManager.authorizationStatus]];
        }
        
    } else {
        [self addText:@"当前系统版本低于13 直接获取wifi ssid"];
        _ssidTextField.text = [self ssidForConnectedNetwork];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [self addText:@"刚刚同意定位权限"];
         if (![GlobalKit shareKit].isSoftAp) {
             _ssidTextField.text = [self ssidForConnectedNetwork];
         }
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    _locationMagager = [[CLLocationManager alloc] init];
    _locationMagager.delegate = self;
    
    NSString * sistemstr = [[UIDevice currentDevice] systemVersion];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [self addText:[NSString stringWithFormat:@"当前系统版本%@",sistemstr]];
    [self addText:[NSString stringWithFormat:@"当前app版本%@",version]];
    [self addText:[NSString stringWithFormat:@"是否softAp配网%d",[GlobalKit shareKit].isSoftAp]];
    
    
    if (![GlobalKit shareKit].isSoftAp) {
        
        [self setWiFiName];
        
        _ssidTextField.placeholder = @"Please enter WiFi SSID";

        _ssidTextField.enabled = YES;
    }else{
        
        _ssidTextField.text = [GlobalKit shareKit].wifiSSID;
        
        _passwordTextField.text = [GlobalKit shareKit].wifiPwd;
        
        _ssidTextField.placeholder = @"Please enter WiFi SSID";

        _ssidTextField.enabled = YES;

    }
    self.textView.hidden = YES;
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvEnterForeGround:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
     [self addText:[NSString stringWithFormat:@"是否softAp配网%d",[GlobalKit shareKit].isSoftAp]];
     [self addText:[NSString stringWithFormat:@"wifiSSID%@",[GlobalKit shareKit].wifiSSID]];
    [self addText:[NSString stringWithFormat:@"wifiPwd%@",[GlobalKit shareKit].wifiPwd]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)recvEnterForeGround:(NSNotification *)notice{
    
    if (![GlobalKit shareKit].isSoftAp) {
        
        [self setWiFiName];

    }
}
- (IBAction)continueAction:(id)sender {
    
    if (_ssidTextField.text.length > 0) {
        
        [GlobalKit shareKit].wifiSSID = _ssidTextField.text;
        
        [GlobalKit shareKit].wifiPwd = _passwordTextField.text;
        
        [self performSegueWithIdentifier:@"UKConnectDeviceViewController" sender:nil];

    }else{
        if (![GlobalKit shareKit].isSoftAp) {
            
            [HUD showAlertWithText:@"Please connect WiFi"];

        }else{
            
            [HUD showAlertWithText:@"Please enter WiFi SSID"];

            [_ssidTextField becomeFirstResponder];
        }
    }

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    UKConnectDeviceViewController *controller = segue.destinationViewController;
    
    controller.ssid = _ssidTextField.text;
    
    controller.password = _passwordTextField.text;
    
}

-(NSString*)ssidForConnectedNetwork{
    NSArray *interfaces = (__bridge_transfer NSArray*)CNCopySupportedInterfaces();
    NSDictionary *info = nil;
    [self addText:[NSString stringWithFormat:@"获取到interfaces信息 %@",interfaces]];
    for (NSString *ifname in interfaces) {
        info = (__bridge_transfer NSDictionary*)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        [self addText:[NSString stringWithFormat:@"获取到wifi信息 %@",info]];
        if (info && [info count]) {
            break;
        }
        info = nil;
    }
    
    NSString *ssid = nil;
//    [self addText:[NSString stringWithFormat:@"获取到wifi信息 %@",info]];
    if ( info ){
        ssid = [info objectForKey:(__bridge_transfer NSString*)kCNNetworkInfoKeySSID];
    }
    info = nil;
    [self addText:[NSString stringWithFormat:@"获取到wifi SSID %@",ssid]];
    return ssid? ssid:@"";
}
@end

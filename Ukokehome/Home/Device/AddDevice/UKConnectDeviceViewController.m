//
//  UKConnectDeviceViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKConnectDeviceViewController.h"
#import "UKHomeViewController.h"
#import "UKConFailViewController.h"
#import "EasyLink.h"

@interface UKConnectDeviceViewController ()<EasyLinkFTCDelegate>{
    EASYLINK *easylink_config;
    NSData *_ssidData;
}
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *WiFiImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (nonatomic, strong) NSTimer *offTimer;
@property (assign, nonatomic) int seconds;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation UKConnectDeviceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [easylink_config unInit];
    easylink_config = nil;
    
    if (easylink_config == nil) {
        
        easylink_config = [[EASYLINK alloc] initForDebug:true WithDelegate:self];
        
        _ssidData = [_ssid dataUsingEncoding:NSUTF8StringEncoding];
        
        [self connectQingke];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _WiFiImgView.animatedImage = [UKHelper getGifImageByName:@"Wifi"];

    if ([[GlobalKit shareKit].deviceType isAirConditioner]) {
        _deviceTypeLabel.text = @"Air Conditioner";
    }else{
        _deviceTypeLabel.text = @"Water Filter";
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self cancleWifiConfig];
    [easylink_config unInit];
    easylink_config = nil;

}

- (void)dealloc{
    
    [easylink_config unInit];
}

- (void)connectQingke{
    
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:5];
    
    [wlanConfig setObject:_ssidData forKey:KEY_SSID];
    [wlanConfig setObject:_password forKey:KEY_PASSWORD];
    [wlanConfig setObject:[NSNumber numberWithBool:YES] forKey:KEY_DHCP];
    
    [easylink_config prepareEasyLink:wlanConfig
                                info:nil
                                mode:[GlobalKit shareKit].isSoftAp?EASYLINK_SOFT_AP:EASYLINK_AWS
                             encrypt:[@"" dataUsingEncoding:NSUTF8StringEncoding] ];
    [easylink_config transmitSettings];
    
    if (!self.offTimer) {
        
        self.seconds = 60;
        
        self.offTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(offTimer:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop]addTimer:self.offTimer forMode:NSRunLoopCommonModes];
        
        [self.offTimer fire];
    }
    
}

- (void)offTimer:(NSTimer *)timer{
    
    if (self.seconds < 0)
    {
        [self cancleWifiConfig];
        
        if (self.offTimer) {
            [self.offTimer invalidate];
            self.offTimer = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Configuration timed out, please try again"];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"UKConFailViewController" sender:nil];
        });
        
    } else
    {
        self.seconds -- ;
    }
}

- (void)cancleWifiConfig{
    
    if (self.offTimer) {
        [self.offTimer invalidate];
        self.offTimer = nil;
    }
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [easylink_config stopTransmitting];
}

-(void)timerCount:(NSTimer *) sender
{
    
    if (self.seconds < 0)
    {
        [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Configuration timed out, please try again"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"UKConFailViewController" sender:nil];
        });
        
    } else
    {
        if(self.seconds%5 == 0)
        {
            [self wifiDeviceIsOnlineWithDeviceId:[GlobalKit shareKit].deviceId];

        }
        
        self.seconds -- ;
        
    }
}

#pragma mark  验证WiFi设备是否在线

- (void)wifiDeviceIsOnlineWithDeviceId:(NSString *)deviceId{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = @{@"deviceId":deviceId,@"deviceType":[GlobalKit shareKit].deviceType}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].isOnline parameters:dic success:^(id responseObject) {
        
        if ([responseObject boolValue]) {
            
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            
            [self addDevice];
            
        }

    } failure:^(id error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
        });
    } WithHud:NO AndTitle:nil];
    
}

- (void)addDevice{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[GlobalKit shareKit].deviceType forKey:@"actualDeviceTypeId"];

    [params setObject:[GlobalKit shareKit].deviceId forKey:@"deviceId"];

    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].match parameters:params success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Add Success"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self popToHomeViewController];
            
        });
    } failure:^(id error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"UKConFailViewController" sender:nil];
        });
        
    }WithHud:YES AndTitle:@"Adding..."];
}

- (void)popToHomeViewController{
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKHomeViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


#pragma mark - EasyLink delegate -

- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict
{
    /*Config is success*/
    NSLog(@"Found by mDNS, client:%d, config success!", [client intValue]);
    NSLog(@"mataDataDict = %@", [mataDataDict description]);
        
    NSString *mac = [[ NSString alloc] initWithData:mataDataDict[@"MAC"] encoding:NSUTF8StringEncoding];
    
    NSLog(@"MAC:%@",mac);
    
    NSString *newMac = [mac stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    [GlobalKit shareKit].deviceId = [newMac lowercaseString];
    
    [easylink_config stopTransmitting];
}

- (void)onFoundByFTC:(NSNumber *)ftcClientTag withConfiguration: (NSDictionary *)configDict
{
    /*Config is not success, need to write config to client to finish*/
    NSLog(@"Found by FTC, client:%d", [ftcClientTag intValue]);
    [easylink_config configFTCClient:ftcClientTag withConfiguration: [NSDictionary dictionary]];
    [easylink_config stopTransmitting];
}

- (void)onDisconnectFromFTC:(NSNumber *)client  withError:(bool)err;
{
    if (self.offTimer) {
        [self.offTimer invalidate];
        self.offTimer = nil;
    }
    
    if(err == NO){
        NSLog(@"Device connected, config success!");
        if (self.timer == nil) {
            
            self.seconds = 60;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
            
            [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            
            [self.timer fire];
            
        }
    }else{
        NSLog(@"Device disconnected with error, config failed!");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [HUD showAlertWithText:@"Configuration failure, please try again"];
            
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"UKConFailViewController" sender:nil];
        });
    }
}

- (void)onEasyLinkSoftApStageChanged: (EasyLinkSoftApStage)stage{
    
    NSLog(@"EasyLinkSoftApStage-%d",stage);
    
    if (stage == eState_connect_to_wrong_wlan) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:[NSString stringWithFormat:@"Please connect the iPhone WiFi to %@",self.ssid]];
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
}


@end

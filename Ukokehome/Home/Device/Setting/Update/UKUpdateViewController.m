//
//  UKUpdateViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKUpdateViewController.h"
#import "UKDeviceSettingViewController.h"

@interface UKUpdateViewController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *upProgressImgView;
@property (nonatomic, strong)NSTimer *wifiUpTimer;
@property (nonatomic, assign) NSInteger allTimeCount;
@property (nonatomic, assign) NSInteger count;

@end

@implementation UKUpdateViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _count = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.allTimeCount = 60;

        if (self.wifiUpTimer == nil) {
            self.wifiUpTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(checkVersionFunction:) userInfo:nil repeats:YES];
        }
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _upProgressImgView.animatedImage = [UKHelper getGifImageByName:@"Progress"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.wifiUpTimer) {
        [self.wifiUpTimer invalidate];
        self.wifiUpTimer = nil;
    }
}

- (BOOL)navigationShouldPopOnBackButton{
    
    [self popToHomeViewController];
    
    return NO;
    
}

- (void)checkVersionFunction:(NSTimer *)timer{
    
    NSMutableDictionary *dic = @{@"deviceId":self.model.deviceId}.mutableCopy;

    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].wfversionGet parameters:dic success:^(id responseObject) {
        
        if (self.allTimeCount < 0) {
            
            self.allTimeCount = 60;
            
            if (self.wifiUpTimer) {
                [self.wifiUpTimer invalidate];
                self.wifiUpTimer = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [HUD showAlertWithText:@"Device update timeout"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self popToHomeViewController];
                        
                    });
                });
            });
            
        }else{
            
            self.allTimeCount --;
            
            NSString *code = responseObject[@"code"];
            
            if ([code integerValue] == VERSION_IS_NEW) {
                
                self.count ++;
                self.allTimeCount = 60;
                
                if (self.wifiUpTimer) {
                    [self.wifiUpTimer invalidate];
                    self.wifiUpTimer = nil;
                }
                if (self.count == 1) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD showAlertWithText:@"Device update succeeded"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self performSegueWithIdentifier:@"UKUpResultViewController" sender:nil];
                            
                        });
                    });
                }

            }else if ([code integerValue] == VERSION_IS_CANUPDATE){
                
                self.allTimeCount = 60;
                
                if (self.wifiUpTimer) {
                    [self.wifiUpTimer invalidate];
                    self.wifiUpTimer = nil;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [HUD showAlertWithText:@"Device update failure"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self popToHomeViewController];
                        
                    });
                });
            }
        }
        
    } failure:^(id error) {
        [HUD hideUIBlockingIndicator];
        if (![error isEqualToString:@"2050"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.allTimeCount = 60;
                
                if (self.wifiUpTimer) {
                    [self.wifiUpTimer invalidate];
                    self.wifiUpTimer = nil;
                }
            });
            
        }else{
            
            self.allTimeCount --;
            
        }
        
        if (self.allTimeCount < 0) {
            
            self.allTimeCount = 60;
            
            if (self.wifiUpTimer) {
                [self.wifiUpTimer invalidate];
                self.wifiUpTimer = nil;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [HUD showAlertWithText:@"Device update timeout"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self popToHomeViewController];
                    
                });
            });
            
        }
    } WithHud:NO AndTitle:nil];
    
}

- (void)popToHomeViewController{
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKDeviceSettingViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

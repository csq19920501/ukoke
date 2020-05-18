//
//  UKShareResultViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKShareResultViewController.h"
#import "UKDeviceSettingViewController.h"

#define SECOND 60

@interface UKShareResultViewController ()

@property (weak, nonatomic) IBOutlet UIButton *resendBtn;

@property (nonatomic, strong) NSTimer *countDownTimer;  ///<倒计时
@property (nonatomic) NSInteger timeFire;
@end

@implementation UKShareResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_countDownTimer == nil) {
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _timeFire = SECOND;
    
}


- (void)viewWillDisappear:(BOOL)animated{
    if (_countDownTimer != nil) {
        
        [self.countDownTimer invalidate];
        
        self.countDownTimer = nil;
    }
}

-(void)timeMethod:(NSTimer *)timer
{
    self.timeFire--;
    
    _resendBtn.userInteractionEnabled = NO;
    
    [_resendBtn setTitle:[NSString stringWithFormat:@"%lds",(long)self.timeFire] forState:UIControlStateNormal];
    
    if(self.timeFire == 0)
    {
        [self.countDownTimer invalidate];
        
        self.countDownTimer = nil;
        
        self.timeFire = SECOND;
        
        _resendBtn.userInteractionEnabled = YES;
        
        [_resendBtn setTitle:@"Re-send" forState:UIControlStateNormal];
        
    }
}


- (IBAction)resendAction:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([_numStr containsString:@"@"]) {
        if (![UKHelper judgeEmailLegal:_numStr]) {
            
            [HUD showAlertWithText:@"Wrong email format"];
            
            return;
        }
        [params setObject:_numStr forKey:@"email"];
        
    }else{
        
        [params setObject:_numStr forKey:@"phoneNum"];
        
    }
    
    [params setObject:self.model.id forKey:@"did"];
    
    NSString *str = [UKAPIList getAPIList].shareCreate;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
        if (self.countDownTimer == nil) {
            
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];
            
        }
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Resharing..."];
    
}

- (IBAction)doneAction:(id)sender {
    
    [self popToHomeViewController];

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

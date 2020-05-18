//
//  UKVerfCodeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKVerfCodeViewController.h"
#import "UKEditProfileViewController.h"

#define TAG1 10000
#define SECOND 60

@interface UKVerfCodeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *codeNumLabels;
@property (nonatomic, strong) NSTimer *countDownTimer;  ///<倒计时
@property (nonatomic, assign) NSInteger timeFire;
@property (nonatomic, assign) BOOL isAddPhone;

@end

@implementation UKVerfCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAddPhone = [GlobalKit shareKit].phoneNumber?NO:YES;
    
    if (_countDownTimer == nil) {
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];

    }

    // Do any additional setup after loading the view.
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
        
        [_resendBtn setTitle:@"Resend code" forState:UIControlStateNormal];

    }
}
- (IBAction)resendAction:(UIButton *)sender {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"phoneNum":self.phoneNum}];
    NSString *str;
    if (!_isAddPhone) {
        str = [UKAPIList getAPIList].updateCode;
    }else{
        str = [UKAPIList getAPIList].code;
    }
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        if (self.countDownTimer == nil) {
            
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];
            
        }
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"sending..."];

}

- (IBAction)verifyAction:(id)sender {
    
    NSInteger count = 0;
    
    NSString *inviteCode = @"";

    for (UILabel *numLabel in _codeNumLabels) {
        
        if (numLabel.text.length == 0) {
            
            count ++;
            
            break;
        }
        
        inviteCode = [NSString stringWithFormat:@"%@%@",inviteCode,numLabel.text];
    }
    
    if (count > 0) {
        
        [HUD showAlertWithText:@"Please fill in the verification code"];
        
        return;
    }
    
    NSMutableDictionary *dic;
    NSString *str;
    if (!_isAddPhone) {
        str = [UKAPIList getAPIList].updatePhone;
        dic = @{@"phoneNum":self.phoneNum,@"code":inviteCode}.mutableCopy;
    }else{
        str = [UKAPIList getAPIList].addPhone;
        dic = @{@"phoneNum":self.phoneNum,@"inviteCode":inviteCode}.mutableCopy;
    }
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        [GlobalKit shareKit].phoneNumber = self.phoneNum;

        if (!self.isAddPhone) {

            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[UKEditProfileViewController class]]) {
                    
                    [controller setValue:[GlobalKit shareKit].phoneNumber forKey:@"phoneNum"];
                    
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
        }else{
            
            
            [self performSegueWithIdentifier:@"UKEditProfileViewController" sender:nil];
        }


    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"verifying..."];
    
}


- (IBAction)enterCode:(UIButton *)sender {
    
    NSString *num = [NSString stringWithFormat:@"%d",(int)(sender.tag - TAG1)];
    
    for (UILabel *numLabel in _codeNumLabels) {
        
        if (numLabel.text.length == 0) {
            
            numLabel.text = num;
            
            break;
        }
    }
    
}

- (IBAction)deleteAction:(UIButton *)sender {
    
    for (int i = (int)_codeNumLabels.count - 1; i >= 0; i --) {
        
        UILabel *numLabel = _codeNumLabels[i];
        
        if (numLabel.text.length != 0) {
            
            numLabel.text = @"";
            
            break;
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UKEditProfileViewController *controller = segue.destinationViewController;
    
    controller.userName = [GlobalKit shareKit].userName;
    controller.email = [GlobalKit shareKit].email;
    controller.phoneNum = [GlobalKit shareKit].phoneNumber;
    controller.isEdit = NO;
}


@end

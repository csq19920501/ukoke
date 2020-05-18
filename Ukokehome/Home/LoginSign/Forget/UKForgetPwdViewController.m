//
//  UKForgetPwdViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKForgetPwdViewController.h"

#define SECOND 60

@interface UKForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confimTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic, strong) NSTimer *countDownTimer;  ///<倒计时
@property (nonatomic) NSInteger timeFire;
@end

@implementation UKForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isEdit?(_showLabel.text = @"Change your password?"):(_showLabel.text = @"Forget your password?");

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

- (IBAction)resendAction:(UIButton *)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *str;
    
    if (_isEdit) {
        
        str = [UKAPIList getAPIList].pwdCode;
        
        [params setObject:_numStr forKey:@"channel"];
        
    }else{
        
        str = [UKAPIList getAPIList].pwdFindCode;
        
        if ([_numStr containsString:@"@"]) {
            if (![UKHelper judgeEmailLegal:_numStr]) {
                
                [HUD showAlertWithText:@"Wrong email format"];
                
                return;
            }
            [params setObject:_numStr forKey:@"email"];
            
        }else{
            
            [params setObject:_numStr forKey:@"phoneNum"];
            
        }
    }

    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
        if (self.countDownTimer == nil) {
            
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod:) userInfo:nil repeats:YES];
            
        }
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"sending..."];
 
}


- (IBAction)saveAction:(id)sender {
    
    if (_codeTextField.text.length == 0 || _pwdTextField.text.length == 0 || _confimTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in the information"];
        
        return;
    }
    
    if (![UKHelper judgePassWordLegal:_pwdTextField.text]) {
        
        [HUD showAlertWithText:@"Must contain upper and lower case letters and Numbers and be larger than 6 digits"];
        
        return;
    }
    
    if (![UKHelper judgeNumText:_codeTextField.text]) {
        
        [HUD showAlertWithText:@"Verification code format is incorrect"];
        
        return;
    }
    
    NSMutableDictionary *params;
    
    NSString *str;
    
    if (_isEdit) {
        
        str = [UKAPIList getAPIList].pwdUpdate;
        
        params = @{@"channel":_numStr,@"password":[[_pwdTextField.text md5Digest] md5Digest],@"inviteCode":_codeTextField.text}.mutableCopy;

    }else{
        
        str = [UKAPIList getAPIList].pwdFindUpdate;
        
        params = @{@"password":[[_pwdTextField.text md5Digest] md5Digest],@"inviteCode":_codeTextField.text}.mutableCopy;
        
        if ([_numStr containsString:@"@"]) {
           
            [params setObject:_numStr forKey:@"email"];
            
        }else{
            
            [params setObject:_numStr forKey:@"phoneNum"];
            
        }
    }
    
    if ([GlobalKit shareKit].clientId) {
        
        [params setObject:[GlobalKit shareKit].clientId forKey:@"clientId"];
        
    }else{
        
        [HUD showAlertWithText:@"Service error"];
        return;
    }
    
    [params setObject:@(ISIPHONE) forKey:@"platform"];
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
        [GlobalKit shareKit].pwd = params[@"password"];
        
        [UKHelper storeUserInfoByDic:responseObject];
        
        [ETLMKSOCKETMANAGER disconnectSocket];
        
        [ETLMKSOCKETMANAGER connectSocket];
        
        [self performSegueWithIdentifier:@"UKUpdatePwdToHomeSegue" sender:nil];
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Saving..."];
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

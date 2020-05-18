//
//  UKSignViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKSignViewController.h"

@interface UKSignViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confimPwdTextField;

@end

@implementation UKSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)signAction:(id)sender {
    
    if (_usernameTextField.text.length == 0 || _emailTextField.text.length == 0 || _pwdTextField.text.length == 0 || _confimPwdTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in the information"];
        
        return;
    }
    
    if (![UKHelper judgeEmailLegal:_emailTextField.text]) {
        
        [HUD showAlertWithText:@"Email format Error"];
        
        return;
    }
    
    if (![UKHelper judgePassWordLegal:_pwdTextField.text]) {
        
        [HUD showAlertWithText:@"Password must have at least 6 or more characters Upper & Lowercase Letters At least one number"];
        
        return;
    }
    
    if (_usernameTextField.text.length > 60) {
        
        [HUD showAlertWithText:@"Overlong username"];
        
        return;
    }
    
    if (_emailTextField.text.length > 32) {
        
        [HUD showAlertWithText:@"Overlong email"];
        
        return;
    }
    
    if (![_pwdTextField.text isEqualToString:_confimPwdTextField.text]) {
        
        [HUD showAlertWithText:@"The passwords you entered do not match"];

        return;
    }
    
    
    NSMutableDictionary *params = @{@"userName":_usernameTextField.text,@"email":_emailTextField.text,@"password":[[_pwdTextField.text md5Digest] md5Digest]}.mutableCopy;
    
    if ([GlobalKit shareKit].clientId) {
        
        [params setObject:[GlobalKit shareKit].clientId forKey:@"clientId"];
        
    }else{
        
        [HUD showAlertWithText:@"Service error"];
        return;
    }
    
    [params setObject:@(ISIPHONE) forKey:@"platform"];

    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].regist parameters:params success:^(id responseObject) {
        
        [GlobalKit shareKit].pwd = params[@"password"];
        
        [UKHelper storeUserInfoByDic:responseObject];
        
        [ETLMKSOCKETMANAGER connectSocket];

        [self performSegueWithIdentifier:@"UKPhoneNumViewController" sender:nil];
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Sign Up..."];
    
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

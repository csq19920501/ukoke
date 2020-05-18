//
//  UKLoginViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/9/27.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKLoginViewController.h"
#import "UKForgetSendCodeViewController.h"

@interface UKLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation UKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)forgetPwdAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKForgetSendCodeViewController" sender:nil];
}

- (IBAction)loginAction:(id)sender {
    
    if (_usernameTextField.text.length == 0 || _pwdTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in the information"];
        
        return;
    }

    if (![UKHelper judgePassWordLegal:_pwdTextField.text]) {
        
        [HUD showAlertWithText:@"Wrong password"];
        
        return;
    }
    
    NSMutableDictionary *params = @{@"userName":_usernameTextField.text,@"password":[[_pwdTextField.text md5Digest] md5Digest],@"loginType":@"ukoke"}.mutableCopy;
    
    if ([GlobalKit shareKit].clientId) {
        
        [params setObject:[GlobalKit shareKit].clientId forKey:@"clientId"];
        
    }else{
        
        [HUD showAlertWithText:@"Service error"];
        return;
    }
    
    [params setObject:@(ISIPHONE) forKey:@"platform"];
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].login parameters:params success:^(id responseObject) {
        
        [GlobalKit shareKit].pwd = params[@"password"];

        [UKHelper storeUserInfoByDic:responseObject];

        [ETLMKSOCKETMANAGER connectSocket];
        
        [self performSegueWithIdentifier:@"UKLoginToHomeSegue" sender:nil];
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Logining..."];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"UKForgetSendCodeViewController"]) {
        UKForgetSendCodeViewController *controller = segue.destinationViewController;
        
        controller.isEdit = NO;
    }

}

@end

//
//  UKForgetSendCodeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/17.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKForgetSendCodeViewController.h"
#import "UKForgetPwdViewController.h"

@interface UKForgetSendCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic, copy) NSString *numStr;

@end

@implementation UKForgetSendCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isEdit?(_showLabel.text = @"Change your password?"):(_showLabel.text = @"Forget your password?");
    // Do any additional setup after loading the view.
}

- (IBAction)sendAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *str;
    if (_isEdit) {
        
        str = [UKAPIList getAPIList].pwdCode;
        
        if ([_numTextField.text containsString:@"@"]) {
            
            if (![UKHelper judgeEmailLegal:_numTextField.text]) {
                
                [HUD showAlertWithText:@"Email format Error"];
                
                return;
            }
            
            if ([_numTextField.text isEqualToString:[GlobalKit shareKit].email]) {
                
                [dic setObject:@"email" forKey:@"channel"];
                
                _numStr = @"email";

            }else{
                
                [HUD showAlertWithText:@"Please enter your own email"];
                
                return;
            }
            
            
        }else{
            
            if (![UKHelper judgeNumText:_numTextField.text]) {
                
                [HUD showAlertWithText:@"Phone format Error"];
                
                return;
            }
            
            if ([_numTextField.text isEqualToString:[GlobalKit shareKit].phoneNumber]) {
                
                [dic setObject:@"phone" forKey:@"channel"];
                
                _numStr = @"phone";
                
            }else{
                
                [HUD showAlertWithText:@"Please enter your own phone number"];
                
                return;
            }
        }
        
    }else{
        
        str = [UKAPIList getAPIList].pwdFindCode;
        
        if ([_numTextField.text containsString:@"@"]) {
            
            if (![UKHelper judgeEmailLegal:_numTextField.text]) {
                
                [HUD showAlertWithText:@"Email format Error"];
                
                return;
            }
            [dic setObject:_numTextField.text forKey:@"email"];
            
        }else{
            if (![UKHelper judgePhoneNum:_numTextField.text]) {
                
                [HUD showAlertWithText:@"Phone format Error"];
                
                return;
            }
            [dic setObject:_numTextField.text forKey:@"phoneNum"];

        }
        
        _numStr = _numTextField.text;
    }

    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        [self performSegueWithIdentifier:@"UKForgetPwdViewController" sender:nil];
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"sending..."];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UKForgetPwdViewController *controller = segue.destinationViewController;
    
    controller.numStr = _numStr;
    
    controller.isEdit = _isEdit;
}


@end

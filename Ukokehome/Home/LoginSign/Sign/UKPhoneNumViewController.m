//
//  UKPhoneNumViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKPhoneNumViewController.h"
#import "UKVerfCodeViewController.h"

@interface UKPhoneNumViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;

@end

@implementation UKPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)areaNumAction:(UIButton *)sender {
    
    
}

- (IBAction)continueAction:(UIButton *)sender {
    
    if (_phoneNumTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Mobile phone is required"];
        
        return;
    }
    
    if (![UKHelper judgePhoneNum:_phoneNumTextField.text]) {
        
        [HUD showAlertWithText:@"Phone format Error"];
        
        return;
    }
    
    NSMutableDictionary *dic = @{@"phoneNum":self.phoneNumTextField.text}.mutableCopy;
    NSString *str;
    
    if ([GlobalKit shareKit].phoneNumber) {
        str = [UKAPIList getAPIList].updateCode;
    }else{
       str = [UKAPIList getAPIList].code;
    }
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        [self performSegueWithIdentifier:@"UKVerfCodeViewController" sender:nil];
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"sending..."];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    UKVerfCodeViewController *controller = segue.destinationViewController;
    
    controller.phoneNum = _phoneNumTextField.text;
    
}


@end

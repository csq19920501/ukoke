//
//  UKAddDeviceByCodeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKAddDeviceByCodeViewController.h"
#import "UKHomeViewController.h"

@interface UKAddDeviceByCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation UKAddDeviceByCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)connectAction:(UIButton *)sender {
    
    if (_codeTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please enter share code"];
        
        return;
    }
    
    if (![UKHelper judgeNumText:_codeTextField.text]) {
        
        [HUD showAlertWithText:@"Verification code format Error"];
        
        return;
    }
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].shareGet parameters:@{@"code":self.codeTextField.text}.mutableCopy success:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Connect success"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popToHomeViewController];
        });
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Connecting..."];
}

- (void)popToHomeViewController{
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKHomeViewController class]]) {
            
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

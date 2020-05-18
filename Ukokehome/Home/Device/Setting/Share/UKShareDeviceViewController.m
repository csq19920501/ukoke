//
//  UKShareDeviceViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKShareDeviceViewController.h"
#import "UKShareResultViewController.h"

@interface UKShareDeviceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

@end

@implementation UKShareDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sendAction:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([_numTextField.text containsString:@"@"]) {
        if (![UKHelper judgeEmailLegal:_numTextField.text]) {
            
            [HUD showAlertWithText:@"Wrong email format"];
            
            return;
        }
        [params setObject:_numTextField.text forKey:@"email"];
        
    }else{
        
        if (![UKHelper judgePhoneNum:_numTextField.text]) {
            
            [HUD showAlertWithText:@"Phone format Error"];
            
            return;
        }
        
        [params setObject:_numTextField.text forKey:@"phoneNum"];
        
    }
    
    [params setObject:self.model.id forKey:@"did"];

    NSString *str = [UKAPIList getAPIList].shareCreate;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
        [self performSegueWithIdentifier:@"UKShareResultViewController" sender:nil];
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Sharing..."];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    UKShareResultViewController *controller = segue.destinationViewController;
    
    controller.model = self.model;
    
    controller.numStr = _numTextField.text;
    
}


@end

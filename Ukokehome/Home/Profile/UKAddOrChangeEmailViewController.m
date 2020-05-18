//
//  UKAddOrChangeEmailViewController.m
//  Ukokehome
//
//  Created by ethome on 2019/3/20.
//  Copyright © 2019 ethome. All rights reserved.
//

#import "UKAddOrChangeEmailViewController.h"

@interface UKAddOrChangeEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation UKAddOrChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([GlobalKit shareKit].email) {
        _titleLabel.text = @"Replace your email?";
    }else{
        _titleLabel.text = @"Add your email?";
    }
    // Do any additional setup after loading the view.
}
- (IBAction)saveAction:(id)sender {
    
    if (![UKHelper judgeEmailLegal:_emailTextField.text]) {
        
        [HUD showAlertWithText:@"Email format Error"];
        
        return;
    }
    NSString *str;

    if ([GlobalKit shareKit].email) {
        str = [UKAPIList getAPIList].updateEmail;
    }else{
        str = [UKAPIList getAPIList].userEdit;
    }
    
    NSMutableDictionary *dic = @{@"email":_emailTextField.text}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        [GlobalKit shareKit].email = self.emailTextField.text;
        
        if (self.emailBlock) {
            self.emailBlock(self.emailTextField.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Saving..."];
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

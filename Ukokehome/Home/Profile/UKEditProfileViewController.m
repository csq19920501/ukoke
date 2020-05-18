//
//  UKEditProfileViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKEditProfileViewController.h"
#import "UKForgetSendCodeViewController.h"
#import "UKAddOrChangeEmailViewController.h"

@interface UKEditProfileViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *dateToolBar;
@property (weak, nonatomic) IBOutlet UIButton *changePwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation UKEditProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    _phoneNumTextField.text = _phoneNum;//手机号修改后传值刷新

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    
    _userNameTextField.text = _userName;
    
    if ([[GlobalKit shareKit].loginType isEqualToString:@"ukoke"]) {
        _isEdit?(_changePwdBtn.hidden = NO):(_changePwdBtn.hidden = YES);
    }else{
        _changePwdBtn.hidden = YES;
    }
    
    self.birthdateTextField.inputView = self.datePicker;
    self.birthdateTextField.inputAccessoryView = self.dateToolBar;
    
    _emailTextField.text = _email;
    _addressTextField.text = _address;
    _birthdateTextField.text = _birthday;
    _genderTextField.text = _gender;
    
}

- (IBAction)changePwdAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"UKChangePwdSegue" sender:nil];
}
- (IBAction)phoneAction:(UIButton *)sender {
    
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UKPhoneNumViewController"] animated:YES];
}
- (IBAction)emailAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKAddOrChangeEmailViewController" sender:nil];

}

- (IBAction)birthdateAction:(UIButton *)sender {
    
    [self.birthdateTextField becomeFirstResponder];
    
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    [self.birthdateTextField resignFirstResponder];
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    
    [self.birthdateTextField resignFirstResponder];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    self.birthdateTextField.text  = [dateFormatter stringFromDate:self.datePicker.date];
    
}

- (IBAction)genderAction:(UIButton *)sender {
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Gender" message:@"Select gender" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.genderTextField.text = @"Male";
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.genderTextField.text = @"Female";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertViewController addAction:maleAction];
    
    [alertViewController addAction:femaleAction];

    [alertViewController addAction:cancelAction];

    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (IBAction)saveAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (_userNameTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in your userName"];
        
        return;
    }else{
        
        [dic setObject:_userNameTextField.text forKey:@"userName"];
        
    }
    
    if (_phoneNumTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in your phone number"];
        
        return;
    }else{
        
        [dic setObject:_phoneNumTextField.text forKey:@"phoneNum"];

    }
    
    if (_emailTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in your email"];
        
        return;
    }else{
        
        if ([UKHelper judgeEmailLegal:_emailTextField.text]) {
            
            [dic setObject:_emailTextField.text forKey:@"email"];

        }else{
            [HUD showAlertWithText:@"Wrong email format"];
            
            return;
        }

    }
    
    if (_addressTextField.text.length != 0) {
        
        [dic setObject:_addressTextField.text forKey:@"address"];
    }
    
    if (_birthdateTextField.text.length != 0) {
        
        [dic setObject:_birthdateTextField.text forKey:@"birthday"];
    }
    
    if (_genderTextField.text.length != 0) {
        
        [dic setObject:[_genderTextField.text isEqualToString:@"Male"]?@"m":@"f" forKey:@"gender"];
    }
    
    NSString *str = [UKAPIList getAPIList].userEdit;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:dic success:^(id responseObject) {
        
        [UKHelper storeUserInfoByDic:responseObject];
        
        if (self.isEdit) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self performSegueWithIdentifier:@"UKSignToHomeSegue" sender:nil];
        }
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Saving..."];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"UKChangePwdSegue"]) {
        
        UKForgetSendCodeViewController *controller = segue.destinationViewController;
        
        controller.isEdit = YES;
    }else if ([segue.identifier isEqualToString:@"UKAddOrChangeEmailViewController"]){
        
        UKAddOrChangeEmailViewController *controller = segue.destinationViewController;
        
        controller.emailBlock = ^(NSString * _Nonnull email) {
            self.emailTextField.text = email;
        };
    }
}


@end

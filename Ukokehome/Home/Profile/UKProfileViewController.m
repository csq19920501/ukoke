//
//  UKProfileViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKProfileViewController.h"
#import "UKEditProfileViewController.h"

@interface UKProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;

@end

@implementation UKProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initView];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)initView{
    
    _emailLabel.text = [GlobalKit shareKit].email;
    _phoneLabel.text = [GlobalKit shareKit].phoneNumber;
    _addressLabel.text = [GlobalKit shareKit].address;    
    _birthdayLabel.text = [GlobalKit shareKit].birthday;
    
}

- (IBAction)editProfileAction:(id)sender {
    
    
    [self performSegueWithIdentifier:@"UKEditProfileViewController" sender:nil];
    
}
- (IBAction)signOutAction:(id)sender {

    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Sign Out" message:@"Are you sure to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [UKAPIList getAPIList].logout;
        
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        
        [params setObject:@(ISIPHONE) forKey:@"platform"];

        [ETAFNetworking postLMK_AFNHttpSrt:url parameters:params success:^(id responseObject) {
            
            [ETLMKSOCKETMANAGER disconnectSocket];
            
            [[GlobalKit shareKit] clearSession];
            
            UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
            controller.modalPresentationStyle = 0;
            [[UKHelper getCurrentVC] presentViewController:controller animated:YES completion:nil];

            
        } failure:^(id error) {
            
        }WithHud:YES AndTitle:@"Sign Outing..."];
        
    }];
    
    [alertViewController addAction:cancelAction];
    
    [alertViewController addAction:sureAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    UKEditProfileViewController *controller = segue.destinationViewController;
    
    controller.userName = [GlobalKit shareKit].userName;
    controller.email = _emailLabel.text;
    controller.phoneNum = _phoneLabel.text;
    controller.address = _addressLabel.text;
    controller.birthday = _birthdayLabel.text;
    controller.gender = [GlobalKit shareKit].gender?([[GlobalKit shareKit].gender isEqualToString:@"m"]?@"Male":@"Female"):nil;
    controller.isEdit = YES;

}


@end

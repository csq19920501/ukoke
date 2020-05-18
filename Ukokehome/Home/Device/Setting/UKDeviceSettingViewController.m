//
//  UKDeviceSettingViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKDeviceSettingViewController.h"
#import "UKHomeViewController.h"
#import "UKUpDetailViewController.h"

@interface UKDeviceSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBut;
@property (nonatomic, copy) NSString *updateDetail;
@end

@implementation UKDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    [self changUpgradeTitle];
}
-(void)viewDidLayoutSubviews{
    [self changUpgradeTitle];
    
}
-(void)changUpgradeTitle{
    if (APPDELEGATE.hasNew) {
        
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"Upgrade(new)"];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:15.0]
         
                              range:NSMakeRange(0, 7)];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:12.0]
         
                              range:NSMakeRange(7, 5)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(7, 5)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor whiteColor]
         
                              range:NSMakeRange(0, 7)];
        
        
        [self.upgradeBut setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        
        
    }else {
         NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"Upgrade"];
//        [self.upgradeBut setTitle: @"Upgrade" forState:UIControlStateNormal];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor whiteColor]
         
                              range:NSMakeRange(0, 7)];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:15.0]
         
                              range:NSMakeRange(0,7)];
        [self.upgradeBut setAttributedTitle:AttributedStr forState:UIControlStateNormal];
    }
}
- (void)initView{
    
    _deviceNameTextField.text = self.model.deviceName;
    
    if ([self.model.actualDeviceTypeId isAirConditioner]) {
        
        _titleLabel.text = @"Air Conditioner";
    }else{
        
        _titleLabel.text = @"Water Filter";
    }
}

- (IBAction)upgradeAction:(id)sender {
    
//    [self performSegueWithIdentifier:@"UKCheckUpViewController" sender:nil];
    NSMutableDictionary *dic = @{@"deviceId":self.model.deviceId}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].wfversionGet parameters:dic success:^(id responseObject) {
        
        NSString *code = responseObject[@"code"];
        
        if ([code integerValue] == VERSION_IS_CANUPDATE) {
            
            self.updateDetail = responseObject[@"memo"];
            
            [self performSegueWithIdentifier:@"UKUpDetailViewController" sender:nil];
            
//            UKUpDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UKUpDetailViewController"];
//
//            controller.model = self.model;
//            controller.updateDetail = self.updateDetail;
//            [self.navigationController pushViewController:controller animated:YES];
            
            APPDELEGATE.hasNew = YES;
//            [self.upgradeBut showBadge];
            
        }else if ([code integerValue] == VERSION_IS_NEW){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"The device is the latest version"];
            });
            APPDELEGATE.hasNew = NO;
//            [self.upgradeBut clearBadge];
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"The device is updating"];
            });
        }
         [self changUpgradeTitle];
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Checking..."];
}

- (IBAction)shareAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKShareDeviceViewController" sender:nil];

}

- (IBAction)resetAction:(id)sender {

    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].deviceDelete parameters:@{@"did":self.model.id}.mutableCopy success:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"Delete success"];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self popToHomeViewController];
            });
            
        } failure:^(id error) {
            
        } WithHud:YES AndTitle:@"Deleting..."];
    }];
    
    [alertViewController addAction:cancelAction];
    
    [alertViewController addAction:sureAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
    
}
- (IBAction)saveAction:(id)sender {
    
    if ([self.deviceNameTextField.text isEqualToString:self.model.deviceName]) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        
        if (self.deviceNameTextField.text.length == 0) {
            
            [HUD showAlertWithText:@"Please enter the device name"];
            
            return;
        }
        
        [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].deviceUpdate parameters:@{@"id":self.model.id,@"deviceName":self.deviceNameTextField.text}.mutableCopy success:^(id responseObject) {
            
            self.model.deviceName = self.deviceNameTextField.text;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"Save success"];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(id error) {
            
        } WithHud:YES AndTitle:@"Saving..."];
    }

}

- (void)popToHomeViewController{
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKHomeViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString: @"UKShareDeviceViewController"]) {
        UIViewController *controller = segue.destinationViewController;
        
        [controller setValue:self.model forKey:@"model"];
    }else{
        UKUpDetailViewController *controller = segue.destinationViewController;
        
        controller.updateDetail = self.updateDetail;
        
        controller.model = self.model;
    }
    
    
}


@end

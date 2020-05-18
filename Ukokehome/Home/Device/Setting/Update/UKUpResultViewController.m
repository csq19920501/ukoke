//
//  UKUpResultViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKUpResultViewController.h"
#import "UKDeviceSettingViewController.h"

@interface UKUpResultViewController ()

@end

@implementation UKUpResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)doneAction:(id)sender {
    
    [self popToHomeViewController];
    
}

- (BOOL)navigationShouldPopOnBackButton{
    
    [self popToHomeViewController];
    
    return NO;
    
}

- (void)popToHomeViewController{
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKDeviceSettingViewController class]]) {
            
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

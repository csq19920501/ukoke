//
//  UKConFailViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKConFailViewController.h"
#import "UKHomeViewController.h"
#import "UKEnteWiFiViewController.h"

@interface UKConFailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *softAp;

@end

@implementation UKConFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.softAp.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.softAp.layer.borderWidth = 5;
}

- (BOOL)navigationShouldPopOnBackButton{
    
    [self popToHomeViewController];
    
    return NO;
    
}

- (IBAction)retryAction:(id)sender {
    
    [GlobalKit shareKit].isSoftAp = NO;
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[UKEnteWiFiViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (IBAction)softapAction:(id)sender {
    
//    [GlobalKit shareKit].isSoftAp = YES;
//
//       for (UIViewController *controller in self.navigationController.childViewControllers) {
//
//           if ([controller isKindOfClass:[UKEnteWiFiViewController class]]) {
//
//               [self.navigationController popToViewController:controller animated:YES];
//           }
//       }
    
    [self performSegueWithIdentifier:@"UKSoftApSegue" sender:nil];
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

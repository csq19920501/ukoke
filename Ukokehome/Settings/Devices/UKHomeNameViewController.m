//
//  UKHomeNameViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/22.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKHomeNameViewController.h"

@interface UKHomeNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *homeNameTextField;

@end

@implementation UKHomeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [_type isEqualToString:@"address"]?@"Home location":@"Home name";
    self.homeNameTextField.placeholder = [_type isEqualToString:@"address"]?@"Home location":@"Home name";
    // Do any additional setup after loading the view.
}
- (IBAction)saveAction:(id)sender {
    
    if (_homeNameTextField.text.length == 0) {
        
        [HUD showAlertWithText:@"Please fill in the information"];
        
        return;
    }
    
    NSMutableDictionary *dic = @{_type:_homeNameTextField.text}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].userSetting parameters:dic success:^(id responseObject) {
        
        if ([self.type isEqualToString:@"address"]) {
            
            [GlobalKit shareKit].address = self.homeNameTextField.text;

        }else{
            [GlobalKit shareKit].homeName = self.homeNameTextField.text;

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Save success"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Saving..."];
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

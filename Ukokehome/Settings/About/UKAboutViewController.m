//
//  UKAboutViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKAboutViewController.h"

@interface UKAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation UKAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = [NSString stringWithFormat:@"v %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    // Do any additional setup after loading the view.
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

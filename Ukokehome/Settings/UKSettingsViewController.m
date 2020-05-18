//
//  UKSettingsViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKSettingsViewController.h"
#import "UKSettingsTableViewCell.h"
#import "SDImageCache.h"

@interface UKSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, assign) NSInteger sizeCache;
@end

@implementation UKSettingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    _sizeCache = [[SDImageCache sharedImageCache] getSize];
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = @[@[@"Home manage"],@[@"Message settings",@"Clear cache"],@[@"Region"],@[@"About Ukoke"]];
    
    _headerArray = @[@"    Devices",@"    General",@"    Region",@"    About"];
    
    _tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}

- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_menuArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UKSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKSettingsTableViewCell" forIndexPath:indexPath];
    
    cell.menuLabel.text = _menuArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        cell.menuLabel.text = [NSString stringWithFormat:@"Clear cache(%@)",[NSString stringWithFormat:@"%@",[self fileSizeWithInterge:_sizeCache]]];
    }else if (indexPath.section == 2){
        
        cell.detailLabel.text = [GlobalKit shareKit].region;
    }
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    label.text = _headerArray[section];
    
    label.textColor = [UIColor whiteColor];
    
    return label;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 25.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [self performSegueWithIdentifier:@"UKHomeManageViewController" sender:nil];
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            [self performSegueWithIdentifier:@"UKMessageSettingViewController" sender:nil];

        }else{
            
            if (_sizeCache > 0) {
                
                [HUD showAlertWithText:@"Cleaning..."];
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD hideUIBlockingIndicator];
                        
                        [HUD showAlertWithText:@"Clean success"];
                    });
                    
                }];
            }else{
                
                [HUD showAlertWithText:@"No Cache"];
            }
        
        }
    }else if (indexPath.section == 2){
        
        [self performSegueWithIdentifier:@"UKRegionViewController" sender:nil];
        
    }else if (indexPath.section == 3){
        
        [self performSegueWithIdentifier:@"UKAboutViewController" sender:nil];
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

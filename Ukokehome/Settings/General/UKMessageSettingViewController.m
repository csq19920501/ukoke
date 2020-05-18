//
//  UKMessageSettingViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKMessageSettingViewController.h"
#import "UKSettingsTableViewCell.h"
#import "UKMsgSettingTableViewCell.h"

#define TAG  10000

@interface UKMessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *headerArray;

@end

@implementation UKMessageSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = @[@[@"Device notifications",@"Store messages"],@[@"DND for messages",@"DND period"]];
    
    _headerArray = @[@"    Receive system notifications",@"    Do not disturb"];
    
    _tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}
- (IBAction)saveAction:(id)sender {
    
    UISwitch *deviceNotSwitch = [self.view viewWithTag:TAG + 1];
    UISwitch *storeMsgSwitch = [self.view viewWithTag:TAG + 2];
    UISwitch *dndSwitch = [self.view viewWithTag:TAG + 3];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSTimeZone *systemTimeZone = [NSTimeZone
                                  systemTimeZone];
    
    NSInteger zone = [systemTimeZone secondsFromGMT]/60/60;
    
    [dic setObject:deviceNotSwitch.on?@"on":@"off" forKey:@"devicePush"];
    [dic setObject:storeMsgSwitch.on?@"on":@"off" forKey:@"storeMsg"];

    if (dndSwitch.on) {
        
        [dic setObject:@"on" forKey:@"dnd"];
        
        [dic setObject:@(zone) forKey:@"timeZone"];

    }else{
        
        [dic setObject:@"off" forKey:@"dnd"];

    }
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].userSetting parameters:dic success:^(id responseObject) {
        
        [GlobalKit shareKit].devicePush = deviceNotSwitch.on?@"on":@"off";
        [GlobalKit shareKit].storeMsg = storeMsgSwitch.on?@"on":@"off";
        [GlobalKit shareKit].dnd = dndSwitch.on?@"on":@"off";
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Save success"];
        });
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Saving..."];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_menuArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        UKSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKSettingsTableViewCell" forIndexPath:indexPath];
        
        cell.menuLabel.text = _menuArray[indexPath.section][indexPath.row];
        
        cell.detailLabel.text = [NSString stringWithFormat:@"%@-%@",[GlobalKit shareKit].dndStart,[GlobalKit shareKit].dndEnd];
        
        return cell;
    }else{
        
        UKMsgSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKMsgSettingTableViewCell" forIndexPath:indexPath];
        
        cell.menuLabel.text = _menuArray[indexPath.section][indexPath.row];
        
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.statusSwitch.on = [[GlobalKit shareKit].devicePush isEqualToString:@"on"]?YES:NO;
                
                cell.statusSwitch.tag = TAG + 1;

            }else{
                cell.statusSwitch.on = [[GlobalKit shareKit].storeMsg isEqualToString:@"on"]?YES:NO;
                
                cell.statusSwitch.tag = TAG + 2;
            }
        }else{
            
            cell.statusSwitch.on = [[GlobalKit shareKit].dnd isEqualToString:@"on"]?YES:NO;

            cell.statusSwitch.tag = TAG + 3;

        }
        
        return cell;
    }

    
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self performSegueWithIdentifier:@"UKSendMsgTypeViewController" sender:nil];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        [self performSegueWithIdentifier:@"UKDndTimeViewController" sender:nil];

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

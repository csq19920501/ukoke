//
//  UKSendMsgTypeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKSendMsgTypeViewController.h"
#import "UKMsgSettingTableViewCell.h"

#define TAG  10000

@interface UKSendMsgTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *headerArray;

@end

@implementation UKSendMsgTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = @[@[@"By message",@"By email",@"By push"]];
    
    _headerArray = @[@"    Receive system notifications"];
    
    _tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}

- (IBAction)saveAction:(id)sender {
    
    UISwitch *emailSwitch = [self.view viewWithTag:TAG];
    UISwitch *msgSwitch = [self.view viewWithTag:TAG + 1];
    UISwitch *pushSwitch = [self.view viewWithTag:TAG + 2];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:emailSwitch.on?@"on":@"off" forKey:@"email"];
    [dic setObject:msgSwitch.on?@"on":@"off" forKey:@"sms"];
    [dic setObject:pushSwitch.on?@"on":@"off" forKey:@"push"];
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].userSetting parameters:dic success:^(id responseObject) {
        
        [GlobalKit shareKit].emailPush = emailSwitch.on?@"on":@"off";
        [GlobalKit shareKit].sms = msgSwitch.on?@"on":@"off";
        [GlobalKit shareKit].push = pushSwitch.on?@"on":@"off";
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
    
    UKMsgSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKMsgSettingTableViewCell" forIndexPath:indexPath];
    
    cell.menuLabel.text = _menuArray[indexPath.section][indexPath.row];
    
    cell.statusSwitch.tag = TAG + indexPath.row;
    
    if (indexPath.row == 0) {
        
        cell.statusSwitch.on = [[GlobalKit shareKit].emailPush isEqualToString:@"on"]?YES:NO;

    }else if (indexPath.row == 1){
        
        cell.statusSwitch.on = [[GlobalKit shareKit].sms isEqualToString:@"on"]?YES:NO;

    }else{
        
        cell.statusSwitch.on = [[GlobalKit shareKit].push isEqualToString:@"on"]?YES:NO;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

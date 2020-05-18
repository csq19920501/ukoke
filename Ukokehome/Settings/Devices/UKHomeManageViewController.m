//
//  UKHomeManageViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKHomeManageViewController.h"
#import "UKSettingsTableViewCell.h"
#import "UKHomeNameViewController.h"

@interface UKHomeManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, copy) NSString *type;
@end

@implementation UKHomeManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = @[@[@"Home name",@"Home location"]];
    
    _headerArray = @[@"    Devices"];
    
    _tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _detailArray = @[[GlobalKit shareKit].homeName?[GlobalKit shareKit].homeName:@"No set",        [GlobalKit shareKit].address?[GlobalKit shareKit].address:@"No Set"];
    
    [self.tableView reloadData];
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
    
    cell.detailLabel.text = _detailArray[indexPath.row];
    
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
    
    if (indexPath.row == 0) {
        
        _type = @"homeName";
    }else{
        _type = @"address";
    }
    
    [self performSegueWithIdentifier:@"UKHomeNameViewController" sender:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    UKHomeNameViewController *controller = segue.destinationViewController;
    
    controller.type = _type;
}


@end

//
//  UKFilterDetailViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/12/10.
//  Copyright © 2018 ethome. All rights reserved.
//

#import "UKFilterDetailViewController.h"
#import "UKFilterDetailTableViewCell.h"
#import "UKFilterSystemViewController.h"

@interface UKFilterDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopLayout;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dateArray;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UILabel *waterValueLabel;

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, assign) BOOL isShowMenu;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) NSArray *stageArray;


@end

@implementation UKFilterDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    _selectBtn = _dayBtn;
    
    [self getWaterValueByDays:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuTableView.tableFooterView = [UIView new];
    
    _detailTableView.tableFooterView = [UIView new];
    
    _menuArray = @[@"Installation Guide",@"Filter Replacement",@"Settings",@"Help"];
    _stageArray = @[@"PP Sediment",@"UDF Carbon",@"CTO Carbon",@"RO Membrane",@"Post Carbon",@"Alkaline"];

    [self initViewByModel];
    // Do any additional setup after loading the view.
}

- (void)initViewByModel{
    
    NSArray *filterDayArr = [self.model.property8 componentsSeparatedByString:@"#"];
    
    NSArray *filterWaterArr = [self.model.property9 componentsSeparatedByString:@"#"];
    
    NSMutableArray *newDayArr = [NSMutableArray array];
    NSMutableArray *newWaterArr = [NSMutableArray array];
    
    NSArray *alarmDayArr = @[@"180",@"180",@"180",@"720",@"360",@"360"];
    NSArray *alarmWaterArr = @[@"1000",@"1000",@"1000",@"4000",@"2000",@"2000"];
    
    for (int i = 0; i < alarmDayArr.count; i ++) {
        
        NSString *day = filterDayArr[i];
        NSString *alarmDay = alarmDayArr[i];
        NSString *newDay = [NSString stringWithFormat:@"%.2f",[day floatValue]/[alarmDay integerValue]];
        
        [newDayArr addObject:newDay];
    }
    
    for (int i = 0; i < alarmWaterArr.count; i ++) {
        
        NSString *water = filterWaterArr[i];
        NSString *alarmWater = alarmWaterArr[i];
        NSString *newWater = [NSString stringWithFormat:@"%.2f",[water floatValue]/[alarmWater integerValue]];
        
        [newWaterArr addObject:newWater];
    }
    
    _detailArray = [NSMutableArray array];
    
    for (int i = 0; i < filterDayArr.count; i ++) {
        
        CGFloat dayNum = [newDayArr[i] floatValue];
        
        CGFloat waterNum = [newWaterArr[i] floatValue];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if (dayNum <= waterNum) {
            
            [dic setObject:[NSString stringWithFormat:@"%@ Days Remain",filterDayArr[i]] forKey:@"detail"];
            
            [dic setObject:[NSString stringWithFormat:@"%f",dayNum]   forKey:@"percent"];
        }else{
            
            [dic setObject:[NSString stringWithFormat:@"%@L Water Remain",filterWaterArr[i]] forKey:@"detail"];
            
            [dic setObject:[NSString stringWithFormat:@"%f",waterNum]   forKey:@"percent"];
        }
        
        [_detailArray addObject:dic];
    }
    
    [self.detailTableView reloadData];
}

- (IBAction)menuAction:(id)sender {
    
    [UIView animateWithDuration:.5 animations:^{
       
        if (!self.isShowMenu) {
            self.menuTableView.alpha = 1.f;
            self.topLayout.constant = 160.f;
            self.heightLayout.constant = 740.f;
            self.showLabel.alpha = 0.f;
            self.imgTopLayout.constant = 0.f;
            [self.view layoutIfNeeded];
        }else{
            self.menuTableView.alpha = 0.f;
            self.topLayout.constant = 0.f;
            self.heightLayout.constant = 770.f;
            self.showLabel.alpha = 1.f;
            self.imgTopLayout.constant = 60.f;
            [self.view layoutIfNeeded];
        }
        
        self.isShowMenu = !self.isShowMenu;

    }];
}
- (IBAction)changeTypeAction:(UIButton *)sender {
    
    _selectBtn = sender;
    
    [self getWaterValueByDays:sender.tag - 10000];
    
}

- (void)getWaterValueByDays:(NSInteger)days{
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].waterValue parameters:@{@"deviceId":self.model.deviceId,@"period":@(days)}.mutableCopy success:^(id responseObject) {
        
        for (UIButton *btn in self.dateArray) {
            
            if (btn == self.selectBtn) {
                
                [btn setBackgroundImage:[UIImage imageNamed:@"FilterDay"] forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
        }
        
        self.waterValueLabel.text = [NSString stringWithFormat:@"%@L",responseObject];
        
    } failure:^(id error) {
        self.waterValueLabel.text = @"Error";
    } WithHud:YES AndTitle:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _menuTableView) {
        return 4;
    }else{
        return _detailArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _menuTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKFilterMenuCell" forIndexPath:indexPath];
        
        cell.textLabel.text = _menuArray[indexPath.row];
        
        return cell;
    }else{
        
        UKFilterDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKFilterDetailTableViewCell" forIndexPath:indexPath];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"Stage0%ld",(long)indexPath.row + 1];
        
        cell.dic = _detailArray[indexPath.row];
        
        cell.stageType = _stageArray[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _menuTableView) {
        
        [HUD showAlertWithText:@"The feature is still in development"];

    }else{
        
        _index = indexPath.row + 1;
        
        [self performSegueWithIdentifier:@"UKFilterSystemViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"UKFilterSystemViewController"]) {
        
        UKFilterSystemViewController *controller = segue.destinationViewController;
        
        controller.index = _index;
        
        controller.detailArr = _detailArray;
        
        controller.stageArray = _stageArray;

    }
}
@end

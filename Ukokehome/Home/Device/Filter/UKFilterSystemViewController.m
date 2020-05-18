//
//  UKFilterSystemViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/12/11.
//  Copyright © 2018 ethome. All rights reserved.
//

#import "UKFilterSystemViewController.h"
#import "UKArcLineView.h"

@interface UKFilterSystemViewController ()
@property (weak, nonatomic) IBOutlet UIView *stage1View;
@property (nonatomic, strong) UKArcLineView *line1view;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *stageViews;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageTypeLabel;
@property (nonatomic, strong) NSMutableArray *stageLineViews;
@property (nonatomic, strong) NSArray *stageDeatilArray;

@end

@implementation UKFilterSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)initView{
    
    _stageDeatilArray = @[@"Removes sediments, dust,sand, particles, dirt and rusts",@"Removes Chlorine, tastes,odors, cloudiness, and colors",@"Removes harmful chemicals chloramines, odors, and more",@"Removes up to 99.9% of contaminants as Fluoride heavy metals, Lead, and more.  Produces quality drinking water up to 75 Gallons Daily",@"Heavy metal, chlorine, taste and odor removal from Tank",@"PH+Inline Alkaline—re-mineralizing calcium filter adds calcium carbonate to increase water alkalinity."];
 
    _line1view = [[UKArcLineView alloc] initWithFrame:_stage1View.bounds];
    
    _line1view.isShowName = YES;
    
    _line1view.name = [NSString stringWithFormat:@"Stage0%ld",(long)_index];
    
    _line1view.labelFont = 22.f;

    _line1view.starScore = [_detailArr[_index - 1][@"percent"] floatValue];
    
    _stage1View.tag = _index;
    
    [self.stage1View addSubview:_line1view];
    
    NSMutableArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6"].mutableCopy;
    
    [array removeObject:[NSString stringWithFormat:@"%ld",(long)_index]];
    
    for (int i = 0; i < array.count; i ++) {
        
        UIView *view = _stageViews[i];
        
        view.tag = [array[i] integerValue];
    }
    
    _stageLineViews = [NSMutableArray array];
    
    for (UIView *view in _stageViews) {
        
        UKArcLineView *lineview = [[UKArcLineView alloc] initWithFrame:view.bounds];
        
        lineview.isShowName = YES;
        
        lineview.name = [NSString stringWithFormat:@"0%ld",(long)view.tag];
        
        lineview.labelFont = 14.f;

        lineview.starScore = [_detailArr[view.tag - 1][@"percent"] floatValue];
        
        [_stageLineViews addObject:lineview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStage:)];
        
        [view addGestureRecognizer:tap];
        
        [view addSubview:lineview];
    }
    
    [self initPercentLabel];
}

- (void)initPercentLabel{
 
    CGFloat starScore = [_detailArr[_index - 1][@"percent"] floatValue];
    
    _detailLabel.text = _stageDeatilArray[_index - 1];
    
    _stageTypeLabel.text = _stageArray[_index - 1];
    
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",starScore * 100];
    
    if (starScore >= 0 && starScore <= 0.1) {
        
        _dayLabel.text = @"Please replace now";
        
        _dayLabel.textColor = [UIColor redColor];
        
        _percentLabel.textColor = [UIColor redColor];
        
    }else if (starScore > 0.1 && starScore <= 0.2){
        
        _dayLabel.text = @"Please replace soon";
        
        _dayLabel.textColor = [UIColor yellowColor];
        
        _percentLabel.textColor = [UIColor yellowColor];
        
    }else{
        
        _dayLabel.text = _detailArr[_index - 1][@"detail"];

        _dayLabel.textColor = [UIColor whiteColor];
        
        _percentLabel.textColor = [UIColor whiteColor];
        
    }
}

- (void)initViewWithStage{

    _line1view.name = [NSString stringWithFormat:@"Stage0%ld",(long)_index];
    
    _line1view.starScore = [_detailArr[_index - 1][@"percent"] floatValue];;
    
    _stage1View.tag = _index;

    NSMutableArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6"].mutableCopy;
    
    [array removeObject:[NSString stringWithFormat:@"%ld",(long)_index]];
    
    for (int i = 0; i < array.count; i ++) {
        
        UIView *view = _stageViews[i];
        
        view.tag = [array[i] integerValue];
    }
    
    for (UKArcLineView *view in _stageLineViews) {

        view.name = [NSString stringWithFormat:@"0%ld",(long)view.superview.tag];
        
        view.starScore = [_detailArr[view.superview.tag - 1][@"percent"] floatValue];

    }
    
    [self initPercentLabel];

}

- (void)changeStage:(UITapGestureRecognizer *)sender{
 
    _index = sender.view.tag;
    
    [self initViewWithStage];
}

- (IBAction)buyAction:(id)sender {
    
    [HUD showAlertWithText:@"The feature is still in development"];
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

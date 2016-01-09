//
//  ChildhoodController.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/28/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "ChildhoodController.h"
#import "Masonry.h"
#import "MFMacro.h"

@interface ChildhoodController ()
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ChildhoodController
@synthesize backButton;

- (void)setupView
{
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    //设置navigationBar为半透明(模糊)效果
    [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    WS(weakSelf)
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - Response
- (void)buttonPressed:(UIButton *)button
{
    if (button == backButton) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)itemPressed:(UIBarButtonItem *)buttonItem
{
    if (buttonItem == self.navigationItem.leftBarButtonItem) {
        DLog(@"返回按钮被按");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (buttonItem  == self.navigationItem.rightBarButtonItem) {
        DLog(@"添加图片按钮被按");
        
    }
}

#pragma mark - Getters & Setters
- (void)setBackButton:(UIButton *)aBackButton
{
    if (backButton != aBackButton) {
        backButton = aBackButton;
    }
}

- (UIButton *)backButton
{
    if (!backButton) {
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return backButton;
}

@end

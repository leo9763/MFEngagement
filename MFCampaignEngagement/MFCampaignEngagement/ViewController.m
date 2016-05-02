//
//  ViewController.m
//  MFCampaignEngagement
//
//  Created by nero on 11/23/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MFMacro.h"
#import "MainScreenScrollView.h"
#import "ChildhoodController.h"
#import "RomanticMusicHelper.h"





@interface ViewController ()

@property (strong, nonatomic) UIButton *settingButton,*shareButton,*musicButton;
@property (strong, nonatomic) MainScreenScrollView *mainStoryScrollView;

@end

@implementation ViewController
@synthesize mainStoryScrollView,settingButton,shareButton,musicButton;

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置navigationBar为半透明(模糊)效果
//    [self.navigationController.navigationBar setTranslucent:YES];
    self.extendedLayoutIncludesOpaqueBars = YES;
    //不给scrollView在bar中的部分上下可滑
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

//    [self.view addSubview:self.mainStoryScrollView];
//    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    //设置navigationBar为半透明(模糊)效果
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroud_transparentNavigationbar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.settingButton.frame = CGRectMake(NAVIGATION_BAR_ITEM_EDGE, 0, NAVIGATION_BAR_ITEM_WIDTH, NAVIGATION_BAR_ITEM_WIDTH);
    self.shareButton.frame = CGRectMake(SCREEN_WIDTH - 2*NAVIGATION_BAR_ITEM_EDGE - NAVIGATION_BAR_ITEM_WIDTH, 0, NAVIGATION_BAR_ITEM_WIDTH, NAVIGATION_BAR_ITEM_WIDTH);
    self.musicButton.frame = CGRectMake(SCREEN_WIDTH - NAVIGATION_BAR_ITEM_EDGE, 0,  NAVIGATION_BAR_ITEM_WIDTH,  NAVIGATION_BAR_ITEM_WIDTH);
    
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithCustomView:self.musicButton];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    
    self.navigationItem.leftBarButtonItem = settingItem;
    self.navigationItem.rightBarButtonItems = @[shareItem,musicItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    //autoLayout前必须先将view添加到superView，否则会报错
    WS(weakSelf)
    
    [mainStoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.mainStoryScrollView makeConstraints];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [mainStoryScrollView updateScreenWithOffset:scrollView.contentOffset];
}

#pragma mark - Response
- (void)buttonPressed:(UIButton *)button
{
    if (button == settingButton) {
        DLog(@"点击了设置");
    } else if (button == shareButton) {
        DLog(@"点击了分享");
    } else if (button == musicButton) {
        DLog(@"点击了🎵");
        
        [[RomanticMusicHelper shareMusicHelper] play];
    }
}

#pragma mark - Getter & Setter
- (UIScrollView *)mainStoryScrollView
{
    if (!mainStoryScrollView) {
        mainStoryScrollView = [[MainScreenScrollView alloc] init];
        mainStoryScrollView.delegate = self;
        mainStoryScrollView.pagingEnabled = YES;
    }
    return mainStoryScrollView;
}

- (void)setSettingButton:(UIButton *)aSettingButton
{
    if (settingButton != aSettingButton) {
        settingButton = aSettingButton;
    }
}

- (UIButton *)settingButton
{
    if (!settingButton) {
        settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setImage:[UIImage imageNamed:@"little_icon_waitter"] forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return settingButton;
}

- (void)setShareButton:(UIButton *)aShareButton
{
    if (shareButton != aShareButton) {
        shareButton = aShareButton;
    }
}

- (UIButton *)shareButton
{
    if (!shareButton) {
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"little_icon_butterfly"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return shareButton;
}

- (void)setMusicButton:(UIButton *)aMusicButton
{
    if (musicButton != aMusicButton) {
        musicButton = aMusicButton;
    }
}

- (UIButton *)musicButton
{
    if (!musicButton) {
        musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [musicButton setImage:[UIImage imageNamed:@"little_icon_musicalNote"] forState:UIControlStateNormal];
        [musicButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return musicButton;
}

@end

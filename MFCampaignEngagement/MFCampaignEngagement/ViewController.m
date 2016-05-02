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
#import "ChildhoodController.h"

#define MF_ME_MODEL_WIDTH   60
#define MF_ME_MODEL_HEIGHT  60
#define MF_YOU_MODEL_WIDTH  60
#define MF_YOU_MODEL_HEIGHT 60
#define MF_BIG_CLOUD_WIDTH  SCREEN_WIDTH/1.5
#define MF_BIG_CLOUD_HEIGTH  SCREEN_HEIGHT/5
#define MF_MIDDLE_CLOUD_WIDTH
#define MF_MIDDLE_CLOUD_HEIGHT
#define MF_LITTLE1_CLOUD_WIDTH
#define MF_LITTLE1_CLOUD_HEIGHT
#define MF_LITTLE2_CLOUD_WIDTH
#define MF_LITTLE2_CLOUD_HEIGHT

typedef NS_ENUM(NSUInteger, LifeStage) {
    LifeStageUnborn = 0,
    LifeStageChild,
    LifeStageJenior,
    LifeStageSenior,
};

@interface ViewController ()

@property (strong, nonatomic) UIButton *meModel,*youModel,*settingButton,*shareButton,*musicButton;
@property (strong, nonatomic) UIScrollView *mainStoryScrollView;
@property (strong, nonatomic) UIImageView *contentView,*bigCloud,*middleCloud,*sun,*littleCloud1,*littleCloud2;
@property (nonatomic, assign) LifeStage stage;
@property (nonatomic, assign) float meRunSpeedRatio,youRunSpeedRatio;
@end

@implementation ViewController
@synthesize meModel,youModel,mainStoryScrollView,contentView,settingButton,shareButton,musicButton,stage,bigCloud,middleCloud,sun,littleCloud1,littleCloud2;

- (void)setupView
{
    self.meRunSpeedRatio = (SCREEN_WIDTH * 1.5 - MF_ME_MODEL_WIDTH) / SCREEN_WIDTH;
    self.youRunSpeedRatio = (SCREEN_WIDTH/2 + MF_YOU_MODEL_WIDTH) / SCREEN_WIDTH;
    self.stage = LifeStageChild;
    
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置navigationBar为半透明(模糊)效果
//    [self.navigationController.navigationBar setTranslucent:YES];
    self.extendedLayoutIncludesOpaqueBars = YES;
    //不给scrollView在bar中的部分上下可滑
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.settingButton.frame = CGRectMake(NAVIGATION_BAR_ITEM_EDGE, 0, NAVIGATION_BAR_ITEM_WIDTH, NAVIGATION_BAR_ITEM_WIDTH);
    self.shareButton.frame = CGRectMake(SCREEN_WIDTH - 2*NAVIGATION_BAR_ITEM_EDGE - NAVIGATION_BAR_ITEM_WIDTH, 0, NAVIGATION_BAR_ITEM_WIDTH, NAVIGATION_BAR_ITEM_WIDTH);
    self.musicButton.frame = CGRectMake(SCREEN_WIDTH - NAVIGATION_BAR_ITEM_EDGE, 0,  NAVIGATION_BAR_ITEM_WIDTH,  NAVIGATION_BAR_ITEM_WIDTH);
    
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithCustomView:self.musicButton];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingButton];
    
    self.navigationItem.leftBarButtonItem = settingItem;
    self.navigationItem.rightBarButtonItems = @[shareItem,musicItem];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mainStoryScrollView];
    [self.mainStoryScrollView addSubview:self.contentView];
    [self.contentView addSubview:self.meModel];
    [self.contentView addSubview:self.youModel];
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    //autoLayout前必须先将view添加到superView，否则会报错
    WS(weakSelf)
    
    [mainStoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.mainStoryScrollView);
        make.height.equalTo(weakSelf.mainStoryScrollView);
        make.width.equalTo(weakSelf.mainStoryScrollView).with.multipliedBy(3.0);
    }];
    
    [meModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(MF_ME_MODEL_WIDTH, MF_ME_MODEL_HEIGHT));
    }];
    
    [youModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH - MF_YOU_MODEL_WIDTH);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(MF_YOU_MODEL_WIDTH, MF_YOU_MODEL_HEIGHT));
    }];
    
    [littleCloud1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_WIDTH/7);
        make.top.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_HEIGTH);
        make.size.mas_equalTo(CGSizeMake(0.6 * MF_BIG_CLOUD_WIDTH, 0.6 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [bigCloud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2);
        make.top.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_HEIGTH/6);
        make.size.mas_equalTo(CGSizeMake(MF_BIG_CLOUD_WIDTH, MF_BIG_CLOUD_HEIGTH));
    }];
    
    [middleCloud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(2 * SCREEN_WIDTH - 0.7 * MF_BIG_CLOUD_WIDTH);
        make.top.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_HEIGTH/4.5);
        make.size.mas_equalTo(CGSizeMake(0.7 * MF_BIG_CLOUD_WIDTH, 0.7 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [littleCloud2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(2 * SCREEN_WIDTH + MF_BIG_CLOUD_WIDTH/4);
        make.top.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_HEIGTH/4);
        make.size.mas_equalTo(CGSizeMake(0.4 * MF_BIG_CLOUD_WIDTH, 0.4 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [sun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH);
        make.top.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_HEIGTH/6);
        make.size.mas_equalTo(CGSizeMake(0.9 * MF_BIG_CLOUD_HEIGTH, 0.9 * MF_BIG_CLOUD_HEIGTH));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    WS(weakSelf)
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX < SCREEN_WIDTH) {
        
        self.stage = LifeStageChild;
        
        [meModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX * weakSelf.meRunSpeedRatio);
        }];
        
        [youModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX * weakSelf.youRunSpeedRatio + SCREEN_WIDTH - MF_YOU_MODEL_WIDTH);
        }];
        
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_WIDTH/7 + offsetX * 0.3);
        }];
        
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2) - offsetX * 0.5);
        }];
        
        
        
    } else if (offsetX >= SCREEN_WIDTH && offsetX < SCREEN_WIDTH * 2) {
        
        self.stage = LifeStageJenior;
        
        [meModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX + SCREEN_WIDTH * 0.5 - MF_ME_MODEL_WIDTH);
        }];
        
        [youModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX + SCREEN_WIDTH * 0.5);
        }];
        
    } else {
        
        self.stage = LifeStageSenior;
        
        return;
    }
}

#pragma mark - Response
- (void)buttonPressed:(UIButton *)button
{
    if (button == meModel) {
        DLog(@"点击了自己");
        ChildhoodController *childhoodController = [[ChildhoodController alloc] init];
        [self.navigationController pushViewController:childhoodController animated:YES];
    } else if (button == youModel) {
        DLog(@"点击了她");
        ChildhoodController *childhoodController = [[ChildhoodController alloc] init];
        [self.navigationController pushViewController:childhoodController animated:YES];
    } else if (button == settingButton) {
        DLog(@"点击了设置");
    } else if (button == shareButton) {
        DLog(@"点击了分享");
    } else if (button == musicButton) {
        DLog(@"点击了🎵");
    }
}

#pragma mark - Getter & Setter
- (void)setMeModel:(UIButton *)aModel
{
    if (aModel != meModel) {
        meModel = aModel;
    }
}

- (UIButton *)meModel
{
    if (!meModel) {
        meModel = [UIButton buttonWithType:UIButtonTypeCustom];
        [meModel addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        meModel.backgroundColor = [UIColor redColor];
    }
    return meModel;
}

- (void)setYouModel:(UIButton *)aYouModel
{
    if (aYouModel != youModel) {
        youModel = aYouModel;
    }
}

- (UIButton *)youModel
{
    if (!youModel) {
        youModel = [UIButton buttonWithType:UIButtonTypeCustom];
        [youModel addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        youModel.backgroundColor = [UIColor blueColor];
    }
    return youModel;
}

- (void)setMainStoryScrollView:(UIScrollView *)aMainStoryScrollView
{
    if (mainStoryScrollView != aMainStoryScrollView) {
        mainStoryScrollView = aMainStoryScrollView;
    }
}

- (UIScrollView *)mainStoryScrollView
{
    if (!mainStoryScrollView) {
        mainStoryScrollView = [UIScrollView new];
        mainStoryScrollView.delegate = self;
        mainStoryScrollView.pagingEnabled = YES;
    }
    return mainStoryScrollView;
}

- (void)setContentView:(UIImageView *)aContentView
{
    if (contentView != aContentView) {
        contentView = aContentView;
        contentView.userInteractionEnabled = YES;
    }
}

- (UIView *)contentView
{
    if (!contentView) {
        contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBackground.png"]];
        contentView.userInteractionEnabled = YES;
        
        bigCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_bigCloud"]];
        middleCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_middleCloud"]];
        littleCloud1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_littleCloud1"]];
        littleCloud2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_littleCloud2"]];
        sun = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_sun"]];
        
        [contentView addSubview:sun];
        [contentView addSubview:bigCloud];
        [contentView addSubview:middleCloud];
        [contentView addSubview:littleCloud1];
        [contentView addSubview:littleCloud2];
        
    }
    return contentView;
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

- (void)setStage:(LifeStage)aStage
{
    if (stage != aStage) {
        stage = aStage;
        
        if (!meModel || !youModel) {
            return;
        }
        
        switch (stage) {
            case LifeStageChild:
                [meModel setImage:[UIImage imageNamed:@"child"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"child"] forState:UIControlStateNormal];
                break;
            case LifeStageJenior:
                [meModel setImage:[UIImage imageNamed:@"jenior"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"jenior"] forState:UIControlStateNormal];
                break;
            case LifeStageSenior:
                [meModel setImage:[UIImage imageNamed:@"senior"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"senior"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (LifeStage)stage
{
    CGFloat offsetX = self.mainStoryScrollView.contentOffset.x;
    
    if (offsetX < SCREEN_WIDTH) {
        stage = LifeStageChild;
    } else if (offsetX >= SCREEN_WIDTH && offsetX <= SCREEN_WIDTH * 2) {
        stage = LifeStageJenior;
    } else {
        stage = LifeStageSenior;
    }
    return stage;
}


@end

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

typedef NS_ENUM(NSUInteger, LifeStage) {
    LifeStageUnborn = 0,
    LifeStageChild,
    LifeStageJenior,
    LifeStageSenior,
};

@interface ViewController ()

@property (strong, nonatomic) UIButton *meModel,*youModel,*settingButton,*shareButton;
@property (strong, nonatomic) UIScrollView *mainStoryScrollView;
@property (strong, nonatomic) UIImageView *contentView;
@property (nonatomic, assign) LifeStage stage;
@property (nonatomic, assign) float meRunSpeedRatio,youRunSpeedRatio,ourOriginalDistance;
@end

@implementation ViewController
@synthesize meModel,youModel,mainStoryScrollView,contentView,settingButton,shareButton,stage;

- (void)setupView
{
    self.meRunSpeedRatio = (SCREEN_WIDTH * 1.5 - MF_ME_MODEL_WIDTH) / SCREEN_WIDTH;
    self.youRunSpeedRatio = (SCREEN_WIDTH/2 + MF_YOU_MODEL_WIDTH) / SCREEN_WIDTH;
    self.ourOriginalDistance = SCREEN_WIDTH - MF_YOU_MODEL_WIDTH;
    self.stage = LifeStageChild;
    
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(itemPressed:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"button_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(itemPressed:)];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self.view addSubview:self.mainStoryScrollView];
    [self.mainStoryScrollView addSubview:self.contentView];
    [self.contentView addSubview:self.meModel];
    [self.contentView addSubview:self.youModel];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //autoLayout前必须先将view添加到superView，否则会报错
    WS(weakSelf)
    
    [mainStoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [meModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(MF_ME_MODEL_WIDTH, MF_ME_MODEL_HEIGHT));
    }];
    
    [youModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(_ourOriginalDistance);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(MF_YOU_MODEL_WIDTH, MF_YOU_MODEL_HEIGHT));
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.mainStoryScrollView);
        make.height.equalTo(weakSelf.mainStoryScrollView);
        make.width.equalTo(weakSelf.mainStoryScrollView).with.multipliedBy(3.0);
    }];
    
//    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.navigationController.navigationBar).with.offset(SCREEN_WIDTH/30);
//        make.bottom.equalTo(weakSelf.navigationController.navigationBar).with.offset(-SCREEN_HEIGHT/80);
//    }];
//    
//    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.navigationController.navigationBar).with.offset(-SCREEN_WIDTH/30);
//        make.bottom.equalTo(weakSelf.navigationController.navigationBar).with.offset(-SCREEN_HEIGHT/80);
//    }];
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
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX * weakSelf.youRunSpeedRatio + _ourOriginalDistance);
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
    }
}

- (void)itemPressed:(UIBarButtonItem *)buttonItem
{
    if (buttonItem == self.navigationItem.leftBarButtonItem) {
        DLog(@"设置按钮被按");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (buttonItem  == self.navigationItem.rightBarButtonItem) {
        DLog(@"分享按钮被按");
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
    }
}

- (UIView *)contentView
{
    if (!contentView) {
        contentView = [UIImageView new];
        contentView.image = [UIImage imageNamed:@"MainBackground.png"];
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
//        settingButton.backgroundColor = [UIColor redColor];
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
//        shareButton.backgroundColor = [UIColor redColor];
        [shareButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return shareButton;
}

- (void)setStage:(LifeStage)aStage
{
    if (stage != aStage) {
        stage = aStage;
        
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

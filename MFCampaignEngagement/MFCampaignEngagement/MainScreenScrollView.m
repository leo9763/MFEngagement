//
//  MainScreenScrollView.m
//  MFCampaignEngagement
//
//  Created by nero on 1/11/16.
//  Copyright © 2016 MingFung. All rights reserved.
//

#import "MainScreenScrollView.h"
#import "MFMacro.h"
#import "Masonry.h"

#define MF_ME_RUN_SPEED_RATIO   ((SCREEN_WIDTH * 1.5 - MF_ME_MODEL_WIDTH) / SCREEN_WIDTH)
#define MF_YOU_RUN_SPEED_RATIO  ((SCREEN_WIDTH/2 + MF_YOU_MODEL_WIDTH) / SCREEN_WIDTH)
#define MF_ME_MODEL_WIDTH       60
#define MF_ME_MODEL_HEIGHT      60
#define MF_YOU_MODEL_WIDTH      60
#define MF_YOU_MODEL_HEIGHT     60
#define MF_BIG_CLOUD_WIDTH      (SCREEN_WIDTH/1.5)
#define MF_BIG_CLOUD_HEIGTH     (SCREEN_HEIGHT/5)
#define MF_MIDDLE_CLOUD_WIDTH
#define MF_MIDDLE_CLOUD_HEIGHT
#define MF_LITTLE1_CLOUD_WIDTH
#define MF_LITTLE1_CLOUD_HEIGHT
#define MF_LITTLE2_CLOUD_WIDTH
#define MF_LITTLE2_CLOUD_HEIGHT

@interface MainScreenScrollView ()

@property (strong, nonatomic) UIImageView *contentView,*bigCloud,*middleCloud,*sun,*littleCloud1,*littleCloud2;

@end

@implementation MainScreenScrollView
@synthesize meModel,youModel,contentView,stage,bigCloud,middleCloud,sun,littleCloud1,littleCloud2;

- (id)init
{
    if (self = [super init]) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.meModel];
        [self.contentView addSubview:self.youModel];
        self.stage = LifeStageUnborn;
    }
    return self;
}

- (void)makeConstraints
{
    WS(weakSelf)
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
        make.width.equalTo(weakSelf).with.multipliedBy(3.0);
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
        make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH/2);
        make.size.mas_equalTo(CGSizeMake(0.6 * MF_BIG_CLOUD_WIDTH, 0.6 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [bigCloud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2);
        make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH/9);
        make.size.mas_equalTo(CGSizeMake(MF_BIG_CLOUD_WIDTH, MF_BIG_CLOUD_HEIGTH));
    }];
    
    [middleCloud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(2 * SCREEN_WIDTH);
        make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH/4.5);
        make.size.mas_equalTo(CGSizeMake(0.7 * MF_BIG_CLOUD_WIDTH, 0.7 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [littleCloud2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(2 * SCREEN_WIDTH + MF_BIG_CLOUD_WIDTH/4);
        make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH/4);
        make.size.mas_equalTo(CGSizeMake(0.4 * MF_BIG_CLOUD_WIDTH, 0.4 * MF_BIG_CLOUD_HEIGTH));
    }];
    
    [sun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH);
        make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH/9);
        make.size.mas_equalTo(CGSizeMake(0.9 * MF_BIG_CLOUD_HEIGTH, 0.9 * MF_BIG_CLOUD_HEIGTH));
    }];
}

- (void)updateScreenWithOffset:(CGPoint)offset
{
    WS(weakSelf)
    
    CGFloat offsetX = offset.x;
    
    if (offsetX < SCREEN_WIDTH) {
        
        self.stage = LifeStageChild;
        
        [meModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX * MF_ME_RUN_SPEED_RATIO);
        }];
        
        [youModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX * MF_YOU_RUN_SPEED_RATIO + SCREEN_WIDTH - MF_YOU_MODEL_WIDTH);
        }];
        
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_WIDTH/7 + offsetX * 0.3);
        }];
        
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2) - offsetX * 0.5);
        }];
        
        [middleCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((2 * SCREEN_WIDTH) -offsetX * 0.4 );
        }];
        
    } else if (offsetX >= SCREEN_WIDTH && offsetX < SCREEN_WIDTH * 2) {
        
        self.stage = LifeStageJenior;
        
        [meModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX + SCREEN_WIDTH * 0.5 - MF_ME_MODEL_WIDTH);
        }];
        
        [youModel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(offsetX + SCREEN_WIDTH * 0.5);
        }];
        
        [middleCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((2 * SCREEN_WIDTH) -offsetX * 0.4 );
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
        if (self.mainScreenDelegate && [self.mainScreenDelegate respondsToSelector:@selector(meDidClick:)]) {
            [_mainScreenDelegate meDidClick:self];
        }
    } else if (button == youModel) {
        DLog(@"点击了她");
        if (self.mainScreenDelegate && [self.mainScreenDelegate respondsToSelector:@selector(youDidClick:)]) {
            [_mainScreenDelegate youDidClick:self];
        }
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
//    CGFloat offsetX = self.contentOffset.x;
//    
//    if (offsetX < SCREEN_WIDTH) {
//        stage = LifeStageChild;
//    } else if (offsetX >= SCREEN_WIDTH && offsetX <= SCREEN_WIDTH * 2) {
//        stage = LifeStageJenior;
//    } else {
//        stage = LifeStageSenior;
//    }
    return stage;
}

@end

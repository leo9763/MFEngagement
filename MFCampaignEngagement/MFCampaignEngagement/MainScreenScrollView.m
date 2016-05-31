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
#define MF_ME_MODEL_HEIGHT      100
#define MF_YOU_MODEL_WIDTH      60
#define MF_YOU_MODEL_HEIGHT     100
#define MF_BIG_CLOUD_WIDTH      (SCREEN_WIDTH/1.5)
#define MF_BIG_CLOUD_HEIGTH     (SCREEN_HEIGHT/5)
#define MF_MIDDLE_CLOUD_WIDTH
#define MF_MIDDLE_CLOUD_HEIGHT
#define MF_LITTLE1_CLOUD_WIDTH
#define MF_LITTLE1_CLOUD_HEIGHT
#define MF_LITTLE2_CLOUD_WIDTH
#define MF_LITTLE2_CLOUD_HEIGHT

@interface MainScreenScrollView ()

@property (strong, nonatomic) UIImageView *contentView,*bigCloud,*middleCloud,*sun,*littleCloud1,*littleCloud2,*bus;
@property (strong, nonatomic) NSTimer *timer;
@property NSUInteger angle;
@property NSInteger multe;
@property BOOL isHalfPlace;

@end

@implementation MainScreenScrollView
@synthesize timer,meModel,youModel,contentView,stage,bigCloud,middleCloud,sun,littleCloud1,littleCloud2,bus;

- (id)init
{
    if (self = [super init]) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.meModel];
        [self.contentView addSubview:self.youModel];
        self.stage = LifeStageUnborn;
        _angle = 0;
        _multe = 1;
        _isHalfPlace = YES;
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
        make.centerY.equalTo(weakSelf.contentView).with.multipliedBy(1.5);
        make.size.mas_equalTo(CGSizeMake(MF_ME_MODEL_WIDTH, MF_ME_MODEL_HEIGHT));
    }];
    
    [youModel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH - MF_YOU_MODEL_WIDTH);
        make.centerY.equalTo(weakSelf.contentView).with.multipliedBy(1.5);
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateCloudOffset) userInfo:nil repeats:YES];
    [self.timer fire];
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
        
        [middleCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((2 * SCREEN_WIDTH) -offsetX * 0.4 );
        }];
        
        [bus mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(SCREEN_WIDTH / 7 - offsetX * 0.35);
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
    
    if (_angle <= 60 && !_isHalfPlace) {
        meModel.transform = CGAffineTransformRotate(meModel.transform, _multe * M_PI/180/2);
        youModel.transform = CGAffineTransformRotate(youModel.transform, -1 * _multe * M_PI/180/2);
        _angle++;
    } if (_angle <= 30) {
        meModel.transform = CGAffineTransformRotate(meModel.transform, _multe * M_PI/180/2);
        youModel.transform = CGAffineTransformRotate(youModel.transform, -1 * _multe * M_PI/180/2);
        _angle++;
    }else {
        _angle = 0;
        _multe = -1 * _multe;
        _isHalfPlace = NO;
    }
}

- (void)resetMeAndYouAngle
{
    [UIView animateWithDuration:0.35 animations:^{
        meModel.transform = CGAffineTransformMakeRotation(0);
        youModel.transform = CGAffineTransformMakeRotation(0);
    }];
    
    _angle = 0;
    _multe = 1;
    _isHalfPlace = YES;
}

- (void)updateCloudOffset
{
    WS(weakSelf)
    
    static float bigFrequency = 0.0;
    static float littleFrequency = 0.0;
    static BOOL isBigReset = NO;
    static BOOL isLittelReset = NO;
    
    if (littleFrequency >= SCREEN_WIDTH * 3 + 0.6 * MF_BIG_CLOUD_WIDTH || (littleFrequency >= SCREEN_WIDTH * 3 - MF_BIG_CLOUD_WIDTH/7 && !isLittelReset)) {
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_left);
        }];
        
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2) - bigFrequency);
        }];
        
        isLittelReset = YES;
        littleFrequency = 0.0;
    } else if ((bigFrequency >= SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2 + MF_BIG_CLOUD_WIDTH && !isBigReset) || bigFrequency >= SCREEN_WIDTH * 3 + MF_BIG_CLOUD_WIDTH) {
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(littleFrequency);
        }];
        
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_right);
        }];
        
        isBigReset = YES;
        bigFrequency = 0.0;
    } else if (isBigReset && !isLittelReset) {
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH * 3 - bigFrequency);
        }];
        
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_WIDTH/7 + littleFrequency);
        }];
    } else if (isLittelReset && !isBigReset) {
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2) - bigFrequency);
        }];
        
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(- 0.6 * MF_BIG_CLOUD_WIDTH + littleFrequency);
        }];
    } else if (isBigReset && isLittelReset) {
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(SCREEN_WIDTH * 3 - bigFrequency);
        }];
        
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(- 0.6 * MF_BIG_CLOUD_WIDTH + littleFrequency);
        }];
    } else {
        [littleCloud1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset(MF_BIG_CLOUD_WIDTH/7 + littleFrequency);
        }];
        
        [bigCloud mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.contentView).with.offset((SCREEN_WIDTH - MF_BIG_CLOUD_WIDTH/2) - bigFrequency);
        }];
    }
    littleFrequency = littleFrequency + 0.2;
    bigFrequency = bigFrequency + 0.2 * 0.3;
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
        [meModel setImage:[UIImage imageNamed:@"littleboy"] forState:UIControlStateNormal];
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
        [youModel setImage:[UIImage imageNamed:@"littlegirl"] forState:UIControlStateNormal];
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
        
        WS(weakSelf)
        
        UIImageView *mountainBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_mountainBackground"]];
        [contentView addSubview:mountainBackground];
        [mountainBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.22);
            make.top.equalTo(weakSelf.contentView).with.offset(NAVIGATION_BAR_HEIGHT + MF_BIG_CLOUD_HEIGTH);
        }];
        
        UIImageView *busBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"busBackground"]];
        [contentView addSubview:busBackground];
        [busBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.16);
            make.bottom.equalTo(mountainBackground.mas_bottom);
        }];
        
        UIImageView *churchroad = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"churchroad"]];
        [contentView addSubview:churchroad];
        [churchroad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(SCREEN_WIDTH*1.02);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.25);
            make.top.equalTo(mountainBackground.mas_bottom).offset(-SCREEN_HEIGHT * 0.01);
        }];
        
        UIImageView *church = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"church"]];
        [contentView addSubview:church];
        [church mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.contentView).offset(SCREEN_WIDTH/4);
            make.width.mas_equalTo(SCREEN_WIDTH/2.5);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.24);
            make.bottom.equalTo(mountainBackground.mas_bottom);
        }];
        
        UIImageView *palace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palace"]];
        [contentView addSubview:palace];
        [palace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(SCREEN_WIDTH/5);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.15);
            make.bottom.equalTo(mountainBackground.mas_bottom).offset(SCREEN_HEIGHT * 0.02);
        }];
        
        UIImageView *teashop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teashop"]];
        [contentView addSubview:teashop];
        [teashop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-SCREEN_WIDTH * 0.8);
            make.width.mas_equalTo(SCREEN_WIDTH/6);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.1);
            make.bottom.equalTo(mountainBackground.mas_bottom).offset(SCREEN_HEIGHT * 0.05);
        }];
        
        //全局
        bigCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_bigCloud"]];
        middleCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_middleCloud"]];
        littleCloud1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_littleCloud1"]];
        littleCloud2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_littleCloud2"]];
        sun = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene_sun"]];
        bus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bus"]];
        
        [contentView addSubview:sun];
        [contentView addSubview:bigCloud];
        [contentView addSubview:middleCloud];
        [contentView addSubview:littleCloud1];
        [contentView addSubview:littleCloud2];
        [contentView addSubview:bus];
        
        [bus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(SCREEN_WIDTH / 7);
            make.width.mas_equalTo(SCREEN_WIDTH/3.3);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.08);
            make.bottom.equalTo(mountainBackground.mas_bottom).offset(10);
        }];
        
        UIImageView *knowroad = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"knowroad"]];
        [contentView addSubview:knowroad];
        [knowroad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT * 0.3);
            make.top.equalTo(weakSelf.bus.mas_bottom).offset(SCREEN_HEIGHT * 0.01);
        }];
        
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
                [meModel setImage:[UIImage imageNamed:@"littleboy"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"littlegirl"] forState:UIControlStateNormal];
                break;
            case LifeStageJenior:
                [meModel setImage:[UIImage imageNamed:@"littleboy"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"littlegirl"] forState:UIControlStateNormal];
                break;
            case LifeStageSenior:
                [meModel setImage:[UIImage imageNamed:@"littleboy"] forState:UIControlStateNormal];
                [youModel setImage:[UIImage imageNamed:@"littlegirl"] forState:UIControlStateNormal];
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

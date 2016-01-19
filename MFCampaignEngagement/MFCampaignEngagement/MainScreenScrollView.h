//
//  MainScreenScrollView.h
//  MFCampaignEngagement
//
//  Created by nero on 1/11/16.
//  Copyright © 2016 MingFung. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LifeStage) {
    LifeStageUnborn = 0,
    LifeStageChild,
    LifeStageJenior,
    LifeStageSenior,
};

@class  MainScreenScrollView;

@protocol MainScreenProtocol <NSObject,UIScrollViewDelegate>

@optional
- (void)meDidClick:(MainScreenScrollView *)mainScreen;
- (void)youDidClick:(MainScreenScrollView *)mainScreen;

@end

@interface MainScreenScrollView : UIScrollView

@property (nonatomic, assign) id<MainScreenProtocol> mainScreenDelegate;
@property (strong, nonatomic) UIButton *meModel,*youModel;
@property (nonatomic, assign) LifeStage stage;

- (void)makeConstraints;
- (void)updateScreenWithOffset:(CGPoint)offset;

@end

//
//  DGAaimaView.h
//  animaByIdage
//
//  Created by chuangye on 15-3-11.
//  Copyright (c) 2015年 chuangye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DGEarthView;

@protocol DGEarthViewDidTapDelegate <NSObject>
@required
- (void)didTapInEarthView:(DGEarthView *)earthView;
@end


@interface DGAaimaView : UIView

@property (nonatomic,strong) DGEarthView *ainmeView;

-(void)DGAaimaView:(DGAaimaView*)animView BigCloudSpeed:(CGFloat)BigCS smallCloudSpeed:(CGFloat)SmaCS earthSepped:(CGFloat)eCS huojianSepped:(CGFloat)hCS littleSpeed:(CGFloat)LCS;

- (id)initWithFrame:(CGRect)frame delegate:(id<DGEarthViewDidTapDelegate>)delegate;

@end

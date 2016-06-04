//
//  DGEarthView.h
//  animaByIdage
//
//  Created by chuangye on 15-3-11.
//  Copyright (c) 2015年 chuangye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGAaimaView.h"

@protocol DGEarthViewDidTapDelegate;

@interface DGEarthView : UIView

@property(nonatomic, assign) CGFloat EarthSepped;
@property(nonatomic,assign)CGFloat huojiansepped;
@property(nonatomic,weak) id<DGEarthViewDidTapDelegate> delegate;

@end

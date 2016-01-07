//
//  UIView+MFViewTools.m
//  MFCampaignEngagement
//
//  Created by nero on 11/30/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "UIView+MFViewTools.h"

@implementation UIView (MFViewTools)

- (void)makeGradientWithColors:(NSArray *)colors
                    startPoint:(CGPoint)startP
                      endPoint:(CGPoint)endP
{
    UIView *layerView = [UIView new];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果

    gradientLayer.borderWidth = 0;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = colors;
    gradientLayer.startPoint = startP;
    gradientLayer.endPoint = endP;
    
    [layerView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self addSubview:layerView];
}

@end

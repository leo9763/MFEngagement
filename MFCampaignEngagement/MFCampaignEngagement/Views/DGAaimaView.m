//
//  DGAaimaView.m
//  animaByIdage
//
//  Created by chuangye on 15-3-11.
//  Copyright (c) 2015年 chuangye. All rights reserved.
//

#import "DGAaimaView.h"
#import "DGEarthView.h"
@implementation DGAaimaView

-(void)DGAaimaView:(DGAaimaView*)animView BigCloudSpeed:(CGFloat)BigCS smallCloudSpeed:(CGFloat)SmaCS earthSepped:(CGFloat)eCS huojianSepped:(CGFloat)hCS littleSpeed:(CGFloat)LCS
{
    _ainmeView.EarthSepped=eCS;
    _ainmeView.huojiansepped=hCS;
}

- (void)awakeFromNib
{
    [self animaInit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self animaInit];
    }
    return self;
}

-(void)animaInit
{
    self.backgroundColor =[UIColor blackColor];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    UIImageView *universe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"universe"]];
    universe.frame = self.bounds;
    [self addSubview:universe];
    
    DGEarthView * ainmeView =[[DGEarthView alloc]initWithFrame:self.bounds];
    [self addSubview:ainmeView];
}

@end
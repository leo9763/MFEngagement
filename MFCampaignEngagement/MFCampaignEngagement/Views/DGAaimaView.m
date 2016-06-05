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

- (id)initWithFrame:(CGRect)frame delegate:(id<DGEarthViewDidTapDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor blackColor];
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        UIImageView *universe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"universe"]];
        universe.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:universe];
        
        DGEarthView * ainmeView =[[DGEarthView alloc]initWithFrame:self.bounds];
        [self addSubview:ainmeView];
        ainmeView.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [_link invalidate];_link = nil;
}

@end
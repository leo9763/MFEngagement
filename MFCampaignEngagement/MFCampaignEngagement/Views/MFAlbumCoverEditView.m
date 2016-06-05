//
//  MFAlbumCoverEditView.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 16/6/5.
//  Copyright © 2016年 MingFung. All rights reserved.
//

#import "MFAlbumCoverEditView.h"

@implementation MFAlbumCoverEditView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSUInteger superViewWidth = CGRectGetWidth(frame);
        NSUInteger inputFieldHeight = CGRectGetHeight(frame)/10;
        UIView *addCoverImageBackground = [[UIView alloc] initWithFrame:CGRectMake(superViewWidth/15, superViewWidth/15, superViewWidth-2*superViewWidth/15, CGRectGetHeight(frame) - inputFieldHeight - 2*superViewWidth/15)];
        UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(superViewWidth/15, CGRectGetMaxY(addCoverImageBackground.frame) + superViewWidth/15, CGRectGetWidth(addCoverImageBackground.frame)*4/5, inputFieldHeight)];
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return self;
}

@end

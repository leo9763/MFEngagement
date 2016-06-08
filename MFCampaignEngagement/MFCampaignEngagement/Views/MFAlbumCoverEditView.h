//
//  MFAlbumCoverEditView.h
//  MFCampaignEngagement
//
//  Created by NeroMilk on 16/6/5.
//  Copyright © 2016年 MingFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JeniorAlbum;

@protocol MFAlbumCoverEditedProtocal <NSObject>

- (void)shouldReloadData;

@end

@interface MFAlbumCoverEditView : UIView
@property (nonatomic, assign) id<MFAlbumCoverEditedProtocal> delegate;

- (id)initWithFrame:(CGRect)frame currentViewController:(UIViewController *)currentViewController;

- (id)initWithAlbum:(JeniorAlbum *)album Frame:(CGRect)frame currentViewController:(UIViewController *)currentViewController;

@end

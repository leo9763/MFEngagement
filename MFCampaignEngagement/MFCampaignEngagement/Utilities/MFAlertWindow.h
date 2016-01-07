//
//  MFAlertWindow.h
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/27/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MFAlertWindowDelegate <NSObject>

@required
- (void)dismissWithClickedButtonIndex:(NSUInteger)index;

@end

@interface MFAlertWindow : UIWindow

@property (assign , nonatomic) id<MFAlertWindowDelegate> delegate;

+ (MFAlertWindow *)alertWindow;

- (void)showWithTitle:(NSString *)title message:(NSString *)message buttons:(NSString *)buttons,...;

@end

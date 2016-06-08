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

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)controller compeletedHandler:(void(^)(NSUInteger clickedIndex))handler buttonTitles:(NSString *)buttonTitles,...;

@end

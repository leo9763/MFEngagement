//
//  ChildhoodController.h
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/28/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChildhoodSex) {
    ChildhoodGirl,
    childhoodBoy,
};

@interface ChildhoodController : UIViewController

@property (nonatomic, assign) ChildhoodSex sex;

@end

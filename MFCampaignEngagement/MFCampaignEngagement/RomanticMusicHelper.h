//
//  RomanticMusicHelper.h
//  MFCampaignEngagement
//
//  Created by nero on 1/12/16.
//  Copyright © 2016 MingFung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RomanticMusicHelper : NSObject

@property (nonatomic, strong) NSMutableDictionary *musicsList;

+ (RomanticMusicHelper *)shareMusicHelper;
- (void)play;
- (void)resume;
- (void)stop;
- (void)showMusicsList;

@end

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
@property (nonatomic, assign) NSInteger currentTrack;
@property (nonatomic, assign) BOOL isPlaying;

+ (RomanticMusicHelper *)shareMusicHelper;
- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;
- (void)showMusicsList;

@end

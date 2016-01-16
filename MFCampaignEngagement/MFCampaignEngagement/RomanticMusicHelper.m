//
//  RomanticMusicHelper.m
//  MFCampaignEngagement
//
//  Created by nero on 1/12/16.
//  Copyright © 2016 MingFung. All rights reserved.
//

#import "RomanticMusicHelper.h"
#import "DirectoryWatcher.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

@interface RomanticMusicHelper () <DirectoryWatcherDelegate,AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) DirectoryWatcher *docWatcher;
@end

@implementation RomanticMusicHelper

+ (RomanticMusicHelper *)shareMusicHelper
{
    static RomanticMusicHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[RomanticMusicHelper alloc] init];
    });
    return shareInstance;
}

- (id)init
{
    self = [super init];

    _musicsList = [NSMutableDictionary dictionary];
    _docWatcher = [DirectoryWatcher watchFolderWithPath:[self applicationDocumentsDirectory] delegate:self];
    [self directoryDidChange:_docWatcher];
    _audioPlayer = [[AVAudioPlayer alloc] init];
    [_audioPlayer prepareToPlay];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    return self;
}

- (void)play
{
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[_musicsList objectForKey:_musicsList.allKeys[0]] error:nil];
    
}

- (void)resume
{
    
}

- (void)stop
{
    
}

- (void)showMusicsList
{
    
}

#pragma mark - Commond Method
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Delegate Method
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher
{
    [self.musicsList removeAllObjects];    // clear out the old docs and start over
    
    NSString *documentsDirectoryPath = [self applicationDocumentsDirectory];
    
    NSArray *documentsDirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath
                                                                                              error:NULL];
    
    for (NSString* curFileName in [documentsDirectoryContents objectEnumerator])
    {
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:curFileName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        BOOL isDirectory;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // proceed to add the document URL to our list (ignore the "Inbox" folder)
        if (!isDirectory)
        {
            [self.musicsList setObject:fileURL forKey:curFileName];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

}
@end



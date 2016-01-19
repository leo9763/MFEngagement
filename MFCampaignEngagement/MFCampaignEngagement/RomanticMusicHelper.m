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
@property (nonatomic, strong) dispatch_queue_t musicQueue;
@end

@implementation RomanticMusicHelper
@synthesize docWatcher = _docWatcher;

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
    
    NSArray *defaultMusics = @[@"Geu Dae Wa Na",@"Moonlight Shadow",@"Na Ppeun Yeo Ja Ya ",@"爱你"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *targetMusicsPath = [self applicationMusicsDirectory];
    
    //新建路径
    if (![fm fileExistsAtPath:targetMusicsPath]) {
        [fm createDirectoryAtPath:targetMusicsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //设置资源不上传到icloud及itunes的属性
    NSURL* URL= [NSURL fileURLWithPath: targetMusicsPath];
    NSError *error = nil;
    [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    //从包中复制到文档
    for (NSString *defaultMusic in defaultMusics)
    {
        NSString *originalMusicsPath = [[NSBundle mainBundle] pathForResource:defaultMusic ofType:@"mp3"];
        NSString *targetMusicPath = [targetMusicsPath stringByAppendingPathComponent:defaultMusic];
        [fm copyItemAtPath:originalMusicsPath toPath:targetMusicPath error:nil];
    }
    
    [self directoryDidChange:self.docWatcher];
    
    _isPlaying = NO;
    _currentTrack = 0;
    [self updatePlayer];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    return self;
}

#pragma mark - Control Method
- (void)play
{
    _isPlaying = YES;
    [self.audioPlayer play];
}

- (void)pause
{
    _isPlaying = NO;
    [self.audioPlayer pause];
}

- (void)resume
{
    [self play];
}

- (void)stop
{
    _isPlaying = NO;
    [self.audioPlayer stop];
}

- (void)next
{
    [self audioPlayerDidFinishPlaying:self.audioPlayer successfully:NO];
}

- (void)back
{
    _currentTrack--;
    _currentTrack = (_currentTrack >= 0)?_currentTrack:_musicsList.allKeys.count-1;
    [self updatePlayer];
    [self play];
}

- (void)showMusicsList
{
    
}

#pragma mark - Commond Method
- (NSString *)applicationMusicsDirectory
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Musics"];
}

- (void)updatePlayer
{
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[_musicsList objectForKey:_musicsList.allKeys[_currentTrack]] error:nil];
    [self.audioPlayer prepareToPlay];
    self.audioPlayer.delegate = self;
}

#pragma mark - Delegate Method
//监视指定路径，路径下的文件有增减更新时触发
- (void)directoryDidChange:(DirectoryWatcher *)folderWatcher
{
    [self.musicsList removeAllObjects];    // clear out the old docs and start over
    
    NSString *documentsDirectoryPath = [self applicationMusicsDirectory];
    
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

//播放器播完一首歌时触发
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _isPlaying = NO;
    _currentTrack++;
    
    if (_currentTrack >= _musicsList.allKeys.count) {
        _currentTrack = 0;
    }
    
    [self updatePlayer];
    [self performSelector:@selector(play) withObject:nil afterDelay:1];
}

#pragma mark - Getter&Setter
- (void)setDocWatcher:(DirectoryWatcher *)docWatcher
{
    if (_docWatcher != docWatcher) {
        _docWatcher = docWatcher;
    }
}

- (DirectoryWatcher *)docWatcher
{
    if (!_docWatcher) {
        _docWatcher = [DirectoryWatcher watchFolderWithPath:[self applicationMusicsDirectory] delegate:self];
    }
    return _docWatcher;
}

- (NSMutableDictionary *)musicsList
{
    if (!_musicsList) {
        _musicsList = [NSMutableDictionary dictionary];
    }
    return _musicsList;
}

@end



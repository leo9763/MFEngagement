//
//  MFAlertWindow.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/27/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "MFAlertWindow.h"
#import "MFMacro.h"

@interface MFAlertWindow()
@property UIAlertController *alert;
@end

@implementation MFAlertWindow

static uint windowLevel = 0;

+ (MFAlertWindow *)alertWindow
{
    MFAlertWindow *instance = [[MFAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    instance.windowLevel = UIWindowLevelAlert;
    
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message buttons:(NSString *)buttons,...
{
    _alert.title = title;
    _alert.message = message;
    WS(weakSelf)
    va_list buttonList;
    va_start(buttonList, buttons);
    __block int buttonIndex = 0;
    for (NSString *button = buttons; button != nil; button = va_arg(buttonList, NSString *)) {
        int index = buttonIndex;
        UIAlertAction *action = [UIAlertAction actionWithTitle:button style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([weakSelf.delegate respondsToSelector:@selector(dismissWithClickedButtonIndex:)]) {
                weakSelf.hidden = YES;
                [weakSelf resignKeyWindow];
                [weakSelf.delegate dismissWithClickedButtonIndex:index];
            }
        }];
        buttonIndex++;
        [_alert addAction:action];
    }
    va_end(buttonList);
    self.rootViewController = _alert;
    [self makeKeyWindow];
    [self makeKeyAndVisible];
}

@end

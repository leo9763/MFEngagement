//
//  ChildhoodController.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/28/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "JeniorController.h"
#import "Masonry.h"
#import "MFMacro.h"
#import "DGAaimaView.h"

@interface JeniorController ()  <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation JeniorController
@synthesize backButton,imagePickerController;

- (void)setupView
{
    //不设置该背景颜色则会在push的动画中出现卡顿
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    //设置navigationBar为半透明(模糊)效果
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImage)];
    
    DGAaimaView *animaView = [[DGAaimaView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:animaView];
    [animaView DGAaimaView:animaView BigCloudSpeed:1.5 smallCloudSpeed:1 earthSepped:1.0 huojianSepped:2.0 littleSpeed:2];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
}

#pragma mark - Response
- (void)buttonPressed:(UIButton *)button
{
    if (button == backButton) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)itemPressed:(UIBarButtonItem *)buttonItem
{
    if (buttonItem == self.navigationItem.leftBarButtonItem) {
        DLog(@"返回按钮被按");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (buttonItem  == self.navigationItem.rightBarButtonItem) {
        DLog(@"添加图片按钮被按");
        
    }
}

- (void)addImage
{
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark - Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker == self.imagePickerController) {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(imagePickerController:didFinishPickingMediaWithInfo:), nil);
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Getters & Setters
- (void)setBackButton:(UIButton *)aBackButton
{
    if (backButton != aBackButton) {
        backButton = aBackButton;
    }
}

- (UIButton *)backButton
{
    if (!backButton) {
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return backButton;
}

- (UIImagePickerController *)imagePickerController
{
    if (!imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;        
    }
    return imagePickerController;
}

@end

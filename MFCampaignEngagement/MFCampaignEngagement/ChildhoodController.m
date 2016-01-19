//
//  ChildhoodController.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 12/28/15.
//  Copyright © 2015 MingFung. All rights reserved.
//

#import "ChildhoodController.h"
#import "Masonry.h"
#import "MFMacro.h"

@interface ChildhoodController ()  <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation ChildhoodController
@synthesize backButton,imagePickerController;

- (void)setupView
{
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    //设置navigationBar为半透明(模糊)效果
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImage)];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    WS(weakSelf)
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
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

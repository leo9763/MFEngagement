//
//  MFAlbumCoverEditView.m
//  MFCampaignEngagement
//
//  Created by NeroMilk on 16/6/5.
//  Copyright © 2016年 MingFung. All rights reserved.
//

#import "MFAlbumCoverEditView.h"
#import "MFMacro.h"
#import "MagicalRecord.h"
#import "JeniorAlbum.h"
#import "MFAlertWindow.h"
#import "MFImageHelper.h"

@interface MFAlbumCoverEditView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIImageView *previewCoverImageView;
@property (nonatomic, retain) UIView *previewCoverImageViewBackground;
@property (nonatomic, assign) UIViewController *currentViewController;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) NSString *originalArea;

@end

@implementation MFAlbumCoverEditView

- (id)initWithFrame:(CGRect)frame currentViewController:(UIViewController *)currentViewController
{
    if (self = [super initWithFrame:frame]) {
        
        self.currentViewController = currentViewController;

        CGRect removeBarHeightRect = CGRectMake(frame.origin.x, frame.origin.y + NAVIGATION_BAR_HEIGHT, frame.size.width, frame.size.height - NAVIGATION_BAR_HEIGHT);
        NSUInteger superViewWidth = CGRectGetWidth(removeBarHeightRect);
        NSUInteger inputFieldHeight = CGRectGetHeight(removeBarHeightRect)/10;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
        
        UIView *addCoverImageBackground = [[UIView alloc] initWithFrame:CGRectMake(superViewWidth/15, superViewWidth/15 + NAVIGATION_BAR_HEIGHT, superViewWidth-2*superViewWidth/15, CGRectGetHeight(removeBarHeightRect) - inputFieldHeight - 3*superViewWidth/15)];
        addCoverImageBackground.backgroundColor = [UIColor grayColor];
        addCoverImageBackground.layer.cornerRadius = 10.0;
        [self drawRoundedRectAndDottedLineWithView:addCoverImageBackground];
        [_backgroundView addSubview:addCoverImageBackground];
        
        UIButton *addCoverImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addCoverImageButton setImage:[UIImage imageNamed:@"button_addImage"] forState:UIControlStateNormal];
        [addCoverImageButton addTarget:self action:@selector(didTapAddCoverImageButton:) forControlEvents:UIControlEventTouchUpInside];
        addCoverImageButton.frame = CGRectMake(0, 0, superViewWidth/10, superViewWidth/10);
        addCoverImageButton.center = addCoverImageBackground.center;
        [_backgroundView addSubview:addCoverImageButton];
        
        _previewCoverImageViewBackground = [[UIView alloc] initWithFrame:addCoverImageBackground.bounds];
        _previewCoverImageViewBackground.hidden = YES;
        _previewCoverImageViewBackground.center = addCoverImageBackground.center;
        _previewCoverImageViewBackground.layer.cornerRadius = 10.0;
        _previewCoverImageViewBackground.backgroundColor = [UIColor lightGrayColor];
        [_backgroundView addSubview:_previewCoverImageViewBackground];
        
        _previewCoverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_previewCoverImageViewBackground.frame)-20, CGRectGetHeight(_previewCoverImageViewBackground.frame)-20)];
        _previewCoverImageView.userInteractionEnabled = YES;
        [_previewCoverImageViewBackground addSubview:_previewCoverImageView];
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        removeButton.frame = CGRectMake(CGRectGetWidth(_previewCoverImageView.frame) - superViewWidth/20 - 5, 0, superViewWidth/20, superViewWidth/20);
        [removeButton setImage:[UIImage imageNamed:@"button_redCancel"] forState:UIControlStateNormal];
        [removeButton addTarget:self action:@selector(didTapRemoveCoverButton:) forControlEvents:UIControlEventTouchUpInside];
        [_previewCoverImageView addSubview:removeButton];
        
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(superViewWidth/15, CGRectGetMaxY(addCoverImageBackground.frame) + superViewWidth/15, CGRectGetWidth(addCoverImageBackground.frame)*3.5/5, inputFieldHeight)];
        _inputField.backgroundColor = [UIColor whiteColor];
        _inputField.layer.cornerRadius = 5.0;
        _inputField.delegate = self;
        [_backgroundView addSubview:_inputField];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishButton setImage:[UIImage imageNamed:@"button_greenOK"] forState:UIControlStateNormal];
        finishButton.frame = CGRectMake(CGRectGetMaxX(_inputField.frame)+superViewWidth/15, CGRectGetMinY(_inputField.frame), inputFieldHeight, inputFieldHeight);
        [finishButton addTarget:self action:@selector(didTapFinishButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundView addSubview:finishButton];
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return self;
}

- (id)initWithAlbum:(JeniorAlbum *)album Frame:(CGRect)frame currentViewController:(UIViewController *)currentViewController
{
    if (self = [self initWithFrame:frame currentViewController:currentViewController]) {
        self.isEditing = YES;
        self.originalArea = self.inputField.text = album.area;
        self.selectedImage = [UIImage imageWithContentsOfFile:album.coverImage];
        [MFImageHelper adaptImageView:self.previewCoverImageView withImage:self.selectedImage];
        _previewCoverImageView.image = self.selectedImage;
    }
    return self;
}

#pragma mark - Response
- (void)didTapFinishButton:(id)sender
{
    if (_isEditing) {
        
        //查询
        NSArray *albums = [NSMutableArray arrayWithArray:[JeniorAlbum MR_findByAttribute:@"area" withValue:self.originalArea]];
        
        if (albums.count == 1) {
            JeniorAlbum *album = albums[0];

            NSDate *date = [NSDate date];
            NSTimeInterval timestamp = [date timeIntervalSince1970];
            NSString *coverImageName = [NSString stringWithFormat:@"%ld",(NSUInteger)timestamp];
            NSString *imageName = [self saveImageToSandboxWithImageName:coverImageName];
            
            if (imageName) {
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm removeItemAtPath:album.coverImage error:nil];
                
                album.area = self.inputField.text;
                album.coverImage = imageName;
                //保存
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                self.hidden = YES;
                if ([_delegate respondsToSelector:@selector(shouldReloadData)]) {
                    [_delegate shouldReloadData];
                }
            }
        }
        
    } else {
        
        //查询
        NSArray *albums = [NSMutableArray arrayWithArray:[JeniorAlbum MR_findByAttribute:@"area" withValue:self.inputField.text]];
        if (albums.count > 0) {
            
            [MFAlertWindow showAlertWithTitle:@"提示" message:@"这相册名称存在了喔，来来来，改个更有新意滴～" controller:self.currentViewController compeletedHandler:^(NSUInteger clickedIndex) {
                [self resumeViewY];
            } buttonTitles:@"好哒",nil];
            
            return;
        }
        
        NSDate *date = [NSDate date];
        NSTimeInterval timestamp = [date timeIntervalSince1970];
        NSString *coverImageName = [NSString stringWithFormat:@"%ld",(NSUInteger)timestamp];
        NSString *imageName = [self saveImageToSandboxWithImageName:coverImageName];
        
        if (imageName) {
            //初始化core data 数据库
            [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.sqlite"];
            
            //创建
            JeniorAlbum *album = [JeniorAlbum MR_createEntity];
            album.area = _inputField.text;
            album.photos = @[];
            album.date = date;
            album.isExpend = NO;
            album.coverImage = imageName;
            
            //保存
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            self.hidden = YES;
            if ([_delegate respondsToSelector:@selector(shouldReloadData)]) {
                [_delegate shouldReloadData];
            }
        }
    }
    
    self.selectedImage = nil;
    self.previewCoverImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_previewCoverImageViewBackground.frame)-20, CGRectGetHeight(_previewCoverImageViewBackground.frame)-20);
    self.inputField.text = @"";
}

- (void)didTapAddCoverImageButton:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
    [self.currentViewController presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)didTapRemoveCoverButton:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        _previewCoverImageViewBackground.alpha = 0;
    } completion:^(BOOL finished) {
        _previewCoverImageViewBackground.alpha = 1;
        _previewCoverImageViewBackground.hidden = YES;
        self.selectedImage = nil;
        self.previewCoverImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_previewCoverImageViewBackground.frame)-20, CGRectGetHeight(_previewCoverImageViewBackground.frame)-20);
    }];
}

#pragma mark - Private
//保存封面圖片
- (NSString *)saveImageToSandboxWithImageName:(NSString *)imageName
{
    if (imageName.length > 0) {
        if (_selectedImage) {
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self.selectedImage)];
            NSString *coverImagePath = GET_LIBARY_PATH(imageName);
            [imageData writeToFile:coverImagePath atomically:NO];
            return imageName;
        } else {
            [MFAlertWindow showAlertWithTitle:@"提示" message:@"亲，请上传一张封面照嘛～" controller:self.currentViewController compeletedHandler:^(NSUInteger clickedIndex) {
                [self resumeViewY];
            } buttonTitles:@"好哒",nil];
            return nil;
        }
    } else {
        return @"";
    }
}

//画圆角虚线
- (void)drawRoundedRectAndDottedLineWithView:(UIView *)view
{
    float h = view.bounds.size.height;
    float w = view.bounds.size.width;
    
    CGRect boardRect = CGRectMake(+5, +5, w-10, h-10);
    UIBezierPath *maskPath = [[UIBezierPath bezierPathWithRoundedRect:boardRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)] bezierPathByReversingPath];
    
    for (CALayer *layer in view.layer.sublayers) {
        if ([layer.name isEqualToString:@"maskLayer"]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.name = @"maskLayer";
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    maskLayer.lineDashPattern = @[@4, @2];//画虚线
    maskLayer.lineWidth = 1.0f;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.masksToBounds = YES;
    
    [view.layer insertSublayer:maskLayer atIndex:0];
}

#pragma mark - Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImage = image;
    
    [MFImageHelper adaptImageView:self.previewCoverImageView withImage:self.selectedImage];
    _previewCoverImageView.center = CGPointMake(_previewCoverImageViewBackground.frame.size.width/2, _previewCoverImageViewBackground.frame.size.height/2);
    
    _previewCoverImageView.image = self.selectedImage;
    _previewCoverImageViewBackground.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    float superViewWidth = CGRectGetWidth(self.frame);
    
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.frame = CGRectMake(CGRectGetMinX(_backgroundView.frame), 0 - CGRectGetHeight(self.frame) + 8*superViewWidth/15 + 4*CGRectGetHeight(_inputField.frame), CGRectGetWidth(_backgroundView.frame), CGRectGetHeight(_backgroundView.frame));
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resumeViewY];
}

- (void)resumeViewY
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.frame = CGRectMake(CGRectGetMinX(_backgroundView.frame), 0, CGRectGetWidth(_backgroundView.frame), CGRectGetHeight(_backgroundView.frame));
    }];
}

@end

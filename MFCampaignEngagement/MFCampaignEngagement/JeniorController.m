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
#import "EasyTableView.h"
#import "MagicalRecord.h"
#import "JeniorAlbum.h"
#import "MFAlbumCoverEditView.h"


#define HORIZONTAL_TABLEVIEW_HEIGHT	[UIScreen mainScreen].bounds.size.height/4
#define VERTICAL_TABLEVIEW_WIDTH	[UIScreen mainScreen].bounds.size.height/5
#define CELL_BACKGROUND_COLOR		[[UIColor greenColor] colorWithAlphaComponent:0.15]

#define BORDER_VIEW_TAG				10

//http://www.cnblogs.com/YouXianMing/p/5010104.html 收纳table动画效果


@interface JeniorController ()  <UINavigationControllerDelegate,UIImagePickerControllerDelegate,DGEarthViewDidTapDelegate,EasyTableViewDelegate>
{
    NSIndexPath *_selectedHorizontalIndexPath;
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) EasyTableView *tableView;
@property (nonatomic, strong) NSMutableArray *myAlbums;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) MFAlbumCoverEditView *albumCoverEditView;
@end

@implementation JeniorController
@synthesize backButton,imagePickerController;

- (void)setupView
{
    //不设置该背景颜色则会在push的动画中出现卡顿
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使navigation不遮挡view，且view的大小不算上navigation面积（xib没有设置项）
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    //设置navigationBar为透明效果
    //方法1
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //方法2
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    DGAaimaView *animaView = [[DGAaimaView alloc] initWithFrame:self.view.bounds delegate:self];
    [self.view addSubview:animaView];
    [animaView DGAaimaView:animaView BigCloudSpeed:1.5 smallCloudSpeed:1 earthSepped:1.0 huojianSepped:2.0 littleSpeed:2];
    
    CGRect frameRect = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), HORIZONTAL_TABLEVIEW_HEIGHT);
    self.tableView = [[EasyTableView alloc] initWithFrame:frameRect ofWidth:VERTICAL_TABLEVIEW_WIDTH];
    
    self.tableView.delegate	= self;
    self.tableView.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableView.allowsSelection = YES;
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableView.separatorColor	= [UIColor darkGrayColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.tableView];
}

- (void)setupData
{
    //初始化core data 数据库
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Model.sqlite"];
    
    //创建
//    self.myAlbums = [NSMutableArray array];
//    NSArray *areas = @[@"Russia",@"Thailand",@"Korea"];
//    for (NSString *area in areas) {
//        JeniorAlbum *album = [JeniorAlbum MR_createEntity];
//        album.area = area;
//        album.photos = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
//        album.date = [NSDate date];
//        [_myAlbums addObject:album];
//    }
    
    //查询
    self.myAlbums = [NSMutableArray arrayWithArray:[JeniorAlbum MR_findAll]];
    
    //删除
//    for (JeniorAlbum *album in self.myAlbums) {
//        [album MR_deleteEntity];
//    }
    
    //保存
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    [self setupData];
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

- (void)albumSectionDidTap:(id)sender
{
    UIView *backgroundView = (UIView *)sender;
    NSUInteger section = backgroundView.tag;
    JeniorAlbum *album = _myAlbums[section];
    
    if (album.isExpend == YES) {
        
        // 缩回去
        album.isExpend = NO;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < [album.photos count]+1; i++) {
            
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    } else {
        
        // 显示出来
        album.isExpend = YES;
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < [album.photos count]+1; i++) {
            
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
        }
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addAlbumSectionDidTap:(id)sender
{
//    [self presentViewController:self.imagePickerController animated:YES completion:^{}];
    [self.view addSubview:self.albumCoverEditView];
}

#pragma mark - Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker == self.imagePickerController) {
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(imagePickerController:didFinishPickingMediaWithInfo:), nil);
    }
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didTapInEarthView:(id)sender
{
    CGRect or = self.tableView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        if (!_isShow) {
            self.tableView.frame = CGRectMake(CGRectGetMinX(or), CGRectGetMinY(or)-CGRectGetHeight(or), CGRectGetWidth(or), CGRectGetHeight(or));
            _isShow = YES;
        } else {
            self.tableView.frame = CGRectMake(CGRectGetMinX(or), CGRectGetMinY(or)+CGRectGetHeight(or), CGRectGetWidth(or), CGRectGetHeight(or));
            _isShow = NO;
        }
    }];
}

#pragma mark - TableView Delegate
// These delegate methods support both example views - first delegate method creates the necessary views
- (UITableViewCell *)easyTableView:(EasyTableView *)easyTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EasyTableViewCell";
    
    UITableViewCell *cell = [easyTableView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label;
    
    if (cell == nil) {
        // Create a new table view cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = CELL_BACKGROUND_COLOR;
        cell.backgroundColor = [UIColor clearColor];
        
        CGRect labelRect		= CGRectMake(10, 10, cell.contentView.frame.size.width-20, cell.contentView.frame.size.height-20);
        label        			= [[UILabel alloc] initWithFrame:labelRect];
        label.autoresizingMask  = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        label.textAlignment		= NSTextAlignmentCenter;
        label.textColor			= [UIColor whiteColor];
        label.font				= [UIFont boldSystemFontOfSize:60];
        
        // Use a different color for the two different examples
        label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        
        UIImageView *borderView		= [[UIImageView alloc] initWithFrame:label.bounds];
        borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        borderView.tag				= BORDER_VIEW_TAG;
        
        [label addSubview:borderView];
        
        [cell.contentView addSubview:label];
    }
    else {
        label = cell.contentView.subviews[0];
    }
    
    // Populate the views with data from a data source
    if (indexPath.row == [[_myAlbums[indexPath.section] photos] count]) {
        label.text = @"+";
    } else {
        label.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    }
    
    // selectedIndexPath can be nil so we need to test for that condition
    
    NSIndexPath * selectedIndexPath = _selectedHorizontalIndexPath;
    BOOL isSelected = selectedIndexPath ? ([selectedIndexPath compare:indexPath] == NSOrderedSame) : NO;
    [self borderIsSelected:isSelected forView:label];
    
    return cell;
}

// Optional delegate to track the selection of a particular cell

- (UIView *)viewForIndexPath:(NSIndexPath *)indexPath easyTableView:(EasyTableView *)tableView {
    UITableViewCell * cell	= [tableView.tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.subviews[0];
}

- (void)easyTableView:(EasyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *__strong* selectedIndexPath = &_selectedHorizontalIndexPath;
    
    if (selectedIndexPath)
        [self borderIsSelected:NO forView:[self viewForIndexPath:*selectedIndexPath easyTableView:tableView]];
    
    *selectedIndexPath = indexPath;
    UILabel * label	= (UILabel *)[self viewForIndexPath:*selectedIndexPath easyTableView:tableView];
    [self borderIsSelected:YES forView:label];
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
- (NSInteger)easyTableView:(EasyTableView *)easyTableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == _myAlbums.count) {
        return 0;
    }
    
    JeniorAlbum *album = _myAlbums[section];
    
    if (album.isExpend == YES) {

        return [album.photos count]+1;
        
    } else {
        
        return 0;
    }
}

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView {
    return _myAlbums.count+1;
}

// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == _myAlbums.count) {
        UIButton *addAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
        [addAlbum setBackgroundColor:[UIColor greenColor]];
        [addAlbum addTarget:self action:@selector(addAlbumSectionDidTap:) forControlEvents:UIControlEventTouchUpInside];
        addAlbum.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH/1.5, HORIZONTAL_TABLEVIEW_HEIGHT);        
        return addAlbum;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH/1.5, HORIZONTAL_TABLEVIEW_HEIGHT)];
    backgroundView.backgroundColor = UIColorFromRGBWithAlpha(0x242424,0.9);
    
    UIImageView *rightArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageView_rightArrow"]];
    rightArrowImageView.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH/4, VERTICAL_TABLEVIEW_WIDTH/4);
    rightArrowImageView.center = CGPointMake(CGRectGetMidX(backgroundView.frame), rightArrowImageView.center.y);
    [backgroundView addSubview:rightArrowImageView];
    
    UIButton *previewImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [previewImageView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [previewImageView setBackgroundColor:[UIColor redColor]];
    [previewImageView addTarget:self action:@selector(albumSectionDidTap:) forControlEvents:UIControlEventTouchUpInside];
    previewImageView.tag = section;
    previewImageView.frame = CGRectMake(3, VERTICAL_TABLEVIEW_WIDTH/4+3, VERTICAL_TABLEVIEW_WIDTH/1.5 - 6, HORIZONTAL_TABLEVIEW_HEIGHT - VERTICAL_TABLEVIEW_WIDTH/4 - 6);
    [backgroundView addSubview:previewImageView];
    
    return backgroundView;
}

- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view {
    UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
    NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
    borderView.image			= [UIImage imageNamed:borderImageName];
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

- (MFAlbumCoverEditView *)albumCoverEditView
{
    if (!_albumCoverEditView) {
        _albumCoverEditView = [[MFAlbumCoverEditView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _albumCoverEditView;
}

@end

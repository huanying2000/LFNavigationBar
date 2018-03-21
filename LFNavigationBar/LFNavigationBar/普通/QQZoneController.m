//
//  QQZoneController.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/20.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "QQZoneController.h"
#import "LFNavigationBar.h"
#import "AppDelegate.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT*2)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 260
#define SCROLL_DOWN_LIMIT 100
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface QQZoneController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation QQZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    self.title = @"qq空间";
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - 64, 0, 0, 0);
    [self.tableView addSubview:self.imgView];
    [self.view addSubview:self.tableView];
    
    [self lf_setNavBarBackgroundAlpha:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self lf_setNavBarBackgroundAlpha:alpha];
    }else {
        [self lf_setNavBarBackgroundAlpha:0];
    }
    
    //限制下拉距离
    if (offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT) {
        self.imgView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    NSString *str = [NSString stringWithFormat:@"LFNavigationBar %zd",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = MainViewColor;
    NSString *str = [NSString stringWithFormat:@"LFNavigationBar %zd",indexPath.row];
    vc.title = str;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter / setter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT)];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.clipsToBounds = YES;
        _imgView.image = [self imageWithImageSimple:[UIImage imageNamed:@"image6"] scaledToSize:CGSizeMake(kScreenWidth, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
    }
    return _imgView;
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return newImage;
}


@end

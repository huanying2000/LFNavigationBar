//
//  QQAppController.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/20.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "QQAppController.h"
#import "LFNavigationBar.h"
#import "AppDelegate.h"

#define NAVBAR_COLORCHANGE_POINT -80
#define IMAGE_HEIGHT 260
#define SCROLL_DOWN_LIMIT 100
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface QQAppController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation QQAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.title = @"qq应用";
    //contentInset 设置除具体内容以外的边框尺寸 同时影响contentOffset 如果为正  contentOffset就相应下滑一定距离
    //在有NAvigationController的情况下 默认UIEdgeInsetsMake(64, 0, 0, 0) 也就是会在你设置的基础上加64
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-64, 0, 0, 0);
    [self.tableView addSubview:self.imgView];
    [self.view addSubview:self.tableView];
    [self lf_setNavBarBackgroundAlpha:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        [self changeNavBarAnimateWithIsClear:NO];
    }else {
        [self changeNavBarAnimateWithIsClear:YES];
    }
    
    //限制下拉距离
    if (offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    
    //改变图片框的大小(上滑的时候不变)
    //这里不能使用offsetY 因为当(offsetY < LIMIT_OFFSET_Y)的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT) {
        self.imgView.frame = CGRectMake(0, newOffsetY, kScreenWidth, -newOffsetY);
    }
}

- (void)changeNavBarAnimateWithIsClear:(BOOL)isClear {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.6 animations:^
     {
         __strong typeof(self) pThis = weakSelf;
         if (isClear == YES) {
             [pThis lf_setNavBarBackgroundAlpha:0];
         } else {
             [pThis lf_setNavBarBackgroundAlpha:1.0];
         }
     }];
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

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        _imgView.image = [self imageWithImageSimple:[UIImage imageNamed:@"image3"] scaledToSize:CGSizeMake(kScreenWidth, IMAGE_HEIGHT+SCROLL_DOWN_LIMIT)];
    }
    return _imgView;
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end

/**
 
 
 最新随笔
 
 最新评论
 iOS中UIImageView的填充模式
 Posted on 2015-10-15 22:15 请叫我ios-alloc 阅读(269) 评论(0) 编辑 收藏
 
 UIImageView的填充模式
 
 属性名称 imageV.contentMode
 枚举属性：
 
 @"UIViewContentModeScaleToFill",      // 拉伸自适应填满整个视图
 @"UIViewContentModeScaleAspectFit",   // 自适应比例大小显示
 @"UIViewContentModeScaleAspectFill",  // 原始大小显示
 @"UIViewContentModeRedraw",           // 尺寸改变时重绘
 @"UIViewContentModeCenter",           // 中间
 @"UIViewContentModeTop",              // 顶部
 @"UIViewContentModeBottom",           // 底部
 @"UIViewContentModeLeft",             // 中间贴左
 @"UIViewContentModeRight",            // 中间贴右
 @"UIViewContentModeTopLeft",          // 贴左上
 @"UIViewContentModeTopRight",         // 贴右上
 @"UIViewContentModeBottomLeft",       // 贴左下
 @"UIViewContentModeBottomRight",      // 贴右下
 **/




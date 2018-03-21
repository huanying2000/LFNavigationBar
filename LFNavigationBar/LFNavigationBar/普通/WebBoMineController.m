//
//  WebBoMineController.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/20.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "WebBoMineController.h"
#import "LFNavigationBar.h"
#import "AppDelegate.h"


#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64

/*
 *iOS7 以前
 *tintColor 设置navigationBar和navigationItem的颜色 navigationItem里面的字体默认为白色，如果想修改navigationItem字体颜色，需要自定义给navigationItem
 *iOS7 之后(新增barTintColor属性)
 *tintColor 不再是以前的设置navigationBar和navigationItem的颜色，而是变成了只修改navigationItem里面的字体颜色。
 *barTintColor 设置navigationBar和navigationItem的颜色 由于iOS7的navigationItem以文字的方式体现，默认为蓝色，所以barTintColor看似乎对navigationItem无效
 */


@interface WebBoMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *topView;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *fansLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation WebBoMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"";
    [self.view addSubview:self.tableView];
    [self.topView addSubview:self.iconView];
    self.iconView.center = CGPointMake(self.topView.center.x, self.topView.center.y - 10);
    [self.topView addSubview:self.nameLabel];
    self.nameLabel.frame = CGRectMake(0, self.iconView.frame.size.height + self.iconView.frame.origin.y + 6, self.view.frame.size.width, 19);
    [self.topView addSubview:self.fansLabel];
    self.fansLabel.frame = CGRectMake(0, self.nameLabel.frame.origin.y + 19 + 5, self.view.frame.size.width, 16);
    [self.topView addSubview:self.detailLabel];
    self.detailLabel.frame = CGRectMake(0, self.fansLabel.frame.origin.y + 16 + 5, self.view.frame.size.width, 15);
    self.tableView.tableHeaderView = self.topView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"··· " style:UIBarButtonItemStyleDone target:self action:nil];
    /*
     如果这个页面不在黑名单内 会在UINavigationBar 的_UIBarBackground 添加一个UIView 并给上背景色NavBarBarTintColor
     */
    //设置导航栏的颜色(不是系统的UINavigationBar) 是一个UIView
    [self lf_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    //设置初始导航栏的透明度
    [self lf_setNavBarBackgroundAlpha:0];
    //设置导航栏按钮和标题的颜色
    [self lf_setNavBarTintColor:[UIColor whiteColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y; //向上滑动 offsetY 增加
//    NSLog(@"%.f",offsetY);
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self lf_setNavBarBackgroundAlpha:alpha];
        [self lf_setNavBarTintColor:[UIColor blackColor]];
        [self lf_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self lf_setStatusBarStyle:UIStatusBarStyleDefault];
        self.title = @"wangrui460";
    }else {
        [self lf_setNavBarBackgroundAlpha:0];
        [self lf_setNavBarTintColor:[UIColor whiteColor]];
        [self lf_setNavBarTitleColor:[UIColor whiteColor]];
        [self lf_setStatusBarStyle:UIStatusBarStyleLightContent];
        self.title = @"";
    }
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
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
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(-[self navBarBottom], 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)topView
{
    if (_topView == nil) {
        _topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wbBG"]];
        _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, IMAGE_HEIGHT);
    }
    return _topView;
}

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image5"]];
        _iconView.bounds = CGRectMake(0, 0, 80, 80);
        _iconView.layer.cornerRadius = 40;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"天神460";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nameLabel;
}

- (UILabel *)fansLabel
{
    if (_fansLabel == nil) {
        _fansLabel = [UILabel new];
        _fansLabel.backgroundColor = [UIColor clearColor];
        _fansLabel.textColor = [UIColor whiteColor];
        _fansLabel.text = @"关注 121  |  粉丝 117";
        _fansLabel.textAlignment = NSTextAlignmentCenter;
        _fansLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fansLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [UILabel new];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.text = @"简介:丽人丽妆公司，熊猫美妆APP iOS工程师";
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}

- (int)navBarBottom
{
    if ([LFNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

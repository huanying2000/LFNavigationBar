//
//  AllTransparent.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/20.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "AllTransparent.h"
#import "LFNavigationBar.h"
#import "AppDelegate.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 220
#define NAV_HEIGHT 64

@interface AllTransparent ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topView;

@end

@implementation AllTransparent

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"wangrui460";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"··· " style:UIBarButtonItemStyleDone target:self action:nil];
    
    // 设置导航栏颜色
    [self lf_setNavBarBarTintColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    // 设置初始导航栏透明度
    [self lf_setNavBarBackgroundAlpha:0];
    
    // 设置导航栏按钮和标题颜色
    [self lf_setNavBarTintColor:[UIColor greenColor]];
    [self lf_setNavBarTitleColor:[UIColor yellowColor]];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self lf_setNavBarBackgroundAlpha:alpha];
        [self lf_setNavBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self lf_setNavBarTitleColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self lf_setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [self lf_setNavBarBackgroundAlpha:0];
        [self lf_setNavBarTintColor:[UIColor greenColor]];
        [self lf_setNavBarTitleColor:[UIColor yellowColor]];
        [self lf_setStatusBarStyle:UIStatusBarStyleLightContent];
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
    AllTransparent *allTransparent = [AllTransparent new];
    [self.navigationController pushViewController:allTransparent animated:YES];
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

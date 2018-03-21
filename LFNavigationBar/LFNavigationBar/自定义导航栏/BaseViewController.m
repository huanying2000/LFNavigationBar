//
//  BaseViewController.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/21.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "LFNavigationBar.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
}

- (void)setupNavBar
{
    [self.view addSubview:self.customNavBar];
    
    // 设置自定义导航栏背景图片
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"millcolorGrad"];
    
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar setLeftButtonWithTitle:@"<<" titleColor:[UIColor whiteColor]];
    }
}

- (LFCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [LFCustomNavigationBar customNavigationBar];
    }
    return _customNavBar;
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

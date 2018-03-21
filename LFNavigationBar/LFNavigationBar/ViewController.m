//
//  ViewController.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"首页";
    
}


- (void)test {
    SecondViewController *sec = [[SecondViewController alloc] init];
    sec.title = @"第二页";
    [self.navigationController pushViewController:sec animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  UIImage+LFHelper.h
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LFHelper)

- (UIImage *)updateImageWithTintColor:(UIColor *)color;

- (UIImage *)updateImageWithTintColor:(UIColor *)color alpha:(CGFloat)alpha;

- (UIImage *)updateImageWithTintColor:(UIColor *)color rect:(CGRect)rect;

- (UIImage *)updateImageWithTintColor:(UIColor *)color insets:(UIEdgeInsets)insets;

-(UIImage *)updateImageWithTintColor:(UIColor*)color alpha:(CGFloat)alpha insets:(UIEdgeInsets)insets;

-(UIImage *)updateImageWithTintColor:(UIColor*)color alpha:(CGFloat)alpha rect:(CGRect)rect;


@end

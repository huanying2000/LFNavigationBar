//
//  UIImage+LFHelper.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import "UIImage+LFHelper.h"

@implementation UIImage (LFHelper)

- (UIImage *)updateImageWithTintColor:(UIColor *)color {
    return [self updateImageWithTintColor:color alpha:1.0];
}


- (UIImage *)updateImageWithTintColor:(UIColor *)color alpha:(CGFloat)alpha {
    CGRect rect = CGRectMake(.0f, .0f, self.size.width, self.size.height);
    return [self updateImageWithTintColor:color alpha:alpha rect:rect];
}


- (UIImage *)updateImageWithTintColor:(UIColor *)color rect:(CGRect)rect {
    return [self updateImageWithTintColor:color alpha:1.0 rect:rect];
}

- (UIImage *)updateImageWithTintColor:(UIColor *)color insets:(UIEdgeInsets)insets {
    return [self updateImageWithTintColor:color alpha:1.0f insets:insets];
}

- (UIImage *)updateImageWithTintColor:(UIColor *)color alpha:(CGFloat)alpha insets:(UIEdgeInsets)insets {
    CGRect originRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect tintImageRect = UIEdgeInsetsInsetRect(originRect, insets);
    return [self updateImageWithTintColor:color alpha:alpha rect:tintImageRect];
}


//全能初始化方法
- (UIImage *)updateImageWithTintColor:(UIColor *)color alpha:(CGFloat) alpha rect:(CGRect)rect {
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    //启动图片上下文
    //第一个参数:指定将来创建出来的bitMap的大小。Bitmap叫做位图，每一个像素点由1－32bit组成。每个像素点包括多个颜色组件和一个Alpha组件（例如：RGBA
    //第二个参数:设置透明 YES代表透明 NO 代表不透明
    //第三个参数:代表缩放 0代表不缩放
    UIGraphicsBeginImageContextWithOptions(imageRect.size,              NO, self.scale);
    //获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //利用DrawInRect方法绘制图片到layer 是通过拉伸原有图片
    [self drawInRect:imageRect];
    //设置图像上下文的填充颜色
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    //设置图形上下文的透明度
    CGContextSetAlpha(contextRef, alpha);
    //设置混合模式
    CGContextSetBlendMode(contextRef, kCGBlendModeSourceAtop);
    //填充当前rect
    CGContextFillRect(contextRef, rect);
    // 根据位图上下文创建一个CGImage图片，并转换成UIImage
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *tintedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    // 释放 imageRef，否则内存泄漏
    CGImageRelease(imageRef);
    // 从堆栈的顶部移除图形上下文
    UIGraphicsEndImageContext();
    
    return tintedImage;
    
}


@end

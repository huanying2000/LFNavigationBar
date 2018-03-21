//
//  LFNavigationBar.h
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFCustomNavigationBar;

@interface LFNavigationBar : UIView

+ (BOOL)isIphoneX;
+ (CGFloat)navBarBottom;
+ (CGFloat)tabbarHeight;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
@end


#pragma mark - Default
@interface LFNavigationBar (LFDefault)


+ (void)lf_widely;

/// 广泛使用该库时，设置需要屏蔽的控制器
+ (void)lf_setBlacklist:(NSArray<NSString *> *)list;

/** set default barTintColor of UINavigationBar */
+ (void)lf_setDefaultNavBarBarTintColor:(UIColor *)color;
/** set default tintColor of UINavigationBar */
+ (void)lf_setDefaultNavBarTintColor:(UIColor *)color;

/** set default titleColor of UINavigationBar */
+ (void)lf_setDefaultNavBarTitleColor:(UIColor *)color;

/** set default statusBarStyle of UIStatusBar */
+ (void)lf_setDefaultStatusBarStyle:(UIStatusBarStyle)style;

/** set default shadowImage isHidden of UINavigationBar */
+ (void)lf_setDefaultNavBarShadowImageHidden:(BOOL)hidden;

@end

#pragma mark - UINavigationBar
@interface UINavigationBar (LFAddition) <UINavigationBarDelegate>

//设置导航栏所有BarButtonItem的透明度
- (void)lf_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

//设置导航栏在垂直方向上评议多少距离
- (void)lf_setTranslationY:(CGFloat)translationY;

//获取当前导航栏在垂直方向上偏移了多少
- (CGFloat)lf_getTranslationY;


@end


#pragma mark - UIViController
@interface UIViewController (LFAddition)

- (UIImage *)lf_navBarBackgroundImage;
//barTintColor
- (void)lf_setNavBarBarTintColor:(UIColor *)color;
- (UIColor *)lf_navBarBarTintColor;

- (void)lf_setNavBarBackgroundAlpha:(CGFloat)alpha;
- (CGFloat)lf_navBarBackgroundAlpha;
//TintColor
- (void)lf_setNavBarTintColor:(UIColor *)color;
- (UIColor *)lf_navBarTintColor;

/** record current ViewController titleColor */
- (void)lf_setNavBarTitleColor:(UIColor *)color;
- (UIColor *)lf_navBarTitleColor;

/** record current ViewController statusBarStyle */
- (void)lf_setStatusBarStyle:(UIStatusBarStyle)style;
- (UIStatusBarStyle)lf_statusBarStyle;

/** record current ViewController navigationBar shadowImage hidden */
- (void)lf_setNavBarShadowImageHidden:(BOOL)hidden;
- (BOOL)lf_navBarShadowImageHidden;


@end




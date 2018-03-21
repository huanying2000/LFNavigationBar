//
//  LFNavigationBar.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

/*
 这里解释一下UINavigationBar 的层级结构(iOS 11)
 一个最原始的UINavigation 的层级结构
 UINavigationBar subViews( _UIBarBackground,_UINavigationBarContentView)
 _UIBarBackground subViews (UIImageView,UIVisualEffectView) 其中UIImageView如果不添加图片 相当于没有frame ,UIVisualEffectView也有两个子视图（_UIVisualEffectBackdropView,_UIVisualEffectSubView）
 
 //如果设置了title 或者 item 层级结构大致相同 但是会在_UINavigationBarContentView 添加子视图 title 或者 item
 
 */



#import "LFNavigationBar.h"
#import <objc/runtime.h>
#import "sys/utsname.h"

@implementation LFNavigationBar

+ (BOOL) isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // judgment by height when in simulators
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}



+ (CGFloat)navBarBottom {
    return [self isIphoneX] ? 88 : 64;
}

+ (CGFloat) tabbarHeight {
    return [self isIphoneX] ? 83 : 49;
}

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end

/*************************************************************/
#pragma mark default navigationBar barTintColor、tintColor and statusBarStyle YOU CAN CHANGE!!!
@implementation LFNavigationBar (LFDefault)

static char kLFIsLocalUsedKey;
static char kLFWhiteistKey;
static char kLFBlacklistKey;

static char kLFDefaultNavBarBarTintColorKey;
static char kLFDefaultNavBarBackgroundImageKey;
static char kLFDefaultNavBarTintColorKey;
static char kLFDefaultNavBarTitleColorKey;
static char kLFDefaultStatusBarStyleKey;
static char kLFDefaultNavBarShadowImageHiddenKey;


+ (BOOL)isLocalUsed {
    id isLocal = objc_getAssociatedObject(self, &kLFIsLocalUsedKey);
    return (isLocal != nil) ? [isLocal boolValue] : NO;
}
//Local 局部使用的ViewController
+ (void)lf_local {
    objc_setAssociatedObject(self, &kLFIsLocalUsedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//广泛使用的该库 会添加黑名单(黑名单中的Controller 不使用)
+ (void)lf_widely {
    objc_setAssociatedObject(self, &kLFIsLocalUsedKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (NSArray<NSString *> *)whitelist {
    NSArray<NSString *> *list = (NSArray<NSString *> *)objc_getAssociatedObject(self, &kLFWhiteistKey);
    return (list != nil) ? list : nil;
}
+ (void)lf_setWhitelist:(NSArray<NSString *> *)list {
    NSAssert([self isLocalUsed], @"白名单是在设置 局部使用 该库的情况下使用的");
    objc_setAssociatedObject(self, &kLFWhiteistKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray<NSString *> *)blacklist {
    NSArray<NSString *> *list = (NSArray<NSString *> *)objc_getAssociatedObject(self, &kLFBlacklistKey);
    return (list != nil) ? list : nil;
}

+ (void)lf_setBlacklist:(NSArray<NSString *> *)list {
    NSAssert(list, @"list 不能设置为nil");
    NSAssert(![self isLocalUsed], @"黑名单是在设置 广泛使用 该库的情况下使用的");
    objc_setAssociatedObject(self, &kLFBlacklistKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)needUpdateNavigationBar:(UIViewController *)vc {
    NSString *vcStr = NSStringFromClass(vc.class);
    if ([self isLocalUsed]) { // 如果局部使用(白名单中包含 才能使用)
        return [[self whitelist] containsObject:vcStr]; // 当白名单里 有 表示需要更新
    } else { //广泛使用 需要黑名单不包含
        return ![[self blacklist] containsObject:vcStr];// 当黑名单里 没有 表示需要更新
    }
}

+ (UIColor *)defaultNavBarBarTintColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kLFDefaultNavBarBarTintColorKey);
    return (color != nil) ? color : [UIColor whiteColor];
}
+ (void)lf_setDefaultNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFDefaultNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIImage *)defaultNavBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kLFDefaultNavBarBackgroundImageKey);
    return image;
}
+ (void)lf_setDefaultNavBarBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kLFDefaultNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)defaultNavBarTintColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kLFDefaultNavBarTintColorKey);
    return (color != nil) ? color : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}
+ (void)lf_setDefaultNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFDefaultNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)defaultNavBarTitleColor {
    UIColor *color = (UIColor *)objc_getAssociatedObject(self, &kLFDefaultNavBarTitleColorKey);
    return (color != nil) ? color : [UIColor blackColor];
}
+ (void)lf_setDefaultNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFDefaultNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (UIStatusBarStyle)defaultStatusBarStyle {
    id style = objc_getAssociatedObject(self, &kLFDefaultStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}
+ (void)lf_setDefaultStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kLFDefaultStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)defaultNavBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kLFDefaultNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : NO;
}
+ (void)lf_setDefaultNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kLFDefaultNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (CGFloat)defaultNavBarBackgroundAlpha {
    return 1.0;
}

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}
+ (CGFloat)middleAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent {
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}


@end

//=============================================================================
#pragma mark - UINavigationBar
//=============================================================================
@implementation UINavigationBar (LFAddition)

static char kLFBackgroundViewKey;
static char kLFBackgroundImageViewKey;
static char kLFBackgroundImageKey;



- (UIView *)backgroundView {
    return (UIView *)objc_getAssociatedObject(self, &kLFBackgroundViewKey);
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (backgroundView) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lf_keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lf_keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    objc_setAssociatedObject(self, &kLFBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView {
    return (UIImageView *)objc_getAssociatedObject(self, &kLFBackgroundImageViewKey);
}

- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, &kLFBackgroundImageViewKey, bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)backgroundImage {
    return (UIImage *)objc_getAssociatedObject(self, &kLFBackgroundImageKey);
}
- (void)setBackgroundImage:(UIImage *)image {
    objc_setAssociatedObject(self, &kLFBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)lf_setBackgroundImage:(UIImage *)image {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    if (self.backgroundImageView == nil) {
        //让 _UIBarBackground 变得没有图片覆盖
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        if (self.subviews.count > 0) {
            self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [LFNavigationBar navBarBottom])];
            self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            // _UIBarBackground is first subView for navigationBar
            [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
        }
    }
    self.backgroundImage = image;
    self.backgroundImageView.image = image;
}

// set navigationBar barTintColor
- (void)lf_setBackgroundColor:(UIColor *)color {
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    self.backgroundImage = nil;
    if (self.backgroundView == nil) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [LFNavigationBar navBarBottom])];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
    }
    self.backgroundView.backgroundColor = color;
}

- (void)lf_keyboardDidShow {
    [self lf_restoreUIBarBackgroundFrame];
}
- (void)lf_keyboardWillHide {
    [self lf_restoreUIBarBackgroundFrame];
}


- (void) lf_restoreUIBarBackgroundFrame {
    // IQKeyboardManager change _UIBarBackground frame sometimes, so I need restore it
    for (UIView *view in self.subviews) {
        Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
        if (_UIBarBackgroundClass != nil) {
            if ([view isKindOfClass:_UIBarBackgroundClass]) {
                view.frame = CGRectMake(0, self.frame.size.height-[LFNavigationBar navBarBottom], [LFNavigationBar screenWidth], [LFNavigationBar navBarBottom]);
            }
        }
    }
}


- (void)lf_setBackgroundAlpha:(CGFloat)alpha {
    //_UIBarBackground
    UIView *barBackgroundView = self.subviews.firstObject;
    if (@available(iOS 11.0, *)) {
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = alpha;
        }
    }else {
        barBackgroundView.alpha = alpha;
    }
}


- (void)lf_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator {
    for (UIView *view in self.subviews) {
        if (hasSystemBackIndicator) {
            // _UIBarBackground/_UINavigationBarBackground对应的view是系统导航栏，不需要改变其透明度
            //iOS10之前使用的是_UINavigationBarBackground, iOS10起改为_UIBarBackground
            Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
            if (_UIBarBackgroundClass != nil) {
                if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                    view.alpha = alpha;
                }
            }
            
            Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
            if (_UINavigationBarBackground != nil) {
                if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                    view.alpha = alpha;
                }
            }
        }else {
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] == NO) {
                Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
                if (_UIBarBackgroundClass != nil) {
                    if ([view isKindOfClass:_UIBarBackgroundClass] == NO) {
                        view.alpha = alpha;
                    }
                }
                
                Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
                if (_UINavigationBarBackground != nil) {
                    if ([view isKindOfClass:_UINavigationBarBackground] == NO) {
                        view.alpha = alpha;
                    }
                }
            }
        }
    }
}


// 设置导航栏在垂直方向上平移多少距离   CGAffineTransformMakeTranslation  平移
- (void)lf_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


/// 获取当前导航栏在垂直方向上偏移了多少
- (CGFloat)lf_getTranslationY {
    return self.transform.ty;
}

#pragma mark - call swizzling methods active 主动调用交换方法

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[1] = {
            @selector(setTitleTextAttributes:)
        };
        for (NSInteger i = 0; i < 1; i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"lf_%@",NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}


- (void)lf_setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    NSMutableDictionary<NSString *,id> *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    if (newTitleTextAttributes == nil) {
        return;
    }
    NSDictionary<NSString *,id> *originTitleTextAttributes = self.titleTextAttributes;
    if (originTitleTextAttributes == nil) {
        [self lf_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    __block UIColor *titleColor;
    [originTitleTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:NSForegroundColorAttributeName]) {
            titleColor = (UIColor *)obj;
            *stop = YES;
        }
    }];
    if (titleColor == nil) {
        [self lf_setTitleTextAttributes:newTitleTextAttributes];
        return;
    }
    if (newTitleTextAttributes[NSForegroundColorAttributeName] == nil) {
        newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    }
    [self lf_setTitleTextAttributes:newTitleTextAttributes];
    
}

@end

@interface UIViewController (Addition)
- (void)setPushToCurrentVCFinished:(BOOL)isFinished;
@end

//==========================================================================
#pragma mark - UINavigationController
//==========================================================================
@implementation UINavigationController (LFAddition)

static CGFloat lf_PopDuration = 0.12;
static int lfPopDisplayCount = 0;

- (CGFloat)lfPopProgress {
    CGFloat all = 60 * lf_PopDuration;
    int current = MIN(all, lfPopDisplayCount);
    return current / all;
}

static CGFloat lfPushDuration = 0.10;
//当前显示的push过来的个数(当前栈内controller的数量)
static int lfPushDisplayCount = 0;
- (CGFloat)lfPushProgress {
    CGFloat all = 60 * lfPushDuration;
    int current = MIN(all, lfPushDisplayCount);
    return current / all;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController lf_statusBarStyle];
}

- (void)setNeedsNavigationBarUpdateForBarBackgroundImage:(UIImage *)backgroundImage {
    [self.navigationBar lf_setBackgroundImage:backgroundImage];
}

- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)barTintColor {
    [self.navigationBar lf_setBackgroundColor:barTintColor];
}

- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    [self.navigationBar lf_setBackgroundAlpha:barBackgroundAlpha];
}


- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor {
    self.navigationBar.tintColor = tintColor;
}

- (void)setNeedsNavigationBarUpdateForShadowImageHidden:(BOOL)hidden {
    self.navigationBar.shadowImage = (hidden == YES) ? [UIImage new] : nil;
}

- (void)setNeedsNavigationBarUpdateForTitleColor:(UIColor *)titleColor {
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}


- (void)updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC progress:(CGFloat)progress {
    // change navBarBarTintColor
    UIColor *fromBarTintColor = [fromVC lf_navBarBarTintColor];
    UIColor *toBarTintColor = [toVC lf_navBarBarTintColor];
    UIColor *newBarTintColor = [LFNavigationBar middleColor:fromBarTintColor toColor:toBarTintColor percent:progress];
    if ([LFNavigationBar needUpdateNavigationBar:fromVC] || [LFNavigationBar needUpdateNavigationBar:toVC]) {
        [self setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
    }
    
    // change navBarTintColor
    UIColor *fromTintColor = [fromVC lf_navBarTintColor];
    UIColor *toTintColor = [toVC lf_navBarTintColor];
    UIColor *newTintColor = [LFNavigationBar middleColor:fromTintColor toColor:toTintColor percent:progress];
    if ([LFNavigationBar needUpdateNavigationBar:fromVC]) {
        [self setNeedsNavigationBarUpdateForTintColor:newTintColor];
    }
    
    // change navBarTitleColor（在wr_popToViewController:animated:方法中直接改变标题颜色）
    UIColor *fromTitleColor = [fromVC lf_navBarTitleColor];
    UIColor *toTitleColor = [toVC lf_navBarTitleColor];
    UIColor *newTitleColor = [LFNavigationBar middleColor:fromTitleColor toColor:toTitleColor percent:progress];
    [self setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
    
    // change navBar _UIBarBackground alpha
    CGFloat fromBarBackgroundAlpha = [fromVC lf_navBarBackgroundAlpha];
    CGFloat toBarBackgroundAlpha = [toVC lf_navBarBackgroundAlpha];
    CGFloat newBarBackgroundAlpha = [LFNavigationBar middleAlpha:fromBarBackgroundAlpha toAlpha:toBarBackgroundAlpha percent:progress];
    [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBarBackgroundAlpha];
    
}


#pragma mark - call swizzling methods active 主动调用交换方法

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[4] = {
            NSSelectorFromString(@"_updateInteractiveTransition:"),
            @selector(popToViewController:animated:),
            @selector(popToRootViewControllerAnimated:),
            @selector(pushViewController:animated:)
        };
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [[NSString stringWithFormat:@"lf_%@", NSStringFromSelector(selector)] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}


- (NSArray<UIViewController *> *)lf_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // pop 的时候直接改变 barTintColor、tintColor
    [self setNeedsNavigationBarUpdateForTitleColor:[viewController lf_navBarTitleColor]];
    [self setNeedsNavigationBarUpdateForTintColor:[viewController lf_navBarTintColor]];
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        lfPopDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:lf_PopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self lf_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return vcs;
}

- (NSArray<UIViewController *> *)lf_popToRootViewControllerAnimated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        lfPopDisplayCount = 0;
    }];
    [CATransaction setAnimationDuration:lf_PopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *vcs = [self lf_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return vcs;
}


- (void)popNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        lfPopDisplayCount += 1;
        CGFloat popProgress = [self lfPopProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:popProgress];
    }
}

- (void)lf_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        lfPushDisplayCount = 0;
        [viewController setPushToCurrentVCFinished:YES];
    }];
    [CATransaction setAnimationDuration:lfPushDuration];
    [CATransaction begin];
    [self lf_pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (void)pushNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        lfPushDisplayCount += 1;
        CGFloat pushProgress = [self lfPushProgress];
        UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:pushProgress];
    }
}

#pragma mark - deal the gesture of return
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive] == YES) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if ([sysVersion floatValue] >= 10) {
            if (@available(iOS 10.0, *)) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    __strong typeof (self) pThis = weakSelf;
                    [pThis dealInteractionChanges:context];
                }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}

// deal the gesture of return break off
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key){
        UIViewController *vc = [context viewControllerForKey:key];
        UIColor *curColor = [vc lf_navBarBarTintColor];
        CGFloat curAlpha = [vc lf_navBarBackgroundAlpha];
        [self setNeedsNavigationBarUpdateForBarTintColor:curColor];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
    };
    
    // after that, cancel the gesture of return
    if ([context isCancelled] == YES) {
        double cancelDuration = 0;
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}

- (void)lf_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    [self updateNavigationBarWithFromVC:fromVC toVC:toVC progress:percentComplete];
    [self lf_updateInteractiveTransition:percentComplete];
}

@end


//==========================================================================
#pragma mark - UIViewController
//==========================================================================
@implementation UIViewController (LFAddition)
static char kLFPushToCurrentVCFinishedKey;
static char kLFPushToNextVCFinishedKey;
static char kLFNavBarBackgroundImageKey;
static char kLFNavBarBarTintColorKey;
static char kLFNavBarBackgroundAlphaKey;
static char kLFNavBarTintColorKey;
static char kLFNavBarTitleColorKey;
static char kLFStatusBarStyleKey;
static char kLFNavBarShadowImageHiddenKey;
static char kLFCustomNavBarKey;
static char kLFSystemNavBarBarTintColorKey;
static char kLFSystemNavBarTintColorKey;
static char kLFSystemNavBarTitleColorKey;


- (BOOL)pushToCurrentVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kLFPushToCurrentVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}

- (void)setPushToCurrentVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kLFPushToCurrentVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pushToNextVCFinished {
    id isFinished = objc_getAssociatedObject(self, &kLFPushToNextVCFinishedKey);
    return (isFinished != nil) ? [isFinished boolValue] : NO;
}
- (void)setPushToNextVCFinished:(BOOL)isFinished {
    objc_setAssociatedObject(self, &kLFPushToNextVCFinishedKey, @(isFinished), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBar backgroundImage
- (UIImage *)lf_navBarBackgroundImage {
    UIImage *image = (UIImage *)objc_getAssociatedObject(self, &kLFNavBarBackgroundImageKey);
    image = (image == nil) ? [LFNavigationBar defaultNavBarBackgroundImage] : image;
    return image;
}
- (void)lf_setNavBarBackgroundImage:(UIImage *)image {
    if ([[self lf_customNavBar] isKindOfClass:[UINavigationBar class]]) {
        //  UINavigationBar *navBar = (UINavigationBar *)[self wr_customNavBar];
        //  [navBar wr_setBackgroundImage:image];
    } else {
        objc_setAssociatedObject(self, &kLFNavBarBackgroundImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

// navigationBar systemBarTintColor
- (UIColor *)lf_systemNavBarBarTintColor {
    return (UIColor *)objc_getAssociatedObject(self, &kLFSystemNavBarBarTintColorKey);
}
- (void)lf_setSystemNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFSystemNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lf_navBarBarTintColor {
    UIColor *barTintColor = (UIColor *)objc_getAssociatedObject(self, &kLFNavBarBarTintColorKey);
    if (![LFNavigationBar needUpdateNavigationBar:self]) {//如果在黑名单内
        if ([self lf_systemNavBarBarTintColor] == nil) {
            barTintColor = self.navigationController.navigationBar.barTintColor;
        } else {
            barTintColor = [self lf_systemNavBarBarTintColor];
        }
    }
    return (barTintColor != nil) ? barTintColor : [LFNavigationBar defaultNavBarBarTintColor];
}
- (void)lf_setNavBarBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFNavBarBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self lf_customNavBar] isKindOfClass:[UINavigationBar class]]) {
        //  UINavigationBar *navBar = (UINavigationBar *)[self wr_customNavBar];
        //  [navBar wr_setBackgroundColor:color];
    } else {
        BOOL isRootViewController = (self.navigationController.viewControllers.firstObject == self);
        if (([self pushToCurrentVCFinished] == YES || isRootViewController == YES) && [self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:color];
        }
    }
}

// navigationBar _UIBarBackground alpha
- (CGFloat)lf_navBarBackgroundAlpha {
    id barBackgroundAlpha = objc_getAssociatedObject(self, &kLFNavBarBackgroundAlphaKey);
    return (barBackgroundAlpha != nil) ? [barBackgroundAlpha floatValue] : [LFNavigationBar defaultNavBarBackgroundAlpha];
}
- (void)lf_setNavBarBackgroundAlpha:(CGFloat)alpha {
    objc_setAssociatedObject(self, &kLFNavBarBackgroundAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self lf_customNavBar] isKindOfClass:[UINavigationBar class]]) {
        //  UINavigationBar *navBar = (UINavigationBar *)[self wr_customNavBar];
        //  [navBar wr_setBackgroundAlpha:alpha];
    } else {
        BOOL isRootViewController = (self.navigationController.viewControllers.firstObject == self);
        if (([self pushToCurrentVCFinished] == YES || isRootViewController == YES) && [self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:alpha];
        }
    }
}

// navigationBar systemTintColor
- (UIColor *)lf_systemNavBarTintColor {
    return (UIColor *)objc_getAssociatedObject(self, &kLFSystemNavBarTintColorKey);
}
- (void)lf_setSystemNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFSystemNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBar tintColor
- (UIColor *)lf_navBarTintColor {
    UIColor *tintColor = (UIColor *)objc_getAssociatedObject(self, &kLFNavBarTintColorKey);
    if (![LFNavigationBar needUpdateNavigationBar:self]) {
        if ([self lf_systemNavBarTintColor] == nil) {
            tintColor = self.navigationController.navigationBar.tintColor;
        } else {
            tintColor = [self lf_systemNavBarTintColor];
        }
    }
    return (tintColor != nil) ? tintColor : [LFNavigationBar defaultNavBarTintColor];
}
- (void)lf_setNavBarTintColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFNavBarTintColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self lf_customNavBar] isKindOfClass:[UINavigationBar class]]) {
        //  UINavigationBar *navBar = (UINavigationBar *)[self wr_customNavBar];
        //  navBar.tintColor = color;
    } else {
        if ([self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:color];
        }
    }
}

// navigationBar systemTitleColor
- (UIColor *)lf_systemNavBarTitleColor {
    return (UIColor *)objc_getAssociatedObject(self, &kLFSystemNavBarTitleColorKey);
}
- (void)lf_setSystemNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFSystemNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// navigationBarTitleColor
- (UIColor *)lf_navBarTitleColor {
    UIColor *titleColor = (UIColor *)objc_getAssociatedObject(self, &kLFNavBarTitleColorKey);
    if (![LFNavigationBar needUpdateNavigationBar:self]) {
        if ([self lf_systemNavBarTitleColor] == nil) {
            titleColor = self.navigationController.navigationBar.titleTextAttributes[@"NSColor"];
        } else {
            titleColor = [self lf_systemNavBarTitleColor];
        }
    }
    return (titleColor != nil) ? titleColor : [LFNavigationBar defaultNavBarTitleColor];
}
- (void)lf_setNavBarTitleColor:(UIColor *)color {
    objc_setAssociatedObject(self, &kLFNavBarTitleColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([[self lf_customNavBar] isKindOfClass:[UINavigationBar class]]) {
        //  UINavigationBar *navBar = (UINavigationBar *)[self wr_customNavBar];
        //  navBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    } else {
        if ([self pushToNextVCFinished] == NO) {
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:color];
        }
    }
}

// statusBarStyle
- (UIStatusBarStyle)lf_statusBarStyle {
    id style = objc_getAssociatedObject(self, &kLFStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : [LFNavigationBar defaultStatusBarStyle];
}
- (void)lf_setStatusBarStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, &kLFStatusBarStyleKey, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

// shadowImage
- (void)lf_setNavBarShadowImageHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, &kLFNavBarShadowImageHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:hidden];
}
- (BOOL)lf_navBarShadowImageHidden {
    id hidden = objc_getAssociatedObject(self, &kLFNavBarShadowImageHiddenKey);
    return (hidden != nil) ? [hidden boolValue] : [LFNavigationBar defaultNavBarShadowImageHidden];
}

// custom navigationBar
- (UIView *)lf_customNavBar {
    UIView *navBar = objc_getAssociatedObject(self, &kLFCustomNavBarKey);
    return (navBar != nil) ? navBar : [UIView new];
}
- (void)lf_setCustomNavBar:(UINavigationBar *)navBar {
    objc_setAssociatedObject(self, &kLFCustomNavBarKey, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:),
            @selector(viewDidAppear:),
            @selector(viewDidDisappear:)
        };
        
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"lf_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)lf_viewWillAppear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        if (![LFNavigationBar needUpdateNavigationBar:self]) {
            if ([self lf_systemNavBarBarTintColor] == nil) {
                [self lf_setSystemNavBarBarTintColor:[self lf_navBarBarTintColor]];
            }
            if ([self lf_systemNavBarTintColor] == nil) {
                [self lf_setSystemNavBarTintColor:[self lf_navBarTintColor]];
            }
            if ([self lf_systemNavBarTitleColor] == nil) {
                [self lf_setSystemNavBarTitleColor:[self lf_navBarTitleColor]];
            }
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self lf_navBarTintColor]];
        }
        [self setPushToNextVCFinished:NO];
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self lf_navBarTitleColor]];
    }
    [self lf_viewWillAppear:animated];
}

- (void)lf_viewWillDisappear:(BOOL)animated {
    if ([self canUpdateNavigationBar] == YES) {
        [self setPushToNextVCFinished:YES];
    }
    [self lf_viewWillDisappear:animated];
}

- (void)lf_viewDidAppear:(BOOL)animated
{
    if ([self isRootViewController] == NO) {
        self.pushToCurrentVCFinished = YES;
    }
    if ([self canUpdateNavigationBar] == YES)
    {
        UIImage *barBgImage = [self lf_navBarBackgroundImage];
        if (barBgImage != nil) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:barBgImage];
        } else {
            if ([LFNavigationBar needUpdateNavigationBar:self]) {
                [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:[self lf_navBarBarTintColor]];
            }
        }
        [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:[self lf_navBarBackgroundAlpha]];
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:[self lf_navBarTintColor]];
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:[self lf_navBarTitleColor]];
        [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:[self lf_navBarShadowImageHidden]];
    }
    [self lf_viewDidAppear:animated];
}

- (void)lf_viewDidDisappear:(BOOL)animated {
    if (![LFNavigationBar needUpdateNavigationBar:self] && !self.navigationController) {
        [self lf_setSystemNavBarBarTintColor:nil];
        [self lf_setSystemNavBarTintColor:nil];
        [self lf_setSystemNavBarTitleColor:nil];
    }
    [self lf_viewDidDisappear:animated];
}

- (BOOL)canUpdateNavigationBar {
    return [self.navigationController.viewControllers containsObject:self];
}

- (BOOL)isRootViewController
{
    UIViewController *rootViewController = self.navigationController.viewControllers.firstObject;
    if ([rootViewController isKindOfClass:[UITabBarController class]] == NO) {
        return rootViewController == self;
    } else {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [tabBarController.viewControllers containsObject:self];
    }
}


@end


























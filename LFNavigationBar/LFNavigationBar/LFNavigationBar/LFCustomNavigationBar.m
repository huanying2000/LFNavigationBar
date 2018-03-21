//
//  LFCustomNavigationBar.m
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

//#import "sys/utsname.h" 获取硬件信息 需要引入这个

#import "LFCustomNavigationBar.h"
#import "sys/utsname.h"

#define LFDefaultTitleSize 18
#define LFDefaultTitleColor [UIColor blackColor]
#define LFDefaultBackgroundColor [UIColor whiteColor]
#define LFScreenWidth [UIScreen mainScreen].bounds.size.width


@implementation UIViewController (LFRoute)

/*
 在日常开发中 多控制器之间的跳转除了用push的方式 还可以使用present的方式 present控制器时 就避免不了使用 resentedViewController、presentingViewController
 假设从A控制器通过present的方式跳转到了B控制器 那么A.presentedViewController 就是B控制器 B.presentingViewController 就是A控制器
 
 UINavigationViewController 也有两个属性visibleViewController 和 topViewController
 visibleViewController 就是当前显示的控制器
 topViewController 是某个导航栈的栈顶视图
 visibleViewController和哪个导航栈没有关系，只是当前显示的控制器，也就是说任意一个导航的visibleViewController所返回的值应该是一样的,
 
 但是topViewController 就是某个导航栈的栈顶视图，和导航息息相关
 
 换句话说如果在仅有一个导航栈上，visibleViewController和topViewController应该是没有区别得。
 */
//返回上一个页面
- (void)toLastViewController {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (UIViewController *)currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return  [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }else if (viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];;
    }else {
        return viewController;
    }
}

@end









@interface LFCustomNavigationBar ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation LFCustomNavigationBar

+ (instancetype)customNavigationBar {
    LFCustomNavigationBar *navigationBar = [[self alloc] initWithFrame:CGRectMake(0, 0, LFScreenWidth, [LFCustomNavigationBar navBarBottom])];
    return navigationBar;
}

+ (int)navBarBottom {
    return 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.backgroundView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightButton];
    [self addSubview:self.bottomLine];
    [self updateFrame];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = LFDefaultBackgroundColor;
}

- (void)updateFrame {
    NSInteger top = ([LFCustomNavigationBar isIphoneX]) ? 44 : 20;
    NSInteger margin = 0;
    NSInteger buttonHeight = 44;
    NSInteger buttonWidth = 44;
    NSInteger titleLabelHeight = 44;
    NSInteger titleLabelWidth = 180;
    
    self.backgroundView.frame = self.bounds;
    self.backgroundImageView.frame = self.bounds;
    self.leftButton.frame = CGRectMake(margin, top, buttonWidth, buttonHeight);
    self.rightButton.frame = CGRectMake(LFScreenWidth - buttonWidth - margin, top, buttonWidth, buttonHeight);
    self.titleLabel.frame = CGRectMake((LFScreenWidth - titleLabelWidth) / 2, top, titleLabelWidth, titleLabelHeight);
    self.bottomLine.frame = CGRectMake(0, (CGFloat)(self.bounds.size.height-0.5), LFScreenWidth, 0.5);
}

#pragma mark - 导航栏左右按钮事件
- (void)clickBack {
    if (self.onClickLeftButton) {
        self.onClickLeftButton();
    }else {
        UIViewController *currentVC = [UIViewController currentViewController];
        [currentVC toLastViewController];
    }
}

- (void)clickRight {
    if (self.onClickRightButton) {
        self.onClickRightButton();
    }
}

- (void)setBottomLineHidden:(BOOL)hidden {
    self.bottomLine.hidden = hidden;
}


- (void)setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundView.alpha = alpha;
    self.backgroundImageView.alpha = alpha;
    self.bottomLine.alpha = alpha;
}


- (void)setTintColor:(UIColor *)color {
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    [self.titleLabel setTextColor:color];
}


#pragma mark - 左右按钮
- (void)setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.leftButton.hidden = NO;
    [self.leftButton setImage:normal forState:UIControlStateNormal];
    [self.leftButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setLeftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setLeftButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
}
- (void)setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
    [self setLeftButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
}
- (void)setLeftButtonWithImage:(UIImage *)image {
    [self setLeftButtonWithNormal:image highlighted:image title:nil titleColor:nil];
}
- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setLeftButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
}


- (void)setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.rightButton.hidden = NO;
    [self.rightButton setImage:normal forState:UIControlStateNormal];
    [self.rightButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setRightButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setRightButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
}
- (void)setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
    [self setRightButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
}
- (void)setRightButtonWithImage:(UIImage *)image {
    [self setRightButtonWithNormal:image highlighted:image title:nil titleColor:nil];
}
- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setRightButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.hidden = NO;
    self.titleLabel.text = _title;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    self.titleLabel.textColor = _titleLabelColor;
}
- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    _titleLabelFont = titleLabelFont;
    self.titleLabel.font = _titleLabelFont;
}
-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.backgroundImageView.hidden = YES;
    _barBackgroundColor = barBackgroundColor;
    self.backgroundView.hidden = NO;
    self.backgroundView.backgroundColor = _barBackgroundColor;
}

- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    self.backgroundView.hidden = YES;
    _barBackgroundImage = barBackgroundImage;
    self.backgroundImageView.hidden = NO;
    self.backgroundImageView.image = _barBackgroundImage;
}

#pragma mark - getter
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.imageView.contentMode = UIViewContentModeCenter;
        _leftButton.hidden = YES;
    }
    return _leftButton;
}
-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.imageView.contentMode = UIViewContentModeCenter;
        _rightButton.hidden = YES;
    }
    return _rightButton;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = LFDefaultTitleColor;
        _titleLabel.font = [UIFont systemFontOfSize:LFDefaultTitleSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(CGFloat)(218.0/255.0) green:(CGFloat)(218.0/255.0) blue:(CGFloat)(218.0/255.0) alpha:1.0];
    }
    return _bottomLine;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}
-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}




+ (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}


@end

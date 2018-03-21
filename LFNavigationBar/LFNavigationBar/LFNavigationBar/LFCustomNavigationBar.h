//
//  LFCustomNavigationBar.h
//  LFNavigationBar
//
//  Created by ios开发 on 2018/3/8.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFCustomNavigationBar : UIView


@property (nonatomic,copy) void(^onClickLeftButton)(void);
@property (nonatomic,copy) void(^onClickRightButton)(void);

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIColor *titleLabelColor;
@property (nonatomic,strong) UIFont *titleLabelFont;
@property (nonatomic, strong) UIColor  *barBackgroundColor;
@property (nonatomic, strong) UIImage  *barBackgroundImage;

+ (instancetype)customNavigationBar;

- (void)setBottomLineHidden:(BOOL)hidden;
- (void)setBackgroundAlpha:(CGFloat)alpha;
- (void)setTintColor:(UIColor *)color;

- (void)setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)setLeftButtonWithImage:(UIImage *)image;
- (void)setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

- (void)setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)setRightButtonWithImage:(UIImage *)image;
- (void)setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;


@end

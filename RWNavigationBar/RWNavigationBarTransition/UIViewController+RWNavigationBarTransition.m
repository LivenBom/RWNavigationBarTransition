//
//  UIViewController+RWNavigationBarTransition.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UIViewController+RWNavigationBarTransition.h"
#import "UINavigationController+RWNavigationBarTransition.h"
#import "UIViewController+RWStatusBarAlpha.h"
#import "UINavigationBar+RWNavigationBarTransition.h"
#import "RWSwizzle.h"

#import <objc/runtime.h>

@implementation UIViewController (RWNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RWSwizzleMethod([self class],
                        @selector(viewWillLayoutSubviews),
                        [self class],
                        @selector(rw_viewWillLayoutSubviews));
        
        RWSwizzleMethod([self class],
                        @selector(viewDidAppear:),
                        [self class],
                        @selector(rw_viewDidAppear:));
        
        RWSwizzleMethod([self class],
                        @selector(viewDidLoad),
                        [self class],
                        @selector(rw_viewDidLoad));
    });
}

- (void)rw_viewDidLoad {
    self.rw_statusBarAlpha = 1;
    [self rw_viewDidLoad];
    /// 设置全局viewController中导航栏的默认样式
    /// 不过，推荐自己项目中创建一个分类处理，避免对本框架的依赖
}


/// 设置PUSH出来的VC导航栏，比如：B界面
/// 备注：此方法会调用若干次，所以要添加一些判断，避免重复添加
- (void)rw_viewWillLayoutSubviews {
    id<UIViewControllerTransitionCoordinator> tc = self.transitionCoordinator;
    /// PUSH的源界面，比如：A界面
    UIViewController *fromViewController = [tc viewControllerForKey:UITransitionContextFromViewControllerKey];
    /// PUSH出来的界面，比如：B界面
    UIViewController *toViewController = [tc viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /// 当前界面是要PUSH出来的界面，比如：B界面
    if ([self isEqual:self.navigationController.viewControllers.lastObject] &&
        [toViewController isEqual:self] &&
        tc.presentationStyle == UIModalPresentationNone) {
        /// 如果导航栏是半透明的，则将viewControlller的view设置为白色底
        /// 备注：墙裂推荐不要修改导航栏的半透明translucent的值，默认是YES
        if (self.navigationController.navigationBar.translucent) {
            [tc containerView].backgroundColor = [self.navigationController rw_containerViewBackgroundColor];
        }
        fromViewController.view.clipsToBounds = NO;
        toViewController.view.clipsToBounds = NO;
        /// 如果没有过渡的假导航栏，则创建一个添加
        if (!self.rw_transitionNavigationBar) {
            /// 创建一个假的导航栏
            [self rw_addTransitionNavigationBarIfNeeded];
            /// 将真的导航栏隐藏
            self.navigationController.rw_naviBarBackgroundViewHidden = YES;
        }
        /// 重置过渡假导航栏的frame
        [self rw_resizeTransitionNavigationBarFrame];
    }
    /// 将过渡导航栏置顶
    if (self.rw_transitionNavigationBar) {
        [self.view bringSubviewToFront:self.rw_transitionNavigationBar];
    }
    
    [self rw_viewWillLayoutSubviews];
}


- (void)rw_viewDidAppear:(BOOL)animated {
    /// PUSH出来的界面，比如：界面B
    UIViewController *transitionViewController = self.navigationController.rw_transitionContextToViewController;
    if (self.rw_transitionNavigationBar) {
        /// 将假的导航栏参数设置到真的导航栏中
        UINavigationBar *transitionBar = self.rw_transitionNavigationBar;
        self.navigationController.navigationBar.tintColor = transitionBar.tintColor;
        [self.navigationController.navigationBar setBackgroundImage:[transitionBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:transitionBar.shadowImage];
        /// 移除过渡的假导航栏
        /// 只移除PUSH出来界面中的假导航栏，比如：B界面
        /// 而PUSH的源界面中的假导航栏是不移除的，比如：A界面，因为Pop会A界面还需要显示
        if ([transitionViewController isEqual:self] || !transitionViewController) {
            [self.rw_transitionNavigationBar removeFromSuperview];
            self.rw_transitionNavigationBar = nil;
        }
    }
    /// 将rw_transitionContextToViewController置空
    if ([transitionViewController isEqual:self]) {
        self.navigationController.rw_transitionContextToViewController = nil;
    }
    /// 将真的导航栏显示出来
    if ([self.navigationController.viewControllers.lastObject isEqual:self]) {
        self.navigationController.rw_naviBarBackgroundViewHidden = NO;
    }
    /// 设置当前viewcontroller状态栏alpha
    self.rw_statusBarAlpha = self.rw_statusBarAlpha;
    
    [self rw_viewDidAppear:animated];
}


/// 设置过渡假导航栏的frame
- (void)rw_resizeTransitionNavigationBarFrame {
    /// 如果是nil，说明self.view还没添加到KeyWindow中，没显示出来
    if (!self.view.window) {
        return;
    }

    /// 获取真导航栏的frame，再赋值给假的导航栏
    UIView *backgroundView = self.navigationController.navigationBar.rw_backgroundView;
    CGRect rect = [backgroundView.superview convertRect:backgroundView.frame toView:self.view];
    self.rw_transitionNavigationBar.frame = rect;
}


/// 创建一个过渡的假导航栏（添加到self.view上）
- (void)rw_addTransitionNavigationBarIfNeeded {
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    if (!self.navigationController.navigationBar) {
        return;
    }
    /// 创建一个过渡的假导航栏
    UINavigationBar *bar = [[UINavigationBar alloc]init];
    bar.barStyle = self.navigationController.navigationBar.barStyle;
    bar.tintColor = self.navigationController.navigationBar.tintColor;
    [bar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[self.navigationController.navigationBar shadowImage]];
    [self.rw_transitionNavigationBar removeFromSuperview];
    self.rw_transitionNavigationBar = bar;
    /// 设置假导航栏的frame
    [self rw_resizeTransitionNavigationBarFrame];
    /// 只有导航栏没有设置隐藏的情况下，才添加假的导航栏
    if (!self.navigationController.navigationBarHidden && !self.navigationController.navigationBar.isHidden) {
        [self.view addSubview:self.rw_transitionNavigationBar];
    }
}


#pragma mark - 关联对象
- (UINavigationBar *)rw_transitionNavigationBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRw_transitionNavigationBar:(UINavigationBar *)rw_transitionNavigationBar {
    objc_setAssociatedObject(self, @selector(rw_transitionNavigationBar), rw_transitionNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

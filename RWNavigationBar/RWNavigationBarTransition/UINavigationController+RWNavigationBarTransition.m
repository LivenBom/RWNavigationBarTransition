//
//  UINavigationController+RWNavigationBarTransition.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UINavigationController+RWNavigationBarTransition.h"
#import <objc/runtime.h>

#import "UIViewController+RWNavigationBarTransition.h"

#import "RWWeakObjectContainer.h"
#import "RWSwizzle.h"

@implementation UINavigationController (RWNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RWSwizzleMethod([self class],
                        @selector(pushViewController:animated:),
                        [self class],
                        @selector(rw_pushViewController:animated:));
        RWSwizzleMethod([self class],
                        @selector(popViewControllerAnimated:),
                        [self class],
                        @selector(rw_popViewControllerAnimated:));
        RWSwizzleMethod([self class],
                        @selector(popToViewController:animated:),
                        [self class],
                        @selector(rw_popToViewController:animated:));
        RWSwizzleMethod([self class],
                        @selector(popToRootViewControllerAnimated:),
                        [self class],
                        @selector(rw_popToRootViewControllerAnimated:));
    });
}


- (UIColor *)rw_containerViewBackgroundColor {
    return UIColor.whiteColor;
}


#pragma mark - Push

/// 在PUSH的A界面中添加假的导航栏并将真的隐藏
- (void)rw_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /// A界面
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    /// 如果是栈的第一个ViewController的话，就直接PUSH
    if (!disappearingViewController) {
        return [self rw_pushViewController:viewController animated:animated];
    }
    
    /// A界面，添加一个假的导航栏
    if (!self.rw_transitionContextToViewController || !disappearingViewController.rw_transitionNavigationBar) {
        [disappearingViewController rw_addTransitionNavigationBarIfNeeded];
    }
    
    /// 如果Animation是NO的话，就没有过渡动画，所以不用将真的导航栏隐藏，因为它马上就显示
    /// A界面，将真的导航栏隐藏
    if (animated) {
        self.rw_transitionContextToViewController = viewController;
        if (disappearingViewController.rw_transitionNavigationBar) {
            disappearingViewController.navigationController.rw_naviBarBackgroundViewHidden = YES;
        }
    }
    return [self rw_pushViewController:viewController animated:animated];
}


#pragma mark - Pop

- (UIViewController *)rw_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self rw_popViewControllerAnimated:animated];
    }
    /// B界面，添加假的导航栏
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController rw_addTransitionNavigationBarIfNeeded];
    /// 通过A界面之前创建的假导航栏，将真的导航栏设置得跟A界面之前假的导航栏一样
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    if (appearingViewController.rw_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = appearingViewController.rw_transitionNavigationBar;
        self.navigationBar.tintColor = appearingNavigationBar.tintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:appearingNavigationBar.shadowImage];
    }
    /// B界面，隐藏真的导航栏
    if (animated) {
        disappearingViewController.navigationController.rw_naviBarBackgroundViewHidden = YES;
    }
    return [self rw_popViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)rw_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.viewControllers containsObject:viewController] || self.viewControllers.count < 2) {
        return [self rw_popToViewController:viewController animated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController rw_addTransitionNavigationBarIfNeeded];
    
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    if (appearingViewController.rw_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = appearingViewController.rw_transitionNavigationBar;
        self.navigationBar.tintColor = appearingNavigationBar.tintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:appearingNavigationBar.shadowImage];
    }
    if (animated) {
        disappearingViewController.navigationController.rw_naviBarBackgroundViewHidden = YES;
    }
    return [self rw_popToViewController:viewController animated:animated];
}



- (NSArray<UIViewController *> *)rw_popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count < 2) {
        return [self rw_popToRootViewControllerAnimated:animated];
    }
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    [disappearingViewController rw_addTransitionNavigationBarIfNeeded];
    
    UIViewController *appearingViewController = self.viewControllers[self.viewControllers.count - 2];
    if (appearingViewController.rw_transitionNavigationBar) {
        UINavigationBar *appearingNavigationBar = appearingViewController.rw_transitionNavigationBar;
        self.navigationBar.tintColor = appearingNavigationBar.tintColor;
        [self.navigationBar setBackgroundImage:[appearingNavigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:appearingNavigationBar.shadowImage];
    }
    if (animated) {
        disappearingViewController.navigationController.rw_naviBarBackgroundViewHidden = YES;
    }
    return [self rw_popToRootViewControllerAnimated:animated];
}



#pragma mark - 关联对象
- (BOOL)rw_naviBarBackgroundViewHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRw_naviBarBackgroundViewHidden:(BOOL)rw_naviBarBackgroundViewHidden {
    objc_setAssociatedObject(self, @selector(rw_naviBarBackgroundViewHidden), @(rw_naviBarBackgroundViewHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /// 适配iOS10之前后iOS10之后的
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")] || [obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            obj.alpha = rw_naviBarBackgroundViewHidden?0:1;
        }
    }];
}

- (UIViewController *)rw_transitionContextToViewController {
    return rw_objc_getAssociatedWeakObject(self, _cmd);
}

- (void)setRw_transitionContextToViewController:(UIViewController *)rw_transitionContextToViewController {
    rw_objc_setAssociatedWeakObject(self, @selector(setRw_transitionContextToViewController:), rw_transitionContextToViewController);
}


@end

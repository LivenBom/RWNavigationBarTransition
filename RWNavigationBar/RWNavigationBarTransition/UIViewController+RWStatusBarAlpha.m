//
//  UIViewController+RWStatusBarAlpha.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UIViewController+RWStatusBarAlpha.h"
#import <objc/runtime.h>
#import "RWSwizzle.h"

@implementation UIViewController (RWStatusBarAlpha)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RWSwizzleMethod([self class],
                        @selector(init),
                        [self class],
                        @selector(rw_init));
    });
}

- (instancetype)rw_init {
    self.rw_statusBarAlpha = 1;
    return [self rw_init];
}

- (CGFloat)rw_statusBarAlpha {
    return [objc_getAssociatedObject(self, @selector(rw_statusBarAlpha)) floatValue];
}

- (void)setRw_statusBarAlpha:(CGFloat)rw_statusBarAlpha {
    objc_setAssociatedObject(self, @selector(rw_statusBarAlpha), @(rw_statusBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (@available(iOS 13.0,*)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        [statusBarManager setValue:@(rw_statusBarAlpha) forKey:@"statusBarAlpha"];
    }
    else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        statusBar.alpha = rw_statusBarAlpha;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

@end

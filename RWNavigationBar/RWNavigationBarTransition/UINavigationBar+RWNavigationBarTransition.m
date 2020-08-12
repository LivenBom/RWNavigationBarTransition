//
//  UINavigationBar+RWNavigationBarTransition.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/12.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UINavigationBar+RWNavigationBarTransition.h"
#import <objc/runtime.h>
#import "RWSwizzle.h"

@implementation UINavigationBar (RWNavigationBarTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RWSwizzleMethod([self class],
                        @selector(layoutSubviews),
                        [self class],
                        @selector(rw_layoutSubviews));
    });
}


- (void)rw_layoutSubviews {
    [self rw_layoutSubviews];
    UIView *backgroundView = self.rw_backgroundView;
    CGRect frame = backgroundView.frame;
    frame.size.height = self.frame.size.height + fabs(frame.origin.y);
    backgroundView.frame = frame;
}


- (UIView *)rw_backgroundView {
    /// 适配iOS10之前后iOS10之后的
    __block UIView *backgroundView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")] || [obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            backgroundView = obj;
            *stop = YES;
        }
    }];
    return backgroundView;
}


@end

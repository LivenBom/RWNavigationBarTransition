//
//  UIStatusBarManager+RWStatusBarAlpha.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UIStatusBarManager+RWStatusBarAlpha.h"
#import "RWSwizzle.h"

@implementation UIStatusBarManager (RWStatusBarAlpha)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RWSwizzleMethod([self class], NSSelectorFromString(@"_updateAlpha"), [self class], NSSelectorFromString(@"rw_updateAlpha"));
    });
}

/// 适配iOS13以后的状态栏透明度修改
- (BOOL)rw_updateAlpha {
    return YES;
}

@end

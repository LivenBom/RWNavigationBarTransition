//
//  UIViewController+RWNavigationBarTransition.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RWNavigationBarTransition)

/// 假的导航栏
@property (nonatomic, strong, nullable) UINavigationBar *rw_transitionNavigationBar;

/// 添加假的导航栏
- (void)rw_addTransitionNavigationBarIfNeeded;

@end

NS_ASSUME_NONNULL_END

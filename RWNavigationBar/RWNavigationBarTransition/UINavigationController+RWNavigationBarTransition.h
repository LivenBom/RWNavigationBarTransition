//
//  UINavigationController+RWNavigationBarTransition.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (RWNavigationBarTransition)

/// 导航栏底层View是否隐藏，隐藏并不会影响viewControlle的布局
@property (nonatomic, assign) BOOL  rw_naviBarBackgroundViewHidden;
/// viewController
@property (nonatomic,  weak ) UIViewController  *rw_transitionContextToViewController;

- (UIColor *)rw_containerViewBackgroundColor;

@end

NS_ASSUME_NONNULL_END

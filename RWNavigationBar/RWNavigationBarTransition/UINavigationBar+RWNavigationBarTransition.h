//
//  UINavigationBar+RWNavigationBarTransition.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/12.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (RWNavigationBarTransition)

/// 返回_UIBarBackground或_UINavigationBarBackground对象
- (UIView *)rw_backgroundView;

@end

NS_ASSUME_NONNULL_END

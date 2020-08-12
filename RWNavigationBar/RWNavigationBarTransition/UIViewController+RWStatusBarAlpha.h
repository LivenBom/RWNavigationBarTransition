//
//  UIViewController+RWStatusBarAlpha.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RWStatusBarAlpha)
/// 状态栏透明度（默认值：1）
@property (nonatomic, assign) CGFloat  rw_statusBarAlpha;
@end

NS_ASSUME_NONNULL_END

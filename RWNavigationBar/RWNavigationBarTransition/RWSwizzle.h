//
//  RWSwizzle.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 方法交换
extern void RWSwizzleMethod(Class originalCls,SEL originalSelector,Class swizzledCls,SEL swizzledSelector);

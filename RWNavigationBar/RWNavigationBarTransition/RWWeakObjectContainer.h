//
//  RWWeakObjectContainer.h
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void rw_objc_setAssociatedWeakObject(id container, void *key, id value);
extern id rw_objc_getAssociatedWeakObject(id container, void *key);


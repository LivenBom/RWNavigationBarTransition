//
//  RWWeakObjectContainer.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "RWWeakObjectContainer.h"
#import <objc/runtime.h>

@interface RWWeakObjectContainer : NSObject
@property (nonatomic, weak) id  object;
@end


@implementation RWWeakObjectContainer
extern void rw_objc_setAssociatedWeakObject(id container, void *key, id value) {
    RWWeakObjectContainer *weakerContainer = [[RWWeakObjectContainer alloc]init];
    weakerContainer.object = value;
    objc_setAssociatedObject(container, key, weakerContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


extern id rw_objc_getAssociatedWeakObject(id container, void *key) {
    return [(RWWeakObjectContainer *)objc_getAssociatedObject(container, key) object];
}
@end


//
//  AppDelegate.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//  Review to be Better

#import "AppDelegate.h"
#import "RWAController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RWAController *vc = [[RWAController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    return YES;
}
@end

//
//  RWFullScreenController.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "RWBController.h"
#import "RWCController.h"

@interface RWBController ()

@end

@implementation RWBController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"B：我是全屏";
    self.view.backgroundColor = UIColor.greenColor;
    
    NSLog(@"B 前：self.navigationController.navigationBar.translucent %d",self.navigationController.navigationBar.translucent);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    NSLog(@"B 后：self.navigationController.navigationBar.translucent %d",self.navigationController.navigationBar.translucent);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
    btn.backgroundColor = UIColor.grayColor;
    [btn setTitle:@"PUSH To C" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pushAction {
    [self.navigationController pushViewController:[RWCController new] animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end

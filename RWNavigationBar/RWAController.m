//
//  ViewController.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "RWAController.h"
#import "RWBController.h"
#import <objc/runtime.h>

@interface RWAController ()
@end

@implementation RWAController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"A";
    self.view.backgroundColor = UIColor.redColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
    btn.backgroundColor = UIColor.grayColor;
    [btn setTitle:@"PUSH To B" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    NSLog(@"添加假导航栏前 ：%@ 的ViewFrame:%@",NSStringFromClass(self.class),NSStringFromCGRect(self.view.frame));
    
//    self.view.clipsToBounds = NO;
//    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    tempView.backgroundColor = UIColor.blueColor;
//    [self.view addSubview:tempView];
//    UINavigationBar *tempBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
//    tempBar.backgroundColor = UIColor.blueColor;
//    [self.view addSubview:tempBar];
}


- (void)pushAction {
    [self.navigationController pushViewController:[RWBController new] animated:YES];
}

@end

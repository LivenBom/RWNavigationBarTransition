//
//  RWBController.m
//  RWNavigationBar
//
//  Created by Liven on 2020/8/10.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "RWCController.h"
#import <YYCategories.h>
#import "RWBController.h"
#import "UIViewController+RWStatusBarAlpha.h"

@interface RWCController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RWCController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"C：我是带tableView";
    /// 提示：
    /// （1）
    /// 在每个ViewContrller，要在viewDidLoad或者viewWillAppear中设置导航栏的样式
    /// 否则会根据上一个导航栏的样式设置当前ViewController导航栏的样式
    /// 比如当前页面如果不设置，那么导航栏就会变成透明的
    /// 快捷的方式就是创建一个ViewController的分类Category，并用Swizzle的方式，设置每个ViewController中导航栏的默认样式
    /// 比如可以在本项目中的UIViewController+RWNavigationBarTransition中的rw_viewDidLoaded方法中设置默认的导航栏样式
    /// （2）
    /// 前面提到尽可能的不要修改导航栏的半透明Translucent的值，保持默认是YES，因为如果设置为NO了，那么会产生全局的影响
    /// 并且会让通过[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]方法设置的导航栏透明，失效
    /// 而让Translucent保持是YES，是否会产生另外一个问题，导航栏半透明，当tableView向上滑动的时候，在导航栏底下的那部分是否会半透明显示：
    /// 答案：是不会的。请观察B界面和C界面在设置导航栏背景样式的时候，translucent的变化
    /// 结论（1）：
    /// translucent在设置空白背景的时候，会自动变成YES
    /// 设置成纯色背景的时候，会自动变成NO
    ///
    /// 请继续观察：既然设置成纯色的背景会自动将translucent设置为NO，那么在设置纯色的背景后，手动将translucent设置为NO，会不会有问题？
    /// 比如在C界面设置纯色背景后，将translucent设置为NO，再跳转到B界面
    /// 经测试最终的结果是：再跳转到B界面设置空白的背景色，translucent不会自动变为YES
    /// 结论（2）：虽然看不到官方的源代码，但我们可以根据测试大胆猜测
    /// navigationBar.translucent的值以手动设置的值为优先
    /// 所以不要轻易的手动修改navigationBar.translucent的值
    NSLog(@"C 前：self.navigationController.navigationBar.translucent %d",self.navigationController.navigationBar.translucent);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.yellowColor] forBarMetrics:UIBarMetricsDefault];
    NSLog(@"C 后：self.navigationController.navigationBar.translucent %d",self.navigationController.navigationBar.translucent);
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view addSubview:self.tableView];
    
    /// 设置导航栏隐藏
    self.rw_statusBarAlpha = 0;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


- (BOOL)prefersStatusBarHidden {
  return NO;
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[RWBController new] animated:YES];
}

@end

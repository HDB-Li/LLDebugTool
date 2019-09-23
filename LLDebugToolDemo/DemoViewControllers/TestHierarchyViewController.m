//
//  TestHierarchyViewController.m
//  LLDebugToolDemo
//
//  Created by admin10000 on 2018/9/28.
//  Copyright © 2018年 li. All rights reserved.
//

#import "TestHierarchyViewController.h"
#import "LLHierarchyHelper.h"
#import "LLDebugTool.h"

@interface TestHierarchyViewController ()

@end

@implementation TestHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test.hierarchy", nil);
    self.tableView.tableFooterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(40, 10, view.frame.size.width - 40 * 2, view.frame.size.height - 10 * 2);
        [btn setTitle:NSLocalizedString(@"hierarchy.info", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(testHierarchy) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = btn.tintColor.CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [view addSubview:btn];
        view;
    });
    [self testHierarchy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [self getCellTitle:indexPath.row];
    UIView *view = [cell viewWithTag:100];
    [view removeFromSuperview];
    view = [self getCellView:indexPath.row];
    [cell.contentView addSubview:view];
    return cell;
}

- (NSString *)getCellTitle:(NSInteger)index {
    if (index == 0) {
        return @"UIView";
    } else if (index == 1) {
        return @"UILabel";
    } else if (index == 2) {
        return @"UIImageView";
    } else if (index == 3) {
        return @"UIButton";
    } else if (index == 4) {
        return @"UITextField";
    }
    return nil;
}

- (UIView *)getCellView:(NSInteger)index {
    UIView *view = nil;
    if (index == 0) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else if (index == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Label";
        view = label;
    } else if (index == 2) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"AppIcon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        view = imageView;
    } else if (index == 3) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"Button" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        view = btn;
    } else if (index == 4) {
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @"Text Field";
        view = textField;
    }
    view.frame = CGRectMake(10 * 2 + 120, 5, [UIScreen mainScreen].bounds.size.width - 10 * 3 - 120, 44 - 5 * 2);
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.tag = 100;
    view.userInteractionEnabled = NO;
    return view;
}

#pragma mark - Actions
- (void)testHierarchy {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionHierarchy];
}

- (void)touchUpInside:(UIButton *)sender {
    
}

@end

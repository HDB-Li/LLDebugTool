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

@interface TestHierarchyViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TestHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"hierarchy.info", nil);
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 55)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(40, 10, view.frame.size.width - 40 * 2, view.frame.size.height - 10 * 2);
        [btn setTitle:NSLocalizedString(@"test.hierarchy", nil) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(testHierarchy) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = btn.tintColor.CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [view addSubview:btn];
        view;
    });
    self.dataArray = @[@"UIView", @"UILabel", @"UIImageView", @"UIButton", @"UITextField", @"UISegmentedControl",@"UISlider", @"UISwitch",@"UIActivityIndicatorView", @"UIProgressView", @"UIPageControl", @"UIStepper", @"UIScrollView", @"UITableView", @"UITableViewCell", @"UICollectionView", @"UICollectionReusableView", @"UITextView", @"UIDatePicker", @"UIPickerView", @"UINavigationBar", @"UIToolbar", @"UITabBar", @"UISearchBar"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testHierarchy)];
    
    [self testHierarchy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    UIView *view = [cell viewWithTag:100];
    [view removeFromSuperview];
    view = [self getCellView:indexPath.row];
    [cell.contentView addSubview:view];
    return cell;
}

- (UIView *)getCellView:(NSInteger)index {
    UIView *view = nil;
    if (index == 0) {
        view = [[UIView alloc] init];
        if (@available(iOS 13.0, *)) {
#ifdef __IPHONE_13_0
            view.backgroundColor = [UIColor systemGroupedBackgroundColor];
#else
            view.backgroundColor = [UIColor performSelector:NSSelectorFromString(@"systemGroupedBackgroundColor")];
#endif
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            view.backgroundColor = [UIColor groupTableViewBackgroundColor];
#pragma clang diagnostic pop
        }
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
        textField.delegate = self;
        view = textField;
    } else if (index == 5)  {
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2"]];
        control.selectedSegmentIndex = 0;
        view = control;
    } else if (index == 6) {
        UISlider *slider = [[UISlider alloc] init];
        view = slider;
    } else if (index == 7) {
        UISwitch *swit = [[UISwitch alloc] init];
        view = swit;
    } else if (index == 8) {
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
        [activity startAnimating];
        view = activity;
    } else if (index == 9) {
        UIProgressView *progress = [[UIProgressView alloc] init];
        view = progress;
    } else if (index == 10) {
        UIPageControl *control = [[UIPageControl alloc] init];
        control.numberOfPages = 3;
        control.currentPage = 1;
        view = control;
    } else if (index == 11) {
        UIStepper *stepper = [[UIStepper alloc] init];
        view = stepper;
    } else if (index == 12) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        view = scrollView;
    } else if (index == 13) {
        UITableView *tableView = [[UITableView alloc] init];
        view = tableView;
    } else if (index == 14) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        view = cell;
    } else if (index == 15) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        view = collectionView;
    } else if (index == 16) {
        UICollectionReusableView *reusableView = [[UICollectionReusableView alloc] init];
        view = reusableView;
    } else if (index == 17) {
        UITextView *textView = [[UITextView alloc] init];
        view = textView;
    } else if (index == 18) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        view = picker;
    } else if (index == 19) {
        UIPickerView *picker = [[UIPickerView alloc] init];
        view = picker;
    } else if (index == 20) {
        UINavigationBar *bar = [[UINavigationBar alloc] init];
        view = bar;
    } else if (index == 21) {
        UIToolbar *bar = [[UIToolbar alloc] init];
        view = bar;
    } else if (index == 22) {
        UITabBar *bar = [[UITabBar alloc] init];
        view = bar;
    } else if (index == 23) {
        UISearchBar *bar = [[UISearchBar alloc] init];
        view = bar;
    }
    view.frame = CGRectMake(10 * 2 + [UIScreen mainScreen].bounds.size.width / 2.0, 5, [UIScreen mainScreen].bounds.size.width - 10 * 3 - [UIScreen mainScreen].bounds.size.width / 2.0, 44 - 5 * 2);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
#pragma clang diagnostic pop
    view.tag = 100;
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [cell viewWithTag:100];
    if (view) {
        view.frame = CGRectMake(view.frame.origin.x, (44 - view.frame.size.height) / 2.0, view.frame.size.width, view.frame.size.height);
    }
}

#pragma mark - Actions
- (void)testHierarchy {
    [[LLDebugTool sharedTool] executeAction:LLDebugToolActionHierarchy];
}

- (void)touchUpInside:(UIButton *)sender {
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

@end

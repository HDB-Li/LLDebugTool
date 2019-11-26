//
//  LLBaseViewController.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLEditTableViewController.h"

#import "LLTableViewSelectableModel.h"
#import "LLImageNameConfig.h"
#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIViewController+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLEditTableViewController ()

@property (nonatomic, strong) NSMutableArray<LLTableViewSelectableDelegate> *oriDataArray;

@property (nonatomic, strong) NSMutableArray<LLTableViewSelectableDelegate> *searchDataArray;

@property (nonatomic, copy) NSString *selectAllString;

@property (nonatomic, copy) NSString *cancelAllString;

@end

@implementation LLEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    if (self.isSearchEnable) {
        [self initSearchEnableFunction];
    }
    if (self.isSelectEnable) {
        [self initSelectEnableFunction];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isSearchEnable) {
        if (self.searchTextField.isFirstResponder) {
            [self.searchTextField resignFirstResponder];
        }
    }
    if (self.isSelectEnable) {
        [self endEditing];
    }
}

#pragma mark - Override
- (void)rightItemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tableView setEditing:sender.isSelected animated:YES];
    [self.navigationController setToolbarHidden:!sender.isSelected animated:YES];
    for (id<LLTableViewSelectableDelegate> model in self.datas) {
        [model setSelected:NO];
    }
    [self.tableView reloadData];
    if (self.isSelectEnable) {
        if (sender.isSelected) {
            self.selectAllItem.title = self.selectAllString;
            self.selectAllItem.enabled = (self.datas.count != 0);
            self.shareItem.enabled = NO;
            self.deleteItem.enabled = NO;
        }
    }
}

- (void)shareFilesWithIndexPaths:(NSArray *)indexPaths {
    
}

- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    [self endEditing];
}

- (BOOL)isSearching {
    return self.searchTextField.text.length;
}

#pragma mark - Primary
- (void)initSearchEnableFunction {
    _searchTextField = [LLFactory getTextField];
    self.searchTextField.textColor = [LLThemeManager shared].primaryColor;
    self.searchTextField.tintColor = [LLThemeManager shared].primaryColor;
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.backgroundColor = [LLThemeManager shared].containerColor;
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LLLocalizedString(@"input.filter.text") attributes:@{NSForegroundColorAttributeName : [LLThemeManager shared].placeHolderColor, NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    self.searchTextField.frame = CGRectMake(kLLGeneralMargin, kLLGeneralMargin, LL_SCREEN_WIDTH - kLLGeneralMargin * 2, 35);
    self.searchTextField.leftView = ({
        UIView *view = [LLFactory getView];
        view.frame = CGRectMake(0, 0, kLLGeneralMargin, kLLGeneralMargin);
        view;
    });
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;

    _headerView = [LLFactory getView];
    _headerView.backgroundColor = [LLThemeManager shared].backgroundColor;
    _headerView.frame = CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, self.searchTextField.LL_bottom + kLLGeneralMargin);
    [self.view addSubview:_headerView];
    [self.headerView addSubview:self.searchTextField];
}

- (void)initSelectEnableFunction {
    self.selectAllString = LLLocalizedString(@"select.all");
    self.cancelAllString = LLLocalizedString(@"cancel.all");
    
    // Navigation bar item
    [self initNavigationItemWithTitle:nil imageName:kEditImageName isLeft:NO];
    [self.rightNavigationButton setImage:[[UIImage LL_imageNamed:kDoneImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // ToolBar
    _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:self.selectAllString style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = [LLThemeManager shared].primaryColor;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _shareItem = [[UIBarButtonItem alloc] initWithTitle:LLLocalizedString(@"share") style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick:)];
    self.shareItem.tintColor = [LLThemeManager shared].primaryColor;
    self.shareItem.enabled = NO;
    
    _deleteItem = [[UIBarButtonItem alloc] initWithTitle:LLLocalizedString(@"delete") style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = [LLThemeManager shared].primaryColor;
    self.deleteItem.enabled = NO;
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:self.selectAllItem, spaceItem, nil];
    if (self.isShareEnable) {
        [items addObject:self.shareItem];
    }
    if (self.isDeleteEnable) {
        [items addObject:self.deleteItem];
    }
    [self setToolbarItems:items];
    
    self.navigationController.toolbar.barTintColor = [LLThemeManager shared].backgroundColor;
}

- (void)leftItemClick:(UIButton *)sender {
    if (self.isSearchEnable) {
        if (self.searchTextField.isFirstResponder) {
            [self.searchTextField resignFirstResponder];
        }
    }
    [super leftItemClick:sender];
}

- (void)selectAllItemClick:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:self.selectAllString]) {
        sender.title = self.cancelAllString;
        [self updateTableViewCellSelectedStyle:YES];
        self.shareItem.enabled = YES;
        self.deleteItem.enabled = YES;
    } else {
        sender.title = self.selectAllString;
        [self updateTableViewCellSelectedStyle:NO];
        self.shareItem.enabled = NO;
        self.deleteItem.enabled = NO;
    }
}

- (void)updateTableViewCellSelectedStyle:(BOOL)selected {
    for (NSInteger i = 0; i < self.datas.count; i++) {
        LLTableViewSelectableModel *model = self.datas[i];
        [model setSelected:selected];
    }
    
    [self.tableView reloadData];
}

- (void)shareItemClick:(UIBarButtonItem *)sender {
    NSArray *indexPaths = self.indexPathsForSelectedRows;
    if (indexPaths.count) {
        [self shareFilesWithIndexPaths:indexPaths];
    }
}

- (void)deleteItemClick:(UIBarButtonItem *)sender {
    NSArray *indexPaths = self.indexPathsForSelectedRows;
    [self showDeleteAlertWithIndexPaths:indexPaths];
}

- (void)showDeleteAlertWithIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count) {
        __weak typeof(self) weakSelf = self;
        [self LL_showAlertControllerWithMessage:[NSString stringWithFormat:LLLocalizedString(@"sure.to.delete"), (long)indexPaths.count] handler:^(NSInteger action) {
            if (action == 1) {
                [weakSelf deleteFilesWithIndexPaths:indexPaths];
            }
        }];
    }
}

- (NSArray *)indexPathsForSelectedRows {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.datas.count; i++) {
        id<LLTableViewSelectableDelegate> model = self.datas[i];
        if ([model isSelected]) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    return [indexPaths copy];
}

- (void)endEditing {
    if (self.tableView.isEditing) {
        [self rightItemClick:self.navigationItem.rightBarButtonItem.customView];
    }
}

- (NSMutableArray *)datas {
    if (self.isSearchEnable && [self isSearching]) {
        return self.searchDataArray;
    }
    return self.oriDataArray;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self datas].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"Sub class must over write tableView:cellForRowAtIndexPath:");
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<LLTableViewSelectableDelegate> model = self.datas[indexPath.row];
    if ([model isSelected]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        if (self.indexPathsForSelectedRows.count == self.datas.count) {
            if ([self.selectAllItem.title isEqualToString:self.selectAllString]) {
                self.selectAllItem.title = self.cancelAllString;
            }
        }
        self.shareItem.enabled = YES;
        self.deleteItem.enabled = YES;
        id<LLTableViewSelectableDelegate> model = self.datas[indexPath.row];
        [model setSelected:YES];
    } else {
        if (self.isSelectEnable) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        id<LLTableViewSelectableDelegate> model = self.datas[indexPath.row];
        [model setSelected:NO];
        if (![self.selectAllItem.title isEqualToString:self.selectAllString]) {
            self.selectAllItem.title = self.selectAllString;
        }
        if (self.indexPathsForSelectedRows.count == 0) {
            self.shareItem.enabled = NO;
            self.deleteItem.enabled = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDeleteEnable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self showDeleteAlertWithIndexPaths:@[indexPath]];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDeleteEnable) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearchEnable) {
        return self.searchTextField.LL_bottom + kLLGeneralMargin;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

#pragma mark - UIScrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isSearchEnable && self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(NSString *)text {
    if ([self.selectAllItem.title isEqualToString:self.cancelAllString]) {
        self.selectAllItem.title = self.selectAllString;
    }
    if (self.isDeleteEnable && self.deleteItem.isEnabled) {
        self.deleteItem.enabled = NO;
        self.shareItem.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldDidChange:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - Getters and setters
- (NSMutableArray<LLTableViewSelectableDelegate> *)oriDataArray {
    if (!_oriDataArray) {
        _oriDataArray = [[NSMutableArray<LLTableViewSelectableDelegate> alloc] init];
    }
    return _oriDataArray;
}

- (NSMutableArray<LLTableViewSelectableDelegate> *)searchDataArray {
    if (!_searchDataArray) {
        _searchDataArray = [[NSMutableArray<LLTableViewSelectableDelegate> alloc] init];
    }
    return _searchDataArray;
}

@end

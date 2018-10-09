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

#import "LLBaseViewController.h"
#import "LLImageNameConfig.h"
#import "LLMacros.h"
#import "LLTool.h"
#import "LLConfig.h"
#import "LLRoute.h"

static NSString *const kEmptyCellID = @"emptyCellID";

@interface LLBaseViewController ()

@property (nonatomic , assign) UITableViewStyle style;

@end

@implementation LLBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = UITableViewStyleGrouped;
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];
    [self initTableView];
    if (self.isSearchEnable) {
        [self initSearch];
    }
    if (self.isSelectEnable) {
        [self initSelectable];
    }
    [self resetDefaultSettings];
    self.view.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isSelectEnable) {
        if (self.tableView.isEditing) {
            [self rightItemClick:self.navigationItem.rightBarButtonItem.customView];
        }
    }
}

#pragma mark - Public
- (void)toastMessage:(NSString *)message {
    [LLTool toastMessage:message];
}

- (void)showAlertControllerWithMessage:(NSString *)message handler:(void (^)(NSInteger action))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Note" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(0);
        }
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(1);
        }
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Rewrite
- (void)leftItemClick {
    [LLRoute showWindow];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tableView setEditing:sender.isSelected animated:YES];
    [self.navigationController setToolbarHidden:!sender.isSelected animated:YES];
}

- (void)selectAllItemClick:(UIBarButtonItem *)sender {
    
}

- (void)shareItemClick:(UIBarButtonItem *)sender {
    
}

- (void)deleteItemClick:(UIBarButtonItem *)sender {
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Primary
- (void)initNavigationItems {
    if (self.navigationController.viewControllers.count <= 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.showsTouchWhenHighlighted = NO;
        btn.adjustsImageWhenHighlighted = NO;
        btn.frame = CGRectMake(0, 0, 40, 40);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
        UIImageRenderingMode mode = UIImageRenderingModeAlwaysTemplate;
        [btn setImage:[[UIImage LL_imageNamed:kCloseImageName] imageWithRenderingMode:mode] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : LLCONFIG_TEXT_COLOR}];
    self.navigationController.navigationBar.tintColor = LLCONFIG_TEXT_COLOR;
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // To Control subviews.
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, CGFLOAT_MIN)];
    self.tableView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    [self.tableView setSeparatorColor:LLCONFIG_TEXT_COLOR];
}

- (void)initSearch {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchBar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    self.searchBar.tintColor = LLCONFIG_TEXT_COLOR;
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)initSelectable {
    // Navigation bar item
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[[UIImage LL_imageNamed:kEditImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [btn setImage:[[UIImage LL_imageNamed:kDoneImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.tintColor = LLCONFIG_TEXT_COLOR;
    [btn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    // ToolBar
    _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItemClick:)];
    self.selectAllItem.tintColor = LLCONFIG_TEXT_COLOR;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _shareItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareItemClick:)];
    self.shareItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.shareItem.enabled = NO;
    
    _deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteItemClick:)];
    self.deleteItem.tintColor = LLCONFIG_TEXT_COLOR;
    self.deleteItem.enabled = NO;
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:self.selectAllItem , spaceItem , nil];
    if (self.isShareEnable) {
        [items addObject:self.shareItem];
    }
    if (self.isDeleteEnable) {
        [items addObject:self.deleteItem];
    }
    [self setToolbarItems:items];
    
    self.navigationController.toolbar.barTintColor = LLCONFIG_BACKGROUND_COLOR;
}

- (void)resetDefaultSettings {
    // Used to solve problems caused by modifying some systems default values with Runtime in the project.
    // Hopefully you changed these defaults at runtime in viewDidLoad, not viewWillAppear or viewDidAppear
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.automaticallyAdjustsScrollViewInsets = YES;
#pragma clang diagnostic pop
    self.navigationController.navigationBar.translucent = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
}

- (UISearchBar *)searchBar {
    return self.searchController.searchBar;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEmptyCellID];
    }
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

@end

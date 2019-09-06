//
//  LLSettingViewController.m
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

#import "LLSettingViewController.h"
#import "LLFactory.h"
#import "LLThemeManager.h"
#import "LLSettingCategoryModel.h"
#import "LLSettingSwitchCell.h"
#import "LLSettingSelectorCell.h"
#import "LLConfig.h"
#import "LLTitleView.h"
#import "LLMacros.h"
#import "LLConfigHelper.h"
#import "LLSettingManager.h"
#import "NSObject+LL_Runtime.h"
#import "LLImageNameConfig.h"

static NSString *const kSwitchCellID = @"SwitchCellID";
static NSString *const kMultipleCellID = @"MultipleCellID";

@interface LLSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <LLSettingCategoryModel *>*dataArray;

@end

@implementation LLSettingViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpUI];
}

#pragma mark - Over write
- (void)primaryColorChanged {
    [super primaryColorChanged];
    [_tableView setSeparatorColor:[LLThemeManager shared].primaryColor];
    [_tableView reloadData];
}

- (void)backgroundColorChanged {
    [super backgroundColorChanged];
    _tableView.backgroundColor = [LLThemeManager shared].backgroundColor;
    [_tableView reloadData];
}

#pragma mark - Primary
- (void)initial {
    [self initUI];
    [self initData];
}

- (void)initUI {
    self.title = @"Setting";
    [self.view addSubview:self.tableView];
}

- (void)initData {
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    // ColorStyle
    [settings addObject:[self getColorStyleModel]];
    
    // EntryWindowStyle
    [settings addObject:[self getEntryWindowStyleModel]];
    
    LLSettingCategoryModel *category1 = [[LLSettingCategoryModel alloc] initWithTitle:@"Color" settings:settings];
    [settings removeAllObjects];
    
    self.dataArray = @[category1];
    [self.tableView reloadData];
}

- (void)setUpUI {
    self.tableView.frame = self.view.bounds;
}

- (LLSettingModel *)getColorStyleModel {
    __weak typeof(self) weakSelf = self;
    LLSettingModel *model = [[LLSettingModel alloc] initWithTitle:@"Color Style" detailTitle:[LLConfigHelper colorStyleDetailDescription]];
    model.block = ^{
        [weakSelf showColorStyleAlert];
    };
    return model;
}

- (void)showColorStyleAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"Color Style" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < 3; i++) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LLConfigHelper colorStyleDescription:i] style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf setNewColorStyle:i];
        }];
        [action setValue:[UIImage LL_imageNamed:kCellSelectImageName] forKey:@"image"];
        [vc addAction:action];
    }
    [vc addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setNewColorStyle:(LLConfigColorStyle)style {
    if (style == [LLConfig shared].colorStyle) {
        return;
    }
    if (style == LLConfigColorStyleCustom) {
        
    } else {
        [LLConfig shared].colorStyle = style;
        [LLSettingManager shared].configColorStyleEnum = @(style);
        [self initData];
    }
}

- (LLSettingModel *)getEntryWindowStyleModel {
    __weak typeof(self) weakSelf = self;
    LLSettingModel *model = [[LLSettingModel alloc] initWithTitle:@"Entry Window" detailTitle:[LLConfigHelper entryWindowStyleDescription]];
    model.block = ^{
        [weakSelf showEntryWindowStyleAlert];
    };
    return model;
}

- (void)showEntryWindowStyleAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:@"Entry Window Style" preferredStyle:UIAlertControllerStyleActionSheet];
#ifdef __IPHONE_13_0
    NSInteger count = 4;
#else
    NSInteger count = 6;
#endif
    for (NSInteger i = 0; i < count; i++) {
        __weak typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:[LLConfigHelper entryWindowStyleDescription:i] style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf setNewEntryWindowStyle:i];
        }];
        [vc addAction:action];
    }
    [vc addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setNewEntryWindowStyle:(LLConfigEntryWindowStyle)style {
    if (style == [LLConfig shared].entryWindowStyle) {
        return;
    }
    
    [LLConfig shared].entryWindowStyle = style;
    [LLSettingManager shared].configEntryWindowStyleEnum = @(style);
    [self initData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSettingModel *model = self.dataArray[indexPath.section].settings[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass];
    [cell setValue:model forKey:@"model"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LLTitleView *view = [[LLTitleView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 40)];
    LLSettingCategoryModel *model = self.dataArray[section];
    view.titleLabel.text = model.title;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLSettingModel *model = self.dataArray[indexPath.section].settings[indexPath.row];
    if (model.block) {
        model.block();
    }
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [LLFactory getTableView:nil frame:self.view.bounds delegate:self style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.backgroundColor = [LLThemeManager shared].backgroundColor;
        [_tableView setSeparatorColor:[LLThemeManager shared].primaryColor];
        [_tableView registerClass:[LLSettingSwitchCell class] forCellReuseIdentifier:NSStringFromClass([LLSettingSwitchCell class])];
        [_tableView registerClass:[LLSettingSelectorCell class] forCellReuseIdentifier:NSStringFromClass([LLSettingSelectorCell class])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableView;
}

@end

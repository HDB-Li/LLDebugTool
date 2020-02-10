//
//  LLWidgetBorderViewController.m
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

#import "LLWidgetBorderViewController.h"

#import "LLWidgetBorderHelper.h"
#import "LLTitleSwitchCell.h"
#import "LLInternalMacros.h"
#import "LLTitleCellModel.h"
#import "LLSettingManager.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"

@interface LLWidgetBorderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LLWidgetBorderViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"function.widget.border");
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self loadData];
}

#pragma mark - Primary
- (void)loadData {
    LLTitleCellModel *model1 = [[LLTitleCellModel alloc] initWithTitle:LLLocalizedString(@"function.widget.border") flag:[LLConfig shared].isShowWidgetBorder];
    model1.changePropertyBlock = ^(id  _Nullable obj) {
        [LLConfig shared].showWidgetBorder = [obj boolValue];
        [LLSettingManager shared].showWidgetBorder = @([obj boolValue]);
        [[LLWidgetBorderHelper shared] setEnable:[obj boolValue]];
    };
    self.dataArray = @[model1];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTitleCellModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass];
    [cell setValue:model forKey:@"model"];
    return cell;
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [LLFactory getTableView:nil frame:self.view.bounds delegate:self style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.backgroundColor = [LLThemeManager shared].backgroundColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        [_tableView setSeparatorColor:[LLThemeManager shared].primaryColor];
        [_tableView registerClass:[LLTitleSwitchCell class] forCellReuseIdentifier:NSStringFromClass([LLTitleSwitchCell class])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableView;
}

@end

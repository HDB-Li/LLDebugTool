//
//  LLTitleViewController.m
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

#import "LLTitleViewController.h"

#import "LLDetailTitleSelectorCell.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleSwitchCell.h"
#import "LLTitleSliderCell.h"
#import "LLInternalMacros.h"
#import "LLTitleHeaderView.h"
#import "LLConst.h"

@interface LLTitleViewController ()

@property (nonatomic, strong) NSMutableArray <LLTitleCellCategoryModel *>*dataArray;

@end

@implementation LLTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LLTitleCell class] forCellReuseIdentifier:NSStringFromClass([LLTitleCell class])];
    [self.tableView registerClass:[LLTitleSwitchCell class] forCellReuseIdentifier:NSStringFromClass([LLTitleSwitchCell class])];
    [self.tableView registerClass:[LLDetailTitleCell class] forCellReuseIdentifier:NSStringFromClass([LLDetailTitleCell class])];
    [self.tableView registerClass:[LLDetailTitleSelectorCell class] forCellReuseIdentifier:NSStringFromClass([LLDetailTitleSelectorCell class])];
    [self.tableView registerClass:[LLTitleSliderCell class] forCellReuseIdentifier:NSStringFromClass([LLTitleSliderCell class])];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTitleCellModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClass];
    [cell setValue:model forKey:@"model"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LLTitleCellCategoryModel *model = self.dataArray[section];
    if (!model.title) {
        return nil;
    }
    LLTitleHeaderView *view = [[LLTitleHeaderView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 40)];
    view.titleLabel.text = model.title;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    LLTitleCellCategoryModel *model = self.dataArray[section];
    if (!model.title) {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTitleCellModel *model = self.dataArray[indexPath.section].items[indexPath.row];
    if (model.block) {
        model.block();
    }
}

#pragma mark - Getters and setters
- (NSMutableArray<LLTitleCellCategoryModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end

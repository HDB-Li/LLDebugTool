//
//  LLHierarchyVC.m
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

#import "LLHierarchyVC.h"
#import "LLHierarchyCell.h"
#import "LLConfig.h"

static NSString *const kHierarchyCellID = @"HierarchyCellID";

@interface LLHierarchyVC ()

@end

@implementation LLHierarchyVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSearchEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Primary
- (void)initial {
    if (self.model.isRoot) {
        self.navigationItem.title = @"Application";
    } else {
        self.navigationItem.title = self.model.viewClass;
    }
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"LLHierarchyCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kHierarchyCellID];
    
    [self loadData];
}

- (void)loadData {
    
}

- (NSMutableArray *)dataArray {
    return self.model.subModels;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLHierarchyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHierarchyCellID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
}

@end

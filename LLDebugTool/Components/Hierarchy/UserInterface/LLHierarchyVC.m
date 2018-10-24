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
#import "LLHierarchyHelper.h"

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

- (void)rightItemClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

#pragma mark - Primary
- (void)initial {
    if (!self.model) {
        self.model = [LLHierarchyHelper sharedHelper].hierarchyInApplication;
    }
    
    if (self.model.isRoot) {
        self.navigationItem.title = @"Application";
    } else {
        self.navigationItem.title = self.model.name;
    }
    
    [self initRightNavigationItemWithImageName:@"LL-pick" selectedImageName:@"LL-done"];
    
    // TableView
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"LLHierarchyCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kHierarchyCellID];
    
    NSArray *datas = [self loadData];
    [self.dataArray addObjectsFromArray:datas];
}

- (NSMutableArray *)loadData {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (LLHierarchyModel *subModel in self.model.subModels) {
        [datas addObjectsFromArray:[self loadDataFromModel:subModel]];
    }
    return datas;
}

- (NSMutableArray *)loadDataFromModel:(LLHierarchyModel *)model {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [datas addObject:model];
    if (!model.isFold) {
        for (LLHierarchyModel *subModel in model.subModels) {
            [datas addObjectsFromArray:[self loadDataFromModel:subModel]];
        }
    }
    return datas;
}

- (NSMutableArray *)allModelsFromModel:(LLHierarchyModel *)model {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:model];
    for (LLHierarchyModel *subModel in model.subModels) {
        [array addObjectsFromArray:[self allModelsFromModel:subModel]];
    }
    return array;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLHierarchyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHierarchyCellID forIndexPath:indexPath];
    LLHierarchyModel *model = self.datas[indexPath.row];
    [cell confirmWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    LLHierarchyModel *model = self.datas[indexPath.row];
    LLHierarchyModel *nextModel = nil;
    if (model.subModels.count) {
        if (self.datas.count > indexPath.row + 1) {
            nextModel = self.datas[indexPath.row + 1];
        }
        
        model.fold = !model.isFold;
    
        [self.tableView beginUpdates];
        
        
        NSArray *preData = [NSArray arrayWithArray:self.datas];
        NSArray *newData = [NSArray arrayWithArray:[self loadData]];
        
        NSMutableSet *preSet = [NSMutableSet setWithArray:preData];// 1 4 5
        NSMutableSet *newSet = [NSMutableSet setWithArray:newData];// 1 2 3
        
        NSMutableSet *intersectSet = [NSMutableSet setWithSet:preSet]; // 1 4 5
        [intersectSet intersectSet:newSet];// 1
        
        [preSet minusSet:intersectSet]; // 4 5
        [newSet minusSet:intersectSet]; // 2 3
        
        
        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        
        for (LLHierarchyModel *model in preSet.allObjects) {
            NSInteger index = [preData indexOfObject:model];
            [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        for (LLHierarchyModel *model in newSet.allObjects) {
            NSInteger index = [newData indexOfObject:model];
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        if (deleteIndexPaths.count) {
            [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        if (insertIndexPaths) {
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:newData];
        
        [self.tableView endUpdates];

        LLHierarchyCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell updateDirection];
        
        NSMutableArray *reloadIndexPaths = [[NSMutableArray alloc] init];
        if (self.datas.count > indexPath.row + 1) {
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            [reloadIndexPaths addObject:nextIndexPath];
        }
        if (nextModel != nil && [self.datas containsObject:nextModel]) {
            NSInteger index = [self.datas indexOfObject:nextModel];
            NSIndexPath *preNextIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [reloadIndexPaths addObject:preNextIndexPath];
        }
        if (reloadIndexPaths.count) {
            [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
}

@end

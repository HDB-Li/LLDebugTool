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
    
    // TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"LLHierarchyCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kHierarchyCellID];
    
    [self loadData];
}

- (void)loadData {
    [self.dataArray removeAllObjects];
    for (LLHierarchyModel *subModel in self.model.subModels) {
        [self loadDataFromModel:subModel];
    }
//    [self.tableView reloadData];
}

- (void)loadDataFromModel:(LLHierarchyModel *)model {
    [self.dataArray addObject:model];
    if (!model.isFold) {
        for (LLHierarchyModel *subModel in model.subModels) {
            [self loadDataFromModel:subModel];
        }
    }
}

- (NSMutableArray *)allModelsFromModel:(LLHierarchyModel *)model {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:model];
    for (LLHierarchyModel *subModel in model.subModels) {
        [array addObjectsFromArray:[self allModelsFromModel:subModel]];
    }
    return array;
}


//- (NSMutableArray *)dataArray {
//    return self.model.subModels;
//}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLHierarchyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHierarchyCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.datas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    LLHierarchyModel *model = self.datas[indexPath.row];
    if (model.subModels.count) {
        model.fold = !model.isFold;
    
        [self.tableView beginUpdates];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSMutableArray *models = [[NSMutableArray alloc] init];
        NSMutableArray *array = [self allModelsFromModel:model];
        [array removeObject:model];
        
        if (model.isFold) {
            for (LLHierarchyModel *subModel in array) {
                if ([self.datas containsObject:subModel]) {
                    NSInteger index = [self.datas indexOfObject:subModel];
                    [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                    [models addObject:subModel];
                }
            }
            
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [self.datas removeObjectsInArray:models];
        } else {
            for (int i = 0; i < array.count; i++) {
                LLHierarchyModel *subModel = array[i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:0]];
                [models addObject:subModel];
            }
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [self.datas insertObjects:models atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, array.count)]];
        }

        [self.tableView endUpdates];

        LLHierarchyCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell updateDirection];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
}

@end

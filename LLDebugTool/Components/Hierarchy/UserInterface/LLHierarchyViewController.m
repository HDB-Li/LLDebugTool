//
//  LLHierarchyViewController.m
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

#import "LLHierarchyViewController.h"
#import "LLHierarchyCell.h"
#import "LLConfig.h"
#import "LLHierarchyHelper.h"

static NSString *const kHierarchyCellID = @"HierarchyCellID";

@interface LLHierarchyViewController () <LLHierarchyCellDelegate>

@property (nonatomic , strong , nonnull) LLHierarchyModel *model;

@end

@implementation LLHierarchyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSearchEnable = YES;
        self.isSelectEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Primary
- (void)initial {
    // TableView
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"LLHierarchyCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellReuseIdentifier:kHierarchyCellID];    
}

- (void)loadData {

    self.model = [LLHierarchyHelper sharedHelper].hierarchyInApplication;
    
    self.navigationItem.title = @"View Hierarchy";
    
    NSArray *datas = [self datasFromCurrentModel];
    [self.dataArray addObjectsFromArray:datas];
    
    self.selectView = [self.datas[21] view];
    
    [self.tableView reloadData];
    
    if (self.selectView) {
        for (int i = 0; i < self.datas.count; i++) {
            LLHierarchyModel *model = self.datas[i];
            if (model.view == self.selectView) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
                break;
            }
        }
    }
}

- (NSMutableArray *)datasFromCurrentModel {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for (LLHierarchyModel *subModel in self.model.subModels) {
        [datas addObjectsFromArray:[self unfoldModelsFromModel:subModel]];
    }
    return datas;
}

- (NSMutableArray *)unfoldModelsFromModel:(LLHierarchyModel *)model {
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    [datas addObject:model];
    if (!model.isFold) {
        for (LLHierarchyModel *subModel in model.subModels) {
            [datas addObjectsFromArray:[self unfoldModelsFromModel:subModel]];
        }
    }
    return datas;
}

#pragma mark - LLHierarchyCellDelegate
- (void)LLHierarchyCellDidSelectFoldButton:(LLHierarchyCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LLHierarchyModel *model = self.datas[indexPath.row];
    LLHierarchyModel *nextModel = nil;
    if (model.subModels.count) {
        if (self.datas.count > indexPath.row + 1) {
            nextModel = self.datas[indexPath.row + 1];
        }
        
        model.fold = !model.isFold;
        
        [self.tableView beginUpdates];
        
        NSArray *preData = [NSArray arrayWithArray:self.datas];
        NSArray *newData = [NSArray arrayWithArray:[self datasFromCurrentModel]];
        
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

- (void)LLHierarchyCellDidSelectInfoButton:(LLHierarchyCell *)cell {
    
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLHierarchyCell *cell = [tableView dequeueReusableCellWithIdentifier:kHierarchyCellID forIndexPath:indexPath];
    cell.delegate = self;
    LLHierarchyModel *model = self.datas[indexPath.row];
    [cell confirmWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self leftItemClick];
    [self.delegate LLHierarchyViewController:self didFinishWithSelectedModel:self.datas[indexPath.row]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
}

@end

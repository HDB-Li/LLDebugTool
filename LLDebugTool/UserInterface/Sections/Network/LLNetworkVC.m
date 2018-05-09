//
//  LLNetworkVC.m
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

#import "LLNetworkVC.h"
#import "LLNetworkCell.h"
#import "LLNetworkModel.h"
#import "LLStorageManager.h"
#import "LLNetworkContentVC.h"
#import "LLImageNameConfig.h"
#import "LLAppHelper.h"
#import "LLConfig.h"

static NSString *const kNetworkCellID = @"NetworkCellID";

@interface LLNetworkVC ()

@property (nonatomic , strong) NSMutableArray *httpDataArray;

@property (nonatomic , strong) NSMutableArray *socketDataArray;

@property (nonatomic , strong) UISegmentedControl *segment;

@end

@implementation LLNetworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Actions
- (void)segmentValueChanged:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (void)rightItemClick {
    NSArray *dataArray = self.segment.selectedSegmentIndex == 0 ? self.httpDataArray : self.socketDataArray;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self showDeleteAlertWithIndexPaths:indexPaths];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.segment.selectedSegmentIndex == 0 ? self.httpDataArray.count : self.socketDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLNetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.segment.selectedSegmentIndex == 0 ? self.httpDataArray[indexPath.row] : self.socketDataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LLNetworkContentVC *vc = [[LLNetworkContentVC alloc] init];
    vc.model = self.segment.selectedSegmentIndex == 0 ? self.httpDataArray[indexPath.row] : self.socketDataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Primary
- (void)initial {
    if (_launchDate == nil) {
        _launchDate = [LLAppHelper sharedHelper].launchDate;
    }
    self.httpDataArray = [[NSMutableArray alloc] init];
    self.socketDataArray = [[NSMutableArray alloc] init];
    [self initTitleView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LLNetworkCell" bundle:nil] forCellReuseIdentifier:kNetworkCellID];
    [self loadData];
}

- (void)initTitleView {
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"Http",@"Socket"]];
    self.segment.frame = CGRectMake(0, 0, 100, 30);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    // TODO config socket.
//    self.navigationItem.titleView = self.segment;
    self.navigationItem.title = @"Network Request";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:kClearImageName] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (LLCONFIG_CUSTOM_COLOR) {
        btn.tintColor = LLCONFIG_TEXT_COLOR;
        [btn setImage:[[UIImage imageNamed:kClearImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

- (void)loadData {
    [self.httpDataArray removeAllObjects];
    [self.httpDataArray addObjectsFromArray:[[LLStorageManager sharedManager] getAllNetworkModelsWithLaunchDate:_launchDate]];
    [self.tableView reloadData];
}

- (void)showDeleteAlertWithIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count) {
        [self showAlertControllerWithMessage:@"Sure to remove items ?" handler:^(NSInteger action) {
            if (action == 1) {
                [self deleteFilesWithIndexPaths:indexPaths];
            }
        }];
    }
}

- (void)deleteFilesWithIndexPaths:(NSArray *)indexPaths {
    NSMutableArray *dataArray = self.segment.selectedSegmentIndex == 0 ? self.httpDataArray : self.socketDataArray;
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:dataArray[indexPath.row]];
    }
    if ([[LLStorageManager sharedManager] removeNetworkModels:models]) {
        [dataArray removeObjectsInArray:models];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self showAlertControllerWithMessage:@"Remove network model fail" handler:^(NSInteger action) {
            if (action == 1) {
                [self loadData];
            }
        }];
    }
}

@end

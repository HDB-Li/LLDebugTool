//
//  LLFunctionViewController.m
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

#import "LLFunctionViewController.h"
#import "LLFunctionModel.h"
#import "LLFunctionCell.h"
#import "LLConfig.h"
#import "LLImageNameConfig.h"
#import "LLMacros.h"

static NSString *const kCellID = @"cellID";

@interface LLFunctionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong, nonnull) UICollectionView *collectionView;

@property (nonatomic, strong, nonnull) NSArray <LLFunctionModel *>*dataArray;

@end

@implementation LLFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Public

#pragma mark - Primary
- (void)initial {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((LL_SCREEN_WIDTH - 10 * 2) / 4.0, 110);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLFunctionCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellWithReuseIdentifier:kCellID];
    [self.view addSubview:self.collectionView];
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:kNetworkImageName title:@"Net" action:LLFunctionActionNetwork]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:kLogImageName title:@"Log" action:LLFunctionActionLog]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:kCrashImageName title:@"Crash" action:LLFunctionActionCrash]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:kAppImageName title:@"App Info" action:LLFunctionActionAppInfo]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:kSandboxImageName title:@"Sandbox" action:LLFunctionActionSandbox]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:@"" title:@"Screenshot" action:LLFunctionActionScreenshot]];
    [items addObject:[[LLFunctionModel alloc] initWithImageName:@"" title:@"Hierarchy" action:LLFunctionActionHierarchy]];
    self.dataArray = [items copy];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLFunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

@end

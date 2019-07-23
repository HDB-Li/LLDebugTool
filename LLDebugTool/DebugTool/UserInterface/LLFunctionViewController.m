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
#import "LLFactory.h"
#import "LLNetworkViewController.h"
#import "LLLogViewController.h"
#import "LLCrashViewController.h"
#import "LLAppInfoViewController.h"
#import "LLSandboxViewController.h"
#import "LLHierarchyViewController.h"

static NSString *const kCellID = @"cellID";

@interface LLFunctionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, LLHierarchyViewControllerDelegate>

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
    self.navigationItem.title = @"LLDebugTool";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((LL_SCREEN_WIDTH - 10 * 2) / 3.0, 90);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [LLFactory getCollectionView:self.view frame:self.view.bounds delegate:self layout:layout];
    self.collectionView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLFunctionCell" bundle:[LLConfig sharedConfig].XIBBundle] forCellWithReuseIdentifier:kCellID];
    
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

- (void)goToNetworkViewController {
    LLNetworkViewController *vc = [[LLNetworkViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToLogViewController {
    LLLogViewController *vc = [[LLLogViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToCrashViewController {
    LLCrashViewController *vc = [[LLCrashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToAppInfoViewController {
    LLAppInfoViewController *vc = [[LLAppInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToSandboxViewController {
    LLSandboxViewController *vc = [[LLSandboxViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doScreenshot {
    
}

- (void)goToHierarchyViewController {
    LLHierarchyViewController *vc = [[LLHierarchyViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LLFunctionModel *model = self.dataArray[indexPath.item];
    switch (model.action) {
        case LLFunctionActionNetwork:
            [self goToNetworkViewController];
            break;
        case LLFunctionActionLog:
            [self goToLogViewController];
            break;
        case LLFunctionActionCrash:
            [self goToCrashViewController];
            break;
        case LLFunctionActionAppInfo:
            [self goToAppInfoViewController];
            break;
        case LLFunctionActionSandbox:
            [self goToSandboxViewController];
            break;
        case LLFunctionActionScreenshot:
            [self doScreenshot];
            break;
        case LLFunctionActionHierarchy:
            [self goToHierarchyViewController];
            break;
        default:
            break;
    }
}

#pragma mark - LLHierarchyViewControllerDelegate
- (void)LLHierarchyViewController:(LLHierarchyViewController *)viewController didFinishWithSelectedModel:(LLHierarchyModel *)selectedModel {
    [self.delegate LLFunctionViewController:self didSelectedHierarchyModel:selectedModel];
}

@end

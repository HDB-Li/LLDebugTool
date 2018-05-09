//
//  LLFilterLevelView.m
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

#import "LLFilterLevelView.h"
#import "LLFilterLabelCell.h"
#import "LLTool.h"
#import "LLLogHelper.h"
#import "LLMacros.h"
#import "LLConfig.h"

static NSString *const kLabelCellID = @"FilterLabelCell";

@interface LLFilterLevelView () <UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UICollectionView *collectionView;

@end

@implementation LLFilterLevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
/**
 * initial method
 */
- (void)initial {
    self.dataArray = [[NSMutableArray alloc] init];
    for (NSString *level in [LLLogHelper levelsDescription]) {
        LLFilterLabelModel *model = [[LLFilterLabelModel alloc] init];
        model.message = level;
        [self.dataArray addObject:model];
    }
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LLFilterLabelCell" bundle:nil] forCellWithReuseIdentifier:kLabelCellID];
    [self addSubview:self.collectionView];
    [LLTool lineView:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1) superView:self];
    if (LLCONFIG_CUSTOM_COLOR) {
        self.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
        self.collectionView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    }
}

- (void)reCalculateFilters {
    if (_changeBlock) {
        NSMutableArray *filters = [[NSMutableArray alloc] init];
        for (LLFilterLabelModel *model in self.dataArray) {
            if (model.isSelected) {
                [filters addObject:model.message];
            }
        }
        _changeBlock(filters);
    }
}

#pragma mark - UICollectionViewDelegate , UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLFilterLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLabelCellID forIndexPath:indexPath];
    [cell confirmWithModel:self.dataArray[indexPath.item]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((LL_SCREEN_WIDTH - 10 * 5) / 4.0, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LLFilterLabelModel *model = self.dataArray[indexPath.item];
    model.isSelected = !model.isSelected;
    
    LLFilterLabelCell *cell = (LLFilterLabelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell confirmWithModel:model];
    
    [self reCalculateFilters];
}

@end

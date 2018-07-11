//
//  LLFilterEventView.m
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

#import "LLFilterEventView.h"
#import "LLFilterLabelCell.h"
#import "LLMacros.h"
#import "LLTool.h"
#import "LLConfig.h"

static NSString *const kEventCellID = @"EventCellID";

@interface LLFilterEventView () <UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UIView *lineView;

@end

@implementation LLFilterEventView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)updateDataArray:(NSArray <LLFilterLabelModel *>*)dataArray {
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.collectionView reloadData];
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    if (height > LL_SCREEN_HEIGHT / 3.0) {
        height = LL_SCREEN_HEIGHT / 3.0;
    } else if (height < 50) {
        height = 50;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
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
    LLFilterLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEventCellID forIndexPath:indexPath];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LLFilterLabelModel *model = self.dataArray[indexPath.item];
    model.isSelected = !model.isSelected;
    
    LLFilterLabelCell *cell = (LLFilterLabelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell confirmWithModel:model];
    [self reCalculateFilters];
}

#pragma mark - Primary
- (void)initial {
    self.dataArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(50, [UIFont systemFontOfSize:17].lineHeight + 12);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"LLFilterLabelCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:kEventCellID];
    [self addSubview:_collectionView];
    self.lineView = [LLTool lineView:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1) superView:self];
    if (LLCONFIG_CUSTOM_COLOR) {
        self.collectionView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    }
}

@end

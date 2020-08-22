//
//  UICollectionView+LL_Hierarchy.m
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

#import "UICollectionView+LL_Hierarchy.h"

#import "LLDetailTitleCellModel.h"
#import "LLFormatterTool.h"
#import "LLHierarchyFormatter.h"
#import "LLTitleCellCategoryModel.h"

#import "NSMutableArray+LL_Utils.h"
#import "NSObject+LL_Hierarchy.h"

@implementation UICollectionView (LL_Hierarchy)

- (NSMutableArray<LLTitleCellCategoryModel *> *)LL_hierarchyCategoryModels {
    NSMutableArray *settings = [[NSMutableArray alloc] init];

    LLDetailTitleCellModel *model1 = [LLDetailTitleCellModel modelWithTitle:@"Sections" detailTitle:[NSString stringWithFormat:@"%ld", (long)self.numberOfSections]];
    [settings addObject:model1];

    LLDetailTitleCellModel *model2 = [[LLDetailTitleCellModel modelWithTitle:@"Delegate" detailTitle:[LLHierarchyFormatter formatObject:self.delegate]] noneInsets];
    [settings addObject:model2];

    LLDetailTitleCellModel *model3 = [[LLDetailTitleCellModel modelWithTitle:@"Data Source" detailTitle:[LLHierarchyFormatter formatObject:self.dataSource]] noneInsets];
    [settings addObject:model3];

    LLDetailTitleCellModel *model4 = [LLDetailTitleCellModel modelWithTitle:@"Layout" detailTitle:[LLHierarchyFormatter formatObject:self.collectionViewLayout]];
    [settings addObject:model4];

    LLTitleCellCategoryModel *model = [LLTitleCellCategoryModel modelWithTitle:@"Collection View" items:settings];

    NSMutableArray *result = [super LL_hierarchyCategoryModels];
    [result LL_insertObject:model atIndex:1];
    return result;
}

@end

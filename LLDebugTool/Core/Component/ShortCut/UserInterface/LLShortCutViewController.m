//
//  LLShortCutViewController.m
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

#import "LLShortCutViewController.h"

#import "LLTitleCellCategoryModel.h"
#import "LLTitleCellModel.h"
#import "LLInternalMacros.h"
#import "LLShortCutHelper.h"
#import "LLShortCutModel.h"
#import "LLToastUtils.h"
#import "LLConfig.h"

@interface LLShortCutViewController ()

@end

@implementation LLShortCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LLLocalizedString(@"function.short.cut");
    [self loadData];
}

#pragma mark - Primary
- (void)loadData {
    [self.dataArray removeAllObjects];
    NSMutableArray *settings = [[NSMutableArray alloc] init];
    
    NSMutableArray *actions = [[LLShortCutHelper shared].actions copy];
    
    for (NSInteger i = 0; i < actions.count; i++) {
        __block LLShortCutModel *action = actions[i];
        LLTitleCellModel *model = [[LLTitleCellModel alloc] initWithTitle:action.name block:^{
            NSString *message = action.action();
            if (![message length]) {
                message = [NSString stringWithFormat:LLLocalizedString(@"short.cut.execute"), action.name];
            }
            [[LLToastUtils shared] toastMessage:message];
        }];
        [settings addObject:model];
    }
    
    LLTitleCellCategoryModel *category = [[LLTitleCellCategoryModel alloc] initWithTitle:nil items:settings];
    [self.dataArray addObject:category];
    [settings removeAllObjects];
}

@end

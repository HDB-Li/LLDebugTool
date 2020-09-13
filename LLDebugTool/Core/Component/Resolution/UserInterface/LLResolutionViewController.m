//
//  LLResolutionViewController.m
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

#import "LLResolutionViewController.h"

#import "LLDebugConfig.h"
#import "LLDebugToolMacros.h"
#import "LLInternalMacros.h"
#import "LLResolutionHelper.h"
#import "LLResolutionModel.h"
#import "LLTitleCellCategoryModel.h"
#import "LLTitleCellModel.h"
#import "LLToastUtils.h"

#import "UIViewController+LL_Utils.h"

@interface LLResolutionViewController ()

@end

@implementation LLResolutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initial];
}

#pragma mark - Primary
- (void)initial {
    self.title = LLLocalizedString(@"function.resolution");
    [self loadData];
}

- (void)loadData {
    [self.dataArray removeAllObjects];

    NSMutableArray *settings = [[NSMutableArray alloc] init];

    // Supports
    __weak typeof(self) weakSelf = self;
    LLResolutionStyle makeStyle = LLDT_CC_Resolution.mockStyle == LLResolutionStyleInvalid ? LLDT_CC_Resolution.realStyle : LLDT_CC_Resolution.mockStyle;
    for (NSNumber *number in LLDT_CC_Resolution.availableResolutions) {
        LLResolutionStyle style = number.integerValue;
        LLResolutionModel *resolutionModel = [[LLResolutionModel alloc] initWithStyle:style];
        LLTitleCellModel *model = [LLTitleCellModel modelWithTitle:resolutionModel.name];
        if (style == makeStyle) {
            model.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            model.block = ^{
                [weakSelf showAlertWithStyle:style];
            };
            model.accessoryType = UITableViewCellAccessoryNone;
        }
        [settings addObject:model];
    }
    LLTitleCellCategoryModel *category = [LLTitleCellCategoryModel modelWithTitle:LLLocalizedString(@"resolution.choose") items:settings];
    [self.dataArray addObject:category];
}

- (void)showAlertWithStyle:(LLResolutionStyle)style {
    __weak typeof(self) weakSelf = self;
    [self LL_showAlertControllerWithTitle:LLLocalizedString(@"resolution.alert.title")
                                  message:LLLocalizedString(@"resolution.alert.message")
                                  handler:^(NSInteger action) {
                                      if (action) {
                                          [weakSelf changeStyle:style];
                                      }
                                  }];
}

- (void)changeStyle:(LLResolutionStyle)style {
    if (style == LLResolutionStyleInvalid) {
        return;
    }
    LLResolutionStyle mockStyle = style;
    if (mockStyle == LLDT_CC_Resolution.realStyle) {
        mockStyle = LLResolutionStyleInvalid;
    }
    LLDT_CC_Resolution.mockStyle = mockStyle;
    [[LLToastUtils shared] toastMessage:LLLocalizedString(@"resolution.change.success")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        exit(0);
    });
}

@end

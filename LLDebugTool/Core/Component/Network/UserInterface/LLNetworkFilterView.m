//
//  LLNetworkFilterView.m
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

#import "LLNetworkFilterView.h"

#import "LLFilterLabelModel.h"
#import "LLFilterEventView.h"
#import "LLFilterDateView.h"
#import "LLInternalMacros.h"
#import "LLFormatterTool.h"
#import "LLNetworkModel.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIButton+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLNetworkFilterView ()

@property (nonatomic, strong) LLFilterEventView *hostView;

@property (nonatomic, strong) LLFilterEventView *typeView;

@property (nonatomic, strong) LLFilterDateView *dateView;

// Data
@property (nonatomic, strong) NSArray *currentHost;
@property (nonatomic, strong) NSArray *currentTypes;
@property (nonatomic, strong) NSDate *currentFromDate;
@property (nonatomic, strong) NSDate *currentEndDate;

@end

@implementation LLNetworkFilterView

#pragma mark - Public
- (void)configWithData:(NSArray <LLNetworkModel *>*)data {
  
    NSMutableSet *hostSet = [NSMutableSet set];
    
    NSString *fromString = data.lastObject.startDate;
    NSString *endString = data.firstObject.startDate;
    
    NSDate *fromDate = [LLFormatterTool dateFromString:fromString style:FormatterToolDateStyle1];
    NSDate *endDate = [LLFormatterTool dateFromString:endString style:FormatterToolDateStyle1];
    if (!fromDate) {
        fromDate = [NSDate date];
    }
    if (!endDate) {
        endDate = [NSDate date];
    }
    
    for (LLNetworkModel *model in data) {
        if (model.url.host.length) {
            [hostSet addObject:model.url.host];
        }
    }
    
    // Host Part
    self.hostView.hidden = YES;
    NSMutableArray *hostArray = [[NSMutableArray alloc] init];
    for (NSString *host in hostSet.allObjects) {
        LLFilterLabelModel *model = [[LLFilterLabelModel alloc] initWithMessage:host];
        [hostArray addObject:model];
    }
    CGFloat lineNo = (hostArray.count / self.hostView.averageCount + (hostArray.count % self.hostView.averageCount == 0 ? 0 : 1));
    if (lineNo > 6) {
        lineNo = 6;
    } else if (lineNo < 1) {
        lineNo = 1;
    }
    CGFloat eventHeight = lineNo * 40 + kLLGeneralMargin;
    self.hostView.frame = CGRectMake(self.hostView.frame.origin.x, self.hostView.frame.origin.y, self.hostView.frame.size.width, eventHeight);
    [self.hostView updateDataArray:hostArray];
    
    // Type Part
    self.typeView.hidden = YES;
    
    // Date Part
    self.dateView.hidden = YES;
    [self.dateView updateFromDate:fromDate endDate:endDate];
}

- (void)reCalculateFilters {
    if (_changeBlock) {
        _changeBlock(self.currentHost,self.currentTypes,
                     self.currentFromDate,self.currentEndDate);
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.titles = @[@"Host",@"Filter",@"Date"];
    self.filterViews = @[self.hostView, self.typeView, self.dateView];
}

#pragma mark - Getters and setters
- (LLFilterEventView *)hostView {
    if (!_hostView) {
        _hostView = [[LLFilterEventView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 100)];
        _hostView.clipsToBounds = YES;
        _hostView.averageCount = 3;
        __weak typeof(self) weakSelf = self;
        _hostView.changeBlock = ^(NSArray *hosts) {
            weakSelf.currentHost = hosts;
            [weakSelf reCalculateFilters];
            [weakSelf updateFilterButton:weakSelf.hostView count:hosts.count];
        };
        [self addSubview:_hostView];
    }
    return _hostView;
}

- (LLFilterEventView *)typeView {
    if (!_typeView) {
        _typeView = [[LLFilterEventView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 50)];
        _typeView.clipsToBounds = YES;
        _typeView.averageCount = 3;
        LLFilterLabelModel *model1 = [[LLFilterLabelModel alloc] initWithMessage:@"Header"];
        LLFilterLabelModel *model2 = [[LLFilterLabelModel alloc] initWithMessage:@"Body"];
        LLFilterLabelModel *model3 = [[LLFilterLabelModel alloc] initWithMessage:@"Response"];
        [_typeView updateDataArray:@[model1,model2,model3]];
        __weak typeof(self) weakSelf = self;
        _typeView.changeBlock = ^(NSArray *types) {
            weakSelf.currentTypes = types;
            [weakSelf reCalculateFilters];
            [weakSelf updateFilterButton:weakSelf.typeView count:types.count];
        };
        [self addSubview:_typeView];
    }
    return _typeView;
}

- (LLFilterDateView *)dateView {
    if (!_dateView) {
        _dateView = [[LLFilterDateView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 120)];
        _dateView.clipsToBounds = YES;
        __weak typeof(self) weakSelf = self;
        _dateView.changeBlock = ^(NSDate *from, NSDate *end) {
            weakSelf.currentFromDate = from;
            weakSelf.currentEndDate = end;
            [weakSelf reCalculateFilters];
            NSInteger count = 0;
            count += from ? 1 : 0;
            count += end ? 1 : 0;
            [weakSelf updateFilterButton:weakSelf.dateView count:count];
        };
        [self addSubview:_dateView];
    }
    return _dateView;
}

@end

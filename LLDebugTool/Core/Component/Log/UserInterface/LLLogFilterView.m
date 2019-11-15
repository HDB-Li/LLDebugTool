//
//  LLLogFilterView.m
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

#import "LLLogFilterView.h"

#import "LLFilterLabelModel.h"
#import "LLFilterEventView.h"
#import "LLFilterOtherView.h"
#import "LLInternalMacros.h"
#import "LLFormatterTool.h"
#import "LLThemeManager.h"
#import "LLLogModel.h"
#import "LLFactory.h"
#import "LLConfig.h"
#import "LLConst.h"

#import "UIButton+LL_Utils.h"
#import "UIView+LL_Utils.h"

@interface LLLogFilterView()

@property (nonatomic, strong) LLFilterEventView *levelView;

@property (nonatomic, strong) LLFilterEventView *eventView;

@property (nonatomic, strong) LLFilterOtherView *otherView;

// Data
@property (nonatomic, strong) NSArray *currentLevels;
@property (nonatomic, strong) NSArray *currentEvents;
@property (nonatomic, copy) NSString *currentFile;
@property (nonatomic, copy) NSString *currentFunc;
@property (nonatomic, strong) NSDate *currentFromDate;
@property (nonatomic, strong) NSDate *currentEndDate;
@property (nonatomic, strong) NSArray *currentUserIds;

@end

@implementation LLLogFilterView

#pragma mark - Public
- (void)configWithData:(NSArray <LLLogModel *>*)data {
    NSMutableSet *eventSet = [NSMutableSet set];
    NSMutableSet *userIDSet = [NSMutableSet set];
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
    
    NSString *fromDateString = data.lastObject.date;
    NSString *endDateString = data.firstObject.date;

    NSDate *fromDate = [LLFormatterTool dateFromString:fromDateString style:FormatterToolDateStyle1];
    NSDate *endDate = [LLFormatterTool dateFromString:endDateString style:FormatterToolDateStyle1];
    if (!fromDate) {
        fromDate = [NSDate date];
    }
    if (!endDate) {
        endDate = [NSDate date];
    }
    
    for (LLLogModel *model in data) {
        if (model.event.length) {
            [eventSet addObject:model.event];
        }
        if (model.userIdentity.length) {
            [userIDSet addObject:model.userIdentity];
        }
        if (model.file.length) {
            NSMutableArray *funcArray = fileDic[model.file];
            if (funcArray) {
                if ([funcArray containsObject:model.function] == NO) {
                    [funcArray addObject:model.function];
                }
            } else {
                fileDic[model.file] = [[NSMutableArray alloc] initWithObjects:model.function, nil];
            }
        }
    }
    
    // Level Part
    self.levelView.hidden = YES;
    
    // Event Part
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    for (NSString *event in eventSet.allObjects) {
        LLFilterLabelModel *model = [[LLFilterLabelModel alloc] initWithMessage:event];
        [eventArray addObject:model];
    }

    self.eventView.hidden = YES;
    CGFloat lineNo = (eventArray.count / self.eventView.averageCount + (eventArray.count % self.eventView.averageCount == 0 ? 0 : 1));
    if (lineNo > 6) {
        lineNo = 6;
    } else if (lineNo < 1) {
        lineNo = 1;
    }
    CGFloat eventHeight = lineNo * 40 + kLLGeneralMargin;
    self.eventView.frame = CGRectMake(self.eventView.frame.origin.x, self.eventView.frame.origin.y, self.eventView.frame.size.width, eventHeight);
    [self.eventView updateDataArray:eventArray];
    
    // Other Part
    self.otherView.hidden = YES;
    [self.otherView updateFileDataDictionary:fileDic fromDate:fromDate endDate:endDate userIdentities:userIDSet.allObjects];
}

- (void)reCalculateFilters {
    if (_changeBlock) {
        _changeBlock(self.currentLevels,self.currentEvents,
                     self.currentFile,self.currentFunc,
                     self.currentFromDate,self.currentEndDate,
                     self.currentUserIds);
    }
}

#pragma mark - Over write
- (void)initUI {
    [super initUI];
    
    self.titles = @[@"Level",@"Event",@"Other"];
    self.filterViews = @[self.levelView, self.eventView, self.otherView];
}

#pragma mark - Getters and setters
- (LLFilterEventView *)levelView {
    if (!_levelView) {
        _levelView = [[LLFilterEventView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _levelView.averageCount = 4;
        _levelView.clipsToBounds = YES;
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSString *level in [LLLogHelper levelsDescription]) {
            LLFilterLabelModel *model = [[LLFilterLabelModel alloc] initWithMessage:level];
            [dataArray addObject:model];
        }
        [_levelView updateDataArray:dataArray];
        __weak typeof(self) weakSelf = self;
        _levelView.changeBlock = ^(NSArray *levels) {
            weakSelf.currentLevels = levels;
            [weakSelf reCalculateFilters];
            [weakSelf updateFilterButton:weakSelf.levelView count:levels.count];
        };
        [self addSubview:_levelView];
    }
    return _levelView;
}

- (LLFilterEventView *)eventView {
    if (!_eventView) {
        _eventView = [[LLFilterEventView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 50)];
        _eventView.averageCount = 3;
        _eventView.clipsToBounds = YES;
        __weak typeof(self) weakSelf = self;
        _eventView.changeBlock = ^(NSArray *events) {
            weakSelf.currentEvents = events;
            [weakSelf reCalculateFilters];
            [weakSelf updateFilterButton:weakSelf.eventView count:events.count];
        };
        [self addSubview:_eventView];
    }
    return _eventView;
}

- (LLFilterOtherView *)otherView {
    if (!_otherView) {
        _otherView = [[LLFilterOtherView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 320)];
        _otherView.clipsToBounds = YES;
        __weak typeof(self) weakSelf = self;
        _otherView.changeBlock = ^(NSString *file, NSString *func, NSDate *from, NSDate *end, NSArray *userIdentities) {
            weakSelf.currentFile = file;
            weakSelf.currentFunc = func;
            weakSelf.currentFromDate = from;
            weakSelf.currentEndDate = end;
            weakSelf.currentUserIds = userIdentities;
            [weakSelf reCalculateFilters];
            NSInteger count = 0;
            count += file.length ? 1 : 0;
            count += func.length ? 1 : 0;
            count += from ? 1 : 0;
            count += end ? 1 : 0;
            count += userIdentities.count;
            [weakSelf updateFilterButton:weakSelf.otherView count:count];
        };
        [self addSubview:_otherView];
    }
    return _otherView;
}

@end

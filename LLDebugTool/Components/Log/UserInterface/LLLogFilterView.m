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
#import "LLTool.h"
#import "LLLogModel.h"
#import "UIButton+LL_Utils.h"
#import "LLFilterEventView.h"
#import "LLFilterOtherView.h"
#import "LLMacros.h"
#import "LLConfig.h"

@interface LLLogFilterView()

@property (nonatomic , strong) NSArray *titles;

@property (nonatomic , assign) CGRect normalFrame;

// Buttons
@property (nonatomic , strong) UIView *btnsBgView;

@property (nonatomic , strong) NSMutableArray *filterBtns;

// Details
@property (nonatomic , strong) NSMutableArray *filterViews;

@property (nonatomic , strong) LLFilterEventView *levelView;

@property (nonatomic , strong) LLFilterEventView *eventView;

@property (nonatomic , strong) LLFilterOtherView *otherView;

// Data
@property (nonatomic , strong) NSArray *currentLevels;
@property (nonatomic , strong) NSArray *currentEvents;
@property (nonatomic , copy) NSString *currentFile;
@property (nonatomic , copy) NSString *currentFunc;
@property (nonatomic , strong) NSDate *currentFromDate;
@property (nonatomic , strong) NSDate *currentEndDate;
@property (nonatomic , strong) NSArray *currentUserIds;

@end

@implementation LLLogFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _normalFrame = frame;
        [self initial];
    }
    return self;
}

- (BOOL)isFiltering {
    BOOL ret = NO;
    for (UIButton *btn in self.filterBtns) {
        if (btn.isSelected) {
            ret = YES;
            break;
        }
    }
    return ret;
}

- (void)cancelFiltering {
    for (UIButton *btn in self.filterBtns) {
        if (btn.selected == YES) {
            [self filterButtonClick:btn];
        }
    }
}

- (void)configWithData:(NSArray *)data {
    NSMutableSet *eventSet = [NSMutableSet set];
    NSMutableSet *userIDSet = [NSMutableSet set];
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
    
    NSDate *fromDate = [LLTool dateFromString:((LLLogModel *)data.lastObject).date];
    NSDate *endDate = [LLTool dateFromString:((LLLogModel *)data.firstObject).date];
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
    [self.filterViews removeAllObjects];
    [self.filterViews addObject:self.levelView];
    self.levelView.hidden = YES;
    
    // Event Part
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    for (NSString *event in eventSet.allObjects) {
        LLFilterLabelModel *model = [[LLFilterLabelModel alloc] initWithMessage:event];
        [eventArray addObject:model];
    }
    [self.filterViews addObject:self.eventView];
    self.eventView.hidden = YES;
    [self.eventView updateDataArray:eventArray];
    
    // Other Part
    [self.filterViews addObject:self.otherView];
    self.otherView.hidden = YES;
    [self.otherView updateFileDataDictionary:fileDic fromDate:fromDate endDate:endDate userIdentities:userIDSet.allObjects];
    
    // Final
    [self bringSubviewToFront:self.btnsBgView];
}

- (void)reCalculateFilters {
    if (_changeBlock) {
        _changeBlock(self.currentLevels,self.currentEvents,
                     self.currentFile,self.currentFunc,
                     self.currentFromDate,self.currentEndDate,
                     self.currentUserIds);
    }
}

- (void)updateFilterButton:(UIView *)filterView count:(NSInteger)count {
    NSInteger index = [self.filterViews indexOfObject:filterView];
    if (index != NSNotFound) {
        UIButton *sender = self.filterBtns[index];
        NSString *title = self.titles[index];
        if (count == 0) {
            [sender setTitle:title forState:UIControlStateNormal];
        } else {
            [sender setTitle:[NSString stringWithFormat:@"%@ - %ld",title,(long)count] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Action
- (void)filterButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == NO) {
        self.frame = self.normalFrame;
        [self hideDetailView:sender.tag];
    } else {
        for (UIButton *btn in self.filterBtns) {
            if (btn != sender && btn.selected) {
                btn.selected = NO;
                [self hideDetailView:btn.tag];
            }
        }
        [self showDetailView:sender.tag];
    }
    [self endEditing:YES];
}

#pragma mark - Primary
- (void)initial {
    self.filterViews = [[NSMutableArray alloc] init];
    self.filterBtns = [[NSMutableArray alloc] init];
    
    self.btnsBgView = [[UIView alloc] initWithFrame:self.bounds];
    self.btnsBgView.backgroundColor = LLCONFIG_BACKGROUND_COLOR;
    [self addSubview:self.btnsBgView];
    
    CGFloat gap = 20;
    CGFloat itemHeight = 25;
    NSInteger count = self.titles.count;
    CGFloat itemWidth = (self.frame.size.width - gap * (count + 1)) / count;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * (itemWidth + gap) + gap, (self.frame.size.height - itemHeight) / 2.0, itemWidth, itemHeight);
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitleColor:LLCONFIG_TEXT_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:LLCONFIG_BACKGROUND_COLOR forState:UIControlStateSelected];
        [btn LL_setBackgroundColor:LLCONFIG_BACKGROUND_COLOR forState:UIControlStateNormal];
        [btn LL_setBackgroundColor:LLCONFIG_TEXT_COLOR forState:UIControlStateSelected];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.tag = i;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = LLCONFIG_TEXT_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterBtns addObject:btn];
        [self.btnsBgView addSubview:btn];
    }
    [LLTool lineView:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1) superView:self.btnsBgView];
}

- (void)showDetailView:(NSInteger)index {
    UIView *view = self.filterViews[index];
    view.hidden = NO;
    view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = CGRectMake(0, self.normalFrame.size.height, view.bounds.size.width, view.bounds.size.height);
        view.alpha = 1;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, view.frame.size.height + self.normalFrame.size.height);
        //        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.frame.origin.y);
    }];
}

- (void)hideDetailView:(NSInteger)index {
    UIView *view = self.filterViews[index];
    [UIView animateWithDuration:0.1 animations:^{
        view.frame = CGRectMake(0, -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        self.frame = self.normalFrame;
        view.hidden = YES;
    }];
}

- (LLFilterEventView *)levelView {
    if (!_levelView) {
        _levelView = [[LLFilterEventView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _levelView.averageCount = 4;
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
        _otherView = [[LLFilterOtherView alloc] initWithFrame:CGRectMake(0, 0, LL_SCREEN_WIDTH, 295)];
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

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"Level",@"Event",@"Other"];
    }
    return _titles;
}

@end

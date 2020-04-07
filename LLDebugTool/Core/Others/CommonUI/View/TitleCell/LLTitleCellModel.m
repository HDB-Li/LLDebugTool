//
//  LLTitleCellModel.m
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

#import "LLTitleCellModel.h"

#import "LLConst.h"
#import "LLDetailTitleCell.h"
#import "LLInternalMacros.h"
#import "LLTitleSliderCell.h"
#import "LLTitleSwitchCell.h"

@implementation LLTitleCellModel

#pragma mark - Public
+ (instancetype)modelWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (instancetype)normalInsets {
    self.separatorInsets = UIEdgeInsetsMake(0, kLLGeneralMargin, 0, 0);
    return self;
}

- (instancetype)noneInsets {
    self.separatorInsets = UIEdgeInsetsMake(0, LL_SCREEN_WIDTH, 0, 0);
    return self;
}

#pragma mark - Primary
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.cellClass = NSStringFromClass(LLTitleCell.class);
        [self normalInsets];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellClass = NSStringFromClass(LLTitleCell.class);
        [self normalInsets];
    }
    return self;
}

#pragma mark - Getters and setters
- (void)setBlock:(void (^)(void))block {
    if (_block != block) {
        _block = [block copy];
        self.accessoryType = block ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
}

@end

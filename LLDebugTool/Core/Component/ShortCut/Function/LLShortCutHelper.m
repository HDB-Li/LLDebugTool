//
//  LLShortCutHelper.m
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

#import "LLShortCutHelper.h"

#import "LLShortCutModel.h"

static LLShortCutHelper *_instance = nil;

@interface LLShortCutHelper ()

@property (nonatomic, strong) NSMutableArray <LLShortCutModel *>*actions;

@end

@implementation LLShortCutHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLShortCutHelper alloc] init];
    });
    return _instance;
}

- (void)registerAction:(LLShortCutModel *)model {
    [_actions addObject:model];
}

- (void)unregisterAction:(LLShortCutModel *)model {
    [_actions removeObject:model];
}

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        _actions = [[NSMutableArray alloc] init];
        [self registerAction:[LLShortCutModel visiableViewControllerModel]];
        [self registerAction:[LLShortCutModel resetStandardUserDefaultsModel]];
        [self registerAction:[LLShortCutModel clearDiskModel]];
    }
    return self;
}

@end

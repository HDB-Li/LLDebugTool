//
//  LLShortCutModel.m
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

#import "LLShortCutModel.h"

#import "LLTool.h"

#import "UIViewController+LL_Utils.h"

@implementation LLShortCutModel

- (instancetype)initWithName:(NSString *)name action:(NSString * (^)(void))action {
    if (self = [super init]) {
        _name = [name copy];
        _action = [action copy];
    }
    return self;
}

+ (LLShortCutModel *)visibleViewControllerModel {
    LLShortCutModel *model = [[LLShortCutModel alloc] initWithName:@"Visible View Controller"
                                                            action:^NSString * {
                                                                return [NSString stringWithFormat:@"%@", [[LLTool keyWindow].rootViewController LL_currentShowingViewController]];
                                                            }];
    return model;
}

+ (LLShortCutModel *)resetStandardUserDefaultsModel {
    LLShortCutModel *model = [[LLShortCutModel alloc] initWithName:@"Reset User Defaults"
                                                            action:^NSString * {
                                                                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[NSBundle mainBundle].bundleIdentifier];
                                                                return nil;
                                                            }];
    return model;
}

+ (LLShortCutModel *)clearDiskModel {
    LLShortCutModel *model = [[LLShortCutModel alloc] initWithName:@"Clear Disk"
                                                            action:^NSString * {
                                                                NSFileManager *manager = [NSFileManager defaultManager];
                                                                NSError *error = nil;
                                                                NSArray<NSString *> *paths = [manager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
                                                                if (error) {
                                                                    return @"Clear Disk Failed";
                                                                }
                                                                for (NSString *path in paths) {
                                                                    if (![manager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:path] error:&error]) {
                                                                        return @"Clear Disk Failed";
                                                                    }
                                                                }
                                                                return nil;
                                                            }];
    return model;
}

@end

//
//  LLSandboxHelper.m
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

#import "LLSandboxHelper.h"

#import "LLDebugConfig.h"
#import "LLSandboxModel.h"
#import "LLTool.h"

#if __has_include(<SSZipArchive.h>)
#import <SSZipArchive.h>
#define LLDEBUGTOOL_SANDBOX_ZIPARCHIVE_ENABLE

#elif __has_include(<SSZipArchive/SSZipArchive.h>)
#import <SSZipArchive/SSZipArchive.h>
#define LLDEBUGTOOL_SANDBOX_ZIPARCHIVE_ENABLE

#elif __has_include("SSZipArchive.h")
#import "SSZipArchive.h"
#define LLDEBUGTOOL_SANDBOX_ZIPARCHIVE_ENABLE

#endif

static LLSandboxHelper *_instance = nil;

@interface LLSandboxHelper ()

@property (copy, nonatomic) NSString *archiveFolderPath;

@end

@implementation LLSandboxHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLSandboxHelper alloc] init];
        [_instance initial];
    });
    return _instance;
}

- (LLSandboxModel *)getCurrentSandboxStructure {
    NSString *path = NSHomeDirectory();
    return [self getSandboxStructureWithPath:path];
}

- (BOOL)enableZipArchive {
#ifdef LLDEBUGTOOL_SANDBOX_ZIPARCHIVE_ENABLE
    return YES;
#else
    return NO;
#endif
}

- (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray<NSString *> *)paths {
#ifdef LLDEBUGTOOL_SANDBOX_ZIPARCHIVE_ENABLE
    if (paths.count == 0 || !path) {
        return NO;
    }
    return [SSZipArchive createZipFileAtPath:path withFilesAtPaths:paths];
#else
    return NO;
#endif
}

#pragma mark - Primary
- (void)initial {
    self.archiveFolderPath = [[LLDebugConfig shared].folderPath stringByAppendingPathComponent:@"Archive"];
    [LLTool removePath:self.archiveFolderPath];
}

- (LLSandboxModel *)getSandboxStructureWithPath:(NSString *)path {
    BOOL isDirectory = NO;
    // Check file is Exist, is Directory or not
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isExist) {
        // return if not exist
        return nil;
    }
    // Create model by self
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    LLSandboxModel *model = [[LLSandboxModel alloc] initWithAttributes:attributes filePath:path];
    if (isDirectory) {
        // Get subPath
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString *subContent in contents) {
            LLSandboxModel *subModel = [self getSandboxStructureWithPath:[path stringByAppendingPathComponent:subContent]];
            if (subModel) {
                model.totalFileSize += subModel.totalFileSize;
                [model.subModels addObject:subModel];
            }
        }
    }
    [self sortSubModels:model];
    return model;
}

- (void)sortSubModels:(LLSandboxModel *)model {
    for (LLSandboxModel *mod in model.subModels) {
        if (mod.subModels.count) {
            [self sortSubModels:mod];
        }
    }
    [model.subModels sortUsingComparator:^NSComparisonResult(LLSandboxModel *obj1, LLSandboxModel *obj2) {
        if (obj2.isDirectory != obj1.isDirectory) {
            return obj2.isDirectory;
        }
        return [obj1.name compare:obj2.name];
    }];
}

@end

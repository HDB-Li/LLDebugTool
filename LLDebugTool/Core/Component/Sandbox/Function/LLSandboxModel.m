//
//  LLSandboxModel.m
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

#import "LLSandboxModel.h"

#import <QuickLook/QuickLook.h>

#import "LLImageNameConfig.h"
#import "LLConfig.h"

@interface LLSandboxModel ()

@property (nonatomic, assign) BOOL previewEnable;

@property (nonatomic, assign) BOOL previewCalculated;

@property (copy, nonatomic) NSString *iconName;

@end

@implementation LLSandboxModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes filePath:(NSString *)filePath{
    if (self = [super init]) {
        _filePath = [filePath copy];
        _name = [[filePath lastPathComponent] copy];
        _fileType = [attributes[NSFileType] copy];
        _isDirectory = [_fileType isEqualToString:NSFileTypeDirectory];
        _fileSize = [attributes[NSFileSize] unsignedLongLongValue];
        _totalFileSize = _fileSize;
        _createDate = attributes[NSFileCreationDate];
        _modifiDate = attributes[NSFileModificationDate];
        _isHidden = [attributes[NSFileExtensionHidden] boolValue];
        _isHomeDirectory = [filePath isEqualToString:NSHomeDirectory()];
        NSArray *extensions = @[@"html", @"pdf", @"docx", @"doc", @"pages", @"txt", @"md", @"xlsx", @"xls", @"numbers", @"gif"];
        [extensions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj caseInsensitiveCompare:filePath.pathExtension] == NSOrderedSame) {
                self->_canOpenWithWebView = YES;
                *stop = YES;
            }
        }];
        extensions = @[@"json", @"plist"];
        [extensions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj caseInsensitiveCompare:filePath.pathExtension] == NSOrderedSame) {
                self->_canOpenWithTextView = YES;
                *stop = YES;
            }
        }];
        extensions = @[@"jpeg", @"jpg", @"png"];
        [extensions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj caseInsensitiveCompare:filePath.pathExtension] == NSOrderedSame) {
                self->_canOpenWithImageView = YES;
                *stop = YES;
            }
        }];
        extensions = @[@"mp4", @"avi", @"mov", @"m4v", @"3gp", @"mpeg", @"mp3", @"wav", @"aac", @"caf"];
        [extensions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj caseInsensitiveCompare:filePath.pathExtension] == NSOrderedSame) {
                self->_canOpenWithVideo = YES;
                *stop = YES;
            }
        }];
    }
    return self;
}

- (NSString *)fileSizeString {
    return [NSByteCountFormatter stringFromByteCount:_fileSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (NSString *)totalFileSizeString {
    return [NSByteCountFormatter stringFromByteCount:_totalFileSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (NSString *)iconName {
    if (!_iconName) {
        if (_isDirectory) {
            if (_subModels.count) {
                _iconName = kSandboxFileFolderImageName;
            } else {
                _iconName = kSandboxFileEmptyFolderImageName;
            }
        } else {
            NSString *extension = self.filePath.pathExtension.lowercaseString;
            
            NSString *imageName = [NSString stringWithFormat:@"LL-%@",extension];
            UIImage *image = [UIImage LL_imageNamed:imageName];
            if (!image) {
                if ([extension isEqualToString:@"docx"]) {
                    imageName = kSandboxFileDocImageName;
                } else if ([extension isEqualToString:@"jpeg"]) {
                    imageName = kSandboxFileJpgImageName;
                } else if ([extension isEqualToString:@"mp4"]) {
                    imageName = kSandboxFileMovImageName;
                } else if ([extension isEqualToString:@"db"] || [extension isEqualToString:@"sqlite"]) {
                    imageName = kSandboxFileSqlImageName;
                } else if ([extension isEqualToString:@"xlsx"]) {
                    imageName = kSandboxFileXlsImageName;
                } else if ([extension isEqualToString:@"rar"]) {
                    imageName = kSandboxFileZipImageName;
                } else {
                    imageName = kSandboxFileUnknownImageName;
                }
            }
            _iconName = [imageName copy];
        }
    }
    return _iconName;
}

#pragma mark - Lazy load
- (NSMutableArray<LLSandboxModel *> *)subModels {
    if (!_subModels) {
        _subModels = [[NSMutableArray alloc] init];
    }
    return _subModels;
}

- (BOOL)canPreview {
    if (!_previewCalculated) {
        _previewCalculated = YES;
        _previewEnable = [QLPreviewController canPreviewItem:[NSURL fileURLWithPath:self.filePath]];
    }
    return _previewEnable;
}

@end

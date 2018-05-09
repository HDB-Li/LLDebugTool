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
#import "LLConfig.h"


#define kBundleName [LLConfig sharedConfig].bundlePath
#define kUnknownName [kBundleName stringByAppendingPathComponent:@"LL-unknown"]
#define kAviName [kBundleName stringByAppendingPathComponent:@"LL-avi"]
#define kCssName [kBundleName stringByAppendingPathComponent:@"LL-css"]
#define kDocName [kBundleName stringByAppendingPathComponent:@"LL-doc"]
#define kGifName [kBundleName stringByAppendingPathComponent:@"LL-gif"]
#define kHtmlName [kBundleName stringByAppendingPathComponent:@"LL-html"]
#define kJpgName [kBundleName stringByAppendingPathComponent:@"LL-jpg"]
#define kJsName [kBundleName stringByAppendingPathComponent:@"LL-js"]
#define kMovName [kBundleName stringByAppendingPathComponent:@"LL-mov"]
#define kMp3Name [kBundleName stringByAppendingPathComponent:@"LL-mp3"]
#define kPdfName [kBundleName stringByAppendingPathComponent:@"LL-pdf"]
#define kPngName [kBundleName stringByAppendingPathComponent:@"LL-png"]
#define kSqlName [kBundleName stringByAppendingPathComponent:@"LL-sql"]
#define kWavName [kBundleName stringByAppendingPathComponent:@"LL-wav"]
#define kXlsName [kBundleName stringByAppendingPathComponent:@"LL-xls"]
#define kZipName [kBundleName stringByAppendingPathComponent:@"LL-zip"]
#define kFolderName [kBundleName stringByAppendingPathComponent:@"LL-folder"]
#define kEmptyFolderName [kBundleName stringByAppendingPathComponent:@"LL-folder-empty"]

@interface LLSandboxModel ()

@property (nonatomic , assign) BOOL previewEnable;

@property (nonatomic , assign) BOOL previewCalculated;

@property (copy , nonatomic) NSString *iconName;

@end

@implementation LLSandboxModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes filePath:(NSString *)filePath{
    if (self = [super init]) {
        _filePath = filePath;
        _name = [filePath lastPathComponent];
        _fileType = attributes[NSFileType];
        _isDirectory = [_fileType isEqualToString:NSFileTypeDirectory];
        _fileSize = [attributes[NSFileSize] unsignedLongLongValue];
        _totalFileSize = _fileSize;
        _createDate = attributes[NSFileCreationDate];
        _modifiDate = attributes[NSFileModificationDate];
        _isHidden = [attributes[NSFileExtensionHidden] boolValue];
        _isHomeDirectory = [filePath isEqualToString:NSHomeDirectory()];
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
                _iconName = kFolderName;
            } else {
                _iconName = kEmptyFolderName;
            }
        } else {
            NSString *extension = self.filePath.pathExtension.lowercaseString;
            
            NSString *imageName = [kBundleName stringByAppendingPathComponent:[NSString stringWithFormat:@"LL-%@",extension]];
            UIImage *image = [UIImage imageNamed:imageName];
            if (!image) {
                if ([extension isEqualToString:@"docx"]) {
                    imageName = kDocName;
                } else if ([extension isEqualToString:@"jpeg"]) {
                    imageName = kJpgName;
                } else if ([extension isEqualToString:@"mp4"]) {
                    imageName = kMovName;
                } else if ([extension isEqualToString:@"db"] || [extension isEqualToString:@"sqlite"]) {
                    imageName = kSqlName;
                } else if ([extension isEqualToString:@"xlsx"]) {
                    imageName = kXlsName;
                } else if ([extension isEqualToString:@"rar"]) {
                    imageName = kZipName;
                } else {
                    imageName = kUnknownName;
                }
            }
            _iconName = imageName;
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

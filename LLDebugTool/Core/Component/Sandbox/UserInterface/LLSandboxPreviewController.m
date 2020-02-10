//
//  LLSandboxPreviewController.m
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

#import "LLSandboxPreviewController.h"

#import "LLImageNameConfig.h"

#import "UIViewController+LL_Utils.h"

@interface LLSandboxPreviewController ()

@end

@implementation LLSandboxPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItemWithTitle:nil imageName:kShareImageName isLeft:NO];
    
    if (!self.filePath) {
        return;
    }
    
    self.title = [self.filePath lastPathComponent];
}

#pragma mark - Over write
- (void)rightItemClick:(UIButton *)sender {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:self.filePath]] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Getters and setters
- (NSURL *)fileURL {
    if (!_fileURL && self.filePath) {
        _fileURL = [NSURL fileURLWithPath:self.filePath];
    }
    return _fileURL;
}

@end

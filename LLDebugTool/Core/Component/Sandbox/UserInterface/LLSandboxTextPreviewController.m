//
//  LLSandboxTextPreviewController.m
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

#import "LLSandboxTextPreviewController.h"

#import "LLInternalMacros.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "LLJsonTool.h"
#import "LLTool.h"

#import "NSDictionary+LL_Utils.h"
#import "NSArray+LL_Utils.h"

@interface LLSandboxTextPreviewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation LLSandboxTextPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark - Over write
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT - LL_NAVIGATION_HEIGHT);
}

#pragma mark - Primary
- (void)setUpUI {
    [self.view addSubview:self.textView];
    
    if (!self.fileURL) {
        return;
    }
        
    NSString *string = nil;
    if ([self.filePath.pathExtension caseInsensitiveCompare:@"plist"] == NSOrderedSame) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:self.fileURL];
        NSArray *array = [[NSArray alloc] initWithContentsOfURL:self.fileURL];
        if (dic != nil) {
            string = [dic LL_jsonString];
        } else if (array != nil) {
            string = [array LL_jsonString];
        }
        if (!string) {
            [LLTool log:@"Load plist failed"];
            return;
        }
    } else {
        NSError *error = nil;
        string = [[NSString alloc] initWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            [LLTool log:@"Get string failed"];
            return;
        }
    }
    self.textView.text = [LLJsonTool formatJsonString:string];
}

#pragma mark - Getters and setters
- (UITextView *)textView {
    if (!_textView) {
        _textView = [LLFactory getTextView];
        _textView.editable = NO;
        _textView.scrollEnabled = YES;
        _textView.selectable = YES;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.tintColor = [LLThemeManager shared].primaryColor;
        _textView.backgroundColor = [LLThemeManager shared].backgroundColor;
        _textView.textColor = [LLThemeManager shared].primaryColor;
        _textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _textView;
}

@end

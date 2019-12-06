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

#import "LLImageNameConfig.h"
#import "LLThemeManager.h"
#import "LLFactory.h"
#import "JsonTool.h"
#import "LLTool.h"

#import "UIViewController+LL_Utils.h"
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
- (void)rightItemClick:(UIButton *)sender {
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:self.filePath]] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.frame = self.view.bounds;
}

#pragma mark - Primary
- (void)setUpUI {
    [self initNavigationItemWithTitle:nil imageName:kShareImageName isLeft:NO];
    
    self.view.backgroundColor = [LLThemeManager shared].backgroundColor;
    [self.view addSubview:self.textView];
    
    if (!self.filePath) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    if (!url) {
        return;
    }
    
    self.title = [self.filePath lastPathComponent];
    
    NSString *string = nil;
    if ([self.filePath.pathExtension caseInsensitiveCompare:@"plist"] == NSOrderedSame) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfURL:url];
        NSArray *array = [[NSArray alloc] initWithContentsOfURL:url];
        if (dic != nil) {
            string = [dic LL_toJsonString];
        } else if (array != nil) {
            string = [array LL_toJsonString];
        }
        if (!string) {
            [LLTool log:@"Load plist failed"];
            return;
        }
    } else {
        NSError *error = nil;
        string = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            [LLTool log:@"Get string failed"];
            return;
        }
    }
    self.textView.text = [JsonTool formatJsonString:string];
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

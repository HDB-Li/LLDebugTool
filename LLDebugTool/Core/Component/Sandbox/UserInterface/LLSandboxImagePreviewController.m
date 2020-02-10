//
//  LLSandboxImagePreviewController.m
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

#import "LLSandboxImagePreviewController.h"

#import "LLInternalMacros.h"
#import "LLFactory.h"

#import "UIView+LL_Utils.h"

@interface LLSandboxImagePreviewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LLSandboxImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark - Primary
- (void)setUpUI {
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
    if (!self.filePath) {
        return;
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.filePath];
    if (!image) {
        return;
    }
    
    self.scrollView.frame = CGRectMake(0, LL_NAVIGATION_HEIGHT, LL_SCREEN_WIDTH, LL_SCREEN_HEIGHT - LL_NAVIGATION_HEIGHT);
    self.imageView.image = image;
    CGSize size = image.size;
    if ((size.width / size.height) > (self.scrollView.LL_width / self.scrollView.LL_height)) {
        self.imageView.frame = CGRectMake(0, 0, self.scrollView.LL_width, self.scrollView.LL_width * size.height / size.width);
    } else {
        self.imageView.frame = CGRectMake(0, 0, self.scrollView.LL_height * size.width / size.height, self.scrollView.LL_height);
    }
    self.imageView.center = CGPointMake(self.scrollView.LL_width / 2.0, self.scrollView.LL_height / 2.0);
    self.scrollView.contentSize = self.imageView.LL_size;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.LL_width > scrollView.contentSize.width) ? (scrollView.LL_width - scrollView.contentSize.width) / 2 : 0;
    CGFloat offsetY = (scrollView.LL_height > scrollView.contentSize.height) ? (scrollView.LL_height - scrollView.contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY);
}

#pragma mark - Getters and setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [LLFactory getImageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [LLFactory getScrollView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 5;
        _scrollView.minimumZoomScale = 1;
    }
    return _scrollView;
}

@end

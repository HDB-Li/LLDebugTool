//
//  LLHierarchyExplorerToolBar.m
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

#import "LLHierarchyExplorerToolBar.h"
#import "LLConfig.h"
#import "UIImage+LL_Utils.h"
#import "LLImageNameConfig.h"

@implementation LLHierarchyExplorerToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initial];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

#pragma mark - Primary
- (void)initial {
    self.tintColor = LLCONFIG_TEXT_COLOR;
    self.barTintColor = LLCONFIG_BACKGROUND_COLOR;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[self itemWithTitle:@"Views" imageName:kPickImageName]];
    [items addObject:[self itemWithTitle:@"Select" imageName:kPickImageName]];
    [items addObject:[self itemWithTitle:@"Move" imageName:kPickImageName]];
    [items addObject:[self itemWithTitle:@"Close" imageName:kPickImageName]];
    [self setItems:items];
}

- (UITabBarItem *)itemWithTitle:(NSString *)title imageName:(NSString *)imageName {
    return [[UITabBarItem alloc] initWithTitle:title image:[UIImage LL_imageNamed:imageName] selectedImage:nil];
}

@end

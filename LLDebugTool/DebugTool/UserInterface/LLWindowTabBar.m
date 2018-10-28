//
//  LLWindowTabBar.m
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

#import "LLWindowTabBar.h"

@interface LLWindowTabBar ()

@property (nonatomic , strong) UIButton *leftButton;

@property (nonatomic , strong) UIButton *rightButton;

@end

@implementation LLWindowTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setValue:@(YES) forKey:@"_scrollsItems"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButtonArray addObject:view];
//        }
//    }
//
//    CGFloat barWidth = self.bounds.size.width;
//    CGFloat barHeight = self.bounds.size.height;
//    CGFloat centerBtnWidth = CGRectGetWidth(self.centerBtn.frame);
//    CGFloat centerBtnHeight = CGRectGetHeight(self.centerBtn.frame);
//    // 设置中间按钮的位置，居中，凸起一丢丢
//    self.centerBtn.center = CGPointMake(barWidth / 2, barHeight - centerBtnHeight/2 - 5);
//    // 重新布局其他 tabBarItem
//    // 平均分配其他 tabBarItem 的宽度
//    CGFloat barItemWidth = (barWidth - centerBtnWidth) / tabBarButtonArray.count;
//    // 逐个布局 tabBarItem，修改 UITabBarButton 的 frame
//    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        CGRect frame = view.frame;
//        if (idx >= tabBarButtonArray.count / 2) {
//            // 重新设置 x 坐标，如果排在中间按钮的右边需要加上中间按钮的宽度
//            frame.origin.x = idx * barItemWidth + centerBtnWidth;
//        } else {
//            frame.origin.x = idx * barItemWidth;
//        }
//        // 重新设置宽度
//        frame.size.width = barItemWidth;
//        view.frame = frame;
//    }];
//    // 把中间按钮带到视图最前面
//    [self bringSubviewToFront:self.centerBtn];
}

@end

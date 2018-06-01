//
//  LLScreenShotColor.h
//  LLDebugToolDemo
//
//  Created by Li on 2018/6/1.
//  Copyright © 2018年 li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LLScreenShotColor : NSObject

@property (nonatomic , assign) CGFloat size;

@property (nonatomic , strong) UIColor *color;

- (instancetype)initWithSize:(CGFloat)size color:(UIColor *)color;

@end

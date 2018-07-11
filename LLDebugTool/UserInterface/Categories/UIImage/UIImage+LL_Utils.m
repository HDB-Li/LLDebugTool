//
//  UIImage+LL_Utils.m
//  LLDebugToolDemo
//
//  Created by 杨波 on 2018/7/11.
//  Copyright © 2018年 li. All rights reserved.
//

#import "UIImage+LL_Utils.h"
#import "LLConfig.h"

@implementation UIImage (LL_Utils)

+(UIImage *)LL_imageNamed:(NSString *)name
{
    if (name) {
        UIImage * image = [self imageNamed:[NSString stringWithFormat:@"%@%@", [LLConfig sharedConfig].bundlePath,name]];
        return image;

    } else {
        return [UIImage new];
    }
}

@end

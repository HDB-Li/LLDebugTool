//
//  UIDevice+LL_AppInfo.m
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

#import "UIDevice+LL_AppInfo.h"

#import <objc/runtime.h>
#import <sys/sysctl.h>

@implementation UIDevice (LL_AppInfo)

- (NSString *)LL_modelName {
    NSString *name = objc_getAssociatedObject(self, _cmd);
    if (name == nil) {
        name = [self LL_getCurrentDeviceModel];
        objc_setAssociatedObject(self, _cmd, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return name;
}

#pragma mark - Primary
- (NSString *)LL_getCurrentDeviceModel {
    NSString *platform = [self LL_platform];
    if ([platform hasPrefix:@"iPhone"]) {
        return [self getCurrentIPhoneName:platform];
    } else if ([platform hasPrefix:@"iPad"]) {
        return [self getCurrentIPadName:platform];
    } else if ([platform hasPrefix:@"iPod"]) {
        return [self getCurrentIPodName:platform];
    }
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator (i386)";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator (x86_64)";

    return @"unknown";
}

- (NSString *)LL_platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

#pragma mark - Primary
- (NSString *)getCurrentIPhoneName:(NSString *)platform {
    NSDictionary *json = @{
        @"iPhone12,5": @"iPhone 11 Pro Max",
        @"iPhone12,3": @"iPhone 11 Pro",
        @"iPhone12,1": @"iPhone 11",
        @"iPhone11,8": @"iPhone XR",
        @"iPhone11,6": @"iPhone XS Max",
        @"iPhone11,4": @"iPhone XS Max",
        @"iPhone11,2": @"iPhone XS",
        @"iPhone10,6": @"iPhone X",
        @"iPhone10,5": @"iPhone 8 Plus",
        @"iPhone10,4": @"iPhone 8",
        @"iPhone10,3": @"iPhone X",
        @"iPhone10,2": @"iPhone 8 Plus",
        @"iPhone10,1": @"iPhone 8",
        @"iPhone9,4": @"iPhone 7 Plus",
        @"iPhone9,3": @"iPhone 7",
        @"iPhone9,2": @"iPhone 7 Plus",
        @"iPhone9,1": @"iPhone 7",
        @"iPhone8,4": @"iPhone SE",
        @"iPhone8,2": @"iPhone 6s Plus",
        @"iPhone8,1": @"iPhone 6s",
        @"iPhone7,2": @"iPhone 6",
        @"iPhone7,1": @"iPhone 6 Plus",
        @"iPhone6,2": @"iPhone 5s",
        @"iPhone6,1": @"iPhone 5s",
        @"iPhone5,4": @"iPhone 5c",
        @"iPhone5,3": @"iPhone 5c",
        @"iPhone5,2": @"iPhone 5",
        @"iPhone5,1": @"iPhone 5",
        @"iPhone4,1": @"iPhone 4S",
        @"iPhone3,3": @"iPhone 4",
        @"iPhone3,2": @"iPhone 4",
        @"iPhone3,1": @"iPhone 4",
        @"iPhone2,1": @"iPhone 3GS",
        @"iPhone1,2": @"iPhone 3G",
        @"iPhone1,1": @"iPhone 1G"
    };
    NSString *model = json[platform];
    if (!model) {
        model = @"iPhone";
    }
    return model;
}

- (NSString *)getCurrentIPadName:(NSString *)platform {
    NSDictionary *json = @{
        @"iPad11,4": @"iPad Air 3",
        @"iPad11,3": @"iPad Air 3",
        @"iPad11,2": @"iPad Mini 5",
        @"iPad11,1": @"iPad Mini 5",
        @"iPad8,8": @"iPad Pro 3",
        @"iPad8,7": @"iPad Pro 3",
        @"iPad8,6": @"iPad Pro 3",
        @"iPad8,5": @"iPad Pro 3",
        @"iPad8,4": @"iPad Pro 3",
        @"iPad8,3": @"iPad Pro 3",
        @"iPad8,2": @"iPad Pro 3",
        @"iPad8,1": @"iPad Pro 3",
        @"iPad7,6": @"iPad 6",
        @"iPad7,5": @"iPad 6",
        @"iPad7,4": @"iPad Pro",
        @"iPad7,3": @"iPad Pro",
        @"iPad7,2": @"iPad Pro 2",
        @"iPad7,1": @"iPad Pro 2",
        @"iPad6,12": @"iPad 5",
        @"iPad6,11": @"iPad 5",
        @"iPad6,8": @"iPad Pro",
        @"iPad6,7": @"iPad Pro",
        @"iPad6,4": @"iPad Pro",
        @"iPad6,3": @"iPad Pro",
        @"iPad5,4": @"iPad Air 2",
        @"iPad5,3": @"iPad Air 2",
        @"iPad5,2": @"iPad Mini 4",
        @"iPad5,1": @"iPad Mini 4",
        @"iPad4,9": @"iPad Mini 3",
        @"iPad4,8": @"iPad Mini 3",
        @"iPad4,7": @"iPad Mini 3",
        @"iPad4,6": @"iPad Mini 2",
        @"iPad4,5": @"iPad Mini 2",
        @"iPad4,4": @"iPad Mini 2",
        @"iPad4,3": @"iPad Air",
        @"iPad4,2": @"iPad Air",
        @"iPad4,1": @"iPad Air",
        @"iPad3,6": @"iPad 4",
        @"iPad3,5": @"iPad 4",
        @"iPad3,4": @"iPad 4",
        @"iPad3,3": @"iPad 3",
        @"iPad3,2": @"iPad 3",
        @"iPad3,1": @"iPad 3",
        @"iPad2,7": @"iPad Mini",
        @"iPad2,6": @"iPad Mini",
        @"iPad2,5": @"iPad Mini",
        @"iPad2,4": @"iPad 2",
        @"iPad2,3": @"iPad 2",
        @"iPad2,2": @"iPad 2",
        @"iPad2,1": @"iPad 2",
        @"iPad1,1": @"iPad 1"
    };
    NSString *model = json[platform];
    if (!model) {
        model = @"iPad";
    }
    return model;
}

- (NSString *)getCurrentIPodName:(NSString *)platform {
    NSDictionary *json = @{
        @"iPod9,1": @"iPod 7",
        @"iPod7,1": @"iPod 6",
        @"iPod5,1": @"iPod 5",
        @"iPod4,1": @"iPod 4",
        @"iPod3,1": @"iPod 3",
        @"iPod2,1": @"iPod 2",
        @"iPod1,1": @"iPod 1"
    };
    NSString *model = json[platform];
    if (!model) {
        model = @"iPod";
    }
    return model;
}

@end

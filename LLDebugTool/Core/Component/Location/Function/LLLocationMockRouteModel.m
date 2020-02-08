//
//  LLLocationMockRouteModel.m
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

#import "LLLocationMockRouteModel.h"

#import "CLLocation+LL_Location.h"

@interface LLLocationMockRouteModel ()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL checkAvailable;

@property (nonatomic, assign) BOOL isAvailable;

@end

@implementation LLLocationMockRouteModel

- (instancetype)initWithLocation:(NSArray <CLLocation *>*)locations timeInterval:(NSTimeInterval)timeInterval name:(NSString *)name {
    if (self = [super init]) {
        _locations = [locations copy];
        _timeInterval = timeInterval;
        _name = [name copy];
        _checkAvailable = YES;
        _isAvailable = YES;
    }
    return self;
}

- (instancetype)initWithJsonFile:(NSString *)filePath timeInterval:(NSTimeInterval)timeInterval name:(NSString *)name {
    if (self = [super init]) {
        _filePath = filePath;
        _timeInterval = timeInterval;
        _name = [name copy];
    }
    return self;
}

- (CLLocation *)nextLocation {
    if (self.index < self.locations.count) {
        CLLocation *location = self.locations[self.index];
        self.index++;
        return location;
    }
    return nil;
}

- (BOOL)isFinish {
    if (self.index >= self.locations.count) {
        return YES;
    }
    return NO;
}

- (void)reload {
    self.index = 0;
}

- (BOOL)isAvailable {
    if (!_checkAvailable) {
        [self analysisJsonFile:self.filePath];
        _checkAvailable = YES;
    }
    return _isAvailable;
}

#pragma mark - Primary
- (void)analysisJsonFile:(NSString *)filePath {
    // Check nil.
    if ([filePath length] == 0) {
        return;
    }
    
    // Check file extension.
    if (![filePath.pathExtension isEqualToString:@"json"]) {
        return;
    }
    
    // Convert to data.
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    if ([data length] == 0) {
        return;
    }
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Check type.
    if (![object isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *json = (NSDictionary *)object;
    // Check key.
    if (![json[@"key"] isEqualToString:@"LLDebugTool"]) {
        return;
    }
    
    NSArray *jsonData = json[@"data"];
    // Check data.
    if (![jsonData isKindOfClass:[NSArray class]]) {
        return;
    }
    
    // Add data.
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (id obj in jsonData) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic[@"lat"] && dic[@"lng"]) {
                CLLocationDegrees lat = [dic[@"lat"] doubleValue];
                CLLocationDegrees lng = [dic[@"lng"] doubleValue];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                location.LL_mock = YES;
                [locations addObject:location];
            }
        }
    }
    
    _locations = [locations copy];
    _isAvailable = YES;
}

@end

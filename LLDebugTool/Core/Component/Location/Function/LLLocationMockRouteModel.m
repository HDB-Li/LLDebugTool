//
//  LLLocationMockRouteModel.m
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

@property (nonatomic, assign) NSInteger index;

@end

@implementation LLLocationMockRouteModel

- (instancetype)initWithLocation:(NSArray <CLLocation *>*)locations timeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        _locations = [locations copy];
        _timeInterval = timeInterval;
    }
    return self;
}

- (instancetype)initWithJsonFile:(NSString *)filePath timeInterval:(NSTimeInterval)timeInterval {
    if (self = [super init]) {
        [self analysisJsonFile:filePath];
        _timeInterval = timeInterval;
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

#pragma mark - Primary
- (void)analysisJsonFile:(NSString *)filePath {
    if ([filePath length] == 0) {
        return;
    }
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    if ([data length] == 0) {
        return;
    }
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!jsonObject || ![jsonObject isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSArray *json = (NSArray *)jsonObject;
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (id obj in json) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic[@"lat"] && dic[@"lng"]) {
                CLLocationDegrees lat = [dic[@"lat"] doubleValue];
                CLLocationDegrees lng = [dic[@"lng"] doubleValue];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                location.LL_routeLocation = YES;
                [locations addObject:location];
            }
        }
    }
    _locations = [locations copy];
}

@end

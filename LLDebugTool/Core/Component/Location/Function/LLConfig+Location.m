//
//  LLConfig+Location.m
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

#import "LLConfig+Location.h"

#import "NSObject+LL_Runtime.h"

@implementation LLConfig (Location)

- (void)setMockLocationLatitude:(double)mockLocationLatitude {
    objc_setAssociatedObject(self, @selector(mockLocationLatitude), @(mockLocationLatitude), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)mockLocationLatitude {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setMockLocationLongitude:(double)mockLocationLongitude {
    objc_setAssociatedObject(self, @selector(mockLocationLongitude), @(mockLocationLongitude), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)mockLocationLongitude {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

@end

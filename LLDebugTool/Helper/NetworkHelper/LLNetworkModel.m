//
//  LLNetworkModel.m
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

#import "LLNetworkModel.h"
#import "LLTool.h"

@interface LLNetworkModel ()

@property (nonatomic , copy , nonnull) NSString *headerString;

@property (nonatomic , copy , nonnull) NSString *responseString;

@property (nonatomic , strong) NSDate *dateDescription;

@end

@implementation LLNetworkModel

- (void)setStartDate:(NSString *)startDate {
    if (![_startDate isEqualToString:startDate]) {
        _startDate = [startDate copy];
        if (!_identity) {
            _identity = [startDate stringByAppendingString:[LLTool absolutelyIdentity]];
        }
    }
}

- (void)setHeaderFields:(NSDictionary<NSString *,NSString *> *)headerFields {
    if (_headerFields != headerFields) {
        _headerFields = headerFields;
        _headerString = nil;
    }
}

- (void)setResponseData:(NSData *)responseData {
    if (_responseData != responseData) {
        _responseData = responseData;
        _responseString = nil;
    }
}

- (NSString *)headerString {
    if (!_headerString) {
        _headerString = [LLTool convertJSONStringFromDictionary:self.headerFields];
    }
    return _headerString;
}

- (NSString *)responseString {
    if (!_responseString && !self.isImage) {
        _responseString = [LLTool convertJSONStringFromData:self.responseData];
    }
    return _responseString;
}

- (NSDate *)dateDescription {
    if (!_dateDescription && self.startDate.length) {
        _dateDescription = [LLTool dateFromString:self.startDate];
    }
    return _dateDescription;
}

- (NSString *)storageIdentity {
    return self.identity;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[LLNetworkModel] \n url:%@,\n startDate:%@,\n method:%@,\n mineType:%@,\n requestBody:%@,\n statusCode:%@,\n header:%@,\n response:%@,\n totalDuration:%@,\n error:%@,\n identity:%@",self.url.absoluteString,self.startDate,self.method,self.mineType,self.requestBody,self.statusCode,self.headerString,self.responseString,self.totalDuration,self.error.localizedDescription,self.identity];
}

@end

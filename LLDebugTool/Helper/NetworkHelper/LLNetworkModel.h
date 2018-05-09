//
//  LLNetworkModel.h
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

#import "LLBaseModel.h"

/**
 Network model. Save and show network request infos.
 */
@interface LLNetworkModel : LLBaseModel

/**
 Network request start date.
 */
@property (nonatomic , copy , nonnull) NSString *startDate;

/**
 Network request URL.
 */
@property (nonatomic , copy , nullable) NSURL *url;

/**
 Network request method.
 */
@property (nonatomic , copy , nullable) NSString *method;

/**
 Network request mine type.
 */
@property (nonatomic , copy , nullable) NSString *mineType;

/**
 Network request request body.
 */
@property (nonatomic , copy , nullable) NSString *requestBody;

/**
 Network request status code.
 */
@property (nonatomic , copy , nonnull) NSString *statusCode;

/**
 Network request response data.
 */
@property (nonatomic , copy , nullable) NSData *responseData;

/**
 Is image or not.
 */
@property (nonatomic , assign) BOOL isImage;

/**
 Network request used duration.
 */
@property (nonatomic , copy , nonnull) NSString *totalDuration;

/**
 Network request error.
 */
@property (nonatomic , strong , nullable) NSError *error;

/**
 Network request header.
 */
@property (nonatomic , copy , nullable) NSDictionary <NSString *,NSString *>*headerFields;

/**
 Network request identity.
 */
@property (nonatomic , copy , readonly , nonnull) NSString *identity;

@end

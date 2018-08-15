//
//  LLTool.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Work as tool.
 */
@interface LLTool : NSObject

/**
 Identity to model. Deal with the same date, start at 1.
 */
+ (NSString *)absolutelyIdentity;

/**
 The only dateformatter for [LLConfig dateFormatter].
 */
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

/**
 The only dateformatter for "yyyy-MM-dd".
 */
+ (NSString *)dayStringFromDate:(NSDate *)date;
+ (NSString *)dayDateFromString:(NSString *)string;

/**
 The only dateformatter for "yyyy-MM-dd HH:mm:ss".
 */
+ (NSDate *)staticDateFromString:(NSString *)string;
+ (NSString *)staticStringFromDate:(NSDate *)date;

/**
 Create lines of unity.
 */
+ (UIView *)lineView:(CGRect)frame superView:(UIView *)superView;

/**
 Convert data or dictionary to JSONString.
 */
+ (NSString *)convertJSONStringFromData:(NSData *)data;
+ (NSString *)convertJSONStringFromDictionary:(NSDictionary *)dictionary;

/**
 Create directory if not exist.
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;

/**
 Get rect from two point
 */
+ (CGRect)rectWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint;

/**
 Show toast.
 */
+ (void)toastMessage:(NSString *)message;

/**
 Show or hide loading message.
 */
+ (void)loadingMessage:(NSString *)message;
+ (void)hideLoadingMessage;

#pragma mark - DEPRECATED

+ (instancetype)sharedTool DEPRECATED_ATTRIBUTE;
- (NSString *)absolutelyIdentity DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *)stringFromDate:(NSDate *)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSDate *)dateFromString:(NSString *)string DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *)dayStringFromDate:(NSDate *)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSDate *)staticDateFromString:(NSString *)string DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *)staticStringFromDate:(NSDate *)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (void)toastMessage:(NSString *)message DEPRECATED_MSG_ATTRIBUTE("Use class method replace");

@end

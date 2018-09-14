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
+ (NSString *_Nonnull)absolutelyIdentity;

/**
 The only dateformatter for [LLConfig dateFormatter].
 */
+ (NSString *_Nonnull)stringFromDate:(NSDate *_Nonnull)date;
+ (NSDate *_Nullable)dateFromString:(NSString *_Nonnull)string;

/**
 The only dateformatter for "yyyy-MM-dd".
 */
+ (NSString *_Nonnull)dayStringFromDate:(NSDate *_Nonnull)date;
+ (NSData *_Nullable)dayDateFromString:(NSString *_Nonnull)string;

/**
 The only dateformatter for "yyyy-MM-dd HH:mm:ss".
 */
+ (NSString *_Nonnull)staticStringFromDate:(NSDate *_Nonnull)date;
+ (NSDate *_Nullable)staticDateFromString:(NSString *_Nonnull)string;

/**
 Create lines of unity.
 */
+ (UIView *_Nonnull)lineView:(CGRect)frame superView:(UIView *_Nullable)superView;

/**
 Convert data or dictionary to JSONString.
 */
+ (NSString *_Nonnull)convertJSONStringFromData:(NSData *_Nullable)data;
+ (NSString *_Nonnull)convertJSONStringFromDictionary:(NSDictionary *_Nullable)dictionary;

/**
 Create directory if not exist.
 */
+ (BOOL)createDirectoryAtPath:(NSString *_Nonnull)path;

/**
 Get rect from two point
 */
+ (CGRect)rectWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint;

/**
 Show toast.
 */
+ (void)toastMessage:(NSString *_Nullable)message;

/**
 Show or hide loading message.
 */
+ (void)loadingMessage:(NSString *_Nullable)message;
+ (void)hideLoadingMessage;

#pragma mark - DEPRECATED

+ (instancetype _Nonnull)sharedTool DEPRECATED_ATTRIBUTE;
- (NSString *_Nonnull)absolutelyIdentity DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *_Nonnull)stringFromDate:(NSDate *_Nonnull)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSDate *_Nullable)dateFromString:(NSString *_Nonnull)string DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *_Nonnull)dayStringFromDate:(NSDate *_Nonnull)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSDate *_Nullable)staticDateFromString:(NSString *_Nonnull)string DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (NSString *_Nonnull)staticStringFromDate:(NSDate *_Nonnull)date DEPRECATED_MSG_ATTRIBUTE("Use class method replace");
- (void)toastMessage:(NSString *_Nullable)message DEPRECATED_MSG_ATTRIBUTE("Use class method replace");

@end

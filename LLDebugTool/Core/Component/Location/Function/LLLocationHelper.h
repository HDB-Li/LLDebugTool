//
//  LLLocationHelper.h
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

#import <CoreLocation/CoreLocation.h>

@class LLLocationMockRouteModel;

NS_ASSUME_NONNULL_BEGIN

/// Location helper.
@interface LLLocationHelper : NSObject

/// Shared instance.
+ (instancetype)shared;

/**
 Set enable to monitoring network request.
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enable;

/**
 Is Mock route.
 */
@property (nonatomic, assign, readonly) BOOL isMockRoute;

/**
 Available route models.
 */
@property (nonatomic, copy) NSArray <LLLocationMockRouteModel *>*availableRoutes;

/**
 Add a custom mock route file.
 */
- (void)addMockRouteFile:(NSString *)filePath;

/**
 Add all json file in directory, deep find.
 */
- (void)addMockRouteDirectory:(NSString *)fileDirectory;

/**
 Remove route from cache.
 */
- (void)removeRoute:(LLLocationMockRouteModel *)model;

/**
 Start mock route locations.
 */
- (void)startMockRoute:(LLLocationMockRouteModel *)model;

/**
 Stop current mock route.
 */
- (void)stopMockRoute;

/**
 Start record route.
 */
- (BOOL)startRecordRoute;

/**
 Stop record route.
 */
- (NSString *_Nullable)stopRecordRoute;

/**
 Whether is LLDebugTool's data in file extend.
 */
+ (BOOL)isLLDebugToolLocationRouteFile:(NSString *)path;

/**
 Add LLDebugTool extend data to file.
 */
+ (BOOL)addLLDebugToolExtendDataWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

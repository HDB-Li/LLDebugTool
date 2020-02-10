//
//  LLLocationMockRouteModel.h
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

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// Mock Route model.
@interface LLLocationMockRouteModel : LLBaseModel

/// Mock locations
@property (nonatomic, copy, nullable) NSArray <CLLocation *>*locations;

/// Time interval between two location.
@property (nonatomic, assign) NSTimeInterval timeInterval;

/// Whether model is available.
@property (nonatomic, assign, readonly) BOOL isAvailable;

/// Model name.
@property (nonatomic, copy, readonly) NSString *name;

/// Model file path.
@property (nonatomic, copy, readonly) NSString *filePath;

/// Initial method.
/// @param locations Mock locations.
/// @param timeInterval Time interval between two location.
/// @param name Model name.
- (instancetype)initWithLocation:(NSArray <CLLocation *>*)locations timeInterval:(NSTimeInterval)timeInterval name:(NSString *)name;

/// Initial a model by a file.
/// @param filePath File path.
/// @param timeInterval Time interval between two location.
/// @param name Model name.
- (instancetype)initWithJsonFile:(NSString *)filePath timeInterval:(NSTimeInterval)timeInterval name:(NSString *)name;

/// Next location.
- (CLLocation *_Nullable)nextLocation;

/// Is finish all location.
- (BOOL)isFinish;

/// Reload to start.
- (void)reload;

@end

NS_ASSUME_NONNULL_END

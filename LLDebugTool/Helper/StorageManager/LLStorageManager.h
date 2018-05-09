//
//  LLStorageManager.h
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

@class LLLogModel;
@class LLCrashModel;
@class LLNetworkModel;

/**
 Operation database.
 */
@interface LLStorageManager : NSObject

/**
 Singleton to operation database.
 Database file path is "../LLDebugTool/LLDebugTool.db".

 @return Singleton
 */
+ (instancetype)sharedManager;

#pragma mark - Crash Model Actions

/**
 Save a crash model to database.
 */
- (BOOL)saveCrashModel:(LLCrashModel *)model;

/**
 Get all crash models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLCrashModel *>*)getAllCrashModel;

/**
 According to the models to remove the crash models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeCrashModels:(NSArray <LLCrashModel *>*)models;

#pragma mark - Network Model Actions

/**
 Save a network model to database.
 */
- (BOOL)saveNetworkModel:(LLNetworkModel *)model;

/**
 Get all network models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLNetworkModel *>*)getAllNetworkModels;

/**
  Get the network models in database via launchDate. If nothing, it will return an emtpy array.
 */
- (NSArray <LLNetworkModel *>*)getAllNetworkModelsWithLaunchDate:(NSString *)launchDate;

/**
 According to the models to remove the network models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeNetworkModels:(NSArray <LLNetworkModel *>*)models;

#pragma mark - Log Model Action

/**
 Save a log model to database.
 */
- (BOOL)saveLogModel:(LLLogModel *)model;

/**
 Get all log models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLLogModel *>*)getAllLogModels;

/**
 Get the log models in database via launchDate. If nothing, it will return an emtpy array.
 */
- (NSArray <LLLogModel *>*)getAllLogModelsWithLaunchDate:(NSString *)launchDate;

/**
 According to the models to remove the log models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeLogModels:(NSArray <LLLogModel *>*)models;

@end

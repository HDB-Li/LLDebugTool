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
#import <UIKit/UIKit.h>
#import "LLLogModel.h"
#import "LLNetworkModel.h"
#import "LLCrashModel.h"

typedef void(^LLStorageManagerBoolBlock)(BOOL result);
typedef void(^LLStorageManagerArrayBlock)(NSArray <LLStorageModel *>*result);

/**
 Operation database.
 */
// TODO: Change from synchronous to asynchronous.
@interface LLStorageManager : NSObject

/**
 Singleton to operation database.
 Database file path is based on LLConfig's folderPath.

 @return Singleton
 */
+ (instancetype)sharedManager;

/**
 Register a class in database and auto create a table.
 */
- (BOOL)registerClass:(Class)cls;

#pragma mark - SAVE
/**
 Save a model in database. Operation depend [model operationOnMainThread] on and callback in main thread.
 */
- (void)saveModel:(LLStorageModel *)model complete:(LLStorageManagerBoolBlock)complete;

/**
 Save a model in database. [synchronous] decision synchronous or asynchronous, if YES, all operations will work in current thread, if NO, Operations will work in child thread and callback in main thread.
 */
- (void)saveModel:(LLStorageModel *)model complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous;

#pragma mark - GET
/**
 Get models in database. If nothing, it will return an emtpy array. Operation in child thread and callback in main thread.
 */
- (void)getModels:(Class)cls complete:(LLStorageManagerArrayBlock)complete;
- (void)getModels:(Class)cls launchDate:(NSString *)launchDate complete:(LLStorageManagerArrayBlock)complete;
- (void)getModels:(Class)cls launchDate:(NSString *)launchDate storageIdentity:(NSString *)storageIdentity complete:(LLStorageManagerArrayBlock)complete;

/**
 Get models in database. [synchronous] decision synchronous or asynchronous, if YES, all operations will work in current thread, if NO, Operations will work in child thread and callback in main thread.
 */
- (void)getModels:(Class)cls launchDate:(NSString *)launchDate storageIdentity:(NSString *)storageIdentity complete:(LLStorageManagerArrayBlock)complete synchronous:(BOOL)synchronous;

#pragma mark - DELETE
/**
 Remove models in database. Operation in child thread and callback in main thread.
 */
- (void)removeModels:(NSArray <LLStorageModel *>*)models complete:(LLStorageManagerBoolBlock)complete;

/**
 Remove models in database. [synchronous] decision synchronous or asynchronous, if YES, all operations will work in current thread, if NO, Operations will work in child thread and callback in main thread.
 */
- (void)removeModels:(NSArray <LLStorageModel *>*)models complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous;

#pragma mark - Screen Shot

/**
 Save screenShots to sandbox. Operation in child thread and callback in main thread.
 */
- (void)saveScreenshot:(UIImage *)image name:(NSString *)name complete:(LLStorageManagerBoolBlock)complete;

#pragma mark - Table

/**
 Clear table.
 */
- (void)clearTable:(Class)cls complete:(LLStorageManagerBoolBlock)complete;
- (void)clearTable:(Class)cls complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous;

/**
 Clear database.
 */
- (void)clearDatabaseWithComplete:(LLStorageManagerBoolBlock)complete;
- (void)clearDatabaseWithComplete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous;

#pragma mark -
- (void)updateDatabaseWithVersion:(NSString *)version complete:(LLStorageManagerBoolBlock)complete;

#pragma mark - DEPRECATED
/**
 Save a crash model to database.
 */
- (BOOL)saveCrashModel:(LLCrashModel *)model DEPRECATED_MSG_ATTRIBUTE("Use saveModel:complete: to replace");

/**
 Get all crash models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLCrashModel *>*)getAllCrashModel DEPRECATED_MSG_ATTRIBUTE("Use getModels:complete: to replace.");

/**
 According to the models to remove the crash models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeCrashModels:(NSArray <LLCrashModel *>*)models DEPRECATED_MSG_ATTRIBUTE("Use removeModels:complete: to replace");

/**
 Save a network model to database.
 */
- (BOOL)saveNetworkModel:(LLNetworkModel *)model DEPRECATED_MSG_ATTRIBUTE("Use saveModel:complete: to replace");

/**
 Get all network models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLNetworkModel *>*)getAllNetworkModels DEPRECATED_MSG_ATTRIBUTE("Use getModels:complete: to replace.");

/**
  Get the network models in database via launchDate. If nothing, it will return an emtpy array.
 */
- (NSArray <LLNetworkModel *>*)getAllNetworkModelsWithLaunchDate:(NSString *)launchDate DEPRECATED_MSG_ATTRIBUTE("Use getModels:launchDate:complete: to replace.");

/**
 According to the models to remove the network models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeNetworkModels:(NSArray <LLNetworkModel *>*)models DEPRECATED_MSG_ATTRIBUTE("Use removeModels:complete: to replace");

/**
 Save a log model to database.
 */
- (BOOL)saveLogModel:(LLLogModel *)model DEPRECATED_MSG_ATTRIBUTE("Use saveModel:complete: to replace");

/**
 Get all log models in database(this time). If nothing, it will return an emtpy array.
 */
- (NSArray <LLLogModel *>*)getAllLogModels DEPRECATED_MSG_ATTRIBUTE("Use getModels:complete: to replace.");

/**
 Get the log models in database via launchDate. If nothing, it will return an emtpy array.
 */
- (NSArray <LLLogModel *>*)getAllLogModelsWithLaunchDate:(NSString *)launchDate DEPRECATED_MSG_ATTRIBUTE("Use getModels:launchDate:complete: to replace.");

/**
 According to the models to remove the log models where happened in dataBase.
 If any one fails, it returns to NO, and any failure will not affect others.
 */
- (BOOL)removeLogModels:(NSArray <LLLogModel *>*)models DEPRECATED_MSG_ATTRIBUTE("Use removeModels:complete: to replace");

/**
 Save screenShots to sandbox.
 */
- (BOOL)saveScreenshot:(UIImage *)image name:(NSString *)name DEPRECATED_MSG_ATTRIBUTE("Use saveScreenshot:name:complete: to replace");

@end

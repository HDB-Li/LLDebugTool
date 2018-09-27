//
//  LLStorageManager.m
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

#import "LLStorageManager.h"
#import <FMDB/FMDB.h>
#import "NSObject+LL_Utils.h"
#import "LLTool.h"
#import "LLConfig.h"
#import "LLRoute.h"

static LLStorageManager *_instance = nil;

// Column Name
static NSString *const kObjectDataColumn = @"ObjectData";
static NSString *const kIdentityColumn = @"Identity";
static NSString *const kLaunchDateColumn = @"LaunchDate";
static NSString *const kDescriptionColumn = @"Desc";

static NSString *const kDatabaseVersion = @"1";

@interface LLStorageManager ()

@property (strong , nonatomic) FMDatabaseQueue * dbQueue;

@property (strong , nonatomic) dispatch_queue_t queue;

@property (strong , nonatomic) NSMutableArray <Class>*registerClass;

@property (copy , nonatomic) NSString *folderPath;

@property (assign , nonatomic) BOOL includeCrash;

@property (assign , nonatomic) BOOL includeNetwork;

@property (assign , nonatomic) BOOL includeLog;

@end

@implementation LLStorageManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LLStorageManager alloc] init];
        [_instance initial];
    });
    return _instance;
}

#pragma mark - Public
- (BOOL)registerClass:(Class)cls {
    if (![self isRegisteredClass:cls]) {
        __block BOOL ret = NO;
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSError *error;
            ret = [db executeUpdate:[self createTableSQLFromClass:cls] values:nil error:&error];
            if (!ret) {
                [self log:[NSString stringWithFormat:@"Create %@ table failed. error = %@",NSStringFromClass(cls),error.description]];
            }
        }];
        if (ret) {
            [self.registerClass addObject:cls];
        }
        return ret;
    }
    return YES;
}

#pragma mark - SAVE
- (void)saveModel:(LLStorageModel *)model complete:(LLStorageManagerBoolBlock)complete {
    [self saveModel:model complete:complete synchronous:NO];
}

- (void)saveModel:(LLStorageModel *)model complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous {
    [self saveOrUpdateModel:model complete:complete synchronous:synchronous isSave:YES];
}

#pragma mark - UPDATE
- (void)updateModel:(LLStorageModel *_Nonnull)model complete:(LLStorageManagerBoolBlock _Nullable)complete {
    [self updateModel:model complete:complete synchronous:NO];
}

- (void)updateModel:(LLStorageModel *_Nonnull)model complete:(LLStorageManagerBoolBlock _Nullable)complete synchronous:(BOOL)synchronous {
    [self saveOrUpdateModel:model complete:complete synchronous:synchronous isSave:NO];
}

#pragma mark - GET
- (void)getModels:(Class)cls complete:(LLStorageManagerArrayBlock)complete {
    NSString *launchDate = [NSObject LL_launchDate];
    [self getModels:cls launchDate:launchDate complete:complete];
}

- (void)getModels:(Class)cls launchDate:(NSString *)launchDate complete:(LLStorageManagerArrayBlock)complete {
    [self getModels:cls launchDate:launchDate storageIdentity:nil complete:complete];
}

- (void)getModels:(Class)cls launchDate:(NSString *)launchDate storageIdentity:(NSString *)storageIdentity complete:(LLStorageManagerArrayBlock)complete {
    [self getModels:cls launchDate:launchDate storageIdentity:storageIdentity complete:complete synchronous:NO];
}

- (void)getModels:(Class)cls launchDate:(NSString *)launchDate storageIdentity:(NSString *)storageIdentity complete:(LLStorageManagerArrayBlock)complete synchronous:(BOOL)synchronous {
    
    // Check thread.
    if (!synchronous && [[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self getModels:cls launchDate:launchDate storageIdentity:storageIdentity complete:complete];
        });
        return;
    }
    
    // Check datas.
    if (![self isRegisteredClass:cls]) {
        [self log:[NSString stringWithFormat:@"Get %@ failed, because model is unregister.",NSStringFromClass(cls)]];
        [self performArrayComplete:complete param:@[] synchronous:synchronous];
        return;
    }
    
    __block NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM %@",[self tableNameFromClass:cls]];
        NSArray *values = @[];
        if (launchDate.length && storageIdentity.length) {
            SQL = [SQL stringByAppendingFormat:@" WHERE %@ = ? AND %@ = ?",kLaunchDateColumn,kIdentityColumn];
            values = @[launchDate,storageIdentity];
        } else if (launchDate.length) {
            SQL = [SQL stringByAppendingFormat:@" WHERE %@ = ?",kLaunchDateColumn];
            values = @[launchDate];
        } else if (storageIdentity.length) {
            SQL = [SQL stringByAppendingFormat:@" WHERE %@ = ?",kIdentityColumn];
            values = @[storageIdentity];
        }
        FMResultSet *set = [db executeQuery:SQL values:values error:&error];
        while ([set next]) {
            NSData *data = [set objectForColumn:kObjectDataColumn];
            id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (model) {
                [modelArray insertObject:model atIndex:0];
            }
        }
    }];
    [self performArrayComplete:complete param:modelArray synchronous:synchronous];
}

#pragma mark - DELETE
- (void)removeModels:(NSArray <LLStorageModel *>*)models complete:(LLStorageManagerBoolBlock)complete {
    [self removeModels:models complete:complete synchronous:NO];
}

- (void)removeModels:(NSArray <LLStorageModel *>*)models complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous {
    
    // Check thread.
    if (!synchronous && [[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self removeModels:models complete:complete];
        });
        return;
    }
    
    // In background thread now. Check models.
    if (models.count == 0) {
        [self performBoolComplete:complete param:@(YES) synchronous:synchronous];
        return;
    }
    
    // Check datas.
    __block Class cls = [models.firstObject class];
    if (![self isRegisteredClass:cls]) {
        [self log:[NSString stringWithFormat:@"Remove %@ failed, because model is unregister.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    __block NSMutableSet *identities = [NSMutableSet set];
    for (LLStorageModel *model in models) {
        if (![model.class isEqual:cls]) {
            [self log:[NSString stringWithFormat:@"Remove %@ failed, because models in array isn't some class.",NSStringFromClass(cls)]];
            [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
            return;
        }
        [identities addObject:model.storageIdentity];
    }
    
    // Perform database operations.
    __block BOOL ret = NO;

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        NSString *tableName = [self tableNameFromClass:cls];
        NSString *identitiesString = [self convertArrayToSQL:identities.allObjects];
        ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ IN %@;",tableName,kIdentityColumn,identitiesString] values:nil error:&error];
        if (!ret) {
            [self log:[NSString stringWithFormat:@"Remove %@ failed, error = %@",NSStringFromClass(cls),error]];
        }
    }];
    
    [self performBoolComplete:complete param:@(ret) synchronous:synchronous];
}

#pragma mark - Table
- (void)clearTable:(Class)cls complete:(LLStorageManagerBoolBlock)complete {
    [self clearTable:cls complete:complete synchronous:NO];
}

- (void)clearTable:(Class)cls complete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous {
    // Check thread.
    if (!synchronous && [[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self clearTable:cls complete:complete synchronous:synchronous];
        });
        return;
    }
    
    // Check datas.
    if (![self isRegisteredClass:cls]) {
        [self log:[NSString stringWithFormat:@"Remove %@ failed, because model is unregister.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    // Perform database operations.
    __block BOOL ret = NO;
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        NSString *tableName = [self tableNameFromClass:cls];
        ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@;",tableName] values:nil error:&error];
        if (!ret) {
            [self log:[NSString stringWithFormat:@"Clear %@ failed, error = %@",NSStringFromClass(cls),error]];
        }
    }];
    
    [self performBoolComplete:complete param:@(ret) synchronous:synchronous];
}

- (void)clearDatabaseWithComplete:(LLStorageManagerBoolBlock)complete {
    [self clearDatabaseWithComplete:complete synchronous:NO];
}

- (void)clearDatabaseWithComplete:(LLStorageManagerBoolBlock)complete synchronous:(BOOL)synchronous {
    // Check thread.
    if (!synchronous && [[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self clearDatabaseWithComplete:complete synchronous:synchronous];
        });
        return;
    }
    
    // Perform database operations
    __block BOOL ret = YES;
    
    for (Class cls in self.registerClass) {
        [self clearTable:cls complete:^(BOOL result) {
            ret = ret && result;
        } synchronous:YES];
    }

    [self performBoolComplete:complete param:@(ret) synchronous:synchronous];
}

- (void)updateDatabaseWithVersion:(NSString *)version complete:(LLStorageManagerBoolBlock)complete {
    if ([version isEqualToString:@"1.1.3"]) {
        // Update to version 1.1.3
        [self update113VersionWithComplete:complete];
    }
}

- (void)update113VersionWithComplete:(LLStorageManagerBoolBlock)complete {
    // Check thread.
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self update113VersionWithComplete:complete];
        });
        return;
    }
    
    // Perform database operations
    __block NSMutableArray *tables = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:@"select name from sqlite_master where type='table' order by name;"];
        while ([set next]) {
            NSString *name = [set stringForColumn:@"name"];
            if (name) {
                [tables addObject:name];
            }
        }
    }];
    
    __block BOOL ret1 = YES;
    __block BOOL ret2 = YES;
    __block BOOL ret3 = YES;
        
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([tables containsObject:@"CrashModelTable"]) {
            ret1 = [db executeUpdate:@"DROP TABLE CrashModelTable"];
        }
        if ([tables containsObject:@"LogModelTable"]) {
            ret2 = [db executeUpdate:@"DROP TABLE LogModelTable"];
        }
        if ([tables containsObject:@"NetworkModelTable"]) {
            ret3 = [db executeUpdate:@"DROP TABLE NetworkModelTable"];
        }
    }];
    
    [self performBoolComplete:complete param:@(ret1 && ret2 && ret3) synchronous:NO];
}

#pragma mark - Primary
/**
 Initialize something
 */
- (void)initial {
    BOOL result = [self initDatabase];
    if (!result) {
        [self log:@"Init Database fail"];
    }
    [self reloadLogModelTable];
}

/**
 Init database.
 */
- (BOOL)initDatabase {
    self.queue = dispatch_queue_create("LLDebugTool.LLStorageManager", DISPATCH_QUEUE_CONCURRENT);
    self.registerClass = [[NSMutableArray alloc] init];
    
    self.folderPath = [LLConfig sharedConfig].folderPath;
    [LLTool createDirectoryAtPath:self.folderPath];
    
    self.includeCrash = [self crashModelClass] ? YES : NO;
    self.includeNetwork = [self networkModelClass] ? YES : NO;
    self.includeLog = [self logModelClass] ? YES : NO;
    
    NSString *filePath = [self.folderPath stringByAppendingPathComponent:@"LLDebugTool.db"];
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    BOOL ret1 = YES;
    BOOL ret2 = YES;
    BOOL ret3 = YES;
    
    if (self.includeCrash) {
        ret1 = [self registerClass:[self crashModelClass]];
    }
    
    if (self.includeNetwork) {
        ret2 = [self registerClass:[self networkModelClass]];
    }
    if (self.includeLog) {
        ret3 = [self registerClass:[self logModelClass]];
    }

    return ret1 && ret2 && ret3;
}

/**
 * Remove unused log models and networks models.
 */
- (void)reloadLogModelTable {
    // Need to remove logs in a global queue.
    if ([[NSThread currentThread] isMainThread]) {
        dispatch_async(_queue, ^{
            [self reloadLogModelTable];
        });
        return;
    }
    

    __block NSArray *crashModels = @[];
    if (self.includeCrash) {
        [self getModels:[self crashModelClass] launchDate:nil storageIdentity:nil complete:^(NSArray<LLStorageModel *> *result) {
            crashModels = result;
        } synchronous:YES];
        
        NSMutableArray *launchDates = [[NSMutableArray alloc] initWithObjects:[NSObject LL_launchDate], nil];
        for (LLStorageModel *model in crashModels) {
            NSString *launchDate = [model valueForKey:@"launchDate"];
            if ([launchDate length]) {
                [launchDates addObject:launchDate];
            }
        }
        [self removeLogModelAndNetworkModelNotIn:launchDates];
    }
}

- (BOOL)removeLogModelAndNetworkModelNotIn:(NSArray *)launchDates {
    __block BOOL ret = YES;
    __block BOOL ret2 = YES;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (self.includeLog) {
            NSError *error1;
            NSString *logTableName = [self tableNameFromClass:[self logModelClass]];
            NSString *launchDateString = [self convertArrayToSQL:launchDates];
            ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ NOT IN %@;",logTableName,kLaunchDateColumn,launchDateString] values:nil error:&error1];
            if (!ret) {
                [self log:[NSString stringWithFormat:@"Remove launch log fail, error = %@",error1]];
            }
        }

        if (self.includeNetwork) {
            NSError *error2;
            NSString *networkTableName = [self tableNameFromClass:[self networkModelClass]];
            NSString *networkLaunchDateString = [self convertArrayToSQL:launchDates];
            ret2 = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ NOT IN %@;",networkTableName,kLaunchDateColumn,networkLaunchDateString] values:nil error:&error2];
            if (!ret2) {
                [self log:[NSString stringWithFormat:@"Remove launch network fail, error = %@",error2]];
            }
        }
    }];

    return ret && ret2;
}

- (BOOL)isRegisteredClass:(Class)cls {
    return [self.registerClass containsObject:cls];
}

- (NSString *)tableNameFromClass:(Class)cls {
    return [NSString stringWithFormat:@"%@Table_%@",NSStringFromClass(cls),kDatabaseVersion];
}

- (NSString *)createTableSQLFromClass:(Class)cls {
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ BLOB NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL,%@ TEXT NOT NULL);",[self tableNameFromClass:cls],kObjectDataColumn,kIdentityColumn,kLaunchDateColumn,kDescriptionColumn];
}

- (NSString *)convertArrayToSQL:(NSArray *)array {
    NSMutableString *SQL = [[NSMutableString alloc] init];
    [SQL appendString:@"("];
    for (NSString *item in array) {
        [SQL appendFormat:@"\"%@\",",item];
    }
    [SQL deleteCharactersInRange:NSMakeRange(SQL.length - 1, 1)];
    [SQL appendString:@")"];
    return SQL;
}

- (void)performBoolComplete:(LLStorageManagerBoolBlock)complete param:(NSNumber *)param synchronous:(BOOL)synchronous {
    if (complete) {
        if (synchronous || [[NSThread currentThread] isMainThread]) {
            complete(param.boolValue);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performBoolComplete:complete param:param synchronous:synchronous];
            });
        }
    }
}

- (void)performArrayComplete:(LLStorageManagerArrayBlock)complete param:(NSArray *)param synchronous:(BOOL)synchronous {
    if (complete) {
        if (synchronous || [[NSThread currentThread] isMainThread]) {
            complete(param);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performArrayComplete:complete param:param synchronous:synchronous];
            });
        }
    }
}

- (void)log:(NSString *)message {
    [LLRoute logWithMessage:message event:kLLDebugToolEvent];
}

- (void)saveOrUpdateModel:(LLStorageModel *_Nonnull)model complete:(LLStorageManagerBoolBlock _Nullable)complete synchronous:(BOOL)synchronous isSave:(BOOL)isSave {
    __block Class cls = model.class;
    
    // Check thread.
    if (!synchronous && [[NSThread currentThread] isMainThread] && model.operationOnMainThread) {
        dispatch_async(_queue, ^{
            [self saveModel:model complete:complete];
        });
        return;
    }
    
    // Check datas.
    if (![self isRegisteredClass:cls]) {
        [self log:[NSString stringWithFormat:@"Save %@ failed, because model is unregister.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    NSString *launchDate = [NSObject LL_launchDate];
    if (launchDate.length == 0) {
        [self log:[NSString stringWithFormat:@"Save %@ failed, because launchDate is nil.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data.length == 0) {
        [self log:[NSString stringWithFormat:@"Save %@ failed, because model's data is null.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    NSString *identity = model.storageIdentity;
    if (identity.length == 0) {
        [self log:[NSString stringWithFormat:@"Save %@ failed, because model's identity is nil.",NSStringFromClass(cls)]];
        [self performBoolComplete:complete param:@(NO) synchronous:synchronous];
        return;
    }
    
    __block NSArray *arguments = @[data,launchDate,identity,model.description?:@"None description"];
    __block BOOL ret = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        if (isSave) {
            ret = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@) VALUES (?,?,?,?);",[self tableNameFromClass:cls],kObjectDataColumn,kLaunchDateColumn,kIdentityColumn,kDescriptionColumn] values:arguments error:&error];
        } else {
            ret = [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? ,%@ = ?,%@ = ?,%@ = ? WHERE %@ = \"%@\";",[self tableNameFromClass:cls],kObjectDataColumn,kLaunchDateColumn,kIdentityColumn,kDescriptionColumn,kIdentityColumn,model.storageIdentity] values:arguments error:&error];
        }
        if (!ret) {
            [self log:[NSString stringWithFormat:@"Save %@ failed, error = %@",NSStringFromClass(cls),error.localizedDescription]];
        }
    }];
    [self performBoolComplete:complete param:@(ret) synchronous:synchronous];
}

- (Class _Nullable)crashModelClass {
    return NSClassFromString(kLLCrashModelName);
}

- (Class _Nullable)networkModelClass {
    return NSClassFromString(kLLNetworkModelName);
}

- (Class _Nullable)logModelClass {
    return NSClassFromString(kLLLogModelName);
}

@end

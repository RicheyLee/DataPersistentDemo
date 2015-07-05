//
//  QYSqliteDBManager.m
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSqliteDBManager.h"
#import "QYStudentModel.h"
#import <sqlite3.h>

#define kSqliteDBFile   @"students.sqlite"

static QYSqliteDBManager *_manager;
static sqlite3 *_sqliteDB;

@implementation QYSqliteDBManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

- (NSString *)documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (BOOL)openDB
{
    if (_sqliteDB) {
        return YES;
    }
    
    NSString *dbFilePath = [[self documentPath] stringByAppendingPathComponent:kSqliteDBFile];
    
    int result = sqlite3_open([dbFilePath UTF8String], &_sqliteDB);
    
    if (result != SQLITE_OK) {
        NSLog(@"Open database failed!");
        return NO;
    }
    
    return YES;
}

- (BOOL)closeDB
{
    if (!_sqliteDB) {
        return NO;
    }
    

    int result = sqlite3_close(_sqliteDB);
    if (result != SQLITE_OK) {
        NSLog(@"Close database failed!");
        return NO;
    }
    _sqliteDB = NULL;

    return YES;
}

- (BOOL)createTable
{
    // SQL
    NSString *sql = @"create table Students(number INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, age INTEGER, sex TEXT, icon BLOB)";
    
    char *errmsg;
    
    int result = sqlite3_exec(_sqliteDB, [sql UTF8String], NULL, NULL, &errmsg);
    if (result != SQLITE_OK) {
        NSLog(@"%s", errmsg);
        return NO;
    }
    
    NSLog(@"Create Students Table Successfully!");
    return YES;
}

- (BOOL)insertStudent:(QYStudentModel *)student
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"insert into Students(number, name, age, sex, icon) values(?, ?, ?, ?, ?)";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 绑定 SQL 语句中的参数，即替换问号
    sqlite3_bind_int(stmt, 1, student.number);
    sqlite3_bind_text(stmt, 2, [student.name UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 3, student.age);
    sqlite3_bind_text(stmt, 4, [student.sex UTF8String], -1, NULL);
    NSData *imageData = UIImagePNGRepresentation(student.icon);
    sqlite3_bind_blob(stmt, 5, [imageData bytes], (int)imageData.length, NULL);
    
    // 5. 执行
    sqlite3_step(stmt);
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    NSLog(@"Insert OK!");
    
    return YES;
}

- (BOOL)deleteStudentByNumber:(int)number
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"delete from Students where number = ?";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 绑定 SQL 语句中的参数，即替换问号
    sqlite3_bind_int(stmt, 1, number);
    
    // 5. 执行
    sqlite3_step(stmt);
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    
    NSLog(@"Delete OK!");
    
    return YES;
}

- (BOOL)updateStudent:(QYStudentModel *)student byNumber:(int)number
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"update Students set name = ?, age = ?, sex = ?, icon = ? where number = ?";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 绑定 SQL 语句中的参数，即替换问号
    sqlite3_bind_text(stmt, 1, [student.name UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 2, student.age);
    sqlite3_bind_text(stmt, 3, [student.sex UTF8String], -1, NULL);
    NSData *imageData = UIImagePNGRepresentation(student.icon);
    sqlite3_bind_blob(stmt, 4, [imageData bytes], (int)imageData.length, NULL);
    
    sqlite3_bind_int(stmt, 5, number);
    
    // 5. 执行
    sqlite3_step(stmt);
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    
    NSLog(@"Update OK!");
    
    return YES;
}

- (QYStudentModel *)extractModelFrom:(sqlite3_stmt *)stmt
{
    // 1. 提取学号
    int number = sqlite3_column_int(stmt, 0);
    
    // 2. 提取名字
    const unsigned char *nameStr = sqlite3_column_text(stmt, 1);
    NSString *name;
    if (nameStr) {
        name = [NSString stringWithCString:(const char *)nameStr encoding:NSUTF8StringEncoding];
    }
    
    // 3. 提取年龄
    int age = sqlite3_column_int(stmt, 2);
    
    // 4. 提取性别
    const unsigned char *sexStr = sqlite3_column_text(stmt, 3);
    NSString *sex;
    if (sexStr) {
        sex = [NSString stringWithCString:(const char *)sexStr encoding:NSUTF8StringEncoding];
    }
    
    // 5. 提取头像
    const void *iconData = sqlite3_column_blob(stmt, 4);
    int size = sqlite3_column_bytes(stmt, 4);
    
    NSData *imageData = [NSData dataWithBytes:iconData length:size];

    UIImage *icon = [UIImage imageWithData:imageData];
    
    // 6. 组装成模型对象
    if (number == 0 && [name isEqualToString:@""]) {
        return nil;
    }
    QYStudentModel *student = [[QYStudentModel alloc] init];
    
    student.number = number;
    student.age = age;
    student.name = name;
    student.sex = sex;
    student.icon = icon;
    
    return student;
}

- (NSArray *)selectAllStudents
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"select * from Students";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 执行SQL
    NSMutableArray *students = [NSMutableArray array];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // 5. 按列提取数据
        QYStudentModel *model = [self extractModelFrom:stmt];
        if (model) {
            [students addObject:model];
        }
    }
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    
    if (students.count == 0) {
        return nil;
    }
    
    return students;
}

- (QYStudentModel *)selectStudentByNumber:(int)number
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"select * from Students where number = ?";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 执行SQL
    
    sqlite3_bind_int(stmt, 1, number);
    
    QYStudentModel *model;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        // 5. 按列提取数据
        model = [self extractModelFrom:stmt];
    }
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    
    return model;
}

- (NSArray *)selectStudentsByName:(NSString *)name
{
    // 1. 打开数据库
    [self openDB];
    
    // 2. 编写SQL
    NSString *sql = @"select * from Students where name = ?";
    
    // 3. 编译SQL
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"Error: sqlite3_prepare_v2");
        return NO;
    }
    
    // 4. 执行SQL
    sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
    
    NSMutableArray *students = [NSMutableArray array];
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // 5. 按列提取数据
        QYStudentModel *model = [self extractModelFrom:stmt];
        if (model) {
            [students addObject:model];
        }
    }
    
    // 6. 释放预编译语句对象
    sqlite3_finalize(stmt);
    
    // 7. 关闭数据库
    [self closeDB];
    
    return students;
}

@end

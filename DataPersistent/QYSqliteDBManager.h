//
//  QYSqliteDBManager.h
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QYStudentModel;

@interface QYSqliteDBManager : NSObject

/**
 * 单利的数据库管理对象
 */
+ (instancetype)sharedInstance;

/**
 *  打开数据数据库操作
 */
- (BOOL)openDB;

/**
 *  关闭数据库操作
 */
- (BOOL)closeDB;

/**
 *  创建数据表
 */
- (BOOL)createTable;

/**
 *  插入数据操作
 */
- (BOOL)insertStudent:(QYStudentModel *)student;

/**
 *  删除数据操作
 */
- (BOOL)deleteStudentByNumber:(int)number;

/**
 * 修改数据操作
 */

- (BOOL)updateStudent:(QYStudentModel *)student byNumber:(int)number;

/**
 * 查找所有记录
 * 返回值: 如果有记录，以数组形式返回，否则，返回nil
 */
- (NSArray *)selectAllStudents;

/**
 *  根据学号，查找指定学生记录
 */
- (QYStudentModel *)selectStudentByNumber:(int)number;

/**
 *  根据姓名，查找指定学生记录，可能重名
 */
- (NSArray *)selectStudentsByName:(NSString *)name;

@end

//
//  QYSQLiteVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSQLiteVC.h"
#import "QYSqliteDBManager.h"

// 如果需要使用SQLite3，需要先连接libsqlite3.0.dylib动态库

#import <sqlite3.h>

@interface QYSQLiteVC ()
@property (nonatomic, strong) QYSqliteDBManager *manager;
@end

@implementation QYSQLiteVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _manager = [QYSqliteDBManager sharedInstance];
    NSLog(@"%@", NSHomeDirectory());
}

- (IBAction)createDB:(id)sender {

    if ([_manager openDB]) {
        NSLog(@"Create Database OK!");
    }
}


- (IBAction)createTable:(id)sender {
    if ([_manager createTable]) {
        NSLog(@"Create Table OK!");
    }
}


@end

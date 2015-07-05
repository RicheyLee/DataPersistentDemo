//
//  QYSQLiteSeachVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-5.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSQLiteSeachVC.h"
#import "QYStudentCell.h"
#import "QYSqliteDBManager.h"

#define kStudentCellID  @"StudentCell"

@interface QYSQLiteSeachVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *number;

@property (nonatomic, strong) NSArray *students;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) QYSqliteDBManager *manager;

@end

@implementation QYSQLiteSeachVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (QYSqliteDBManager *)manager
{
    if (_manager == nil) {
        _manager = [QYSqliteDBManager sharedInstance];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)selectAll:(id)sender {
    _students = [self.manager selectAllStudents];
    [self.tableView reloadData];
}

- (IBAction)selectStuByNumber:(id)sender {
    QYStudentModel *model = [self.manager selectStudentByNumber:[_number.text intValue]];
    
//    _students = @[model];
    if (model) {
        _students = @[model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _students.count;
    if (_students == nil) {
        return 0;
    }
    
    return _students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:kStudentCellID];
    if (cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYStudentCell" owner:self options:nil][0];
        cell = [[QYStudentCell alloc] init];
    }
    
    // 配置cell
    cell.number.text = [[_students[indexPath.row] valueForKey:@"number"] stringValue];
    cell.name.text = [_students[indexPath.row] valueForKey:@"name"];
    cell.age.text = [[_students[indexPath.row] valueForKey:@"age"] stringValue];
    cell.sex.text = [_students[indexPath.row] valueForKey:@"sex"];
    cell.icon.image = [_students[indexPath.row] valueForKey:@"icon"];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123.0;
}

@end

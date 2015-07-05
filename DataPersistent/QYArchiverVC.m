//
//  QYArchiverVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-2.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYArchiverVC.h"
#import "QYStudent.h"

#define kFileName   @"student.data"

@interface QYArchiverVC ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *studyID;

@property (nonatomic, strong) NSString *filePath;
@end

@implementation QYArchiverVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)miscInit
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    _filePath = [docPath stringByAppendingPathComponent:kFileName];
    
    NSLog(@"%@", _filePath);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self miscInit];
    
    // 从文件解档出数据模型，并更新到界面上
    [self loadData];

}

/*
 * 将界面元素保存到数据模型中，并进行归档
 */
- (IBAction)archiveData:(id)sender {
    
    QYStudent *student = [[QYStudent alloc] init];
    
    student.name = _name.text;
    student.age = [_age.text intValue];
    student.studyID = _studyID.text;
    
    NSLog(@"%@", student);
    
    if ([NSKeyedArchiver archiveRootObject:student toFile:_filePath]) {
        NSLog(@"archive ok.");
    }
}

- (void)loadData
{
    QYStudent *student = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
    
    if (student == nil) {
        NSLog(@"No data");
        return;
    }
    
    NSLog(@"unarchive ok.'");
    
    _name.text = student.name;
    _age.text = [@(student.age) stringValue];
    _studyID.text = student.studyID;
}

@end

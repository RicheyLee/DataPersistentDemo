//
//  QYOCAPIsVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-1.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYOCAPIsVC.h"

#define kFileName   @"OCFile.txt"

@interface QYOCAPIsVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSString *filePath;
@end

@implementation QYOCAPIsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadData
{
    NSString *str = [[NSString alloc] initWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil && ![str isEqualToString:@""]) {
       _textField.text = str;
    }
}

- (void)miscInit
{
    // Document目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    // 创建test目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDir = [docPath stringByAppendingPathComponent:@"test"];
    
    NSError *error;
    [fileManager createDirectoryAtPath:testDir withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    // 创建文件
    _filePath = [testDir stringByAppendingPathComponent:kFileName];
    NSLog(@"_filePath:%@",_filePath);
    if(_filePath == nil){
        [fileManager createFileAtPath:_filePath contents:nil attributes:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self miscInit];
    
    // 从文件读取内容，加载到textField上
    [self loadData];
}

- (IBAction)saveData:(id)sender {
    NSLog(@"content to save:%@",_textField.text);
    NSError *error;
    if([_textField.text writeToFile:_filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]){
        NSLog(@"save ok");
    }    
    
}

@end

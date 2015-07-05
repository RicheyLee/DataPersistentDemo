//
//  QYCAPIsVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-1.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYCAPIsVC.h"

#define kTmpFileName    @"CAPIFile.txt"

@interface QYCAPIsVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation QYCAPIsVC

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
    NSString *tmpPath = NSTemporaryDirectory();
    
    _filePath = [tmpPath stringByAppendingPathComponent:kTmpFileName];
    NSLog(@"%@", _filePath);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self miscInit];
    
    // 用C接口从文件读取数据并更新到textField上
    [self loadData];
    
    
}

- (void)loadData
{
    const char *fileName = [_filePath UTF8String];
    
    FILE *fp = fopen(fileName, "r");
    if (NULL == fp) {
        perror("fopen");
        return;
    }
    
    // 读取文件内容到内存
    char buf[BUFSIZ] = {0};
    
    // 取文件大小
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    
    // 再将文件位置移到文件头
    rewind(fp);
    
    fread(buf, size, 1, fp);

    // 赋值给textField
    if (buf[0] != 0) {
        _textField.text = [NSString stringWithUTF8String:buf];
    }
    
    fclose(fp);
}

// 当点击save按钮时，将textField的内容保存进文件
- (IBAction)saveData:(id)sender {
    
    const char *fileName = [_filePath UTF8String];
    
    FILE *fp = fopen(fileName, "w+");
    if (NULL == fp) {
        perror("fopen");
        return;
    }
    
    const char *content = [_textField.text UTF8String];
    
    fwrite(content, _textField.text.length, 1, fp);
    
    fclose(fp);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}


@end

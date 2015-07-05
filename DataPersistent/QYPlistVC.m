//
//  QYPlistVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-2.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYPlistVC.h"

#define kFileName   @"test.plist"

@interface QYPlistVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *filePath;
@end

@implementation QYPlistVC


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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self miscInit];

    [self loadData];
}

- (void)loadData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:_filePath];
    
    NSString *text = dict[@"input"];
    
    if (text && text.length > 0) {
        _textField.text = text;
    }
    
    NSLog(@"load data ok.");
}

- (IBAction)saveData:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"input"] = _textField.text;
    
    if ([dict writeToFile:_filePath atomically:YES]) {
        NSLog(@"save data ok.");
    }
}

@end

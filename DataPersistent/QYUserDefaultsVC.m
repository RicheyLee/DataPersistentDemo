//
//  QYUserDefaultsVC.m
//  DataPersistent
//
//  Created by qingyun on 14-12-1.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYUserDefaultsVC.h"

@interface QYUserDefaultsVC ()
@property (weak, nonatomic) IBOutlet UISwitch *toggle;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation QYUserDefaultsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadData];
}

- (void)loadData
{
    // NSUserDefaults实例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.toggle.on = [userDefaults boolForKey:@"toggle"];
    
    self.progress.progress = [userDefaults floatForKey:@"progress"];
    
    self.textField.text = [userDefaults stringForKey:@"input"];
}

- (IBAction)saveData:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:self.toggle.on forKey:@"toggle"];
    
    float progress = _progress.progress;
    [userDefaults setFloat:progress forKey:@"progress"];
    
    [userDefaults setObject:_textField.text forKey:@"input"];
    
    // 同步内容，刷新到磁盘
    [userDefaults synchronize];
}



@end

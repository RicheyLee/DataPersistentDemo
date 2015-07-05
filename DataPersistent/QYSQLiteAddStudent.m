//
//  QYSQLiteAddStudent.m
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYSQLiteAddStudent.h"
#import "QYSqliteDBManager.h"
#import "QYStudentModel.h"

@interface QYSQLiteAddStudent () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)QYSqliteDBManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation QYSQLiteAddStudent

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _manager = [QYSqliteDBManager sharedInstance];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.icon.frame, location)) {
        //
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPickerController.delegate = self;
        
        [self presentViewController:imgPickerController animated:YES completion:^{

        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.icon.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

- (IBAction)saveData:(id)sender {
    QYStudentModel *model = [[QYStudentModel alloc] init];
    
    model.number = [_number.text intValue];
    model.name = _name.text;
    model.age = [_age.text intValue];
    model.sex = _sex.text;
    model.icon = _icon.image;
    
    [_manager insertStudent:model];
}

@end

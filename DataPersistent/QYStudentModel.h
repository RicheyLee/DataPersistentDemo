//
//  QYStudentModel.h
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYStudentModel : NSObject
@property (nonatomic) int number;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int age;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) UIImage *icon;

@end

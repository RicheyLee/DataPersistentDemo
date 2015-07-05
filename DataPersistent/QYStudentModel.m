//
//  QYStudentModel.m
//  DataPersistent
//
//  Created by qingyun on 14-12-4.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYStudentModel.h"

@implementation QYStudentModel

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Student Info: Number:<%d>, Name:<%@>, Age:<%d>, Sex:<%@>, Icon:<%@>", _number, _name, _age, _sex, _icon];
    
    return desc;
}

@end

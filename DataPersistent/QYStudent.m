//
//  QYStudent.m
//  DataPersistent
//
//  Created by qingyun on 14-12-2.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYStudent.h"

@implementation QYStudent

/*
 * 编码、归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:kNameKey];
    [aCoder encodeInt:_age forKey:kAgeKey];
    [aCoder encodeObject:_studyID forKey:kStudyIDKey];
}

/*
 * 解码、解档
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:kNameKey];
        _age = [aDecoder decodeIntForKey:kAgeKey];
        _studyID = [aDecoder decodeObjectForKey:kStudyIDKey];
    }
    
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Student's name %@, age %d, studyID %@", _name, _age, _studyID];
    
    return desc;
}

@end

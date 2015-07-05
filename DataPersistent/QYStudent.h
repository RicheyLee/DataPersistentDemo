//
//  QYStudent.h
//  DataPersistent
//
//  Created by qingyun on 14-12-2.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNameKey        @"name"
#define kAgeKey         @"age"
#define kStudyIDKey     @"studyID"

@interface QYStudent : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic) int age;
@property (nonatomic, strong) NSString *studyID;

@end

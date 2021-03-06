//
//  DataCenterClear.m
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/29.
//  Copyright © 2016年 quick. All rights reserved.
//

#import "DataCenterClear.h"

@implementation DataCenterClear
-(NSString*)databaseName{
    return @"persons.db";
}

+(id)defaultDataCenter{
    static dispatch_once_t onceToken;
    static DataCenter* sharedCenter;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    
    return sharedCenter;
}
@end

//
//  DataCenter.h
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/20.
//  Copyright © 2016年 quick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface DataCenter : NSObject
-(instancetype) init __attribute__((unavailable("init prohibited")));

/**
 The dabase name should be hide under database.
 My purpose is for clear and secret use.
 */
-(NSString*)databaseName;
+(id)defaultDataCenter;
-(BOOL)savePerson:(Person*)person;
-(NSArray*)allPersons;

-(void)test_saveDefaultPersonForCount:(NSInteger)count;
-(void)test_saveTransactionDefaultPersonForCount:(NSInteger)count;
@end

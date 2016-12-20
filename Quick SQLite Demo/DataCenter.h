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

+(id)defaultDataCenter;
-(BOOL)savePerson:(Person*)person;
-(NSArray*)allPersons;
@end

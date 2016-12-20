//
//  DataCenter.m
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/20.
//  Copyright © 2016年 quick. All rights reserved.
//

#import "DataCenter.h"
#import <QuickSQLite/QuickSQLite.h>


#define kDBName     @"persons.sql"

#define kTableName  @"person"

#define kColumnId       @"_id"
#define kColumnName     @"name"
#define kColumnAge      @"age"
#define kColumnAvatar   @"avatar"
#define kColumnHeight   @"height"


@interface DataCenter()<QSQLiteOpenHelperDelegate>
@property (nonatomic, strong) QSQLiteOpenHelper* dbHelper;
@end

@implementation DataCenter


-(id)initInternally{
    self = [super init];
    if (self) {
        _dbHelper = [[QSQLiteOpenHelper alloc] initWithName:kDBName version:1 openDelegate:self];
        
    }
    
    return self;
}

+(id)defaultDataCenter{
    static dispatch_once_t onceToken;
    static DataCenter* sharedCenter;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] initInternally];
    });
    
    return sharedCenter;
}

#define FILL_CONTENT(array, key, value) do{\
    QDBValue* content = [QDBValue instanceForObject:value withKey:key];\
    if(content != nil){\
        [array addObject: content];\
    }\
}while(0)

-(BOOL)savePerson:(Person*)person{
    NSDictionary* values = @{
                             kColumnName: person.name,
                             kColumnAvatar: UIImagePNGRepresentation(person.avatar),
                             kColumnAge: @(person.age),
                             kColumnHeight: @(person.height)
                             };
    
    if(person.identity == 0){
        person.identity = (NSUInteger)[self.dbHelper insert:kTableName values:values];
        return person.identity > 0;
    }else{
        NSString* where = [NSString stringWithFormat:@"%@=%ld", kColumnId, (unsigned long)person.identity];
        return [self.dbHelper update:kTableName values:values where:where] > 0;
    }
}

-(NSArray*)allPersons{
    NSArray* rows = [self.dbHelper query:kTableName columns:@[kColumnId, kColumnAvatar, kColumnHeight, kColumnAge, kColumnName] where:nil];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (NSDictionary* row in rows) {
        Person* person = [[Person alloc] init];
        person.name = row[kColumnName];
        person.age = ((NSNumber*)row[kColumnAge]).unsignedIntegerValue;
        person.height =((NSNumber*)row[kColumnHeight]).floatValue;
        person.identity = ((NSNumber*)row[kColumnId]).unsignedIntegerValue;
        person.avatar = [UIImage imageWithData:row[kColumnAvatar]];
        
        [result addObject:person];
    }
    
    return result;
}

#pragma mark - db open delegate
-(NSString*) pathToCopyBundleDBFileForSQLiteOpenHelper:(QSQLiteOpenHelper *)openHelper
                                              withName:(NSString*)name{
    if([kDBName isEqualToString:name]){
        return [[NSBundle mainBundle] pathForResource:kDBName ofType:nil];
    }
    
    return nil;
}
@end

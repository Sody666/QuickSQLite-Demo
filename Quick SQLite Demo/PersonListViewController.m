//
//  PersonListViewController.m
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/20.
//  Copyright © 2016年 quick. All rights reserved.
//

#import "PersonListViewController.h"
#import <QuickVFL/QuickVFL.h>
#import "PersonTableViewCell.h"
#import "DataCenterClear.h"

@interface PersonListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView* tableViewPersons;
@property (nonatomic, readonly) NSArray* persons;
@end

@implementation PersonListViewController
@synthesize persons = _persons;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Persons in Database";
    
    [self setupWidgets];
    [self.tableViewPersons reloadData];
}

-(void)setupWidgets{
    _tableViewPersons = QUICK_SUBVIEW(self.view, UITableView);
    UIButton* buttonAdd = QUICK_SUBVIEW(self.view, UIButton);
    
    NSString* layout = @"   H:|[_tableViewPersons]|;\
                            V:|[_tableViewPersons]-[buttonAdd(44)]-| {left, right};";
    [self.view q_addConstraintsByText:layout
                        involvedViews:NSDictionaryOfVariableBindings(_tableViewPersons, buttonAdd)];
    
    self.tableViewPersons.delegate = self;
    self.tableViewPersons.dataSource = self;
    self.tableViewPersons.tableFooterView = [[UIView alloc] init];
    
    [buttonAdd setTitle:@"Add One Person" forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(onAddButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [buttonAdd setBackgroundColor:[UIColor blueColor]];
    
    [self.view setNeedsLayout];
}

-(NSArray*)persons{
    if(_persons == nil){
        _persons = [[DataCenterClear defaultDataCenter] allPersons];
    }
    
    return _persons;
}

-(void)onAddButtonTapped:(id)sender{
    DataCenter* center = [DataCenterClear defaultDataCenter];
    
    NSUInteger count = [center allPersons].count;
    Person* person = [[Person alloc] init];
    person.name = [NSString stringWithFormat:@"Alice%u", count + 1];
    person.height = 175;
    person.age = 21;
    person.avatar = [UIImage imageNamed:@"avatar"];
    
    [center savePerson:person];

    _persons = nil;
    
    [self.tableViewPersons reloadData];
}

#pragma mark - table view delegate
// to make the source code neat, we set it to 75.
// person table view cell can caculate itself actually.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.persons.count;
}

#define CELL_ID @"personCell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if(cell == nil){
        cell = [[PersonTableViewCell alloc] initWithReuseIdentifier:CELL_ID];
    }
    
    [cell fillCellWithPerson:[self.persons objectAtIndex:indexPath.row]];
    
    return cell;
}
@end

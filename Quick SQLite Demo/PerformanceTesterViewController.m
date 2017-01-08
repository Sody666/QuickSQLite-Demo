//
//  PerformanceTesterViewController.m
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/29.
//  Copyright © 2016年 quick. All rights reserved.
//

#import "PerformanceTesterViewController.h"
#import <QuickVFL/QuickVFL.h>
#import "DataCenterClear.h"
#import "DataCenterSecret.h"
#import "PerformanceTesterViewController.h"

@interface PerformanceTesterViewController ()
@property (nonatomic, weak) UILabel* labelStatus;
@property (nonatomic, weak) UITextField* textFieldCount;
@property (nonatomic, assign) BOOL isTesting;
@end

@implementation PerformanceTesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupWidgets];
    self.title = @"Inserting Performance Tests";
}

-(void)setupWidgets{
    UITextField* textFieldCount = QUICK_SUBVIEW(self.view, UITextField);
    UILabel* labelStatus = QUICK_SUBVIEW(self.view, UILabel);
    UIButton* buttonStart = QUICK_SUBVIEW(self.view, UIButton);
    
    NSString* layout = @"                                                       \
        H:|-[textFieldCount]-|;                                                 \
        V:|-30-[textFieldCount]-[labelStatus]-[buttonStart]-(>=0)-| {left, right}; \
    ";
    
    [self.view q_addConstraintsByText:layout
                        involvedViews:NSDictionaryOfVariableBindings(textFieldCount, labelStatus, buttonStart)];
    
    
    labelStatus.numberOfLines = 0;
    labelStatus.font = [UIFont systemFontOfSize:16];
    
    textFieldCount.placeholder = @"Count of Inserting";
    textFieldCount.keyboardType = UIKeyboardTypeNumberPad;
    
    [buttonStart setTitle:@"Start" forState:UIControlStateNormal];
    [buttonStart setBackgroundColor:[UIColor orangeColor]];
    [buttonStart addTarget:self action:@selector(onStartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.labelStatus = labelStatus;
    self.textFieldCount = textFieldCount;
    
    [self.view setNeedsLayout];
}

-(void)onRightItemTapped:(id)sender{
    [self.navigationController pushViewController:[[PerformanceTesterViewController alloc] init] animated:YES];
}

-(void)onStartButtonTapped:(id)sender{
    if(self.isTesting){
        self.labelStatus.text = [NSString stringWithFormat:@"%@\n\nPrevious testing is still working...", self.labelStatus.text];
        return;
    }
    
    NSInteger count = self.textFieldCount.text.integerValue;
    if(count < 1){
        self.labelStatus.text = @"Please provide a valid count.";
        return;
    }
    
    self.isTesting = YES;
    [self startTestingForCount:count];
}

-(void)startTestingForCount:(NSInteger)count{
    dispatch_queue_t serialQueue = dispatch_queue_create("db testing", DISPATCH_QUEUE_SERIAL);
    
    NSMutableString* status = [[NSMutableString alloc] initWithFormat:@"Inserting %li persons into database:\n\n", (long)count];
    NSString* extraMessage = @"Testing is still walking...";
    __block NSDate* startDate = nil;
    self.labelStatus.text = extraMessage;
    
    
    DataCenter* dataCenterSecret = [DataCenterSecret defaultDataCenter];
    DataCenter* dataCenterClear = [DataCenterClear defaultDataCenter];
    
    
    dispatch_async(serialQueue, ^{
        startDate = [NSDate date];
        [dataCenterClear test_saveTransactionDefaultPersonForCount:count];
        [status appendFormat:@"%.4fs into clear db in transaction mode\n", [NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelStatus.text = [NSString stringWithFormat:@"%@\n%@", status, extraMessage];
        });
    });
    
    
    dispatch_async(serialQueue, ^{
        startDate = [NSDate date];
        [dataCenterSecret test_saveTransactionDefaultPersonForCount:count];
        [status appendFormat:@"%.4fs into encrypted db in transaction mode\n", [NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelStatus.text = [NSString stringWithFormat:@"%@\n%@", status, extraMessage];
            
        });
        
        
    });
    
    dispatch_async(serialQueue, ^{
        startDate = [NSDate date];
        [dataCenterClear test_saveDefaultPersonForCount:count];
        [status appendFormat:@"%.4fs into clear db\n", [NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelStatus.text = [NSString stringWithFormat:@"%@\n%@", status, extraMessage];
        });
    });
    
    
    
    dispatch_async(serialQueue, ^{
        startDate = [NSDate date];
        [dataCenterSecret test_saveDefaultPersonForCount:count];
        [status appendFormat:@"%.4fs into encrypted db\n", [NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelStatus.text = [NSString stringWithFormat:@"%@\n%@", status, @"Test finished."];
        });
        
        self.isTesting = NO;
    });
    
    
    dispatch_async(serialQueue, ^{
        NSArray* all1 = [dataCenterSecret allPersons];
        NSArray* all2 = [dataCenterClear allPersons];
        for (Person* p in all1) {
            NSLog(@"%@",p.name);
        }
        
        NSLog(@"%d %d", all1.count, all2.count);
    });
    

}

@end

//
//  PersonTableViewCell.m
//  Quick SQLite Demo
//
//  Created by sudi on 2016/12/20.
//  Copyright © 2016年 quick. All rights reserved.
//

#import "PersonTableViewCell.h"
#import <QuickVFL/QuickVFL.h>
#import "Person.h"

@interface PersonTableViewCell()
@property (nonatomic, weak) UILabel* labelName;
@property (nonatomic, weak) UILabel* labelAge;
@property (nonatomic, weak) UILabel* labelHeight;
@property (nonatomic, weak) UIImageView* imageViewAvatar;
@end

@implementation PersonTableViewCell

-(id)init{
    self = [super init];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(id)initWithReuseIdentifier:(NSString*)identifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        [self setupWidgets];
    }
    
    return self;
}

-(void)setupWidgets{
    self.labelAge = QUICK_SUBVIEW(self.contentView, UILabel);
    self.labelName = QUICK_SUBVIEW(self.contentView, UILabel);
    self.labelHeight = QUICK_SUBVIEW(self.contentView, UILabel);
    self.imageViewAvatar = QUICK_SUBVIEW(self.contentView, UIImageView);
    
    NSString* layout = @"\
    /*name, age, height left right align*/\
    V:|-[_labelName][_labelAge][_labelHeight]-(>=8)-| {left, right};\
    H:|-[_labelName]-[_imageViewAvatar]-|;\
    /*if name, age, height part is higher than avatar, center it*/\
    H:[_imageViewAvatar]{centerY};\
    V:|-(>=8)-[_imageViewAvatar]-(>=8)-|;";
    
    [self.contentView q_addConstraintsByText:layout
                               involvedViews:NSDictionaryOfVariableBindings(_labelAge, _labelName, _labelHeight, _imageViewAvatar)];
    
    [self.imageViewAvatar q_stayShapedWhenStretchedWithPriority:UILayoutPriorityDefaultHigh isHorizontal:YES];
}

-(void)fillCellWithPerson:(Person*)person{
    self.labelName.text = person.name;
    self.labelAge.text = @(person.age).stringValue;
    self.labelHeight.text = @(person.height).stringValue;
    self.imageViewAvatar.image = person.avatar;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
@end

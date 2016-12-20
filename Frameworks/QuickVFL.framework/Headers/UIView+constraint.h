//
//  UIView+constraint.h
//  Quick VFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QUICK_SUBVIEW(super, subviewClass) ([super q_addAutolayoutSubviewByClass:[subviewClass class]])
@interface UIView(constraint)
/**
 *  alloc and init a widget for autolayout use.
 *
 *  @return widget generated
 */
+(id)q_autolayoutInstance;

/**
 *  Add a autolayout subview by class;
 *
 *  @param targetClass target widget's class
 *
 *  @return widget generated and added.
 */
-(id)q_addAutolayoutSubviewByClass:(id)targetClass;

/**
 *  add autolayout constraint to me.
 *
 *  @param text  VFL text
 *  @param views views involed
 *
 *  @return added constraints
 */
-(NSArray*) q_addConstraintsByText:(NSString*)text
                  involvedViews:(NSDictionary*)views;

/**
 *  Stay shaped when there is less space than needed.
 *
 *  @param priority     priority to stay original shape
 *  @param isHorizontal is for horizontal orientation
 */
-(void)q_stayShapedWhenCompressedWithPriority:(UILayoutPriority)priority
                                  isHorizontal:(BOOL)isHorizontal;

/**
 *  Stay shaped when there are more space than needed.
 *
 *  @param priority     priority to stay original shape
 *  @param isHorizontal is for horizontal orientation
 */
-(void)q_stayShapedWhenStretchedWithPriority:(UILayoutPriority)priority
                                 isHorizontal:(BOOL)isHorizontal;

/**
 *  Set send's width equal to another view's attribute
 *
 *  @param aView      target view
 *  @param attribute  equal attribution
 *  @param multiplier multiplier value
 */
-(void)q_equalWidthToView:(UIView*)aView
       forLayoutAttribute:(NSLayoutAttribute)attribute
               multiplier:(CGFloat)multiplier;

/**
 *  Set send's height equal to another view's attribute
 *
 *  @param aView      target view
 *  @param attribute  equal attribution
 *  @param multiplier multiplier value
 */
-(void)q_equalHeightToView:(UIView*)aView
        forLayoutAttribute:(NSLayoutAttribute)attribute
                multiplier:(CGFloat)multiplier;


/**
 *  Add a constraint to hide self.
 *  Note: The result constraint will be low priority, and 
 *  clipsToBounds property of the view will be set to YES.
 *
 *  @return constraint added.
 */
-(NSLayoutConstraint*)q_addHideConstraintHorizontally;

/**
 *  Add a constraint to hide self.
 *  Note: The result constraint will be low priority, and
 *  clipsToBounds property of the view will be set to YES.
 *
 *  @return constraint added.
 */
-(NSLayoutConstraint*)q_addHideConstraintVertically;
@end

//
//  UIScrollView+constraint.h
//  QuickVFL
//
//  Created by Sou Dai on 16/9/21.
//  Copyright © 2016 Sou Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QScrollOrientationVertical = 0,
    QScrollOrientationHorizontal,
} QScrollOrientation;

@interface UIScrollView(constraint)
/**
 *  Prepare the content view for scroll view.
 *
 *  @param orientation the orientation for future use
 *
 *  @return prepared content view
 */
-(UIView*)q_prepareAutolayoutContentViewForOrientation:(QScrollOrientation)orientation;

/**
 *  Refresh the content view.
 *  Make sure the height of the content view is determined before calling this.
 *
 *  Note: Used for vertically scroll.
 *
 *  Should be used when the content view height is determined.
 */
-(void)q_refreshContentViewHeight;

/**
 *  Refresh the content view.
 *  Make sure the height of the content view is determined before calling this.
 *
 *  Note: Used for horizontally scroll.
 *
 *  Should be used when the content view width is determined.
 */
-(void)q_refreshContentViewWidth;
@end

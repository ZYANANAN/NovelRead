//
//  UIView+Constraint.h
//  WifiPlus_iOS
//
//  Created by abraham on 9/18/14.
//  Copyright (c) 2014 carlosk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Constraint)

//constraints to super view
- (void)setConstraintLeading:(CGFloat)height;
- (void)setConstraintTrail:(CGFloat)height;
- (void)setConstraintTop:(CGFloat)height;
- (void)setConstraintBottom:(CGFloat)height;
- (void)setConstraintTop:(CGFloat)top leading:(CGFloat)leading trail:(CGFloat)trail;
- (void)setConstraintTop:(CGFloat)top leading:(CGFloat)leading trail:(CGFloat)trail bottom:(CGFloat)bottom;
- (void)setConstraintCenter;

//constraints to self
- (void)setConstraintHeight:(CGFloat)height;
- (void)setConstraintWidth:(CGFloat)width;


#pragma mark - Deprecated
- (void)addConstraintY:(CGFloat)y superView:(UIView *)superView;
@end

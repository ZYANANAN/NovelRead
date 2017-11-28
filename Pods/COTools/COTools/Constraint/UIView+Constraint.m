//
//  UIView+Constraint.m
//  WifiPlus_iOS
//
//  Created by abraham on 9/18/14.
//  Copyright (c) 2014 carlosk. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

#pragma mark - constraints to super view
- (void)setConstraintLeading:(CGFloat)leading {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (constraints.count) {
        //清除工作
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (!(theConstraint.firstItem && theConstraint.secondItem)) {
                continue;
            }
            NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
            if ([items containsObject:self] && [items containsObject:superView]) {
                if (theConstraint.firstAttribute == NSLayoutAttributeLeading && theConstraint.secondAttribute == NSLayoutAttributeLeading) {
                    [superView removeConstraint:theConstraint];
                    break;
                }
            }
        }
    }
    
    //加constraint
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-y-[self]" options:0 metrics:@{@"y":@(leading)} views:@{@"self":self}];
    [superView addConstraints:newConstraints];
}
- (void)setConstraintTrail:(CGFloat)trail {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (constraints.count) {
        //清除工作
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (!(theConstraint.firstItem && theConstraint.secondItem)) {
                continue;
            }
            NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
            if ([items containsObject:self] && [items containsObject:superView]) {
                if (theConstraint.firstAttribute == NSLayoutAttributeTrailing && theConstraint.secondAttribute == NSLayoutAttributeTrailing) {
                    [superView removeConstraint:theConstraint];
                    break;
                }
            }
        }
    }
    
    //加constraint
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[self]-y-|" options:0 metrics:@{@"y":@(trail)} views:@{@"self":self}];
    [superView addConstraints:newConstraints];
    
}
- (void)setConstraintTop:(CGFloat)top {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (constraints.count) {
        //清除工作
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (!(theConstraint.firstItem && theConstraint.secondItem)) {
                continue;
            }
            NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
            if ([items containsObject:self] && [items containsObject:superView]) {
                if (theConstraint.firstAttribute == NSLayoutAttributeTop && theConstraint.secondAttribute == NSLayoutAttributeTop) {
                    [superView removeConstraint:theConstraint];
                    break;
                }
            }
        }
    }
    //加constraint
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[self]" options:0 metrics:@{@"y":@(top)} views:@{@"self":self}];
    [superView addConstraints:newConstraints];
}
- (void)setConstraintBottom:(CGFloat)bottom {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (constraints.count) {
        //清除工作
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (!(theConstraint.firstItem && theConstraint.secondItem)) {
                continue;
            }
            NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
            if ([items containsObject:self] && [items containsObject:superView]) {
                if (theConstraint.firstAttribute == NSLayoutAttributeBottom && theConstraint.secondAttribute == NSLayoutAttributeBottom) {
                    [superView removeConstraint:theConstraint];
                    break;
                }
            }
        }
    }
    
    //加constraint
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self]-y-|" options:0 metrics:@{@"y":@(bottom)} views:@{@"self":self}];
    [superView addConstraints:newConstraints];
}

- (void)setConstraintTop:(CGFloat)top leading:(CGFloat)leading trail:(CGFloat)trail {
    [self setConstraintTop:top];
    [self setConstraintLeading:leading];
    [self setConstraintTrail:trail];
}

- (void)setConstraintTop:(CGFloat)top leading:(CGFloat)leading trail:(CGFloat)trail bottom:(CGFloat)bottom {
    [self setConstraintTop:top];
    [self setConstraintLeading:leading];
    [self setConstraintTrail:trail];
    [self setConstraintBottom:bottom];
}

- (void)setConstraintCenter {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (constraints.count) {
        //清除工作
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (!(theConstraint.firstItem && theConstraint.secondItem)) {
                continue;
            }
            NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
            if ([items containsObject:self] && [items containsObject:superView]) {
                if (theConstraint.firstAttribute == NSLayoutAttributeTop && theConstraint.secondAttribute == NSLayoutAttributeTop) {
                    [superView removeConstraint:theConstraint];
                    break;
                }
            }
        }
    }
    //加constraint
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [superView addConstraints:@[constraint1,constraint2]];
}
#pragma mark - constraints to self
- (void)setConstraintHeight:(CGFloat)height {
    NSArray *constraints = self.constraints;
    if (constraints.count) {
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (theConstraint.firstItem == self && theConstraint.firstAttribute == NSLayoutAttributeHeight) {
                [self removeConstraint:theConstraint];
                
            }
        }

    }
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]" options:0 metrics:@{@"height":@(height)} views:@{@"self":self}];
    [self addConstraints:newConstraints];
}

- (void)setConstraintWidth:(CGFloat)width {
    NSArray *constraints = self.constraints;
    if (constraints.count) {
        for (NSLayoutConstraint *theConstraint in constraints) {
            if (theConstraint.firstItem == self && theConstraint.firstAttribute == NSLayoutAttributeWidth) {
                [self removeConstraint:theConstraint];
                
            }
        }
    }
    NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[self(width)]" options:0 metrics:@{@"width":@(width)} views:@{@"self":self}];
    [self addConstraints:newConstraints];
}

#pragma mark - Deprecated
- (void)addConstraintY:(CGFloat)y superView:(UIView *)superView {
    if (self.superview != superView) {
        return;
    }
    NSArray *constraints = superView.constraints;
    if (!constraints.count) {
        return;
    }
    for (NSLayoutConstraint *theConstraint in constraints) {
        NSArray *items = @[theConstraint.firstItem,theConstraint.secondItem];
        if ([items containsObject:self] && [items containsObject:superView]) {
            if (theConstraint.firstAttribute == NSLayoutAttributeTop && theConstraint.secondAttribute == NSLayoutAttributeTop) {
                [superView removeConstraint:theConstraint];
                NSArray *newConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-y-[self]" options:0 metrics:@{@"y":@(y)} views:@{@"self":self}];
                [superView addConstraints:newConstraints];
                break;
            }
        }
    }
}

@end

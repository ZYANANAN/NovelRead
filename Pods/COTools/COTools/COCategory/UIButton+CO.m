//
//  UIButton+CO.m
//  MyFamework
//
//  Created by carlos on 13-9-7.
//  Copyright (c) 2013年 carlos. All rights reserved.
//

#import "UIButton+CO.h"
#import "UIView+CO.h"
#import "UIImage+CO.h"
#import "UIColor+CO.h"

@implementation UIButton (CO)

//添加按键事件
-(void)coAddOnClickEven:(SEL )selector withTarget:(id)target{
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitle:(NSString  *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setBgImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}
- (void)setBgNormalImage:(UIImage *)image withPressImage:(UIImage *)image1{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image1 forState:UIControlStateHighlighted];
}
- (void)setImage:(UIImage  *)image{
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setNormalImage:(UIImage *)image withPressImage:(UIImage *)image1{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image1 forState:UIControlStateHighlighted];
}

- (void)setBtnStyleWhite {
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] size:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1] size:self.size] forState:UIControlStateHighlighted];
}

- (void)setBtnTilteStyleGray {
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1] forState:UIControlStateHighlighted];
}

- (void)setBtnStyleBlue {
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:15.0/255.0 green:198.0/255.0 blue:220.0/255.0 alpha:1] size:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:13.0/255.0 green:158.0/255.0 blue:176.0/255.0 alpha:1] size:self.size] forState:UIControlStateHighlighted];
}

- (void)setBtnStyleOrange {
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246.0/255.0 green:104.0/255.0 blue:28.0/255.0 alpha:1] size:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:159.0/255.0 green:67.0/255.0 blue:18.0/255.0 alpha:1] size:self.size] forState:UIControlStateHighlighted];
}

- (void)setBtnTitltStyleOrange {
    self.clipsToBounds = YES;
    [self setTitleColor:[UIColor colorWithRGBHex:0xf6681c] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRGBHex:0xf6681c] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setBtnNormalColor:(UIColor *)normalColor withHighlightColor:(UIColor *)highlightColor {
    [self setBackgroundImage:[UIImage imageWithColor:normalColor size:self.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightColor size:self.size] forState:UIControlStateHighlighted];
}
@end

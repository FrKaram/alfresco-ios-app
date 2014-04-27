//
//  UIColor+Custom.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 16/01/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)mainMenuBackgroundColor
{
    return [UIColor colorWithRed:(CGFloat)53.0/255.0 green:(CGFloat)53.0/255.0 blue:(CGFloat)55.0/255.0 alpha:1.0];
}

+ (UIColor *)mainMenuLabelColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)appTintColor
{
    return [UIColor colorWithRed:(CGFloat)56.0/255.0 green:(CGFloat)170.0/255.0 blue:(CGFloat)218.0/255.0 alpha:1.0];
}

+ (UIColor *)textDefaultColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)textHighlightColor
{
    return [UIColor blackColor];
}

+ (UIColor *)documentActionsTintColor
{
    return [UIColor colorWithRed:(CGFloat)53.0/255.0 green:(CGFloat)53.0/255.0 blue:(CGFloat)55.0/255.0 alpha:1.0];
}

+ (UIColor *)syncButtonFailedColor
{
    // Matches status-sync-failed.png
    return [UIColor colorWithRed:0.82 green:0.32 blue:0.34 alpha:1.0];
}

+ (UIColor *)borderGreyColor
{
    return [UIColor colorWithRed:(CGFloat)212.0/255.0 green:(CGFloat)212.0/255.0 blue:212.0/255.0 alpha:1.0f];
}

+ (UIColor *)systemNoticeInformationColor
{
    return [UIColor colorWithRed:(CGFloat)56.0/255.0 green:(CGFloat)170.0/255.0 blue:(CGFloat)218.0/255.0 alpha:1.0];
}

+ (UIColor *)systemNoticeErrorColor
{
    return [UIColor colorWithRed:(CGFloat)220.0/255.0 green:0 blue:0 alpha:1.0];
}
+ (UIColor *)systemNoticeWarningColor
{
    return [UIColor yellowColor];
}

+ (UIColor *)taskPriorityHighColor
{
    return [UIColor redColor];
}

+ (UIColor *)taskPriorityMediumColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)taskPriorityLowColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)taskOverdueColor
{
    return [UIColor redColor];
}

@end

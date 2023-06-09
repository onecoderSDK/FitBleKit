/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolColor.h
 * Function : PYToolColor
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import <UIKit/UIKit.h>

@interface PYToolColor : UIColor

// Single class
+ (PYToolColor *)selfAlloc;

// Hex string to color
- (UIColor *)hexColor:(NSString *)colorString;

@end

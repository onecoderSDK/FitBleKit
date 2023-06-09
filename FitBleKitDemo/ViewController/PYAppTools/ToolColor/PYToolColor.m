/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolColor.m
 * Function : PYToolColor
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import "PYToolColor.h"

PYToolColor *g_toolColor = nil;

@implementation PYToolColor

#pragma mark - ***************************** System ******************************
/*-*******************************************************************************
* Method: selfAlloc
* Description: Single class
* Parameter:
* Return Data:
*********************************************************************************/
+ (PYToolColor *)selfAlloc {
    if (g_toolColor == nil) {
        g_toolColor = [[PYToolColor alloc] init];
    }
    return g_toolColor;
}


#pragma mark - ***************************** Contents ****************************
/*-*******************************************************************************
 * Method: hexColor
 * Description: Hex string to color
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (UIColor *)hexColor:(NSString *)colorString {
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 8){
        return [UIColor blackColor];
    }
    
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 8) {
        return [UIColor blackColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *aString = [cString substringWithRange:range];
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (a > 100) { a = 100; }
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 100.0f)];
}


@end

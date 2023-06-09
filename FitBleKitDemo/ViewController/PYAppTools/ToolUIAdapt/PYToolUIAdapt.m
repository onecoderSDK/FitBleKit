/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolUIAdapt.m
 * Function : PYToolUIAdapt
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import "PYToolUIAdapt.h"

PYToolUIAdapt *g_toolUIAdapt = nil;

@implementation PYToolUIAdapt

#pragma mark - ***************************** System ******************************
/*-*******************************************************************************
* Method: selfAlloc
* Description: Single class
* Parameter:
* Return Data:
*********************************************************************************/
+ (PYToolUIAdapt *)selfAlloc {
    if (g_toolUIAdapt == nil) {
        g_toolUIAdapt = [[PYToolUIAdapt alloc] init];
    }
    return g_toolUIAdapt;
}


#pragma mark - ***************************** Contents ****************************
/*-*******************************************************************************
 * Method: adaptScreen
 * Description: Adapt iphone screen
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (CGRect)adaptScreen:(CGRect)viewFrame {
    CGRect realFrame = CGRectMake(viewFrame.origin.x*PY_SCREEN_RATE, viewFrame.origin.y*PY_SCREEN_RATE, viewFrame.size.width*PY_SCREEN_RATE, viewFrame.size.height*PY_SCREEN_RATE);
    return realFrame;
}


/*-*******************************************************************************
 * Method: getViewWidth
 * Description: get View Width
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (CGFloat)getViewWidth:(NSString *)viewString withFont:(UIFont *)font andHeight:(CGFloat)height {
    CGSize startSize = CGSizeMake(1000, height);
    CGRect resultSize = [viewString boundingRectWithSize:startSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return resultSize.size.width;
}


/*-*******************************************************************************
 * Method: setViewBorderWith
 * Description: Set view border and radian
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (void)setViewBorderWith:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    view.layer.cornerRadius = cornerRadius*PY_SCREEN_RATE;  //圆弧半径
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.layer.masksToBounds = YES;
}


/*-*******************************************************************************
* Method: isNotchScreen
* Description: is Notch Screen
* Parameter:
* Return Data:
*********************************************************************************/
- (BOOL)isNotchScreen {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }

    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;
    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }
    
    return NO;
}


@end

/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolUIAdapt.h
 * Function : PYToolUIAdapt
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PY_BASE_WEIGHT      375.0
#define PY_SCREEN_RATE      ([UIScreen mainScreen].bounds.size.width / PY_BASE_WEIGHT)
#define PY_SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height / PY_SCREEN_RATE)
#define PY_ISIPHONE_XUP     (PY_SCREEN_HEIGHT >= 800 ? YES : NO)
#define PY_HEADER_HEIGHT    (PY_ISIPHONE_XUP ? 34.0/PY_SCREEN_RATE : 20.0)
#define PY_FOOTER_HEIGHT    (PY_ISIPHONE_XUP ? 34.0/PY_SCREEN_RATE : 0.0)
#define PY_APPHEADER_HEIGHT (44.0+PY_HEADER_HEIGHT)

@interface PYToolUIAdapt : NSObject

// Single class
+ (PYToolUIAdapt *)selfAlloc;

// Adapt iphone screen
- (CGRect)adaptScreen:(CGRect)viewFrame;

// get View Width
- (CGFloat)getViewWidth:(NSString *)viewString withFont:(UIFont *)font andHeight:(CGFloat)height;

// Set view border and radian
- (void)setViewBorderWith:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

// is Notch Screen
- (BOOL)isNotchScreen;

@end

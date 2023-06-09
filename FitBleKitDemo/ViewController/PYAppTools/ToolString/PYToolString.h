/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolString.h
 * Function : PYToolString
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define APP_LANGUAGE_KEY   @"AppLanguageKey"

@interface PYToolString : NSString

@property (strong, nonatomic) NSString *languageKey;

// Single class
+ (PYToolString *)selfAlloc;

- (NSString *)getDefaultLanguageKey;

// Local String
- (NSString *)localString:(NSString *)key;

// number font
- (UIFont *)numberFontOfSize:(CGFloat)font;

// number font
- (UIFont *)numberBoldFontOfSize:(CGFloat)font;

// New font
- (UIFont *)newFontOfSize:(CGFloat)font;

// New bold font
- (UIFont *)newBoldFontOfSize:(CGFloat)font;

// Line String
- (NSMutableAttributedString *)lineString:(NSString *)textString andColor:(UIColor *)textColor;

- (NSMutableAttributedString *)unitString:(NSString *)textString andUnit:(NSString *)unitString withBig:(CGFloat)bigFont andLow:(CGFloat)lowFont;

// Validate Email
- (BOOL)validateEmail:(NSString *)email;

// Validate mobile phone
- (BOOL)validateMobile:(NSString *)mobileNum;

// Is number string
- (BOOL)isNumberString:(NSString *)valueString;

- (NSString *)getPhoneType;

// Sha1 encoding
- (NSString *)sha1Encoding:(NSString *)valueString;

// Md5 encoding
- (NSString *)md5Encoding:(NSString *)valueString;

// Base64 encoding
- (NSString *)base64Encoding:(NSString *)valueString;

// Base64 decoding
- (NSString *)base64Decoding:(NSString *)valueString;

@end


/*-**********************************************************************************
 * Copyright: Shenzhen Onecoder Technology Co., Ltd
 * File Name: PYToolString.m
 * Function : PYToolString
 * Editor   : Pendy
 * Version  : 1.0.1
 * Date     : 2019.11.18
 ************************************************************************************/

#import "PYToolString.h"
#import "PYToolUIAdapt.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import "sys/utsname.h"

PYToolString *g_toolString = nil;

@implementation PYToolString


#pragma mark - ***************************** System ******************************
/*-*******************************************************************************
* Method: selfAlloc
* Description: Single class
* Parameter:
* Return Data:
*********************************************************************************/
+ (PYToolString *)selfAlloc {
    if (g_toolString == nil) {
        g_toolString = [[PYToolString alloc] init];
    }
    return g_toolString;
}


#pragma mark - ***************************** Contents ****************************
/*-*******************************************************************************
* Method: localString
* Description: Local String
* Parameter:
* Return Data:
*********************************************************************************/
- (NSString *)getDefaultLanguageKey {
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    NSString *systemkey = @"en";
    if([languageCode hasPrefix:@"zh-Hans"]) {
        systemkey = @"zh-Hans"; // 汉语
    }
    else if([languageCode hasPrefix:@"pt"]) {
        systemkey = @"pt-PT"; // 葡萄牙语
    }
    else if([languageCode hasPrefix:@"ru"]) {
        systemkey = @"ru"; // 俄语
    }
    else if([languageCode hasPrefix:@"ko"]) {
        systemkey = @"ko"; // 韩语
    }
    else if([languageCode hasPrefix:@"es"]) {
        systemkey = @"es"; // 西班牙语
    }
    else if([languageCode hasPrefix:@"ja"]) {
        systemkey = @"ja"; // 日语
    }
    else {
        systemkey = @"en"; // 英语
    }
    
    NSString *lanPath = [[NSBundle mainBundle] pathForResource:systemkey ofType:@"lproj"];
    if (lanPath == nil) {
        systemkey = @"en";
    }
    
    return systemkey;
}


/*-*******************************************************************************
* Method: localString
* Description: Local String
* Parameter:
* Return Data:
*********************************************************************************/
- (NSString *)localString:(NSString *)key {
    NSString *lanPath = [[NSBundle mainBundle] pathForResource:self.languageKey ofType:@"lproj"];
    if (lanPath == nil) {
        lanPath = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    
    NSString *valueString = [[NSBundle bundleWithPath:lanPath] localizedStringForKey:key value:@"" table:nil];
    if (valueString == nil) {
        valueString = @"";
    }
    return valueString;
    
//    return NSLocalizedString(key, nil);
}


/*-*******************************************************************************
 * Method: numberFontOfSize
 * Description: number font
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (UIFont *)numberFontOfSize:(CGFloat)font {
    return  [UIFont fontWithName:@"BarlowCondensed-Medium" size:font*PY_SCREEN_RATE];
}


/*-*******************************************************************************
 * Method: numberBoldFontOfSize
 * Description: number Bold font
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (UIFont *)numberBoldFontOfSize:(CGFloat)font {
    return  [UIFont fontWithName:@"BarlowCondensed-SemiBoldItalic" size:font*PY_SCREEN_RATE];
}


/*-*******************************************************************************
 * Method: newFontOfSize
 * Description: New font
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (UIFont *)newFontOfSize:(CGFloat)font {
    return  [UIFont systemFontOfSize:font*PY_SCREEN_RATE];
}


/*-*******************************************************************************
 * Method: newBoldFontOfSize
 * Description: New bold font
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (UIFont *)newBoldFontOfSize:(CGFloat)font {
    return  [UIFont boldSystemFontOfSize:font*PY_SCREEN_RATE];
}


/*-*******************************************************************************
 * Method: lineString
 * Description: Line String
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSMutableAttributedString *)lineString:(NSString *)textString andColor:(UIColor *)textColor {
    NSDictionary *attributes = @ {NSUnderlineStyleAttributeName:@1,NSForegroundColorAttributeName:textColor};
    if (textString == nil || textString.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"" attributes:attributes];
    }
    NSMutableAttributedString *valueString = [[NSMutableAttributedString alloc] initWithString:textString attributes:attributes];
    return valueString;
}


/*-*******************************************************************************
 * Method: unitString
 * Description: unitString
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSMutableAttributedString *)unitString:(NSString *)textString andUnit:(NSString *)unitString withBig:(CGFloat)bigFont andLow:(CGFloat)lowFont {
    NSDictionary *bigMap = @{NSFontAttributeName:[[PYToolString selfAlloc] numberFontOfSize:bigFont]};
    NSDictionary *lowMap = @{NSFontAttributeName:[[PYToolString selfAlloc] numberFontOfSize:lowFont]};
    if (textString == nil || textString.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"" attributes:lowMap];
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:textString attributes:bigMap];
    [attributeStr addAttributes:lowMap range:NSMakeRange([textString length]-[unitString length], [unitString length])];
    return attributeStr;
}


/*-*******************************************************************************
 * Method: validateEmail
 * Description: Validate Email
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/*-*******************************************************************************
 * Method: validateMobile
 * Description: Validate mobile phone
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (BOOL)validateMobile:(NSString *)mobileNum {
    NSString *phoneRegex = @"^(1[3-8])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];
}


/*-*******************************************************************************
 * Method: isNumberString
 * Description: Is number string
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (BOOL)isNumberString:(NSString *)valueString {
    NSString *dataString = [valueString stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataString];
    int val;
    return [scanner scanInt:&val] && [scanner isAtEnd];
}


/*-*******************************************************************************
* Method: validateMobile
* Description: Validate mobile phone
* Parameter:
* Return Data:
*********************************************************************************/
- (NSString *)getPhoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])  return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])  return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])  return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone6,2"])  return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])  return @"iPhone6 plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])  return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])  return @"iPhone6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])  return @"iPhone6S plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])  return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])  return @"iPhone 7 (CDMA)";
    if ([deviceString isEqualToString:@"iPhone9,3"])  return @"iPhone 7 (GSM)";
    if ([deviceString isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus (CDMA)";
    if ([deviceString isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus (GSM)";
    if ([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (Global/A1905)";
    if ([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus (A1864/A1898)";
    if ([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus (Global/A1897)";
    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X (A1865/A1902)";
    if ([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X (Global/A1901)";
    if ([deviceString isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"]) return @"iPhone SE (2nd generation)";
    if ([deviceString isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([deviceString isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([deviceString isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([deviceString isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    
    if ([deviceString isEqualToString:@"iPod1,1"])    return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])    return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])    return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])    return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])    return @"iPad 1G";
    if ([deviceString isEqualToString:@"iPad2,1"])    return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])    return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])    return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])    return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])    return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"])    return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"])    return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad3,1"])    return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])    return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])    return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])    return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])    return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])    return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])    return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])    return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])    return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"])    return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"])    return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"])    return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])    return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])    return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])    return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])    return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])    return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])    return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])    return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])    return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])    return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])   return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])   return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])    return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])    return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])    return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,5"])    return @"iPad 6th generation";
    if ([deviceString isEqualToString:@"iPad7,6"])    return @"iPad 6th generation";
    if ([deviceString isEqualToString:@"iPad8,1"])    return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,2"])    return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,3"])    return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,4"])    return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,5"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,6"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,7"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,8"])    return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([deviceString isEqualToString:@"iPad11,1"])   return @"iPad mini 5";
    if ([deviceString isEqualToString:@"iPad11,2"])   return @"iPad mini 5";
    if ([deviceString isEqualToString:@"iPad11,3"])   return @"iPad Air 3";
    if ([deviceString isEqualToString:@"iPad11,4"])   return @"iPad Air 3";
    if ([deviceString isEqualToString:@"iPad11,6"])   return @"iPad 8";
    if ([deviceString isEqualToString:@"iPad11,7"])   return @"iPad 8";
    if ([deviceString isEqualToString:@"iPad12,1"])   return @"iPad 9";
    if ([deviceString isEqualToString:@"iPad12,2"])   return @"iPad 9";
    if ([deviceString isEqualToString:@"iPad13,1"])   return @"iPad Air 4";
    if ([deviceString isEqualToString:@"iPad13,2"])   return @"iPad Air 4";
    if ([deviceString isEqualToString:@"iPad13,4"])   return @"iPad Pro 4 (11-inch) ";
    if ([deviceString isEqualToString:@"iPad13,5"])   return @"iPad Pro 4 (11-inch) ";
    if ([deviceString isEqualToString:@"iPad13,6"])   return @"iPad Pro 4 (11-inch) ";
    if ([deviceString isEqualToString:@"iPad13,7"])   return @"iPad Pro 4 (11-inch) ";
    if ([deviceString isEqualToString:@"iPad13,8"])   return @"iPad Pro 5 (12.9-inch) ";
    if ([deviceString isEqualToString:@"iPad13,9"])   return @"iPad Pro 5 (12.9-inch) ";
    if ([deviceString isEqualToString:@"iPad13,10"])  return @"iPad Pro 5 (12.9-inch) ";
    if ([deviceString isEqualToString:@"iPad13,11"])  return @"iPad Pro 5 (12.9-inch) ";
    if ([deviceString isEqualToString:@"iPad14,1"])   return @"iPad mini 6";
    if ([deviceString isEqualToString:@"iPad14,2"])   return @"iPad mini 6";
    
    if ([deviceString isEqualToString:@"i386"])       return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])     return @"Simulator";

    return deviceString;
}


/*-*******************************************************************************
 * Method: sha1Encoding
 * Description: Sha1 encoding
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSString *)sha1Encoding:(NSString *)valueString {
    const char *cstr = [valueString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:valueString.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}


/*-*******************************************************************************
 * Method: md5Encoding
 * Description: Md5 encoding
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSString *)md5Encoding:(NSString *)valueString {
    const char *cStr = [valueString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_LONG len = (CC_LONG)strlen(cStr);
    CC_MD5(cStr, len, digest);
    char md5string[CC_MD5_DIGEST_LENGTH*2+1];
    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        sprintf(md5string+i*2, "%02x", digest[i]);
    }
    md5string[CC_MD5_DIGEST_LENGTH*2] = 0;
    return [NSString stringWithCString:md5string encoding:NSASCIIStringEncoding];
}


/*-*******************************************************************************
 * Method: base64Encoding
 * Description: Base64 encoding
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSString *)base64Encoding:(NSString *)valueString {
    NSData *data = [valueString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}


/*-*******************************************************************************
 * Method: base64Decoding
 * Description: Base64 decoding
 * Parameter:
 * Return Data:
 *********************************************************************************/
- (NSString *)base64Decoding:(NSString *)valueString {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:valueString options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}


@end

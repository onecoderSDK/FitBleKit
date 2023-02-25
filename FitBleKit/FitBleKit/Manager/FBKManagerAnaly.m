/********************************************************************************
 * 文件名称：FBKManagerAnaly.h
 * 内容摘要：设备公共解析
 * 版本编号：1.0.1
 * 创建日期：2020年12月28日
 *******************************************************************************/

#import "FBKManagerAnaly.h"
#import "FBKSpliceBle.h"

@implementation FBKManagerAnaly


/*-********************************************************************************
* Method: analyMacVersion
* Description: analyMacVersion
* Parameter:
* Return Data:
***********************************************************************************/
- (NSDictionary *)analyMacVersion:(NSData *)byteData {
    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
    
    const uint8_t *bytes = [byteData bytes];
    int firstNum = bytes[0]&0xFF;
    if (firstNum == 210) {
        int keyMark = bytes[2]&0xFF;
        if (keyMark == 128) {
            NSMutableString *macString = [[NSMutableString alloc] init];
            NSMutableString *OTAMacString = [[NSMutableString alloc] init];
            if (byteData.length >= 10) {
                for (int i = 4; i < 10; i++) {
                    int byteNumber = bytes[i]&0xFF;
                    NSString *mac = [FBKSpliceBle decimalToHex:byteNumber];
                    if (mac.length == 1) {
                        mac = [NSString stringWithFormat:@"0%@",mac];
                    }
                    
                    if (i == 9) {
                        [macString appendString:mac];
                        
                        if (byteNumber == 255) {
                            byteNumber = 0;
                        }
                        else {
                            byteNumber = byteNumber+1;
                        }
                        
                        NSString *macOta = [FBKSpliceBle decimalToHex:byteNumber];
                        if (macOta.length == 1) {
                            macOta = [NSString stringWithFormat:@"0%@",macOta];
                        }
                        [OTAMacString appendString:macOta];
                    }
                    else {
                        [macString appendString:mac];
                        [OTAMacString appendString:mac];
                    }
                }
            }
            
            [resultMap setObject:@"0" forKey:@"key"];
            [resultMap setObject:[macString uppercaseString] forKey:@"macString"];
            [resultMap setObject:[OTAMacString uppercaseString] forKey:@"OTAMacString"];
        }
        else if (keyMark == 129) {
            if (byteData.length >= 12) {
                int offset = 4;
                [resultMap setObject:@"1" forKey:@"key"];
                for (int i = 0; i < 3; i++) {
                    int ver1 = bytes[offset+i*3+0]&0xFF;
                    int ver2 = bytes[offset+i*3+1]&0xFF;
                    int ver3 = bytes[offset+i*3+2]&0xFF;
                    NSString *versionString = [NSString stringWithFormat:@"V%i.%i.%i",ver1,ver2,ver3];
                    if (i == 0) {
                        [resultMap setObject:versionString forKey:@"hardwareVersion"];
                    }
                    else if (i == 1) {
                        [resultMap setObject:versionString forKey:@"firmwareVersion"];
                    }
                    else if (i == 2) {
                        [resultMap setObject:versionString forKey:@"softwareVersion"];
                    }
                }
            }
        }
        else if (keyMark == 130) {
            if (byteData.length >= 5) {
                [resultMap setObject:@"2" forKey:@"key"];
                NSMutableString *resultString = [[NSMutableString alloc] init];
                for (int i = 3; i < byteData.length-1; i++) {
                    NSString *byteString = [NSString stringWithFormat:@"%C",bytes[i]];
                    [resultString appendString:byteString];
                }
                [resultMap setObject:resultString forKey:@"customerName"];
            }
        }
    }
    
    return resultMap;
}


@end

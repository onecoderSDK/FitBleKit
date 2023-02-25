/********************************************************************************
 * 文件名称：FBKPowerAnaly.m
 * 内容摘要：功率计蓝牙解析
 * 版本编号：1.0.1
 * 创建日期：2021年01月04日
 ********************************************************************************/

#import "FBKPowerAnaly.h"
#import "FBKDateFormat.h"


@implementation FBKPowerAnaly {
    int m_zeroCheckNumber;
    NSMutableArray *m_zeroArray;
    BOOL m_isSpliceData;
}


/********************************************************************************
 * 方法名称：init
 * 功能描述：init
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (instancetype)init {
    self = [super init];
    if (self) {
        m_zeroCheckNumber = 0;
        m_zeroArray = [[NSMutableArray alloc] init];
        m_isSpliceData = false;
    }
    return self;
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙实时数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveRealTimeData:(NSString *)hexString {
    int length = (int)hexString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[hexString length]; i++) {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    
    if (length >= 8) {
        int firstNum = bytes[0]&0xFF;
        int secondNum = bytes[1]&0xFF;
        if (firstNum == 32 && secondNum == 8) {
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
            NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
            
            int powerLow = bytes[2]&0xFF;
            int powerHi = bytes[3]&0xFF;
            int powerNum = powerLow + (powerHi<<8);
            [resultDic setObject:[NSString stringWithFormat:@"%i",powerNum] forKey:@"power1"];
            [resultDic setObject:[NSString stringWithFormat:@"%i",powerNum] forKey:@"power"];
            if (m_isSpliceData) {
                [resultDic setObject:[NSString stringWithFormat:@"%.0f",round((double)powerNum*1025.0/1471.0)] forKey:@"power"];
            }
            
            int c1 = bytes[4]&0xFF;
            int c2 = bytes[5]&0xFF;
            NSString *taNum = [NSString stringWithFormat:@"%d",(c2<<8)+c1];
            [resultDic setObject:taNum forKey:@"cadenceCount"];
            
            int c3 = bytes[6]&0xFF;
            int c4 = bytes[7]&0xFF;
            NSString *taTime = [NSString stringWithFormat:@"%d",(c4<<8)+c3];
            [resultDic setObject:taTime forKey:@"cadenceTime"];
            
            [resultDic setObject:nowTime forKey:@"createTime"];
            [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
            
            [self.delegate analyticalResult:resultDic withResultNumber:PowerResultRealTime];
        }
    }
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙回复的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBlueData:(NSString *)hexString {
    int length = (int)hexString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[hexString length]; i++) {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    
    if (length >= 3) {
        int firstNum = bytes[0]&0xFF;
        int keyNum = bytes[1]&0xFF;
        int resultNum = bytes[2]&0xFF;
        
        if (firstNum == 32 && keyNum == 12) {
            NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
            [resultMap setObject:@"0" forKey:@"status"];
            [resultMap setObject:@"0" forKey:@"value"];
            
            if (resultNum == 4) {
                [resultMap setObject:@"0" forKey:@"status"];
                [resultMap setObject:@"0" forKey:@"value"];
            }
            else if (resultNum == 1) {
                if (length >= 5) {
                    int checkLow = bytes[3]&0xFF;
                    int checkHi = bytes[4]&0xFF;
                    int value = checkLow + (checkHi<<8);
                    [resultMap setObject:@"1" forKey:@"status"];
                    [resultMap setObject:[NSString stringWithFormat:@"%i",value] forKey:@"value"];
                }
            }
            
            [self.delegate analyticalResult:resultMap withResultNumber:PowerResultCalibration];
        }
    }
}


/********************************************************************************
 * 方法名称：receiveBlueData
 * 功能描述：获取到蓝牙实时数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveZeroData:(NSString *)hexString {
    int length = (int)hexString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[hexString length]; i++) {
        int int_ch;
        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48);
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55;
        else
            int_ch2 = hex_char2-87;
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        j++;
    }
    
    if (length >= 7) {
        int firstNum = bytes[0]&0xFF;
        int keyNum = bytes[2]&0xFF;
        if (firstNum == 219 && keyNum == 3) {
            int calHi = bytes[3]&0xFF;
            int calLow = bytes[4]&0xFF;
            int calNum = calLow + (calHi<<8);
            
            int zeroHi = bytes[5]&0xFF;
            int zeroLow = bytes[6]&0xFF;
            int zeroNum = zeroLow + (zeroHi<<8);
            
            if (calNum == 0 && zeroNum == 0) {
                m_isSpliceData = true;
            }
        }
    }
}


@end

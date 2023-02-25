/********************************************************************************
 * 文件名称：FBKSpliceBle.h
 * 内容摘要：蓝牙数据拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月09日
 ********************************************************************************/

#import "FBKSpliceBle.h"

@implementation FBKSpliceBle

/********************************************************************************
 * 方法名称：decimalToHex
 * 功能描述：十进制转化为十六进制
 * 输入参数：decimalNum - 十进制数据
 * 返回数据：
 ********************************************************************************/
+ (NSString *)decimalToHex:(int)decimalNum
{
    if (decimalNum < 0)
    {
        char resultNum = (char)(decimalNum);
        decimalNum = resultNum&0xFF;
    }
    
    NSString *decimalValue;
    NSString *hexString = @"";
    int decimalList;
    
    for (int i = 0; i < 9; i++)
    {
        decimalList = decimalNum%16;
        decimalNum  = decimalNum/16;
        
        switch (decimalList)
        {
            case 10:
                decimalValue = @"a"; break;
            case 11:
                decimalValue = @"b"; break;
            case 12:
                decimalValue = @"c"; break;
            case 13:
                decimalValue = @"d"; break;
            case 14:
                decimalValue = @"e"; break;
            case 15:
                decimalValue = @"f"; break;
            default:
                decimalValue = [NSString stringWithFormat:@"%i",decimalList];
        }
        
        hexString = [decimalValue stringByAppendingString:hexString];
        
        if (decimalNum == 0)
        {
            break;
        }
    }
    
    if (hexString.length == 1)
    {
        hexString = [NSString stringWithFormat:@"0%@",hexString];
    }
    
    return hexString;
}


/********************************************************************************
 * 方法名称：getHexData
 * 功能描述：十进制拼接的字符
 * 输入参数：dataDic - 数据   isCheck - 是否需要校验和
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getHexData:(NSDictionary *)dataDic haveCheckNum:(BOOL)isCheck
{
    NSMutableString *dataString = [[NSMutableString alloc] initWithString:@""];
    int length = (int)dataDic.allKeys.count;
    
    if (isCheck)
    {
        int allNum = 0;
        
        for (int i = 0; i < length-1; i++)
        {
            NSString *key = [NSString stringWithFormat:@"byte%i",i];
            int num = [[dataDic objectForKey:key] intValue];
            allNum = allNum + num;
            NSString *decimalString = [self decimalToHex:num];
            
            if (decimalString.length == 1)
            {
                decimalString = [NSString stringWithFormat:@"0%@",decimalString];
            }
            
            [dataString appendString:decimalString];
        }
        
        int endNum = allNum % 256;
        NSString *checkNum = [self decimalToHex:endNum];
        
        if (checkNum.length == 1)
        {
            checkNum = [NSString stringWithFormat:@"0%@",checkNum];
        }
        
        [dataString appendString:checkNum];
    }
    else
    {
        for (int i = 0; i < length; i++)
        {
            NSString *key = [NSString stringWithFormat:@"byte%i",i];
            int num = [[dataDic objectForKey:key] intValue];
            NSString *decimalString = [self decimalToHex:num];
            
            if (decimalString.length == 1)
            {
                decimalString = [NSString stringWithFormat:@"0%@",decimalString];
            }
            
            [dataString appendString:decimalString];
        }
    }
    
    return dataString;
}


/********************************************************************************
 * 方法名称：getCheckNumber
 * 功能描述：获取校验和
 * 输入参数：myString - 16进制数据
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getCheckNumber:(NSString *)cmdString
{
    int j = 0;
    Byte bytes[20];
    
    for(int i = 0; i<[cmdString length]; i++)
    {
        int int_ch;
        unichar hex_char1 = [cmdString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [cmdString characterAtIndex:i];
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
    
    int byteLong = (int)cmdString.length/2;
    int checkNumber = 0;
    
    for (int i = 0; i < byteLong; i++)
    {
        int value = bytes[i]&0xFF;
        checkNumber = checkNumber + value;
    }
    
    checkNumber = checkNumber % 256;
    NSString *resultString = [NSString stringWithFormat:@"%@%@",cmdString,[self decimalToHex:checkNumber]];
    
    return resultString;
}

/********************************************************************************
 * 方法名称：getWriteData
 * 功能描述：获取写入命令的原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSData *)getWriteData:(NSString *)cmdString
{
    int length = (int)cmdString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[cmdString length]; i++)
    {
        int int_ch;
        unichar hex_char1 = [cmdString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [cmdString characterAtIndex:i];
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
    
    NSData *myda = [[NSData alloc] initWithBytes:bytes length:length];
    
    return myda;
}


/********************************************************************************
 * 方法名称：bleDataToString
 * 功能描述：蓝牙数据转String
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)bleDataToString:(NSData *)cmdData {
    const uint8_t *bytes = [cmdData bytes];
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < cmdData.length; i++) {
        int value = bytes[i]&0xFF;
        NSString *valueString = [self decimalToHex:value];
        [resultString appendString:valueString];
    }
    return resultString;
}


/********************************************************************************
 * 方法名称：getBitNumber
 * 功能描述：获取数据bit字节数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (int)getBitNumber:(int)dataNumber andStart:(int)start withStop:(int)stop
{
    if(start < 0 || start > 7)
    {
        return 0;
    }
    
    if(stop < 0 || stop > 7)
    {
        return 0;
    }
    
    if(start > stop)
    {
        return 0;
    }
    
    int resultNumber = (dataNumber & (0xFF >> (7 - stop))) >> start;
    
    return resultNumber;
}


+ (long)getSignedData:(long)valueNumber andCount:(int)count {
    long resultNumber = valueNumber;
    long maxNumber = 0;
    for (int i = 0; i < count; i++) {
        int myByte = 255;
        if (i == 0) {
            maxNumber = maxNumber + myByte;
        }
        else if (i == 1) {
            maxNumber = maxNumber + (myByte<<8);
        }
        else if (i == 2) {
            maxNumber = maxNumber + (myByte<<16);
        }
        else if (i == 3) {
            maxNumber = maxNumber + (myByte<<24);
        }
    }
    
    long middleNumber = 0;
    if (maxNumber != 0) {
        middleNumber = maxNumber / 2;
    }
    
    if (resultNumber > middleNumber) {
        resultNumber = resultNumber - maxNumber - 1;
    }
    
    return resultNumber;
}


/********************************************************************************
 * 方法名称：utf8ToUnicode
 * 功能描述：UTF-8转换成Unicode编码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0')
        {
            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
            int asiNum = [str characterAtIndex:0];
            NSString *result = [NSMutableString stringWithFormat:@"00%@",[self decimalToHex:asiNum]];
            [s appendFormat:@"%@",result];
        }
        else if(_char >= 'a' && _char <= 'z')
        {
            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
            int asiNum = [str characterAtIndex:0];
            NSString *result = [NSMutableString stringWithFormat:@"00%@",[self decimalToHex:asiNum]];
            [s appendFormat:@"%@",result];
        }
        else if(_char >= 'A' && _char <= 'Z')
        {
            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
            int asiNum = [str characterAtIndex:0];
            NSString *result = [NSMutableString stringWithFormat:@"00%@",[self decimalToHex:asiNum]];
            [s appendFormat:@"%@",result];
        }
        else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    
    return s;
}


/********************************************************************************
 * 方法名称：getMacAddress
 * 功能描述：获取MAC地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)getMacAddress:(NSString *)infoString
{
    NSString *resultString = [[NSString alloc] init];
    resultString = @"";
    
    NSString *dataString = infoString;
    if (dataString.length >= 12)
    {
        dataString = [[dataString substringFromIndex:dataString.length-12] substringToIndex:12];
        
        NSMutableString *myString = [[NSMutableString alloc] init];
        for (int i = 0; i < dataString.length/2; i++)
        {
            if (i == dataString.length/2-1)
            {
                NSString *str = [[dataString substringFromIndex:i*2] substringToIndex:2];
                [myString appendString:str];
            }
            else
            {
                NSString *str = [[dataString substringFromIndex:i*2] substringToIndex:2];
                [myString appendString:str];
                [myString appendString:@":"];
            }
        }
        
        return myString;
    }
    
    return resultString;
}


/********************************************************************************
 * 方法名称：stringToAscii
 * 功能描述：字符转换成Ascii编码
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)stringToAscii:(NSString *)string
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < string.length; i++)
    {
        int asciiCode = [string characterAtIndex:i];
        NSString *codeString = [self decimalToHex:asciiCode];
        [resultString appendString:codeString];
    }
    
    return resultString;
}


/********************************************************************************
 * 方法名称：analyticalDeviceId
 * 功能描述：解析设备ID数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)analyticalDeviceId:(NSData *)byteData
{
    const uint8_t *resultBytes = [byteData bytes];
    
    if (byteData.length >= 6)
    {
        long int b2 = resultBytes[2]&0xFF;
        long int b3 = resultBytes[3]&0xFF;
        long int b4 = resultBytes[4]&0xFF;
        long int b5 = resultBytes[5]&0xFF;
        NSString *idNumber = [NSString stringWithFormat:@"%ld",b5+(b4<<8)+(b3<<16)+(b2<<24)];
        return idNumber;
    }
    
    return @"";
}


/********************************************************************************
 * 方法名称：encryptionString
 * 功能描述：加密
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (NSString *)encryptionString:(NSString *)cmdString withKey:(int)key {
    int length = (int)cmdString.length/2;
    
    int j = 0;
    Byte bytes[length];
    
    for(int i = 0; i<[cmdString length]; i++) {
        int int_ch;
        unichar hex_char1 = [cmdString characterAtIndex:i];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16;
        else
            int_ch1 = (hex_char1-87)*16;
        i++;
        
        unichar hex_char2 = [cmdString characterAtIndex:i];
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
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < length; i++) {
        int value = bytes[i];
//        if (i!=0) {
//            value = value^key;
//        }
        value = value^key;
        [resultString appendString:[self decimalToHex:value]];
    }
    
    return resultString;
}


/********************************************************************************
 * 方法名称：compareUuid
 * 功能描述：compareUuid
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
+ (BOOL)compareUuid:(CBUUID *)bleUuid withUuid:(NSString *)uuidString {
    if ([bleUuid isEqual:[CBUUID UUIDWithString:uuidString]]) {
        return true;
    }
    
    NSString *bleUuidString = bleUuid.UUIDString;
    if (bleUuidString.length > 8) {
        bleUuidString = [[bleUuidString substringFromIndex:4] substringToIndex:4];
        bleUuidString = bleUuidString.uppercaseString;
    }
    
    if ([bleUuidString isEqualToString:uuidString.uppercaseString]) {
        return true;
    }
    
    return false;
}


@end


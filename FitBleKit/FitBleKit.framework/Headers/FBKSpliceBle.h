/********************************************************************************
 * 文件名称：FBKSpliceBle.h
 * 内容摘要：蓝牙数据拼接
 * 版本编号：1.0.1
 * 创建日期：2017年11月09日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FBKSpliceBle : NSObject

// 十进制转化为十六进制
+ (NSString *)decimalToHex:(int)decimalNum;

// 十进制拼接的字符
+ (NSString *)getHexData:(NSDictionary *)dataDic haveCheckNum:(BOOL)isCheck;

// 获取校验和
+ (NSString *)getCheckNumber:(NSString *)cmdString;

// 获取写入命令的原数据
+ (NSData *)getWriteData:(NSString *)cmdString;

// 蓝牙数据转String
+ (NSString *)bleDataToString:(NSData *)cmdData;

// 获取数据bit字节数据
+ (int)getBitNumber:(int)dataNumber andStart:(int)start withStop:(int)stop;

+ (long)getSignedData:(long)valueNumber andCount:(int)count;

// UTF-8转换成Unicode编码
+ (NSString *)utf8ToUnicode:(NSString *)string;

// 获取MAC地址
+ (NSString *)getMacAddress:(NSString *)infoString;

// 字符转换成Ascii编码
+ (NSString *)stringToAscii:(NSString *)string;

// 解析设备ID数据
+ (NSString *)analyticalDeviceId:(NSData *)byteData;

// 加密
+ (NSString *)encryptionString:(NSString *)cmdString withKey:(int)key;

+ (BOOL)compareUuid:(CBUUID *)bleUuid withUuid:(NSString *)uuidString;

@end

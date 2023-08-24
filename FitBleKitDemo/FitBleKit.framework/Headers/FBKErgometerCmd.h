/*-******************************************************************************
 * 文件名称：FBKErgometerCmd.h
 * 内容摘要：Ergometer蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2023年08月10日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    ErgometerEnterZero = 0,
    ErgometerZeroInfo,
    ErgometerEnterCalibration,
    ErgometerCalibrationInfo,
    ErgometerSetFrequency,
    ErgometerGetFrequency,
} ErgometerCmdNumber;


@interface FBKErgometerCmd : NSObject

// 进入零点模式
- (NSData *)enterZeroMode;

// 获取零点信息
- (NSData *)getZeroInfo;

// 进入标定模式
- (NSData *)enterCalibrationMode;

// 获取标定信息
- (NSData *)getCalibrationInfo;

// 设置采样频率
- (NSData *)setSamplingFrequency:(int)frequency;

// 获取采样频率
- (NSData *)getSamplingFrequency;

@end

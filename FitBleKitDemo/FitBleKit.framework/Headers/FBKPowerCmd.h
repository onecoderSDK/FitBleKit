/********************************************************************************
 * 文件名称：FBKPowerCmd.h
 * 内容摘要：功率计蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2021年01月04日
 ********************************************************************************/

#import <Foundation/Foundation.h>

@interface FBKPowerCmd : NSObject

- (NSData *)calibrationPower;

- (NSData *)getCalibrationResult;

@end

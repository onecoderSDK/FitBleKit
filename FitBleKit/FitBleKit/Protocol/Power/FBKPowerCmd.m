/********************************************************************************
 * 文件名称：FBKPowerCmd.m
 * 内容摘要：功率计蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2021年01月04日
 ********************************************************************************/

#import "FBKPowerCmd.h"

@implementation FBKPowerCmd

/*-********************************************************************************
* Method: calibrationPower
* Description: calibrationPower
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)calibrationPower {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[1];
    bytes[0] = (Byte) (12);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: getCalibrationResult
* Description: getCalibrationResult
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)getCalibrationResult {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (170);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (3);
    bytes[3] = (Byte) (177);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


@end

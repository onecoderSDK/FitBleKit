/********************************************************************************
 * 文件名称：FBKECGCmd.m
 * 内容摘要：ECG蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2021年03月18日
 ********************************************************************************/

#import "FBKECGCmd.h"

@implementation FBKECGCmd

/*-********************************************************************************
* Method: setDeviceColor
* Description: setDeviceColor
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)setDeviceColor:(ECGShowColor)showColor {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    int colorNumber = showColor;
    
    Byte bytes[5];
    bytes[0] = (Byte) (178);
    bytes[1] = (Byte) (5);
    bytes[2] = (Byte) (20);
    bytes[3] = (Byte) (colorNumber);
    
    int sunNumber = (178 + 5 + 20 + colorNumber) % 256;
    bytes[4] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: ecgSwitch
* Description: ecgSwitch
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)ecgSwitch:(BOOL)isOn {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    int switchNo = 0;
    if (isOn) {
        switchNo = 1;
    }
    
    Byte bytes[5];
    bytes[0] = (Byte) (226);
    bytes[1] = (Byte) (5);
    bytes[2] = (Byte) (1);
    bytes[3] = (Byte) (switchNo);
    
    int sunNumber = (226 + 5 + 1 + switchNo) % 256;
    bytes[4] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


@end

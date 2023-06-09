/********************************************************************************
 * 文件名称：FBKECGCmd.h
 * 内容摘要：ECG蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2021年03月18日
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum{
    ShowRedColor = 1,
    ShowGreenColor = 2,
    ShowBlueColor = 3,
}ECGShowColor;

@interface FBKECGCmd : NSObject

- (NSData *)setDeviceColor:(ECGShowColor)showColor;

- (NSData *)ecgSwitch:(BOOL)isOn;

@end

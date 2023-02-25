/********************************************************************************
 * 文件名称：FBKProtocolECG.h
 * 内容摘要：ECG蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2021年01月20日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKECGCmd.h"

typedef enum{
    ECGSetColor = 0,
    ECGSendSwitch = 1,
} ECGCmdNumber;

@interface FBKProtocolECG : FBKProtocolBase

@end

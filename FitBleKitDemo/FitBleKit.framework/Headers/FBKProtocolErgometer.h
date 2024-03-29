/********************************************************************************
 * 文件名称：FBKProtocolECG.h
 * 内容摘要：拉力计蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2023年02月28日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerAnalytical.h"
#import "FBKErgometerCmd.h"

typedef enum {
    ErgResultRealTimeData = 0,
    ErgResultEnterZero,
    ErgResultZeroInfo,
    ErgResultEnterCalibration,
    ErgResultCalibrationInfo,
    ErgResultSetFrequency,
    ErgResultGetFrequency,
    ErgResultInvalidCmd,
} ErgometerResultNumber;

@interface FBKProtocolErgometer : FBKProtocolBase

@end

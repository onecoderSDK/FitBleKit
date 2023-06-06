/********************************************************************************
 * 文件名称：FBKProtocolNScale.h
 * 内容摘要：新秤蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月18日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"

typedef enum{
    NScaleCmdSetTime = 0, // 手环时间
    NScaleCmdSetType,     // 个人基本信息
    NScaleCmdSetUnit,     // 人睡眠信息
}NScaleCmdNumber;


@interface FBKProtocolNScale : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end

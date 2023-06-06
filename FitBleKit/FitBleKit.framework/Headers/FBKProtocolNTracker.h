/********************************************************************************
 * 文件名称：FBKProtocolNTracker.h
 * 内容摘要：新手环蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"

typedef enum{
    NTrackerCmdSetTime = 0,       // 手环时间
    NTrackerCmdSetUserInfo,       // 个人基本信息
    NTrackerCmdSetSleepInfo,      // 人睡眠信息
    NTrackerCmdSetWaterInfo,      // 个人喝水信息
    NTrackerCmdSetSitInfo,        // 个人久坐信息
    NTrackerCmdSetNoticeInfo,     // 个人通知信息
    NTrackerCmdSetAlarmInfo,      // 个人闹钟信息
    NTrackerCmdSetBikeInfo,       // 单车参数
    NTrackerCmdSetHRMax,          // 心率最大值
    NTrackerCmdSetANTInfo,        // ANT等级
    NTrackerCmdOpenRealTImeSteps, // 开启实时数据
    NTrackerCmdOpenTakePhoto,     // 开启拍照
    NTrackerCmdOpenHRMode,        // 开启心率模式
    NTrackerCmdOpenHRTenMode,     // 开启心率10分钟采集模式
    NTrackerCmdOpenANCSMode,      // 进入配对模式
    NTrackerCmdGetDeviceSupport,  // 获取设备支持信息
    NTrackerCmdGetBeforeUtc,      // 获取上次同步的UTC
    NTrackerCmdGetTotalRecord,    // 获取所有历史数据
    NTrackerCmdGetStepRecord,     // 获取运动历史数据
    NTrackerCmdGetSleepRecord,    // 获取睡眠历史数据
    NTrackerCmdGetHRRecord,       // 获取心率历史数据
    NTrackerCmdGetBikeRecord,     // 获取踏频历史数据
    NTrackerCmdGetTrainRecord,    // 获取训练历史数据
    NTrackerCmdGetEverydayRecord, // 获取每天步数总和历史数据
    NTrackerCmdAckCmd,            // 回复命令
    NTrackerCmdSendCmdSuseed,     // 发送命令成功
}NTrackerCmdNumber;


@interface FBKProtocolNTracker : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end

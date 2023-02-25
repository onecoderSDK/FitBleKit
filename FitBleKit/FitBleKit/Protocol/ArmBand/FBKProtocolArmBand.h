/********************************************************************************
 * 文件名称：FBKProtocolArmBand.h
 * 内容摘要：臂带蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年03月26日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"
#import "FBKArmBandCmd.h"

typedef enum{
    ArmBandCmdSetTime = 0,       // 手环时间
    ArmBandCmdOpenRealTImeSteps, // 开启实时数据
    ArmBandCmdSetMaxHR,          // 设置最大心率
    ArmBandCmdEnterHRVMode,      // 进入HRV模式
    ArmBandCmdEnterSPO2Mode,     // 进入SPO2模式
    ArmBandCmdEnterTemMode,      // 进入温度模式
    ArmBandCmdSetHrvTime,        // 设置HRV时间
    ArmBandCmdSetHrColor,        // 设置臂带显示颜色
    ArmBandCmdGetDeviceSupport,  // 获取设备支持信息
    ArmBandCmdGetTotalRecord,    // 获取所有历史数据
    ArmBandCmdGetStepRecord,     // 获取运动历史数据
    ArmBandCmdGetHRRecord,       // 获取心率历史数据
    ArmBandCmdAckCmd,            // 回复命令
    ArmBandCmdSendCmdSuseed,     // 发送命令成功
    
    ArmBandCmdSetAge,            // 设置年龄
    ArmBandCmdSetShock,          // 设置震动阈值
    ArmBandCmdGetShock,          // 获取震动阈值
    ArmBandCmdCloseShock,        // 关闭震动功能
    ArmBandCmdMaxInterval,       // 设置心率区间最大值
    ArmBandCmdLightSwitch,       // 设置呼吸灯的开关
    ArmBandCmdColorShock,        // 设置颜色变换震动功能
    ArmBandCmdColorInterval,     // BLE颜色设置阈值
    ArmBandCmdClearRecord,       // 清除历史存储数据
    ArmBandCmdGetMacAddress,     // 获取Mac地址
    ArmBandCmdGetVersion,        // 获取设备版本号
    ArmBandCmdEnterOTA,          // 进入OTA模式
    ArmBandCmdDataFrequency,     // 设置数据采样频率
    
    ArmBandCmdFiveZone,      // 设置区间UI的展示
    ArmBandCmdOpenShow,      // 开启设定显示
    ArmBandCmdCloseShow,     // 关闭设定显示
}ArmBandCmdNumber;

@interface FBKProtocolArmBand : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end

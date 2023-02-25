/********************************************************************************
 * 文件名称：FBKProtocolRosary.h
 * 内容摘要：念珠蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProRosaryCmd.h"
#import "FBKProRosaryAnalytical.h"

typedef enum{
    RosaryCmdEditMode = 0,  // 开始/结束念珠
    RosaryCmdSearchRemind,  // 查询来电提醒方式
    RosaryCmdSetRemind,     // 设置来电提醒方式
    RosaryCmdSearchPower,   // 查询电量
    RosaryCmdSearchBeadNum, // 查询念珠一圈颗数
    RosaryCmdSetBeadNum,    // 设置念珠一圈颗数
    RosaryCmdGetRTSteps,    // 获取实时步数
    RosaryCmdRTNumber,      // 获取念珠计数
    RosaryCmdSetTime,       // 设置设备时间
    RosaryCmdSetRemiadList, // 设置参数
    RosaryCmdSetBookId,     // 设置经书ID
    RosaryCmdSetAncs,       // ANCS
    RosaryCmdGetRecord,     // 获取念珠历史数据
    RosaryCmdGetNowStatus,  // 获取念珠当前状态
}RosaryCmdNumber;

@interface FBKProtocolRosary : FBKProtocolBase<FBKProRosaryCmdDelegate,FBKProRosaryAnalyticalDelegate>

@end

/********************************************************************************
 * 文件名称：FBKProtocolKettleBell.h
 * 内容摘要：壶铃蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年04月02日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"

typedef enum{
    KettleBellCmdSetTime = 0,       // 手环时间
    KettleBellCmdGetTotalRecord,    // 获取所有历史数据
    KettleBellCmdAckCmd,            // 回复命令
    KettleBellCmdSendCmdSuseed,     // 发送命令成功
}KettleBellCmdNumber;

@interface FBKProtocolKettleBell : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end

/********************************************************************************
 * 文件名称：FBKProtocolBikeComputer.h
 * 内容摘要：码表蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2018年02月02日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProNTrackerCmd.h"
#import "FBKProNTrackerAnalytical.h"

typedef enum{
    BikeComputerCmdSetTime = 0,  // 手环时间
    BikeComputerCmdGetFitList,   // 获取fit文件名列表
    BikeComputerCmdGetFitFile,   // 获取fit文件
    BikeComputerCmdDeleteFit,    // 删除fit文件
    BikeComputerCmdDeleteFitHis, // 删除fit文件对应的历史
    BikeComputerCmdDeleteFitAll, // 删除fit文件和对应的历史
    BikeComputerCmdSetZone,      // 设置码表时区
}BikeComputerCmdNumber;

@interface FBKProtocolBikeComputer : FBKProtocolBase<FBKProNTrackerCmdDelegate,FBKProNewBandAnalyticalDelegate>

@end

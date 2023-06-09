/********************************************************************************
 * 文件名称：FBKProtocolOldScale.h
 * 内容摘要：老秤蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKProOldScaleCmd.h"
#import "FBKProOldScaleAnalytical.h"

typedef enum{
    OldScaleCmdSetTime = 0, // 设置时间
    OldScaleCmdSetUserInfo, // 设置用户信息
    OldScaleCmdSetUnit,     // 设置设备单位
    OldScaleCmdGetInfo,     // 获取设备基本信息
    OldScaleCmdAddUser,     // 添加用户信息命令
    OldScaleCmdDeleUser,    // 删除用户信息命令
    OldScaleCmdTipUser,     // 指定用户信息命令
    OldScaleCmdAckCmd,      // 应答命令
}OldScaleCmdNumber;

@interface FBKProtocolOldScale : FBKProtocolBase<FBKProOldScaleCmdDelegate,FBKProOldScaleAnalyticalDelegate>

@end

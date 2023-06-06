/********************************************************************************
 * 文件名称：FBKProtocolBase.h
 * 内容摘要：新拳击蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKProtocolBase.h"
#import "FBKFightCmd.h"

typedef enum {
    FightResultInfo = 0,
    FightResultEnterDfu = 1,
    FightResultTurnOffDevice = 2,
    FightResultSetSandbag = 3,
} FightResultNumber;

@interface FBKProtocolFight : FBKProtocolBase

@end

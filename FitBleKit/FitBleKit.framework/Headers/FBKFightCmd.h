/********************************************************************************
 * 文件名称：FBKFightCmd.h
 * 内容摘要：新拳击蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKFightClass.h"

typedef enum {
    FightCmdEnterDfu = 0,
    FightCmdTurnOffDevice = 1,
    FightCmdSetSandbag = 2,
} FightCmdNumber;


@interface FBKFightCmd : NSObject

- (NSData *)enterDfuCmd;

- (NSData *)turnOffDevice;

- (NSData *)setSandbagInfo:(FBKFightSandbag *)sandbagInfo;

@end

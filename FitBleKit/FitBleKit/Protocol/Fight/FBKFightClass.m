/********************************************************************************
 * 文件名称：FBKFightClass.h
 * 内容摘要：新拳击蓝牙参数类
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKFightClass.h"

@implementation FBKFightClass

@end


@implementation FBKFightSandbag

#pragma mark - ****************************** Syetems *************************************
/*-****************************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
*******************************************************************************************/
- (id)init {
    self.sandbagLength = -1;
    self.sandbagWidth  = -1;
    self.sandbagHight  = -1;
    self.sandbagWeight = -1;
    self.sandbagType   = -1;
    self.sandbagSensitivity = 13;
    return self;
}

@end


@implementation FBKFightInfo

#pragma mark - ****************************** Syetems *************************************
/*-****************************************************************************************
* Method: init
* Description: init
* Parameter:
* Return Data:
*******************************************************************************************/
- (id)init {
    self.protocolVersion    = -1;
    self.fightNumbers       = -1;
    self.fightFrequency     = -1;
    self.isEnoughBattery    = false;
    self.strengthIndex      = -1;
    return self;
}

@end

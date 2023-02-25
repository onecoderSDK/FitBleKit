/********************************************************************************
 * 文件名称：FBKProtocolBase.m
 * 内容摘要：新拳击蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKProtocolFight.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolFight {
    FBKFightCmd   *m_deviceCmd;
}

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init {
    self = [super init];
    m_deviceCmd = [[FBKFightCmd alloc] init];
    return self;
}


/********************************************************************************
* 方法名称：dealloc
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)dealloc {
}


#pragma mark - **************************** 接收数据  *****************************
/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object {
    FightCmdNumber cmdNumber = (FightCmdNumber)cmdId;
    
    switch (cmdNumber) {
        case FightCmdEnterDfu: {
            NSData *cmdData = [m_deviceCmd enterDfuCmd];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        case FightCmdTurnOffDevice: {
            NSData *cmdData = [m_deviceCmd turnOffDevice];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        case FightCmdSetSandbag: {
            FBKFightSandbag *mySandbag = (FBKFightSandbag *)object;
            NSData *cmdData = [m_deviceCmd setSandbagInfo:mySandbag];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        default:
            break;
    }
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid {
    if ([FBKSpliceBle compareUuid:uuid withUuid:FIGHT_NOTIFY_UUID]) {
        [self analyData:hexData];
    }
}


/*-******************************************************************************
* 方法名称：analyData
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)analyData:(NSData *)resultData {
    const uint8_t *bytes = [resultData bytes];
    
    int length = (int)resultData.length;
    int lastNumber = bytes[length-1]&0xFF;
    int checkNumber = 0;
    for (int i = 0; i < length-1; i++) {
        int value = bytes[i];
        checkNumber = checkNumber + value;
    }
    
    if (lastNumber != checkNumber%256) {
        NSLog(@"****************校验和错误！！！");
        return;
    }
    
    if (length < 3) {
        NSLog(@"**************** 无法解析该数据！！！");
        return;
    }
    
    int cmdNumber = bytes[0]&0xFF;
    int keyNumber = bytes[2]&0xFF;
    if (cmdNumber == 178) {
        if (keyNumber == 0 && length >= 12) {
            int offset = 3;
            int protocolVersion = bytes[offset]&0xFF;
            offset = offset + 1;
            
            int fightNoHi   = bytes[offset]&0xFF;
            int fightNoLow  = bytes[offset+1]&0xFF;
            int fightNumber = (fightNoHi<<8) + fightNoLow;
            offset = offset + 2;
            
            int frequencyHi   = bytes[offset]&0xFF;
            int frequencyLow  = bytes[offset+1]&0xFF;
            int frequency     = (frequencyHi<<8) + frequencyLow;
            offset = offset + 2;
            
            int battaryStatus = bytes[offset]&0xFF;
            BOOL isBatteryOn = false;
            if (battaryStatus == 1) {
                isBatteryOn = true;
            }
            offset = offset + 1;
            
            
            int strengthHi   = bytes[offset]&0xFF;
            int strengthLow  = bytes[offset+1]&0xFF;
            int strength     = (strengthHi<<8) + strengthLow;
            offset = offset + 2;
            
            FBKFightInfo *myFightInfo = [[FBKFightInfo alloc] init];
            myFightInfo.protocolVersion = protocolVersion;
            myFightInfo.fightNumbers = fightNumber;
            myFightInfo.fightFrequency = frequency;
            myFightInfo.isEnoughBattery = isBatteryOn;
            myFightInfo.strengthIndex = strength;
            
            FightResultNumber resultNumber = FightResultInfo;
            [self.delegate analyticalBleData:myFightInfo withResultNumber:resultNumber];
        }
    }
    else if (cmdNumber == 210) {
        if (keyNumber == 1) {
            int resultNo = bytes[3]&0xFF;
            FightResultNumber resultNumber = FightResultEnterDfu;
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",resultNo] withResultNumber:resultNumber];
        }
        else if (keyNumber == 2) {
            int resultNo = bytes[3]&0xFF;
            FightResultNumber resultNumber = FightResultTurnOffDevice;
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",resultNo] withResultNumber:resultNumber];
        }
        else if (keyNumber == 3) {
            int resultNo = bytes[3]&0xFF;
            FightResultNumber resultNumber = FightResultSetSandbag;
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",resultNo] withResultNumber:resultNumber];
        }
    }
    
}


@end

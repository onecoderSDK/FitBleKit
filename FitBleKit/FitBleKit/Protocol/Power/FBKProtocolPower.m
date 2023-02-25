/********************************************************************************
 * 文件名称：FBKProtocolPower.m
 * 内容摘要：功率计蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2021年01月04日
 ********************************************************************************/

#import "FBKProtocolPower.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolPower {
    FBKPowerCmd   *m_powerCmd;
    FBKPowerAnaly *m_powerAnaly;
    BOOL m_isEncryption;
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
    m_powerCmd = [[FBKPowerCmd alloc] init];
    m_powerAnaly = [[FBKPowerAnaly alloc] init];
    m_powerAnaly.delegate = self;
    m_isEncryption = false;
    return self;
}


/********************************************************************************
* 方法名称：dealloc
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)dealloc {
    m_powerCmd = nil;
    m_powerAnaly.delegate = nil;
    m_powerAnaly = nil;
}

#pragma mark - **************************** 接收数据  *****************************
/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object {
    PowerCmdNumber powerCmd = (PowerCmdNumber)cmdId;
    
    switch (powerCmd) {
        case PowerCalibration: {
            NSData *cmdData = [m_powerCmd calibrationPower];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        case GetCalibrationData: {
            NSData *cmdData = [m_powerCmd getCalibrationResult];
            [self.delegate writeSpliceByte:cmdData withUuid:@"FD0A"];
            break;
        }
            
        case PowerEncryption: {
            NSString *encryptionString = (NSString *)object;
            if ([encryptionString isEqualToString:@"0"]) {
                m_isEncryption = false;
            }
            else {
                m_isEncryption = true;
            }
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
    NSString *hexString = [FBKSpliceBle bleDataToString:hexData];
    if ([FBKSpliceBle compareUuid:uuid withUuid:POWER_NOTIFY_CHAR_UUID]) {
        if (m_isEncryption) {
            hexString = [FBKSpliceBle encryptionString:hexString withKey:170];
        }
        [m_powerAnaly receiveRealTimeData:hexString];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:POWER_WRITE_NOTIFY_UUID]) {
        [m_powerAnaly receiveBlueData:hexString];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBK_DEVICE_OTA_NOTIFY]) {
        [m_powerAnaly receiveZeroData:hexString];
    }
}



#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalResult
 * 功能描述：解析结果
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalResult:(id)resultData withResultNumber:(PowerResult)resultId {
    [self.delegate analyticalBleData:resultData withResultNumber:resultId];
}


@end


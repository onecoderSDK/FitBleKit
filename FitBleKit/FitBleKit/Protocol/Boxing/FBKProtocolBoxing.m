/********************************************************************************
 * 文件名称：FBKProtocolBoxing.m
 * 内容摘要：拳击器蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2019年03月26日
 ********************************************************************************/

#import "FBKProtocolBoxing.h"
#import "FBKDateFormat.h"
#import "FBKSpliceBle.h"

@implementation FBKProtocolBoxing
{
    FBKProNTrackerCmd *m_boxingCmd;
    FBKProNTrackerAnalytical *m_boxingAnalytical;
}


#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init
{
    self = [super init];
    
    m_boxingCmd = [[FBKProNTrackerCmd alloc] init];
    m_boxingCmd.delegate = self;
    
    m_boxingAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_boxingAnalytical.delegate = self;
    m_boxingAnalytical.analyticalDeviceType = BleDeviceBoxing;
    
    return self;
}


/********************************************************************************
* 方法名称：dealloc
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)dealloc
{
    m_boxingCmd.delegate = nil;
    m_boxingCmd = nil;
    
    m_boxingAnalytical.delegate = nil;
    m_boxingAnalytical = nil;
}


#pragma mark - **************************** 接收数据  *****************************
/********************************************************************************
 * 方法名称：receiveBleCmd
 * 功能描述：接收拼接命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleCmd:(int)cmdId withObject:(id)object
{
    BoxingCmdNumber boxingCmd = (BoxingCmdNumber)cmdId;
    
    switch (boxingCmd)
    {
        case BoxingCmdSetTime:
            [m_boxingCmd setUTC];
            break;
            
        case BoxingCmdGetTotalRecord:
            [m_boxingCmd getTotalRecordCmd];
            break;
            
        case BoxingCmdSetAxisZone:{
            NSData *setData = [self setBoxingZone:(FBKBoxingSet *)object];
            [self.delegate writeSpliceByte:setData withUuid:FBK_DEVICE_OTA_WRITE];
            break;
        }
            
        case BoxingCmdSetAxisSwitch:{
            NSString *switchString = (NSString *)object;
            NSData *setData = [self setBoxingZoneSwitch:[switchString intValue]];
            [self.delegate writeSpliceByte:setData withUuid:FBK_DEVICE_OTA_WRITE];
            break;
        }
            
        case BoxingCmdAckCmd:
            [m_boxingCmd getAckCmd:(NSString *)object];
            break;
            
        case BoxingCmdSendCmdSuseed:
            [m_boxingCmd sendCmdSuseed:(NSString *)object];
            break;
            
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
    if ([FBKSpliceBle compareUuid:uuid withUuid:FBKNEWBANDNOTIFYFD19]) {
        [m_boxingAnalytical receiveBlueData:hexString];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBK_DEVICE_OTA_NOTIFY]) {
        [self getCmdSendResult:hexData];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBKBOXINGNOTIFYFD0D]) {
        [self axisDataList:hexData];
    }
}


/********************************************************************************
 * 方法名称：bleErrorReconnect
 * 功能描述：蓝牙异常重连
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleErrorReconnect
{
    [m_boxingAnalytical receiveBlueDataError];
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：sendBleCmdData
 * 功能描述：传输写入的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendBleCmdData:(NSData *)byteData;
{
    [self.delegate writeBleByte:byteData];
}


/********************************************************************************
 * 方法名称：analyticalSucceed
 * 功能描述：解析数据返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalSucceed:(id)resultData withResultNumber:(FBKAnalyticalNumber)resultNumber
{
    switch (resultNumber)
    {
        case FBKAnalyticalDeviceVersion:
        {
            int softVersion = [[NSString stringWithFormat:@"%@",(NSString *)resultData] intValue];
            if (softVersion == 1 || softVersion == 2)
            {
                softVersion = 1;
            }
            
            m_boxingCmd.m_softVersion = softVersion;
            
            [m_boxingCmd setUTC];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
        }
            
        case FBKAnalyticalSendSuseed:
            [m_boxingCmd sendCmdSuseed:(NSString *)resultData];
            break;
            
        case FBKAnalyticalAck:
            [m_boxingCmd getAckCmd:(NSString *)resultData];
            break;
            
        case FBKAnalyticalBigData:
            [self.delegate synchronizationStatus:DeviceBleSyncOver];
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
            
        case FBKAnalyticalSyncing:
            [self.delegate synchronizationStatus:DeviceBleSynchronization];
            break;
            
        default:
            [self.delegate analyticalBleData:resultData withResultNumber:resultNumber];
            break;
    }
}


/*-********************************************************************************
* Method: setBoxingZone
* Description: setBoxingZone
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)setBoxingZone:(FBKBoxingSet *)boxingSet {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[14];
    bytes[0] = (Byte) (179);
    bytes[1] = (Byte) (14);
    bytes[2] = (Byte) (1);
    bytes[3] = (Byte) (boxingSet.axisType);
    
    if (boxingSet.isReserve) {
        bytes[4] = (Byte) (1);
    } else {
        bytes[4] = (Byte) (0);
    }
    
    long int myLowZone = boxingSet.lowZone;
    bytes[5] = myLowZone>>24;
    bytes[6] = myLowZone>>16;
    bytes[7] = myLowZone>>8;
    bytes[8] = myLowZone;
    
    long int myHiZone = boxingSet.hightZone;
    bytes[9]  = myHiZone>>24;
    bytes[10] = myHiZone>>16;
    bytes[11] = myHiZone>>8;
    bytes[12] = myHiZone;
    
    int sunNumber = 0;
    for (int i = 0; i < 13; i++) {
        sunNumber = sunNumber + (bytes[i]&0xff);
    }
    
    bytes[13] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: setBoxingZone
* Description: setBoxingZone
* Parameter:switchNo - 0:off   1:on
* Return Data:
***********************************************************************************/
- (NSData *)setBoxingZoneSwitch:(int)switchNo {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[5];
    bytes[0] = (Byte) (179);
    bytes[1] = (Byte) (5);
    bytes[2] = (Byte) (2);
    bytes[3] = (Byte) (switchNo);
    
    int sunNumber = 0;
    for (int i = 0; i < 4; i++) {
        sunNumber = sunNumber + (bytes[i]&0xff);
    }
    
    bytes[4] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-******************************************************************************
* 方法名称：getCmdSendResult
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)getCmdSendResult:(NSData *)resultData {
    const uint8_t *bytes = [resultData bytes];
    int lastNumber = bytes[resultData.length-1]&0xFF;
    int checkNumber = 0;
    
    for (int i = 0; i < resultData.length-1; i++) {
        int value = bytes[i]&0xFF;
        checkNumber = checkNumber + value;
    }
    
    if (lastNumber != checkNumber%256) {
        NSLog(@"****************校验和错误！！！");
        return;
    }
    
    int firstNum = bytes[0]&0xFF;
    if (firstNum == 211) {
        int cmdId = bytes[2]&0xFF;
        if (cmdId == 1) {
            FBKAnalyticalNumber resultNumber = FBKResultBoxingAxis;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
        else if (cmdId == 2) {
            int value = bytes[3]&0xFF;
            FBKAnalyticalNumber resultNumber = FBKResultBoxingAxisSwitch;
            [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",value] withResultNumber:resultNumber];
        }
    }
    else if (firstNum == 162) {
        int valueLength = (bytes[1]&0xFF) - 8;
        int bagNumber = bytes[2]&0xFF;
        int offSet = 3;
        
        int time1  = bytes[offSet]&0xFF;
        int time2  = bytes[offSet+1]&0xFF;
        int time3  = bytes[offSet+2]&0xFF;
        int time4  = bytes[offSet+3]&0xFF;
        long int myTime = time4 + (time3<<8) + (time2<<16) + (time1<<24);
        offSet = offSet + 4;
        
        if (valueLength%12 == 0) {
            int dataNum = valueLength/12;
            NSMutableArray *axisArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < dataNum; i++) {
                FBKBoxingAxis *boxingAxis = [[FBKBoxingAxis alloc] init];
                for (int j = 0; j < 6; j++) {
                    int axis1  = bytes[offSet]&0xFF;
                    int axis2  = bytes[offSet+1]&0xFF;
                    signed short int myAxis = (signed short int)axis2 | ((signed short int)axis1<<8);
                    offSet = offSet + 2;
                    
                    if (j == 0) {
                        boxingAxis.accelerationX = myAxis;
                    } else if (j == 1) {
                        boxingAxis.accelerationY = myAxis;
                    } else if (j == 2) {
                        boxingAxis.accelerationZ = myAxis;
                    } else if (j == 3) {
                        boxingAxis.angularX = myAxis;
                    } else if (j == 4) {
                        boxingAxis.angularY = myAxis;
                    } else if (j == 5) {
                        boxingAxis.angularZ = myAxis;
                    }
                }
                [axisArray addObject:boxingAxis];
            }
            
            NSMutableDictionary *axisDataMap = [[NSMutableDictionary alloc] init];
            [axisDataMap setObject:[NSString stringWithFormat:@"%i",bagNumber] forKey:@"sortNo"];
            [axisDataMap setObject:[NSString stringWithFormat:@"%li",myTime] forKey:@"timestamps"];
            [axisDataMap setObject:axisArray forKey:@"axisDataList"];
            
            FBKAnalyticalNumber resultNumber = FBKResultAxisList;
            [self.delegate analyticalBleData:axisDataMap withResultNumber:resultNumber];
        }
    }
}


/*-******************************************************************************
* 方法名称：axisDataList
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)axisDataList:(NSData *)resultData {
    const uint8_t *bytes = [resultData bytes];
    int lastNumber = bytes[resultData.length-1]&0xFF;
    int checkNumber = 0;
    
    for (int i = 0; i < resultData.length-1; i++) {
        int value = bytes[i]&0xFF;
        checkNumber = checkNumber + value;
    }
    
    if (lastNumber != checkNumber%256) {
        NSLog(@"****************校验和错误！！！");
        return;
    }
    
    int firstNum = bytes[0]&0xFF;
    if (firstNum == 162) {
        int valueLength = (bytes[1]&0xFF) - 4;
        int bagNumber = bytes[2]&0xFF;
        if (valueLength%24 == 0) {
            int offSet = 3;
            int dataNum = valueLength/24;
            NSMutableArray *axisArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < dataNum; i++) {
                FBKBoxingAxis *boxingAxis = [[FBKBoxingAxis alloc] init];
                for (int j = 0; j < 6; j++) {
                    int axis1  = bytes[offSet]&0xFF;
                    int axis2  = bytes[offSet+1]&0xFF;
                    int axis3  = bytes[offSet+2]&0xFF;
                    int axis4  = bytes[offSet+3]&0xFF;
                    signed int myAxis = (signed int)axis4 | ((signed int)axis3<<8) | ((signed int)axis2<<16) | ((signed int)axis1<<24);
                    offSet = offSet + 4;
                    
                    if (j == 0) {
                        boxingAxis.accelerationX = (double)myAxis/1000.0;
                    } else if (j == 1) {
                        boxingAxis.accelerationY = (double)myAxis/1000.0;
                    } else if (j == 2) {
                        boxingAxis.accelerationZ = (double)myAxis/1000.0;
                    } else if (j == 3) {
                        boxingAxis.angularX = (double)myAxis/1000.0;
                    } else if (j == 4) {
                        boxingAxis.angularY = (double)myAxis/1000.0;
                    } else if (j == 5) {
                        boxingAxis.angularZ = (double)myAxis/1000.0;
                    }
                }
                [axisArray addObject:boxingAxis];
            }
            
            NSMutableDictionary *axisDataMap = [[NSMutableDictionary alloc] init];
            [axisDataMap setObject:[NSString stringWithFormat:@"%i",bagNumber] forKey:@"sortNo"];
            [axisDataMap setObject:[NSString stringWithFormat:@"%i",-1] forKey:@"timestamps"];
            [axisDataMap setObject:axisArray forKey:@"axisDataList"];
            
            FBKAnalyticalNumber resultNumber = FBKResultAxisList;
            [self.delegate analyticalBleData:axisDataMap withResultNumber:resultNumber];
        }
    }
}

@end

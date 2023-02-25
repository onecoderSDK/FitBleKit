/********************************************************************************
 * 文件名称：FBKProtocolECG.m
 * 内容摘要：ECG蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2021年01月20日
 ********************************************************************************/

#import "FBKProtocolECG.h"
#import "FBKSpliceBle.h"
#import "FBKDateFormat.h"
#import "FBKProNTrackerAnalytical.h"

@implementation FBKProtocolECG {
    FBKECGCmd   *m_ECGCmd;
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
    m_ECGCmd = [[FBKECGCmd alloc] init];
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
    ECGCmdNumber ecgCmd = (ECGCmdNumber)cmdId;
    
    switch (ecgCmd) {
        case ECGSetColor: {
            NSString *colorString = (NSString *)object;
            ECGShowColor myColor = [colorString intValue];
            NSData *cmdData = [m_ECGCmd setDeviceColor:myColor];
            [self.delegate writeBleByte:cmdData];
            break;
        }
            
        case ECGSendSwitch: {
            NSString *switchString = (NSString *)object;
            BOOL switchStatus = NO;
            if ([switchString intValue] == 1) {
                switchStatus = YES;
            }
            NSData *cmdData = [m_ECGCmd ecgSwitch:switchStatus];
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
    if ([FBKSpliceBle compareUuid:uuid withUuid:ECG_NOTIFY_UUID]) {
        [self spliceData:hexData];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBK_DEVICE_OTA_NOTIFY]) {
        [self switchData:hexData];
    }
    else if ([FBKSpliceBle compareUuid:uuid withUuid:FBKHEARTRATENOTIFY2A37]) {
        [self getRealTimeData:hexData];
    }
}


/*-******************************************************************************
* 方法名称：spliceData
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)spliceData:(NSData *)resultData {
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
    
    int cmdNumber = bytes[0]&0xFF;
    int keyNumber = bytes[2]&0xFF;
    if (cmdNumber == 210 && keyNumber == 20) {
        int resultByte = bytes[3];
        FBKAnalyticalNumber resultNumber = FBKArmBandResultECGCOLOR;
        [self.delegate analyticalBleData:[NSString stringWithFormat:@"%i",resultByte] withResultNumber:resultNumber];
        return;
    }
    
    int firstNum = bytes[0]&0xFF;
    if (firstNum == 162) {
        NSMutableArray *ecgArray = [[NSMutableArray alloc] init];
        int allLength = bytes[1]&0xFF;
        if (allLength != resultData.length) {
            allLength = (int)resultData.length;
        }
        
        for (int i = 2; i < allLength-1; i++) {
            if (i%2 == 0 && i < allLength-2) {
                int hiByte = bytes[i]&0xFF;
                int lowByte = bytes[i+1]&0xFF;
                int ECGNumber = (hiByte<<8) + lowByte;
                if (ECGNumber > 32767) {
                    ECGNumber = ECGNumber - 65535;
                }
                [ecgArray addObject:[NSString stringWithFormat:@"%i",ECGNumber]];
            }
        }
        
        NSMutableDictionary *ecgMap = [[NSMutableDictionary alloc] init];
        [ecgMap setObject:ecgArray forKey:@"ECG"];
        [ecgMap setObject:@"0" forKey:@"sortNo"];
        
        FBKAnalyticalNumber resultNumber = FBKArmBandResultECG;
        [self.delegate analyticalBleData:ecgMap withResultNumber:resultNumber];
    }
    else if (firstNum == 163) {
        NSMutableArray *ecgArray = [[NSMutableArray alloc] init];
        int allLength = bytes[1]&0xFF;
        if (allLength != resultData.length) {
            allLength = (int)resultData.length;
        }
        
        int sortNo = bytes[2]&0xFF;
        
        for (int i = 3; i < allLength-1; i++) {
            if (i%2 == 1 && i < allLength-2) {
                int hiByte = bytes[i]&0xFF;
                int lowByte = bytes[i+1]&0xFF;
                
                int ECGNumber = (hiByte<<8) + lowByte;
                if (ECGNumber > 32767) {
                    ECGNumber = ECGNumber - 65535;
                }
                [ecgArray addObject:[NSString stringWithFormat:@"%i",ECGNumber]];
            }
        }
        
        NSMutableDictionary *ecgMap = [[NSMutableDictionary alloc] init];
        [ecgMap setObject:ecgArray forKey:@"ECG"];
        [ecgMap setObject:[NSString stringWithFormat:@"%i",sortNo] forKey:@"sortNo"];
        
        FBKAnalyticalNumber resultNumber = FBKArmBandResultECG;
        [self.delegate analyticalBleData:ecgMap withResultNumber:resultNumber];
    }
    else if (firstNum == 164) {
        NSMutableArray *ecgArray = [[NSMutableArray alloc] init];
        int allLength = bytes[1]&0xFF;
        if (allLength != resultData.length) {
            allLength = (int)resultData.length;
        }
        
        int sortNo = bytes[2]&0xFF;
        int key = allLength^sortNo; // ADD
        
        for (int i = 3; i < allLength-1; i++) {
            if (i%2 == 1 && i < allLength-2) {
                int hiByte = bytes[i]&0xFF;
                int lowByte = bytes[i+1]&0xFF;
                hiByte  = hiByte^key; // ADD
                lowByte = lowByte^key; // ADD
                
                int ECGNumber = (hiByte<<8) + lowByte;
                if (ECGNumber > 32767) {
                    ECGNumber = ECGNumber - 65535;
                }
                [ecgArray addObject:[NSString stringWithFormat:@"%i",ECGNumber]];
            }
        }
        
        NSMutableDictionary *ecgMap = [[NSMutableDictionary alloc] init];
        [ecgMap setObject:ecgArray forKey:@"ECG"];
        [ecgMap setObject:[NSString stringWithFormat:@"%i",sortNo] forKey:@"sortNo"];
        
        FBKAnalyticalNumber resultNumber = FBKArmBandResultECG;
        [self.delegate analyticalBleData:ecgMap withResultNumber:resultNumber];
    }
}


/*-******************************************************************************
* 方法名称：switchData
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)switchData:(NSData *)resultData {
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
    
    int cmdNumber = bytes[0]&0xFF;
    int keyNumber = bytes[2]&0xFF;
    if (cmdNumber == 194) {
        if (keyNumber == 1) {
            FBKAnalyticalNumber resultNumber = FBKArmBandResultECGSwitch;
            [self.delegate analyticalBleData:@"1" withResultNumber:resultNumber];
        }
    }
}


/********************************************************************************
 * 方法名称：getRealTimeData
 * 功能描述：解析心率数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)getRealTimeData:(NSData *)resultData {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    const uint8_t *bytes = [resultData bytes];
    
    int c0 = bytes[0]&0xFF;
    NSString *dataLength = [NSString stringWithFormat:@"%d",c0];
    [resultDic setObject:dataLength forKey:@"dataLength"];
    
    int c1 = bytes[1]&0xFF;
    NSString *nowXinLv = [NSString stringWithFormat:@"%d",c1];
    [resultDic setObject:nowXinLv forKey:@"heartRate"];
    [resultDic setObject:@"0" forKey:@"mark"];
    
    NSMutableArray *intervalArray = [[NSMutableArray alloc] init];
    int intervalLength = (int)resultData.length;
    if (intervalLength > 2 && intervalLength%2 == 0) {
        for (int i = 2; i < intervalLength; i++) {
            if (i%2 == 0) {
                int lowByte = bytes[i]&0xFF;
                int hiByte = bytes[i+1]&0xFF;
                NSString *interval = [NSString stringWithFormat:@"%d",(hiByte<<8) + lowByte];
                [intervalArray addObject:interval];
            }
        }
    }
    
    if (intervalArray.count > 0) {
        [resultDic setObject:intervalArray forKey:@"interval"];
    }
    
    NSString *nowTime = [FBKDateFormat getDateString:[NSDate date] withType:@"yyyy-MM-dd HH:mm:ss"];
    [resultDic setObject:nowTime forKey:@"createTime"];
    [resultDic setObject:[NSString stringWithFormat:@"%.0f",[FBKDateFormat getTimestamp:nowTime]] forKey:@"timestamps"];
    
    FBKAnalyticalNumber resultNumber = FBKECGResultRealHR;
    [self.delegate analyticalBleData:resultDic withResultNumber:resultNumber];
    
    return resultDic;
}


@end

/********************************************************************************
 * 文件名称：FBKProtocolRun.m
 * 内容摘要：Run蓝牙协议
 * 版本编号：1.0.1
 * 创建日期：2021年05月25日
 ********************************************************************************/

#import "FBKProtocolRun.h"
#import "FBKSpliceBle.h"
#import "FBKProNTrackerAnalytical.h"

@implementation FBKProtocolRun

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：init
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (id)init {
    self = [super init];
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
}


/********************************************************************************
 * 方法名称：receiveBleData
 * 功能描述：接收蓝牙原数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveBleData:(NSData *)hexData withUuid:(CBUUID *)uuid{
    if ([FBKSpliceBle compareUuid:uuid withUuid:RUNNING_NOTIFY_UUID]) {
        [self analyRunning:hexData];
    }
}


/*-****************************************************************************************
 * Method: analyRunning
 * Description: analyRunning
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)analyRunning:(NSData *)resultData {
    const uint8_t *bleBytes = [resultData bytes];
    int flag = bleBytes[0]&0xFF;
    
    int speedLow = bleBytes[1]&0xFF;
    int speedhi = bleBytes[2]&0xFF;
    double speed = (double)(speedLow + (speedhi<<8)) / 256.0 * 3.6; // (km/h)
    
    int cadence = bleBytes[3]&0xFF;// (RPM)
    
    double strideLength = 0; // (m)
    int strideStatus = flag&0x01;
    if (strideStatus == 1) {
        int strideLow = bleBytes[4]&0xFF;
        int stridehi = bleBytes[5]&0xFF;
        strideLength = (double)(strideLow + (stridehi<<8)) / 100.0;
    }
    
    double distance = 0; // (m)
    int distanceStatus = flag&0x02;
    if (distanceStatus == 2) {
        int distance1 = bleBytes[6]&0xFF;
        int distance2 = bleBytes[7]&0xFF;
        int distance3 = bleBytes[8]&0xFF;
        int distance4 = bleBytes[9]&0xFF;
        distance = (double)(distance1 + (distance2<<8) + (distance3<<16) + (distance4<<24)) / 10.0;
    }
    
    int status = 0; // (0-不在跑  1-跑步中)
    int moveStatus = flag&0x04;
    if (moveStatus == 4) {
        status = 1;
    }
    
    NSMutableDictionary *runMap = [[NSMutableDictionary alloc] init];
    [runMap setObject:[NSString stringWithFormat:@"%.2f",speed] forKey:@"speed"];
    [runMap setObject:[NSString stringWithFormat:@"%i",cadence] forKey:@"cadence"];
    [runMap setObject:[NSString stringWithFormat:@"%.2f",strideLength] forKey:@"stride"];
    [runMap setObject:[NSString stringWithFormat:@"%.1f",distance] forKey:@"distance"];
    [runMap setObject:[NSString stringWithFormat:@"%i",status] forKey:@"runStatus"];
    
    FBKAnalyticalNumber resultNumber = FBKRunningResultRealData;
    [self.delegate analyticalBleData:runMap withResultNumber:resultNumber];
}


@end

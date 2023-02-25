/********************************************************************************
 * 文件名称：FBKCadenceData.m
 * 内容摘要：踏频速度计算
 * 版本编号：1.0.1
 * 创建日期：2017年11月20日
 ********************************************************************************/

#import "FBKCadenceData.h"

#define   EffectiveTime   3.5

@implementation FBKCadenceData {
    NSMutableDictionary *m_zeroCadenceMap;
    NSMutableDictionary *m_zeroSpeedMap;
    NSMutableDictionary *m_beforCadenceeMap;
    NSMutableDictionary *m_beforSpeedeMap;
    double m_beforeCadence;
    double m_beforeSpeed;
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
    m_zeroCadenceMap = [[NSMutableDictionary alloc] init];
    m_zeroSpeedMap = [[NSMutableDictionary alloc] init];
    m_beforCadenceeMap = [[NSMutableDictionary alloc] init];
    m_beforSpeedeMap = [[NSMutableDictionary alloc] init];
    m_beforeCadence = -1.0;
    m_beforeSpeed = -1.0;
    
    self.whellDiameter = 2.096;
    return self;
}


/********************************************************************************
 * 方法名称：clearCadenceData
 * 功能描述：重新计数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)clearCadenceData {
    [m_zeroCadenceMap removeAllObjects];
    [m_beforCadenceeMap removeAllObjects];
    m_beforeCadence = -1.0;
}


/********************************************************************************
 * 方法名称：clearSpeedData
 * 功能描述：重新计数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)clearSpeedData {
    [m_zeroSpeedMap removeAllObjects];
    [m_beforSpeedeMap removeAllObjects];
    m_beforeSpeed = -1.0;
}


/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)calculationDeviceData:(NSDictionary *)cadenceMap {
    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
    NSDictionary *cadenceData = [self calculationCadence:cadenceMap];
    NSDictionary *speedData = [self calculationSpeed:cadenceMap];
    [resultMap addEntriesFromDictionary:cadenceData];
    [resultMap addEntriesFromDictionary:speedData];
    return resultMap;
}


/********************************************************************************
 * 方法名称：calculationCadence
 * 功能描述：计算踏频
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)calculationCadence:(NSDictionary *)cadenceMap {
    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
    double cadenceNum = 0;
    
    if (m_beforCadenceeMap.allKeys.count == 0) {
        [resultMap setObject:[NSString stringWithFormat:@"%f",-1.0] forKey:@"cadence"];
        if ([cadenceMap objectForKey:@"cadenceCount"] != nil) {
            [m_beforCadenceeMap removeAllObjects];
            [m_beforCadenceeMap addEntriesFromDictionary:cadenceMap];
        }
    }
    else {
        if ([cadenceMap objectForKey:@"cadenceCount"] != nil) {
            double timestamps   = [[m_beforCadenceeMap objectForKey:@"timestamps"] doubleValue];
            double cadenceCount = [[m_beforCadenceeMap objectForKey:@"cadenceCount"] doubleValue];
            double cadenceTime  = [[m_beforCadenceeMap objectForKey:@"cadenceTime"] doubleValue];
            
            double timestampsNow   = [[cadenceMap objectForKey:@"timestamps"] doubleValue];
            double cadenceCountNow = [[cadenceMap objectForKey:@"cadenceCount"] doubleValue];
            double cadenceTimeNow  = [[cadenceMap objectForKey:@"cadenceTime"] doubleValue];
            
            if (timestampsNow-timestamps < EffectiveTime) {
                double myCadenceCount = [self byteOverflow:cadenceCountNow-cadenceCount andBitNumber:2];
                double myCadenceTime = [self byteOverflow:cadenceTimeNow-cadenceTime andBitNumber:2];
                
                if (myCadenceTime != 0) {
                    cadenceNum = myCadenceCount / (myCadenceTime/1024) * 60;
                }
            }
            
            [m_beforCadenceeMap removeAllObjects];
            [m_beforCadenceeMap addEntriesFromDictionary:cadenceMap];
            
            if (cadenceNum == 0) {
                BOOL canZero = false;
                if (m_zeroCadenceMap.allKeys.count > 0) {
                    double timestampsZone = [[m_zeroCadenceMap objectForKey:@"timestamps"] doubleValue];
                    if (timestampsNow - timestampsZone > EffectiveTime) {
                        canZero = true;
                    }
                }
                else {
                    [m_zeroCadenceMap addEntriesFromDictionary:m_beforCadenceeMap];
                }
                
                if (!canZero) {
                    cadenceNum = m_beforeCadence;
                }
                
                m_beforeCadence = cadenceNum;
                [resultMap setObject:[NSString stringWithFormat:@"%f",cadenceNum] forKey:@"cadence"];
            }
            else {
//                if (cadenceNum > 120 && cadenceNum-m_beforeCadence > 50) {
//                    cadenceNum = m_beforeCadence;
//                    [self clearCadenceData];
//                }
//
//                if (cadenceNum > 300) {
//                    cadenceNum = m_beforeCadence;
//                }
//
                m_beforeCadence = cadenceNum;
                [resultMap setObject:[NSString stringWithFormat:@"%f",cadenceNum] forKey:@"cadence"];
                
                if (m_zeroCadenceMap.allKeys.count > 0) {
                    [m_zeroCadenceMap removeAllObjects];
                }
            }
        }
    }
    
    return resultMap;
}


/********************************************************************************
 * 方法名称：calculationSpeed
 * 功能描述：计算速度
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSDictionary *)calculationSpeed:(NSDictionary *)speedMap {
    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
    double distanceNum = 0;
    double speedNum = 0;
    
    if (m_beforSpeedeMap.allKeys.count == 0) {
        [resultMap setObject:[NSString stringWithFormat:@"%f",-1.0] forKey:@"speed"];
        [resultMap setObject:[NSString stringWithFormat:@"%f",-1.0] forKey:@"distance"];
        if ([speedMap objectForKey:@"wheelCount"] != nil) {
            [m_beforSpeedeMap removeAllObjects];
            [m_beforSpeedeMap addEntriesFromDictionary:speedMap];
        }
    }
    else {
        if ([speedMap objectForKey:@"wheelCount"] != nil) {
            double timestamps   = [[m_beforSpeedeMap objectForKey:@"timestamps"] doubleValue];
            double wheelCount   = [[m_beforSpeedeMap objectForKey:@"wheelCount"] doubleValue];
            double wheelTime    = [[m_beforSpeedeMap objectForKey:@"wheelTime"] doubleValue];
            
            double timestampsNow   = [[speedMap objectForKey:@"timestamps"] doubleValue];
            double wheelCountNow   = [[speedMap objectForKey:@"wheelCount"] doubleValue];
            double wheelTimeNow    = [[speedMap objectForKey:@"wheelTime"] doubleValue];
            
            double myWheelCount = [self byteOverflow:wheelCountNow-wheelCount andBitNumber:4];
            double myWheelTime = [self byteOverflow:wheelTimeNow-wheelTime andBitNumber:2];
            distanceNum = myWheelCount * self.whellDiameter;
            
            if (timestampsNow-timestamps < EffectiveTime) {
                if (myWheelTime != 0) {
                    speedNum = distanceNum / (myWheelTime/1024); // m/s
                }
            }
            
            [m_beforSpeedeMap removeAllObjects];
            [m_beforSpeedeMap addEntriesFromDictionary:speedMap];
            
            if (speedNum == 0) {
                BOOL canZero = false;
                if (m_zeroSpeedMap.allKeys.count > 0) {
                    double timestampsZone = [[m_zeroSpeedMap objectForKey:@"timestamps"] doubleValue];
                    if (timestampsNow - timestampsZone > EffectiveTime) {
                        canZero = true;
                    }
                }
                else {
                    [m_zeroSpeedMap addEntriesFromDictionary:m_beforSpeedeMap];
                }
                
                if (!canZero) {
                    speedNum = m_beforeSpeed;
                }
                
                m_beforeSpeed = speedNum;
                [resultMap setObject:[NSString stringWithFormat:@"%f",speedNum] forKey:@"speed"];
            }
            else {
//                if (speedNum > 20 && speedNum-m_beforeSpeed > 15) {
//                    speedNum = m_beforeSpeed;
//                    [self clearSpeedData];
//                }
//
//                if (speedNum > 120) {
//                    speedNum = m_beforeSpeed;
//                }
//
                m_beforeSpeed = speedNum;
                [resultMap setObject:[NSString stringWithFormat:@"%f",speedNum] forKey:@"speed"];
                
                if (m_zeroSpeedMap.allKeys.count > 0) {
                    [m_zeroSpeedMap removeAllObjects];
                }
            }
    
        }
    }
    
    [resultMap setObject:[NSString stringWithFormat:@"%f",distanceNum] forKey:@"distance"];
    return resultMap;
}


/*-*******************************************************************************
* Method: byteOverflow
* Description: byteOverflow
* Parameter:
* Return Data:
*********************************************************************************/
- (float)byteOverflow:(float)value andBitNumber:(int)bitNumber {
    float hiNum = 0;
    float resultNum = value;
    
    if (bitNumber == 4) {
        int tww = 255;
        hiNum = (tww<<24)+(tww<<16)+(tww<<8)+tww;
    }
    else if (bitNumber == 2) {
        hiNum = 65535;
    }
    
    if (value < 0) {
        resultNum = value+hiNum;
    }
    
    return resultNum;
}


@end

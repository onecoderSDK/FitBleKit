/********************************************************************************
* 文件名称：FBKApiBroadcastScale.m
* 内容摘要：广播蓝牙秤API
* 版本编号：1.0.1
* 创建日期：2019年10月10日
********************************************************************************/

#import "FBKApiBroadcastScale.h"
#import "FBKSpliceBle.h"

@implementation FBKApiBroadcastScale {
    FBKApiScanDevices *m_scanner;
    int m_countTime;
    int m_timeout;
    DeviceIdType m_deviceIdType;
    NSTimer *m_timeOutTimer;
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
    self.deviceId = [[NSString alloc] init];
    self.deviceId = @"";
    self.deviceType = BleDeviceBroadScale;
    self.isConnected = NO;
    m_timeout = 8;
    m_countTime = 0;
    m_deviceIdType = DeviceIdUUID;
    return self;
}


/********************************************************************************
 * 方法名称：startTimer
 * 功能描述：开启计时
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startTimer {
    if (m_timeOutTimer != nil) {
        [m_timeOutTimer invalidate];
        m_timeOutTimer = nil;
    }
    m_timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(countTime)
                                                  userInfo:nil
                                                   repeats:YES];
}


/********************************************************************************
* 方法名称：countTime
* 功能描述：计时
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)countTime {
    m_countTime = m_countTime - 1;
    if (m_countTime < -1) {
        m_countTime = -1;
    }
    if (m_countTime == 0) {
        self.isConnected = NO;
        [self.delegate bleConnectStatus:DeviceBleDisconneced andDevice:self];
    }
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startConnectBleApi
 * 功能描述：开始连接蓝牙设备
 * 输入参数：deviceId-设备ID  seconds-超时时间（最小8秒）  type-设备类型
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleApi:(NSString *)deviceId timeout:(int)seconds andIdType:(DeviceIdType)idType {
    self.deviceId = deviceId;
    m_deviceIdType = idType;
    if (seconds >= 8) {
        m_timeout = seconds;
    }
    
    m_scanner = [[FBKApiScanDevices alloc] init];
    m_scanner.delegate = self;
    [self startTimer];
    [self.delegate bleConnectStatus:DeviceBleConnecting andDevice:self];
}


/********************************************************************************
 * 方法名称：disconnectBleApi
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleApi {
    self.deviceId = @"";
    m_deviceIdType = DeviceIdUUID;
    [m_scanner stopScanBleApi];
    m_scanner = nil;
    
    if (m_timeOutTimer != nil) {
        [m_timeOutTimer invalidate];
        m_timeOutTimer = nil;
    }
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
* 方法名称：phoneBleStatus
* 功能描述：手机蓝牙状态
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)phoneBleStatus:(BOOL)isPoweredOn {
    if (isPoweredOn) {
        [self.delegate bleConnectStatus:DeviceBleIsOpen andDevice:self];
        [m_scanner startScanBleApi:nil isRealTimeDevice:YES withRssi:120];
    }
    else {
        [self.delegate bleConnectStatus:DeviceBleClosed andDevice:self];
    }
}

/********************************************************************************
* 方法名称：getDeviceList
* 功能描述：设备列表
* 输入参数：
* 返回数据：
********************************************************************************/
- (void)getDeviceList:(NSArray *)deviceList {
    if (deviceList.count == 1) {
        CBPeripheral *nowPeripheral = [[deviceList objectAtIndex:0] objectForKey:@"peripheral"];
        NSDictionary *advertisementData = [[deviceList objectAtIndex:0] objectForKey:@"advertisementData"];
        NSData *byteData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
        [self analyticalXinHaiScale:byteData withUuid:nowPeripheral.identifier.UUIDString];
    }
}


/********************************************************************************
 * 方法名称：analyticalXinHaiScale
 * 功能描述：解析芯海设备数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalXinHaiScale:(NSData *)byteData withUuid:(NSString *)uuidString {
    const uint8_t *resultBytes = [byteData bytes];
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    if (byteData.length >= 15) {
        int scaleKey = resultBytes[0]&0xFF;
        
        if (scaleKey == 202) {
            // 异或校验
            int dataLength = resultBytes[2]&0xFF;
            int dataSum = resultBytes[dataLength+3]&0xFF;
            int addSum = 0;
            
            for (int i = 1; i < dataLength+3; i++) {
                addSum^=resultBytes[i]&0xFF;
            }
            
            if (dataSum == addSum) {
                // 设备版本号
                int version = resultBytes[1]&0xFF;
                NSString *versionString = [NSString stringWithFormat:@"V%i.%i",(version/16),(version%16)];
                
                // 设备版ID
//                long int id3 = resultBytes[3]&0xFF;
//                long int id4 = resultBytes[4]&0xFF;
//                long int id5 = resultBytes[5]&0xFF;
//                long int id6 = resultBytes[6]&0xFF;
//                NSString *idNumber = [NSString stringWithFormat:@"%@%.10ld",XINHAI_BROADCAST_SCALE,id6+(id5<<8)+(id4<<16)+(id3<<24)];
                
                // 设备类型  0-体重秤  1-体脂秤
                int type = resultBytes[7]&0xFF;
                NSString *typeString = [NSString stringWithFormat:@"%i",type];
                
                // 消息体属性
                int bodyNum = resultBytes[8]&0xFF;
                
                // 数据类型  0-广播数据  1-测量数据
                int dataType = [FBKSpliceBle getBitNumber:bodyNum andStart:0 withStop:0];
                NSString *dataTypeString = [NSString stringWithFormat:@"%i",dataType];
                
                // 小数位数  0-1位小数  1-0位小数  2-2位小数
                int decimal = [FBKSpliceBle getBitNumber:bodyNum andStart:1 withStop:2];
                
                // 单位  0-KG  1-斤  2-LB  3-ST:LB
                int units = [FBKSpliceBle getBitNumber:bodyNum andStart:3 withStop:4];
                NSString *unitString = @"KG";
                
                // 测量流水号（依次增加，到255后 又从1开始流水，0保留）
                int sortNumber = resultBytes[9]&0xFF;
                NSString *sortString = [NSString stringWithFormat:@"%i",sortNumber];
                
                // 重量
                int weightHi = resultBytes[10]&0xFF;
                int weightLow = resultBytes[11]&0xFF;
                int weight = weightLow+(weightHi<<8);
                float weightNumber = (float)weight;
                
                if (units == 0) {
                    weightNumber = weightNumber;
                }
                else if (units == 1) {
                    weightNumber = weightNumber/2;
                }
                else if (units == 2) {
                    weightNumber = weightNumber*0.45359;
                }
                else if (units == 3) {
                    weightNumber = weightHi*6.35+weightLow/10*0.45359;
                }
                
                if (decimal == 0) {
                    weightNumber = weightNumber/10;
                }
                else if (decimal == 1) {
                    weightNumber = weightNumber;
                }
                else if (decimal == 2) {
                    weightNumber = weightNumber/100;
                }
                
                NSString *weightString = [NSString stringWithFormat:@"%.2f",weightNumber];
                
                // 阻抗
                int impedanceHi = resultBytes[12]&0xFF;
                int impedanceLow = resultBytes[13]&0xFF;
                int impedance = impedanceLow+(impedanceHi<<8);
                float impedanceNumber = (float)impedance/10;
                NSString *impedanceString = [NSString stringWithFormat:@"%.1f",impedanceNumber];
                
                [resultDic setObject:versionString forKey:@"version"];
                [resultDic setObject:uuidString forKey:@"scaleId"];
                [resultDic setObject:typeString forKey:@"type"];
                [resultDic setObject:dataTypeString forKey:@"dataType"];
                [resultDic setObject:unitString forKey:@"units"];
                [resultDic setObject:sortString forKey:@"sortNumber"];
                [resultDic setObject:weightString forKey:@"weight"];
                [resultDic setObject:impedanceString forKey:@"impedance"];
                
                if ([uuidString isEqualToString:self.deviceId]) {
                    m_countTime = m_timeout;
                    if (!self.isConnected) {
                        self.isConnected = YES;
                        [self.delegate bleConnectStatus:DeviceBleConnected andDevice:self];
                        [self.delegate scaleVersion:versionString andDevice:self];
                    }
                    
                    if (weight > 0) {
                        [self.delegate weightData:resultDic andDevice:self];
                    }
                }
            }
        }
    }
}


@end

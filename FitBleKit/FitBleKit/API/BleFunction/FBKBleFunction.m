/********************************************************************************
 * 文件名称：FBKBleFunction.h
 * 内容摘要：Ble Function
 * 版本编号：1.0.1
 * 创建日期：2021年04月22日
 ********************************************************************************/

#import "FBKBleFunction.h"
#import "FBKSpliceBle.h"

@implementation FBKFunction

- (id)init {
    self = [super init];
    self.functionType = FunctionTypeOld;
    self.isHR  = false;
    self.isHRV = false;
    self.isECG = false;
    self.haveRecord = false;
    return self;
}

@end


@implementation FBKBleFunction {
    BOOL m_isHaveHRV;
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
    self.deviceType = BleDeviceFunction;
    [self.managerController setManagerDeviceType:BleDeviceFunction];
    m_isHaveHRV = false;
    self.checkTime = 0.5;
    return self;
}


#pragma mark - **************************** 协议回调 *****************************
/********************************************************************************
 * 方法名称：analyticalData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    FBKAnalyticalNumber resultType = (FBKAnalyticalNumber)resultNumber;
    if (resultType == FBKECGResultRealHR) {
        NSDictionary *dataMap = (NSDictionary *)resultData;
        NSArray *hrvArray = [dataMap objectForKey:@"interval"];
        if (hrvArray != nil) {
            if (hrvArray.count > 0) {
                m_isHaveHRV = true;
            }
        }
    }
}


/********************************************************************************
 * 方法名称：蓝牙连接状态
 * 功能描述：bleConnectStatus
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status {
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    
    if (status == DeviceBleDisconneced) {
        m_isHaveHRV = false;
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


/********************************************************************************
 * 方法名称：UUIDS
 * 功能描述：bleConnectUuids
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectUuids:(NSArray *)charUuidArray {
    BOOL isHave2A37 = false;
    BOOL isHaveFC20 = false;
    BOOL isHaveFD19 = false;
    BOOL isHaveEC09 = false;
    
    for (int i = 0; i < charUuidArray.count; i++) {
        CBCharacteristic *charac = [charUuidArray objectAtIndex:i];
        if ([FBKSpliceBle compareUuid:charac.UUID withUuid:FBKHEARTRATENOTIFY2A37]) {
            isHave2A37 = true;
        }
        else if ([FBKSpliceBle compareUuid:charac.UUID withUuid:FBKOLDBANDNOTIFYFC20]) {
            isHaveFC20 = true;
        }
        else if ([FBKSpliceBle compareUuid:charac.UUID withUuid:FBKARMBANDNOTIFYFD19]) {
            isHaveFD19 = true;
        }
        else if ([FBKSpliceBle compareUuid:charac.UUID withUuid:ECG_NOTIFY_UUID]) {
            isHaveEC09 = true;
        }
    }
    
    double delayInSeconds = self.checkTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        FBKFunction *myFunction = [[FBKFunction alloc] init];
        
        if (isHave2A37 || isHaveEC09) {
            if (isHaveEC09) {
                myFunction.functionType = FunctionTypeECG;
                myFunction.haveRecord = false;
                myFunction.isHR = isHave2A37;
                myFunction.isHRV = isHave2A37;
                myFunction.isECG = true;
            }
            else {
                if (isHaveFC20) {
                    myFunction.functionType = FunctionTypeOld;
                    myFunction.haveRecord = true;
                    myFunction.isHR = true;
                    myFunction.isHRV = true;
                    myFunction.isECG = false;
                }
                else if (isHaveFD19) {
                    myFunction.functionType = FunctionTypeNew;
                    myFunction.haveRecord = true;
                    myFunction.isHR = true;
                    myFunction.isHRV = true;
                    myFunction.isECG = false;
                }
                else {
                    myFunction.functionType = FunctionTypeOld;
                    myFunction.haveRecord = false;
                    myFunction.isHR = true;
                    myFunction.isHRV = true;
                    myFunction.isECG = false;
                }
            }
        }
        else {
            myFunction.functionType = FunctionTypeOther;
            myFunction.haveRecord = false;
            myFunction.isHR = false;
            myFunction.isHRV = false;
            myFunction.isECG = false;
        }
        
        [self.delegate deviceFunction:myFunction andDevice:self];
        [self disconnectBleApi];
    });
}


@end

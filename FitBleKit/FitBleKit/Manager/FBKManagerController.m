/********************************************************************************
 * 文件名称：FBKManagerController.h
 * 内容摘要：调度层
 * 版本编号：1.0.1
 * 创建日期：2017年11月17日
 *******************************************************************************/

#import "FBKManagerController.h"
#import "FBKDeviceBaseInfo.h"
#import "FBKSpliceBle.h"

@implementation FBKManagerController
{
    NSString *m_deviceId;
    FBKDeviceBaseInfo *m_deviceBaseInfo;
    FBKManagerCmd *m_managerCmd;
    FBKManagerAnaly *m_managerAnaly;
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
    
    m_deviceId = [[NSString alloc] init];
    m_deviceBaseInfo = [[FBKDeviceBaseInfo alloc] init];
    m_managerCmd = [[FBKManagerCmd alloc] init];
    m_managerAnaly = [[FBKManagerAnaly alloc] init];
    self.bleController = [[FBKBleController alloc] init];
    self.bleController.delegate = self;
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：setDeviceType
 * 功能描述：设置设备类型
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setManagerDeviceType:(BleDeviceType)type
{
    self.deviceType = type;
    
    switch (type) {
            
        case BleDeviceNewBand:
        {
            FBKProtocolNTracker *bandNew = [[FBKProtocolNTracker alloc] init];
            bandNew.delegate = self;
            self.protocolBase = bandNew;
            break;
        }
            
        case BleDeviceNewScale:
        {
            FBKProtocolNScale *scaleNew = [[FBKProtocolNScale alloc] init];
            scaleNew.delegate = self;
            self.protocolBase = scaleNew;
            break;
        }
            
        case BleDeviceOldScale:
        {
            FBKProtocolOldScale *scaleOld = [[FBKProtocolOldScale alloc] init];
            scaleOld.delegate = self;
            self.protocolBase = scaleOld;
            break;
        }
            
        case BleDeviceSkipping:
        {
            FBKProtocolSkipping *skipping = [[FBKProtocolSkipping alloc] init];
            skipping.delegate = self;
            self.protocolBase = skipping;
            break;
        }
            
        case BleDeviceCadence:
        {
            FBKProtocolCadence *cadence = [[FBKProtocolCadence alloc] init];
            cadence.delegate = self;
            self.protocolBase = cadence;
            break;
        }
            
        case BleDeviceOldBand:
        {
            FBKProtocolOldBand *bandOld = [[FBKProtocolOldBand alloc] init];
            bandOld.delegate = self;
            self.protocolBase = bandOld;
            break;
        }
            
        case BleDeviceHeartRate:
        {
            FBKProtocolOldBand *heartRate = [[FBKProtocolOldBand alloc] init];
            heartRate.delegate = self;
            self.protocolBase = heartRate;
            break;
        }
            
        case BleDeviceRosary:
        {
            FBKProtocolRosary *rosary = [[FBKProtocolRosary alloc] init];
            rosary.delegate = self;
            self.protocolBase = rosary;
            break;
        }
            
        case BleDeviceBikeComputer:
        {
            FBKProtocolBikeComputer *bikeComputer = [[FBKProtocolBikeComputer alloc] init];
            bikeComputer.delegate = self;
            self.protocolBase = bikeComputer;
            break;
        }
            
        case BleDeviceArmBand:
        {
            FBKProtocolArmBand *ArmBand = [[FBKProtocolArmBand alloc] init];
            ArmBand.delegate = self;
            self.protocolBase = ArmBand;
            break;
        }
            
        case BleDeviceKettleBell:
        {
            FBKProtocolKettleBell *KettleBell = [[FBKProtocolKettleBell alloc] init];
            KettleBell.delegate = self;
            self.protocolBase = KettleBell;
            break;
        }
            
        case BleDeviceHubConfig:
        {
            FBKProtocolHubConfig *HubConfig = [[FBKProtocolHubConfig alloc] init];
            HubConfig.delegate = self;
            self.protocolBase = HubConfig;
            break;
        }
            
        case BleDeviceBoxing: {
            FBKProtocolBoxing *Boxing = [[FBKProtocolBoxing alloc] init];
            Boxing.delegate = self;
            self.protocolBase = Boxing;
            break;
        }
            
        case BleDevicePower: {
            FBKProtocolPower *power = [[FBKProtocolPower alloc] init];
            power.delegate = self;
            self.protocolBase = power;
            break;
        }
            
        case BleDeviceECG: {
            FBKProtocolECG *ecg = [[FBKProtocolECG alloc] init];
            ecg.delegate = self;
            self.protocolBase = ecg;
            break;
        }
            
        case BleDeviceFunction: {
            FBKProtocolECG *ecg = [[FBKProtocolECG alloc] init];
            ecg.delegate = self;
            self.protocolBase = ecg;
            break;
        }
            
        case BleDeviceRunning: {
            FBKProtocolRun *run = [[FBKProtocolRun alloc] init];
            run.delegate = self;
            self.protocolBase = run;
            break;
        }
            
        case BleDevicePPGDFU: {
            FBKProtocolPPG *PPG = [[FBKProtocolPPG alloc] init];
            PPG.delegate = self;
            self.protocolBase = PPG;
            break;
        }
            
        case BleDeviceFight: {
            FBKProtocolFight *fightClass = [[FBKProtocolFight alloc] init];
            fightClass.delegate = self;
            self.protocolBase = fightClass;
            break;
        }
            
        default: {
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：startConnectBleApi
 * 功能描述：开始连接蓝牙设备
 * 输入参数：deviceId-设备ID
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleManage:(NSString *)deviceId withDeviceType:(BleDeviceType)type andIdType:(DeviceIdType)idType
{
    m_deviceId = deviceId;
    self.protocolBase.delegate = self;
    [self.bleController startConnectBleDevice:nil withDeviceId:deviceId andDeviceType:self.deviceType compareWithIdType:idType];
}


/********************************************************************************
 * 方法名称：disconnectBleManage
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleManage
{
    self.isConnected = NO;
    self.protocolBase.delegate = nil;
    [self.bleController disconnectBleDevice];
}


/********************************************************************************
 * 方法名称：editCharacteristicNotifyApi
 * 功能描述：操作通道状态
 * 输入参数：status-开关
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotifyManage:(BOOL)status withCharacteristic:(NSString *)uuid
{
    [self.bleController editCharacteristicNotify:uuid withStatus:status];
}


/********************************************************************************
 * 方法名称：readCharacteristicApi
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristicManage:(NSString *)uuid
{
    [self.bleController readCharacteristic:uuid];
}


/********************************************************************************
 * 方法名称：getPrivateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getPrivateVersion {
    NSData *byteData = [m_managerCmd deviceVersionInfoCmd];
    [self.bleController writeByte:byteData sendCharacteristic:FBK_DEVICE_OTA_WRITE writeWithResponse:false];
}


/********************************************************************************
 * 方法名称：getPrivateMacAddress
 * 功能描述：获取私有Mac地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getPrivateMacAddress {
    NSData *byteData = [m_managerCmd deviceMacAddressCmd];
    [self.bleController writeByte:byteData sendCharacteristic:FBK_DEVICE_OTA_WRITE writeWithResponse:false];
}


/********************************************************************************
 * 方法名称：getOtaCustomerName
 * 功能描述：获取客户名称
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getOtaCustomerName {
    NSData *byteData = [m_managerCmd customerNameCmd];
    [self.bleController writeByte:byteData sendCharacteristic:FBK_DEVICE_OTA_WRITE writeWithResponse:false];
}


/********************************************************************************
 * 方法名称：enterOTAMode
 * 功能描述：进入OTA模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterOTAMode {
    NSData *byteData = [m_managerCmd enterOTACmd];
    [self.bleController writeByte:byteData sendCharacteristic:FBK_DEVICE_OTA_WRITE writeWithResponse:false];
}


/********************************************************************************
 * 方法名称：readdeviceName
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSString *)readDeviceName {
    return self.bleController.deviceName;
}


/********************************************************************************
 * 方法名称：writeDataManage
 * 功能描述：写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeDataManage:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response
{
    [self.bleController writeByte:byteData sendCharacteristic:uuid writeWithResponse:response];
}


/********************************************************************************
 * 方法名称：receiveApiCmd
 * 功能描述：接收API命令
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)receiveApiCmd:(int)cmdNumber withObject:(id)object {
    if (!self.isConnected) {
        [self.delegate bleConnectError:@"Ble is disconnect"];
    }
    
    [self.protocolBase receiveBleCmd:cmdNumber withObject:object];
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接失败信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)errorInfo andDeviceType:(BleDeviceType)type
{
    [self.delegate bleConnectError:errorInfo];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDeviceType:(BleDeviceType)type {
    switch (status) {
        case DeviceBleConnected: {
            NSArray *uuidArray = [m_deviceBaseInfo getScanUuidArray:type andEditType:CharacteristicNotify];
            for (int i = 0; i < uuidArray.count; i++) {
                NSString *uuid = [NSString stringWithFormat:@"%@",[uuidArray objectAtIndex:i]];
                [self.bleController editCharacteristicNotify:uuid withStatus:YES];
            }
            
            [self.bleController editCharacteristicNotify:FBK_DEVICE_OTA_NOTIFY withStatus:YES];
            
            if (self.deviceType == BleDevicePower) {
                [self.protocolBase receiveBleCmd:GetCalibrationData withObject:@""];
            }
            
            break;
        }
            
        case DeviceBleReconnect:
            [self.protocolBase bleErrorReconnect];
            break;
            
        default:
            break;
    }
    
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    
    [self.delegate bleConnectStatus:status];
}


/********************************************************************************
 * 方法名称：bleConnectWriteStatus
 * 功能描述：蓝牙写入状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectWriteStatus:(BOOL)Succeed andDeviceType:(BleDeviceType)type
{
    
}


/********************************************************************************
 * 方法名称：bleConnectByteData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectByteData:(CBCharacteristic *)characteristic andDeviceType:(BleDeviceType)type {
    if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKALLDEVICEREPOWER]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerPower:[resultDic objectForKey:@"power"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICEREFIRMVERSION]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerFirmwareVersion:[resultDic objectForKey:@"firmwareVersion"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICEREHARDVERSION]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerHardwareVersion:[resultDic objectForKey:@"hardwareVersion"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBKDEVICERESOFTVERSION]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerSoftwareVersion:[resultDic objectForKey:@"softwareVersion"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_SYSTEMID]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerSystemData:[resultDic objectForKey:@"systemID"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_MODEL]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerModelString:[resultDic objectForKey:@"modelString"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_SERIAL]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerSerialNumber:[resultDic objectForKey:@"serialNumber"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICER_MANUFACTURER]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:[self.protocolBase receiveBaseData:characteristic]];
        [self.delegate deviceManagerManufacturerName:[resultDic objectForKey:@"manufacturerName"]];
        return;
    }
    else if ([FBKSpliceBle compareUuid:characteristic.UUID withUuid:FBK_DEVICE_OTA_NOTIFY]) {
        NSData *resultByte = characteristic.value;
        NSMutableDictionary *dataMap = [[NSMutableDictionary alloc] initWithDictionary:[m_managerAnaly analyMacVersion:resultByte]];
        NSString *keyString = [dataMap objectForKey:@"key"];
        if (keyString != nil) {
            if ([keyString isEqualToString:@"0"]) {
                [dataMap removeObjectForKey:@"key"];
                [self.delegate analyCommonData:dataMap withResultNumber:AllDeviceMacAddress];
            }
            else if ([keyString isEqualToString:@"1"]) {
                [dataMap removeObjectForKey:@"key"];
                [self.delegate analyCommonData:dataMap withResultNumber:AllDeviceVersion];
            }
            else if ([keyString isEqualToString:@"2"]) {
                [dataMap removeObjectForKey:@"key"];
                [self.delegate analyCommonData:dataMap withResultNumber:AllDeviceCustomerName];
            }
        }
        
        if (self.deviceType != BleDeviceArmBand && self.deviceType != BleDeviceECG && self.deviceType != BleDevicePower && self.deviceType != BleDevicePPGDFU && self.deviceType != BleDeviceHeartRate && self.deviceType != BleDeviceBoxing) {
            return;
        }
    }
    
    [self.protocolBase receiveBleData:characteristic.value withUuid:characteristic.UUID];
}


/********************************************************************************
 * 方法名称：bleConnectByteData
 * 功能描述：蓝牙结果数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectUuids:(NSArray *)charUuidArray andDeviceType:(BleDeviceType)type {
    [self.delegate bleConnectUuids:charUuidArray];
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：蓝牙LOG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)device {
    [self.delegate bleConnectLog:logString andDevice:self];
}


#pragma mark - **************************** 解析回调 *****************************
/********************************************************************************
 * 方法名称：writeBleByte
 * 功能描述：向蓝牙写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeBleByte:(NSData *)byteData {
    NSArray *uuidArray = [m_deviceBaseInfo getScanUuidArray:self.deviceType andEditType:CharacteristicWrite];
    
    if (uuidArray.count > 0 && self.isConnected) {
        if (self.deviceType == BleDevicePower) {
            NSString *uuid = [NSString stringWithFormat:@"%@",[uuidArray objectAtIndex:0]];
            [self.bleController writeByte:byteData sendCharacteristic:uuid writeWithResponse:true];
            return;
        }
        
        NSString *uuid = [NSString stringWithFormat:@"%@",[uuidArray objectAtIndex:0]];
        [self.bleController writeByte:byteData sendCharacteristic:uuid writeWithResponse:NO];
    }
}


/********************************************************************************
 * 方法名称：writeSpliceByte
 * 功能描述：向蓝牙写入特殊数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeSpliceByte:(NSData *)byteData withUuid:(NSString *)uuidString {
    [self.bleController writeByte:byteData sendCharacteristic:uuidString writeWithResponse:NO];
}


/********************************************************************************
 * 方法名称：analyticalBleData
 * 功能描述：解析完成的Ble数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalBleData:(id)resultData withResultNumber:(int)resultNumber
{    
    [self.delegate analyticalData:resultData withResultNumber:resultNumber];
}


/********************************************************************************
 * 方法名称：synchronizationStatus
 * 功能描述：大数据同步状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)synchronizationStatus:(DeviceBleStatus)status
{
    [self.delegate bleConnectStatus:status];
}


@end


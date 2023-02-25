/********************************************************************************
 * 文件名称：FBKApiBsaeMethod.m
 * 内容摘要：API基础类
 * 版本编号：1.0.1
 * 创建日期：2017年11月08日
 ********************************************************************************/

#import "FBKApiBsaeMethod.h"

@implementation FBKApiBsaeMethod {
    FBKApiBaseInfo *m_baseInfo;
    FBKApiBaseInfoStatus *m_baseInfoStatus;
    int  m_baseInfoCmdNumber;
    BOOL m_isGetBaseInfo;
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
    self.managerController = [[FBKManagerController alloc] init];
    self.managerController.delegate = self;
    self.deviceId = [[NSString alloc] init];
    
    m_baseInfo = [[FBKApiBaseInfo alloc] init];
    m_baseInfoStatus = [[FBKApiBaseInfoStatus alloc] init];
    m_baseInfoCmdNumber = 11;
    m_isGetBaseInfo = false;
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startConnectBleApi
 * 功能描述：开始连接蓝牙设备
 * 输入参数：deviceId-设备ID   type-设备类型
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType
{
    self.deviceId = deviceId;
    [self.managerController startConnectBleManage:deviceId withDeviceType:self.deviceType andIdType:idType];
}


/********************************************************************************
 * 方法名称：disconnectBleApi
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleApi
{
    [self.managerController disconnectBleManage];
}


/********************************************************************************
 * 方法名称：editCharacteristicNotifyApi
 * 功能描述：操作通道状态
 * 输入参数：status-开关
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotifyApi:(BOOL)status  withCharacteristic:(NSString *)uuid
{
    [self.managerController editCharacteristicNotifyManage:status withCharacteristic:uuid];
}


/********************************************************************************
 * 方法名称：readCharacteristicApi
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristicApi:(NSString *)uuid
{
    [self.managerController readCharacteristicManage:uuid];
}


/********************************************************************************
 * 方法名称：writeData
 * 功能描述：写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeData:(NSData *)byteData withCharacteristic:(NSString *)uuid writeWithResponse:(BOOL)response
{
    if (!self.isConnected)
    {
        [self.dataSource bleConnectError:@"Ble is disconnect" andDevice:self];
        return;
    }
    
    [self.managerController writeDataManage:byteData withCharacteristic:uuid writeWithResponse:response];
}


/********************************************************************************
 * 方法名称：readDevicePower
 * 功能描述：获取电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readDevicePower
{
    [self readCharacteristicApi:FBKALLDEVICEREPOWER];
}


/********************************************************************************
 * 方法名称：readFirmwareVersion
 * 功能描述：获取固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readFirmwareVersion {
    [self readCharacteristicApi:FBKDEVICEREFIRMVERSION];
}


/********************************************************************************
 * 方法名称：readHardwareVersion
 * 功能描述：获取硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readHardwareVersion {
    [self readCharacteristicApi:FBKDEVICEREHARDVERSION];
}


/********************************************************************************
 * 方法名称：readSoftwareVersion
 * 功能描述：获取软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readSoftwareVersion {
    [self readCharacteristicApi:FBKDEVICERESOFTVERSION];
}


/********************************************************************************
 * 方法名称：readSystemId
 * 功能描述：获取System Id
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readSystemId {
    [self readCharacteristicApi:FBK_DEVICER_SYSTEMID];
}


/********************************************************************************
 * 方法名称：readModelString
 * 功能描述：获取Model String
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readModelString {
    [self readCharacteristicApi:FBK_DEVICER_MODEL];
}


/********************************************************************************
 * 方法名称：readSerialNumber
 * 功能描述：获取序列号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readSerialNumber {
    [self readCharacteristicApi:FBK_DEVICER_SERIAL];
}


/********************************************************************************
 * 方法名称：readManufacturerName
 * 功能描述：获取制造商信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readManufacturerName {
    [self readCharacteristicApi:FBK_DEVICER_MANUFACTURER];
}

/********************************************************************************
 * 方法名称：getPrivateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getPrivateVersion {
    [self.managerController getPrivateVersion];
}


/********************************************************************************
 * 方法名称：getPrivateMacAddress
 * 功能描述：获取私有Mac地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getPrivateMacAddress {
    [self.managerController getPrivateMacAddress];
}


/********************************************************************************
 * 方法名称：getOtaCustomerName
 * 功能描述：获取客户名称
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getOtaCustomerName {
    [self.managerController getOtaCustomerName];
}


/********************************************************************************
 * 方法名称：enterOTAMode
 * 功能描述：进入OTA模式
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterOTAMode {
    [self.managerController enterOTAMode];
}


/********************************************************************************
* 方法名称：readDeviceName
* 功能描述：
* 输入参数：
* 返回数据：
********************************************************************************/
- (NSString *)readDeviceName {
    return [self.managerController readDeviceName];
}


/*-********************************************************************************
* Method: getDeviceBaseInfo
* Description: getDeviceBaseInfo
* Parameter:
* Return Data:
***********************************************************************************/
- (void)getDeviceBaseInfo {
    m_baseInfo = [[FBKApiBaseInfo alloc] init];
    m_baseInfoStatus = [[FBKApiBaseInfoStatus alloc] init];
    m_isGetBaseInfo = true;
    [self sendBaseInfoCmd];
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：蓝牙连接状态
 * 功能描述：bleConnectStatus
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status
{
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed)
    {
        self.isConnected = YES;
    }
    else
    {
        self.isConnected = NO;
    }
    
    [self.dataSource bleConnectStatus:status andDevice:self];
}


/********************************************************************************
 * 方法名称：蓝牙连接错误信息
 * 功能描述：bleConnectError
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error
{
    [self.dataSource bleConnectError:error andDevice:self];
}


/********************************************************************************
 * 方法名称：UUIDS
 * 功能描述：bleConnectUuids
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectUuids:(NSArray *)charUuidArray {
    
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：bleConnectLog
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)device {
    [self.dataSource bleConnectLog:logString andDevice:self];
}


/********************************************************************************
 * 方法名称：蓝牙结果数据
 * 功能描述：analyticalData
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyCommonData:(id)resultData withResultNumber:(int)resultNumber {
    AllDeviceResult resultType = (AllDeviceResult)resultNumber;
    if (resultType == AllDeviceVersion) {
        NSDictionary *resultMap = (NSDictionary *)resultData;
        if (m_isGetBaseInfo){
            if (!m_baseInfoStatus.getCmdVersion) {
                NSString *firmwareVersion = [resultMap objectForKey:@"firmwareVersion"];
                NSString *hardwareVersion = [resultMap objectForKey:@"hardwareVersion"];
                NSString *softwareVersion = [resultMap objectForKey:@"softwareVersion"];
                m_baseInfoStatus.getCmdVersion = true;
                m_baseInfo.firmVersion = firmwareVersion;
                m_baseInfo.hardVersion = hardwareVersion;
                m_baseInfo.softVersion = softwareVersion;
                [self sendBaseInfoCmd];
            }
            return;
        }
        
        [self.dataSource privateVersion:resultMap andDevice:self];
    }
    else if (resultType == AllDeviceMacAddress) {
        NSDictionary *resultMap = (NSDictionary *)resultData;
        if (m_isGetBaseInfo){
            if (!m_baseInfoStatus.getCmdMac) {
                NSString *macString = [resultMap objectForKey:@"macString"];
                NSString *OTAMacString = [resultMap objectForKey:@"OTAMacString"];
                m_baseInfoStatus.getCmdMac = true;
                m_baseInfo.deviceMac = macString;
                m_baseInfo.dfuMac = OTAMacString;
                [self sendBaseInfoCmd];
            }
            return;
        }
        
        [self.dataSource privateMacAddress:resultMap andDevice:self];
    }
    else if (resultType == AllDeviceCustomerName) {
        NSDictionary *dataMap = (NSDictionary *)resultData;
        NSString *customerName = @"";
        if ([dataMap objectForKey:@"customerName"] != nil) {
            customerName = [dataMap objectForKey:@"customerName"];
        }
        
        if (m_isGetBaseInfo){
            if (!m_baseInfoStatus.getCmdCustomer) {
                m_baseInfoStatus.getCmdCustomer = true;
                m_baseInfo.customerName = customerName;
                [self sendBaseInfoCmd];
            }
            return;
        }
    }
}


/********************************************************************************
 * 方法名称：蓝牙结果数据
 * 功能描述：analyticalData
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    
}


/********************************************************************************
 * 方法名称：获取电量
 * 功能描述：deviceManagerPower
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerPower:(NSString *)powerInfo {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readBattery) {
            m_baseInfoStatus.readBattery = true;
            m_baseInfo.battery = [powerInfo intValue];
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource devicePower:powerInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取固件版本号
 * 功能描述：deviceManagerFirmwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerFirmwareVersion:(NSString *)versionInfo {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readFirmVersion) {
            m_baseInfoStatus.readFirmVersion = true;
            m_baseInfo.firmVersion = versionInfo;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceFirmware:versionInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取硬件版本号
 * 功能描述：deviceManagerHardwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerHardwareVersion:(NSString *)versionInfo {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readHardVersion) {
            m_baseInfoStatus.readHardVersion = true;
            m_baseInfo.hardVersion = versionInfo;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceHardware:versionInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取软件版本号
 * 功能描述：deviceManagerSoftwareVersion
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerSoftwareVersion:(NSString *)versionInfo {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readSoftVersion) {
            m_baseInfoStatus.readSoftVersion = true;
            m_baseInfo.softVersion = versionInfo;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceSoftware:versionInfo andDevice:self];
}


/********************************************************************************
 * 方法名称：获取SystemID
 * 功能描述：deviceManagerSystemData
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerSystemData:(NSData *)systemData {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readSystemId) {
            m_baseInfoStatus.readSystemId = true;
            m_baseInfo.systemId = systemData;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceSystemData:systemData andDevice:self];
}


/********************************************************************************
 * 方法名称：获取Model String
 * 功能描述：deviceManagerModelString
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerModelString:(NSString *)modelString {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readModel) {
            m_baseInfoStatus.readModel = true;
            m_baseInfo.modelString = modelString;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceModelString:modelString andDevice:self];
}


/********************************************************************************
 * 方法名称：获取序列号
 * 功能描述：deviceManagerSerialNumber
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerSerialNumber:(NSString *)serialNumber {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readSerial) {
            m_baseInfoStatus.readSerial = true;
            m_baseInfo.serialNumber = serialNumber;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceSerialNumber:serialNumber andDevice:self];
}


/********************************************************************************
 * 方法名称：获取制造商信息
 * 功能描述：deviceManagerManufacturerName
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceManagerManufacturerName:(NSString *)manufacturerName {
    if (m_isGetBaseInfo){
        if (!m_baseInfoStatus.readManufacturer) {
            m_baseInfoStatus.readManufacturer = true;
            m_baseInfo.manufacturerName = manufacturerName;
            [self sendBaseInfoCmd];
        }
        return;
    }
    [self.dataSource deviceManufacturerName:manufacturerName andDevice:self];
}


#pragma mark - **************************** 设备信息 *****************************
/*-********************************************************************************
* Method: getCmdOKNumber
* Description: getCmdOKNumber
* Parameter:
* Return Data:
***********************************************************************************/
- (int)getCmdOKNumber:(FBKApiBaseInfoStatus *) infoStatus {
    int cmdOKNumber = 0;
    if (infoStatus.readBattery){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readFirmVersion){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readHardVersion){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readSoftVersion){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readSystemId){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readModel){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readSerial){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.readManufacturer){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.getCmdVersion){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.getCmdMac){ cmdOKNumber = cmdOKNumber+1; }
    if (infoStatus.getCmdCustomer){ cmdOKNumber = cmdOKNumber+1; }
    return cmdOKNumber;
}


/*-********************************************************************************
* Method: sendBaseInfoCmd
* Description: sendBaseInfoCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (void)sendBaseInfoCmd {
    if (m_isGetBaseInfo) {
        int cmdNumber = [self getCmdOKNumber:m_baseInfoStatus];
        NSLog(@"sendBaseInfoCmd:%d --- %d",m_baseInfoCmdNumber,cmdNumber);
        
        if (cmdNumber == m_baseInfoCmdNumber) {
            m_isGetBaseInfo = false;
            [self.dataSource deviceBaseInfo:m_baseInfo andDevice:self];
            return;
        }
        
        switch (cmdNumber) {
            case 0:  [self readDevicePower]; break;
            case 1:  [self readFirmwareVersion]; break;
            case 2:  [self readHardwareVersion]; break;
            case 3:  [self readSoftwareVersion]; break;
            case 4:  [self getPrivateVersion]; break;
            case 5:  [self getPrivateMacAddress]; break;
            case 6:  [self getOtaCustomerName]; break;
            case 7:  [self readSystemId]; break;
            case 8:  [self readModelString]; break;
            case 9:  [self readSerialNumber]; break;
            case 10: [self readManufacturerName]; break;
            default: break;
        }
        
        [self timeOutResult:cmdNumber];
    }
}


/*-********************************************************************************
* Method: sendBaseInfoCmd
* Description: sendBaseInfoCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (void)timeOutResult:(int)cmdNumber {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        switch (cmdNumber) {
            case 0:{
                if (!self->m_baseInfoStatus.readBattery) {
                    self->m_baseInfoStatus.readBattery = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 1: {
                if (!self->m_baseInfoStatus.readFirmVersion) {
                    self->m_baseInfoStatus.readFirmVersion = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 2: {
                if (!self->m_baseInfoStatus.readHardVersion) {
                    self->m_baseInfoStatus.readHardVersion = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 3: {
                if (!self->m_baseInfoStatus.readSoftVersion) {
                    self->m_baseInfoStatus.readSoftVersion = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 4: {
                if (!self->m_baseInfoStatus.getCmdVersion) {
                    self->m_baseInfoStatus.getCmdVersion = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 5: {
                if (!self->m_baseInfoStatus.getCmdMac) {
                    self->m_baseInfoStatus.getCmdMac = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 6: {
                if (!self->m_baseInfoStatus.getCmdCustomer) {
                    self->m_baseInfoStatus.getCmdCustomer = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 7: {
                if (!self->m_baseInfoStatus.readSystemId) {
                    self->m_baseInfoStatus.readSystemId = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 8: {
                if (!self->m_baseInfoStatus.readModel) {
                    self->m_baseInfoStatus.readModel = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 9: {
                if (!self->m_baseInfoStatus.readSerial) {
                    self->m_baseInfoStatus.readSerial = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            case 10: {
                if (!self->m_baseInfoStatus.readManufacturer) {
                    self->m_baseInfoStatus.readManufacturer = true;
                    [self sendBaseInfoCmd];
                }
                break;
            }
                
            default:
                break;
        }
    });
}


@end

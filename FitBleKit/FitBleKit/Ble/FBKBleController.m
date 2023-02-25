/********************************************************************************
 * 文件名称：FBKBleController.m
 * 内容摘要：蓝牙通讯
 * 版本编号：1.0.1
 * 创建日期：2017年11月01日
 ********************************************************************************/

#import "FBKBleController.h"
#import "FBKSpliceBle.h"

@implementation FBKBleController
{
    CBCentralManager *m_manager;              // 控制器
    CBPeripheral     *m_peripheral;           // 连接的蓝牙
    NSMutableArray   *m_devicesArray;         // 设备列表
    NSMutableArray   *m_servicesArray;        // 服务列表
    NSMutableArray   *m_characteristicsArray; // 通道列表
    int              m_checkServiceNum;       // 连接service的个数
    NSString         *m_deviceId;             // 设备类ID
    BleDeviceType    m_deviceType;            // 设备类型
    DeviceIdType     m_idType;                // ID类型
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
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO],
                             CBCentralManagerOptionShowPowerAlertKey,
                             nil];
    m_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    m_devicesArray  = [[NSMutableArray alloc] init];
    m_servicesArray = [[NSMutableArray alloc] init];
    m_characteristicsArray = [[NSMutableArray alloc] init];
    m_checkServiceNum  = 0;
    m_deviceId = [[NSString alloc] init];
    
    return self;
}


#pragma mark - **************************** 对外接口 *****************************
/********************************************************************************
 * 方法名称：startConnectBleDevice
 * 功能描述：开始连接蓝牙设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)startConnectBleDevice:(NSArray *)UUIDArray withDeviceId:(NSString *)deviceId andDeviceType:(BleDeviceType)type compareWithIdType:(DeviceIdType)idType
{
    m_deviceId = deviceId;
    m_deviceType = type;
    m_idType = idType;
    [m_devicesArray removeAllObjects];
    
    if (![self getSettingConnectedBlue:m_deviceId])
    {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerOptionShowPowerAlertKey,
                                 [NSNumber numberWithBool:YES],
                                 CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        
        [m_manager scanForPeripheralsWithServices:UUIDArray options:options];
    }
}


/********************************************************************************
 * 方法名称：disconnectBleDevice
 * 功能描述：断开蓝牙连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)disconnectBleDevice
{
    [m_manager stopScan];
    
    if (m_peripheral.name != nil)
    {
        [m_manager cancelPeripheralConnection:m_peripheral];
        m_deviceId = @"";
        m_peripheral = nil;
        [self.delegate bleConnectStatus:DeviceBleDisconneced andDeviceType:m_deviceType];
    }
}


/********************************************************************************
 * 方法名称：editCharacteristicNotify
 * 功能描述：操作通道状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)editCharacteristicNotify:(NSString *)charUuid withStatus:(BOOL)status {
    for (CBCharacteristic *charac in m_characteristicsArray) {
        if ([FBKSpliceBle compareUuid:charac.UUID withUuid:charUuid]) {
            [self.delegate bleConnectLog:[NSString stringWithFormat:@"editCharacteristicNotify is %@---%i",charac.UUID.UUIDString,status] andDevice:self];

            if (m_peripheral != nil) {
                [m_peripheral setNotifyValue:status forCharacteristic:charac];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：readCharacteristic
 * 功能描述：读操作
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)readCharacteristic:(NSString *)charUuid {
    for (CBCharacteristic *charac in m_characteristicsArray) {
        if ([FBKSpliceBle compareUuid:charac.UUID withUuid:charUuid]) {
            if (m_peripheral != nil) {
                [self.delegate bleConnectLog:[NSString stringWithFormat:@"readCharacteristic is %@",charac.UUID.UUIDString] andDevice:self];
                [m_peripheral readValueForCharacteristic:charac];
            }
        }
    }
}


/********************************************************************************
 * 方法名称：writeByte
 * 功能描述：向蓝牙通道写入数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)writeByte:(NSData *)byteData sendCharacteristic:(NSString *)charUuid writeWithResponse:(BOOL)isResponse
{
    for (CBCharacteristic *charac in m_characteristicsArray)
    {
        if ([FBKSpliceBle compareUuid:charac.UUID withUuid:charUuid]) {
            if (isResponse)
            {
                [self.delegate bleConnectLog:[NSString stringWithFormat:@"%@ write withResponse data is %@",charac.UUID.UUIDString,byteData] andDevice:self];
                
                if (m_peripheral != nil) {
                    [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
                }
            }
            else
            {
                [self.delegate bleConnectLog:[NSString stringWithFormat:@"%@ write withoutResponse data is %@",charac.UUID.UUIDString,byteData] andDevice:self];
                
                if (m_peripheral != nil) {
                    [m_peripheral writeValue:byteData forCharacteristic:charac type:CBCharacteristicWriteWithoutResponse];
                }
            }
        }
    }
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:charUuid forKey:@"uuid"];
    [infoDic setObject:byteData forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FBKWRITENOTIFICATION object:infoDic];
}


#pragma mark - **************************** 扫描回调 *****************************
/********************************************************************************
 * 方法名称：getSettingConnectedBlue
 * 功能描述：搜索并连接系统已配对的蓝牙
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)getSettingConnectedBlue:(NSString *)UUIDString
{
    if (m_idType != DeviceIdUUID)
    {
        return NO;
    }
    
    if (UUIDString == nil)
    {
        return NO;
    }
    
    NSArray *UUIDArray = [[NSArray alloc] initWithObjects:[[NSUUID UUID] initWithUUIDString:UUIDString], nil];
    NSArray *settingBlueArray = [m_manager retrievePeripheralsWithIdentifiers:UUIDArray];
    
    if ([settingBlueArray isKindOfClass:[NSArray class]])
    {
        if (settingBlueArray.count > 0)
        {
            for (int i = 0; i < settingBlueArray.count; i++)
            {
                CBPeripheral *nowPeripheral = [settingBlueArray objectAtIndex:i];
                
                if ([m_deviceId isEqualToString:nowPeripheral.identifier.UUIDString])
                {
                    [m_manager stopScan];
                    m_peripheral = nowPeripheral;
                    [m_devicesArray addObject:m_peripheral];
                    [m_manager connectPeripheral:m_peripheral options:nil];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}


#pragma mark - **************************** 蓝牙回调 *****************************
/********************************************************************************
 * 方法名称：centralManagerDidUpdateState
 * 功能描述：蓝牙状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            [self.delegate bleConnectStatus:DeviceBleIsOpen andDeviceType:m_deviceType];
            break;
        }
        default:
        {
            [self.delegate bleConnectStatus:DeviceBleClosed andDeviceType:m_deviceType];
            [self.delegate bleConnectError:@"Phone bluetooth is closed !" andDeviceType:m_deviceType];
            break;
        }
    }
}


/********************************************************************************
 * 方法名称：didDiscoverPeripheral
 * 功能描述：查到外设，停止扫描，连接设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *name = peripheral.name;
    if (peripheral.name == nil)
    {
        name = @"UnknowName";
    }
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:peripheral.identifier.UUIDString forKey:@"UUIDString"];
    [infoDic setObject:name forKey:@"peripheralName"];
    [infoDic setObject:advertisementData forKey:@"advertisementData"];
    
    if ([self compareId:m_deviceId andDeviceInfo:infoDic])
    {
        [m_manager stopScan];
        m_peripheral = peripheral;
        [m_devicesArray addObject:m_peripheral];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
    
    [self getSettingConnectedBlue:m_deviceId];
}


/********************************************************************************
 * 方法名称：didConnectPeripheral
 * 功能描述：开始连接外设
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.delegate bleConnectStatus:DeviceBleConnecting andDeviceType:m_deviceType];
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
    [self.delegate bleConnectLog:@"didConnectPeripheral Is Succeed" andDevice:self];
}


/********************************************************************************
 * 方法名称：didFailToConnectPeripheral
 * 功能描述：连接外设失败
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.delegate bleConnectLog:[NSString stringWithFormat:@"didFailToConnectPeripheral Is Error %@",error] andDevice:self];
    [self.delegate bleConnectError:error andDeviceType:m_deviceType];
}


/********************************************************************************
 * 方法名称：didDiscoverServices
 * 功能描述：连接外设成功
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"didDiscoverServices Is Error %@",error] andDevice:self];
        return;
    }
    
    m_checkServiceNum = 0;
    [m_servicesArray removeAllObjects];
    [m_characteristicsArray removeAllObjects];
    
    for (CBService *service in peripheral.services)
    {
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"peripheral.services %@ %@",service.UUID,service.UUID.UUIDString] andDevice:self];
        
        [m_servicesArray addObject:service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}


/********************************************************************************
 * 方法名称：didDiscoverCharacteristicsForService
 * 功能描述：连接服务成功，获取数据通道
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"didDiscoverCharacteristicsForService Is Error %@",error] andDevice:self];
        return;
    }
    
    m_checkServiceNum++;
    
    for (CBCharacteristic *charac in service.characteristics)
    {
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"peripheral.Characteristics %@ %@ %@",service.UUID.UUIDString ,charac.UUID,charac.UUID.UUIDString] andDevice:self];
        [m_characteristicsArray addObject:charac];
    }
    
    if (m_checkServiceNum == m_servicesArray.count) {
        int maxResponse = (int)[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
        int maxNoResponse = (int)[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"m_checkServiceNum ----------------------%i--%i",maxResponse,maxNoResponse] andDevice:self];
        self.deviceName = peripheral.name;
        [self.delegate bleConnectStatus:DeviceBleConnected andDeviceType:m_deviceType];
        [self.delegate bleConnectUuids:m_characteristicsArray andDeviceType:m_deviceType];
    }
}


/********************************************************************************
 * 方法名称：didUpdateValueForCharacteristic
 * 功能描述：获取手环外设发来的数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"didUpdateValueForCharacteristic Is Error %@",error] andDevice:self];
        self.deviceName = peripheral.name;
        return;
    }
    
    [self.delegate bleConnectLog:[NSString stringWithFormat:@"deviceId: %@  uuid: %@   value: %@",m_deviceId, characteristic.UUID, characteristic.value] andDevice:self];
    [self.delegate bleConnectByteData:characteristic andDeviceType:m_deviceType];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:[NSString stringWithFormat:@"%@",characteristic.UUID] forKey:@"uuid"];
    [infoDic setObject:characteristic.value forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FBKDATANOTIFICATION object:infoDic];
}


/********************************************************************************
 * 方法名称：didUpdateNotificationStateForCharacteristic
 * 功能描述：特征的状态更新通知
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"didUpdateNotificationStateForCharacteristic Is Error %@---%@",characteristic.UUID,error.localizedDescription] andDevice:self];
    }
}


/********************************************************************************
 * 方法名称：didWriteValueForCharacteristic
 * 功能描述：检测向外设写数据是否成功
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        [self.delegate bleConnectError:error andDeviceType:m_deviceType];
        [self.delegate bleConnectWriteStatus:NO andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:[NSString stringWithFormat:@"didWriteValueForCharacteristic Is Error %@",error] andDevice:self];
    }
    else
    {
        [self.delegate bleConnectWriteStatus:YES andDeviceType:m_deviceType];
        [self.delegate bleConnectLog:@"writeValue Is Succeed" andDevice:self];
    }
}


/********************************************************************************
 * 方法名称：didDisconnectPeripheral
 * 功能描述：失去连接后重新连接
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    [self.delegate bleConnectLog:@"************** connect again **************" andDevice:self];
    if (m_deviceId.length != 0 && m_peripheral != nil)
    {
        [self.delegate bleConnectStatus:DeviceBleReconnect andDeviceType:m_deviceType];
        [m_manager connectPeripheral:m_peripheral options:nil];
    }
}


#pragma mark - **************************** ID值匹配 *****************************
/********************************************************************************
 * 方法名称：compareId
 * 功能描述：ID值匹配
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)compareId:(NSString *)idString andDeviceInfo:(NSDictionary *)info
{
    BOOL isIdEqual = NO;
    
    if (idString.length == 0)
    {
        return isIdEqual;
    }
    
    if (m_idType == DeviceIdUUID)
    {
        NSString *UUIDString = [info objectForKey:@"UUIDString"];
        if ([idString isEqualToString:UUIDString])
        {
            isIdEqual = YES;
        }
    }
    else if (m_idType == DeviceIdMacAdress)
    {
        NSData *byteData = [[info objectForKey:@"advertisementData"] objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *macString = [FBKSpliceBle bleDataToString:byteData];
        NSString *MACAddress = [FBKSpliceBle getMacAddress:macString];
        if ([idString isEqualToString:MACAddress])
        {
            isIdEqual = YES;
        }
    }
    else if (m_idType == DeviceIdName)
    {
        NSString *peripheralName = [info objectForKey:@"peripheralName"];
        if ([peripheralName hasSuffix:idString])
        {
            isIdEqual = YES;
        }
    }
    else
    {
        NSData *byteData = [[info objectForKey:@"advertisementData"] objectForKey:@"kCBAdvDataManufacturerData"];
        NSString *myIdString = [FBKSpliceBle analyticalDeviceId:byteData];
        if ([idString isEqualToString:myIdString])
        {
            isIdEqual = YES;
        }
    }
    
    return isIdEqual;
}


@end

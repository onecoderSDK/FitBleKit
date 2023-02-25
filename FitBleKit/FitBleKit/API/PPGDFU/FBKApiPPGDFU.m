/*-****************************************************************************************
* Copyright: Technology Co., Ltd
* File Name: FBKPPGDFUDelegate.m
* Function : PPG Api
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.07.09
 ******************************************************************************************/

#import "FBKApiPPGDFU.h"

@implementation FBKApiPPGDFU

#pragma mark - ****************************** Syetems *************************************
/*-****************************************************************************************
* Method: init
* Description: start here
* Parameter:
* Return Data:
 ******************************************************************************************/
- (id)init {
    self = [super init];
    self.managerController = [[FBKManagerController alloc] init];
    self.managerController.delegate = self;
    self.deviceId = [[NSString alloc] init];
    self.deviceType = BleDevicePPGDFU;
    [self.managerController setManagerDeviceType:BleDevicePPGDFU];
    return self;
}


#pragma mark - ****************************** Protocol ************************************
/*-****************************************************************************************
* Method: startConnectBleApi
* Description: startConnectBleApi
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)startConnectBleApi:(NSString *)deviceId andIdType:(DeviceIdType)idType {
    self.deviceId = deviceId;
    [self.managerController startConnectBleManage:deviceId withDeviceType:self.deviceType andIdType:idType];
}


/*-****************************************************************************************
* Method: disconnectBleApi
* Description: disconnectBleApi
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)disconnectBleApi {
    [self.managerController disconnectBleManage];
}


/*-****************************************************************************************
* Method: startPPGOTAForPath
* Description: startPPGOTAForPath
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)startPPGOTAForPath:(NSString *)filePath {
    [self.managerController receiveApiCmd:PPGDFUFilePath withObject:filePath];
    [self.managerController receiveApiCmd:PPGStartDFU withObject:nil];
}


/*-****************************************************************************************
* Method: readDeviceName
* Description: readDeviceName
* Parameter:
* Return Data:
 ******************************************************************************************/
- (NSString *)readDeviceName {
    return [self.managerController readDeviceName];
}


#pragma mark - ****************************** Ble Delegate ********************************
/*-****************************************************************************************
* Method: analyticalData
* Description: analyticalData
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)analyticalData:(id)resultData withResultNumber:(int)resultNumber {
    PPGResultNumber resultType = (PPGResultNumber)resultNumber;
    if (resultType == PPGDFUProgress) {
        NSString *dataString = (NSString *)resultData;
        [self.delegate ppgDfuProgress:[dataString intValue] andDevice:self];
    }
    else if (resultType == PPGDFUResult) {
        NSString *dataString = (NSString *)resultData;
        BOOL isSucceed = false;
        if ([dataString intValue] == 1) {
            isSucceed = true;
        }
        [self.delegate ppgDfuResult:isSucceed andDevice:self];
    }
}


/*-****************************************************************************************
* Method: bleConnectStatus
* Description: bleConnectStatus
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status {
    if (status == DeviceBleConnected || status == DeviceBleSynchronization || status == DeviceBleSyncOver || status == DeviceBleSyncFailed) {
        self.isConnected = YES;
    }
    else {
        self.isConnected = NO;
    }
    [self.delegate bleConnectStatus:status andDevice:self];
}


/*-****************************************************************************************
* Method: bleConnectError
* Description: bleConnectError
* Parameter:
* Return Data:
 ******************************************************************************************/
- (void)bleConnectError:(id)error {
    [self.delegate bleConnectError:error andDevice:self];
}


- (void)bleConnectUuids:(NSArray *)charUuidArray {}
- (void)analyCommonData:(id)resultData withResultNumber:(int)resultNumber {}
- (void)deviceManagerPower:(NSString *)powerInfo {}
- (void)deviceManagerFirmwareVersion:(NSString *)versionInfo {}
- (void)deviceManagerHardwareVersion:(NSString *)versionInfo {}
- (void)deviceManagerSoftwareVersion:(NSString *)versionInfo {}


@end

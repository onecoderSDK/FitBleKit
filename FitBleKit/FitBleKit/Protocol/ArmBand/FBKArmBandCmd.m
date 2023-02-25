/*-***********************************************************************************
* File Name: FBKArmBandCmd.m
* Function : Arm Band Cmd
* Editor   : Pendy 
* Version  : 1.0.1
* Date     : 2020.05.07
*************************************************************************************/

#import "FBKArmBandCmd.h"
#import "FBKSpliceBle.h"

@implementation FBKArmBandCmd


/*-***********************************************************************************
* Method: setAgeNumber
* Description: setAgeNumber
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setAgeNumber:(int)ageNumber {
    if (ageNumber > 150) {
        ageNumber = 150;
    }
    
    if (ageNumber < 0) {
        ageNumber = 20;
    }
    
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",8] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",ageNumber] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setShock
* Description: set Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setShock:(int)shockNumber {
    if (shockNumber > 255) {
        shockNumber = 255;
    }
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",9] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",shockNumber] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: getShock
* Description: get Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)getShock {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",10] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: closeShock
* Description: close Shock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)closeShock {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",11] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setMaxInterval
* Description: set Max Interval
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setMaxInterval:(int)maxNumber {
    if (maxNumber > 255) {
        maxNumber = 255;
    }
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",12] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",maxNumber] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setLightSwitch
* Description: set Light Switch
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setLightSwitch:(BOOL)isOpen {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",13] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    if (isOpen) {
        [cmdMap setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte3"];
    }
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: setColorShock
* Description: setColorShock
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setColorShock:(BOOL)isOpen {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",14] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    if (isOpen) {
        [cmdMap setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte3"];
    }
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: colorInterval
* Description: colorInterval
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)colorInterval:(int)intervalNumber {
    if (intervalNumber > 65535) {
        intervalNumber = 65535;
    }
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",6] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",15] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",intervalNumber/256] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",intervalNumber%256] forKey:@"byte4"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte5"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: clearRecord
* Description: clearRecord
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)clearRecord {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",178] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",5] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",16] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte3"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte4"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: getMacAddressData
* Description: getMacAddressData
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)getMacAddressData {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",162] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",128] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: getVersion
* Description: getVersion
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)getVersion {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",162] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",129] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: enterOTAMode
* Description: enterOTAMode
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)enterOTAMode {
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",162] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",4] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",1] forKey:@"byte2"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte3"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


/*-***********************************************************************************
* Method: dataFrequency
* Description: dataFrequency
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)dataFrequency:(int)frequency {
    if (frequency > 70) {
        frequency = 70;
    }

    if (frequency < 1) {
        frequency = 1;
    }
    
    NSMutableDictionary *cmdMap = [[NSMutableDictionary alloc] init];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",161] forKey:@"byte0"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",frequency] forKey:@"byte1"];
    [cmdMap setObject:[NSString stringWithFormat:@"%i",0] forKey:@"byte2"];
    NSString *cmdString = [FBKSpliceBle getHexData:cmdMap haveCheckNum:YES];
    NSData *writeData = [[NSData alloc] initWithData:[FBKSpliceBle getWriteData:cmdString]];
    return writeData;
}


// 智云医康定制指令
/*-***********************************************************************************
* Method: setPrivateFiveZone
* Description: 设置区间UI的展示
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)setPrivateFiveZone:(NSArray *)zoneArray {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[19];
    bytes[0] = (Byte) (194);
    bytes[1] = (Byte) (19);
    bytes[2] = (Byte) (1);
    
    int offset = 3;
    for (int i = 0; i<zoneArray.count; i++) {
        FBKArmBandPrivate *myPrivate = [zoneArray objectAtIndex:i];
        bytes[offset] = (Byte) (myPrivate.heartZone1);
        bytes[offset+1] = (Byte) (myPrivate.heartZone2);
        bytes[offset+2] = (Byte) (myPrivate.showTime);
        offset = offset+3;
    }
    
    int sunNumber = 0;
    for (int i = 0; i < 18; i++) {
        sunNumber = sunNumber + bytes[i];
    }
    bytes[18] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-***********************************************************************************
* Method: openPrivateShow
* Description: 开启设定显示
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)openPrivateShow {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (194);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (2);
    
    int sunNumber = 0;
    for (int i = 0; i < 3; i++) {
        sunNumber = sunNumber + bytes[i];
    }
    bytes[3] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-***********************************************************************************
* Method: closePrivateShow
* Description: 关闭设定显示
* Parameter:
* Return Data:
*************************************************************************************/
- (NSData *)closePrivateShow{
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (194);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (3);
    
    int sunNumber = 0;
    for (int i = 0; i < 3; i++) {
        sunNumber = sunNumber + bytes[i];
    }
    bytes[3] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


@end

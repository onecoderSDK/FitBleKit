/********************************************************************************
 * 文件名称：FBKFightCmd.h
 * 内容摘要：新拳击蓝牙命令
 * 版本编号：1.0.1
 * 创建日期：2022年08月23日
 ********************************************************************************/

#import "FBKFightCmd.h"

@implementation FBKFightCmd

/*-********************************************************************************
* Method: enterDfuCmd
* Description: enterDfuCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)enterDfuCmd {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (178);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (1);
    
    int sunNumber = 0;
    for (int i = 0; i < 3; i++) {
        sunNumber = sunNumber + bytes[i]&0xff;
    }
    
    bytes[3] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: turnOffDevice
* Description: turnOffDevice
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)turnOffDevice {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (178);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (2);
    
    int sunNumber = 0;
    for (int i = 0; i < 3; i++) {
        sunNumber = sunNumber + bytes[i]&0xff;
    }
    
    bytes[3] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: setSandbagInfo
* Description: setSandbagInfo
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)setSandbagInfo:(FBKFightSandbag *)sandbagInfo {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[14];
    bytes[0]  = (Byte) (178);
    bytes[1]  = (Byte) (14);
    bytes[2]  = (Byte) (3);
    bytes[3]  = (Byte) (sandbagInfo.sandbagLength/256);
    bytes[4]  = (Byte) (sandbagInfo.sandbagLength%256);
    bytes[5]  = (Byte) (sandbagInfo.sandbagWidth/256);
    bytes[6]  = (Byte) (sandbagInfo.sandbagWidth%256);
    bytes[7]  = (Byte) (sandbagInfo.sandbagHight/256);
    bytes[8]  = (Byte) (sandbagInfo.sandbagHight%256);
    bytes[9]  = (Byte) (sandbagInfo.sandbagWeight/256);
    bytes[10] = (Byte) (sandbagInfo.sandbagWeight%256);
    bytes[11] = (Byte) (sandbagInfo.sandbagType);
    bytes[12] = (Byte) (sandbagInfo.sandbagSensitivity);
    
    int sunNumber = 0;
    for (int i = 0; i < 13; i++) {
        sunNumber = sunNumber + bytes[i]&0xff;
    }
    
    bytes[13] = (Byte) (sunNumber%256);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


@end

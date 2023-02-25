/********************************************************************************
 * 文件名称：FBKManagerCmd.m
 * 内容摘要：设备公共命令
 * 版本编号：1.0.1
 * 创建日期：2020年12月28日
 *******************************************************************************/

#import "FBKManagerCmd.h"

@implementation FBKManagerCmd


/*-********************************************************************************
* Method: deviceVersionInfoCmd
* Description: deviceVersionInfoCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)deviceVersionInfoCmd {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (162);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (129);
    
    int sunNumber = (162 + 4 + 129) % 256;
    bytes[3] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: deviceMacAddressCmd
* Description: deviceMacAddressCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)deviceMacAddressCmd {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (162);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (128);
    
    int sunNumber = (162 + 4 + 128) % 256;
    bytes[3] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: customerNameCmd
* Description: customerNameCmd
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)customerNameCmd {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (162);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (130);
    
    int sunNumber = (162 + 4 + 130) % 256;
    bytes[3] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


/*-********************************************************************************
* Method: enterOTACmd
* Description: enterOTACmd
* Parameter:
* Return Data:
***********************************************************************************/
- (NSData *)enterOTACmd {
    NSMutableData *resultData = [[NSMutableData alloc] init];
    
    Byte bytes[4];
    bytes[0] = (Byte) (162);
    bytes[1] = (Byte) (4);
    bytes[2] = (Byte) (1);
    
    int sunNumber = (162 + 4 + 1) % 256;
    bytes[3] = (Byte) (sunNumber);
    
    [resultData appendBytes:bytes length:sizeof(bytes)];
    return resultData;
}


@end

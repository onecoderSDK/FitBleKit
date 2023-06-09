/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: FileEditViewController.h
* Function : File Edit
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.03.11
******************************************************************************************/

#import "BaseViewController.h"
#import "DeviceClass.h"

@protocol FileEditDelegate <NSObject>
- (void)postAxisData:(FBKBoxingSet *)boxSet;
@end

@interface FileEditViewController : BaseViewController

@property(assign,nonatomic) id <FileEditDelegate> delegate;

@end

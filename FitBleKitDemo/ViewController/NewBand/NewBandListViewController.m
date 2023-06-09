/********************************************************************************
 * 文件名称：NewBandListViewController.m
 * 内容摘要：新手环数据展示
 * 版本编号：1.0.1
 * 创建日期：2018年03月20日
 ********************************************************************************/

#import "NewBandListViewController.h"
#import "BindDeviceViewController.h"
#import "CFileOperate.h"

@interface NewBandListViewController () {
    UITextView *m_content;
    NSMutableArray *m_keyArray;
    NSMutableDictionary *m_myDataDic;
    UIDocumentInteractionController *m_documentController;
}

@end

@implementation NewBandListViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_myDataDic = [[NSMutableDictionary alloc] initWithDictionary:self.dataDic];
    m_keyArray = [[NSMutableArray alloc] initWithArray:m_myDataDic.allKeys];
    [self stepsDate];
    [self loadHeadView];
    [self loadContentView];
}


/********************************************************************************
 * 方法名称：didReceiveMemoryWarning
 * 功能描述：内存警告时，释放内存
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - **************************** 加载界面 *****************************
/********************************************************************************
 * 方法名称：loadHeadView
 * 功能描述：获取头视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadHeadView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"Data List";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
    UIButton *headLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UIImageView *headLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 24, 24)];
    headLeftImg.backgroundColor = [UIColor clearColor];
    headLeftImg.image = [UIImage imageNamed:@"img_app_back.png"];
    [headLeftBtn addSubview:headLeftImg];
    
    UIButton *headRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 80, 50)];
    headRightBtn.backgroundColor = [UIColor clearColor];
    [headRightBtn setTitle:@"Log" forState:UIControlStateNormal];
    [headRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headRightBtn addTarget:self action:@selector(shareLog) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headRightBtn];
    
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(logPress)];
    longPressGesture.minimumPressDuration=2.0f;//设置长按 时间
    [headRightBtn addGestureRecognizer:longPressGesture];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerBackView addSubview:lineView];
}


/********************************************************************************
 * 方法名称：loadContentView
 * 功能描述：获取内容视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadContentView {
    for (int i = 0; i < m_keyArray.count; i++) {
        NSString *keyString = [m_keyArray objectAtIndex:i];
        float whitchWide = (self.view.frame.size.width-20)/3;
        
        UIButton *dataBtn = [[UIButton alloc] initWithFrame:CGRectMake((i%3)*(whitchWide+10), 81+49*(i/3), whitchWide, 48)];
        dataBtn.tag = 100+i;
        dataBtn.backgroundColor = [UIColor blackColor];
        [dataBtn setTitle:keyString forState:UIControlStateNormal];
        [dataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dataBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [dataBtn addTarget:self action:@selector(dataShow:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dataBtn];
    }
    
    m_content = [[UITextView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-180)];
    m_content.backgroundColor = [UIColor blackColor];
    m_content.font = [UIFont systemFontOfSize:15];
    m_content.text = @"";
    m_content.textColor = [UIColor whiteColor];
    [m_content setEditable:NO];
    [self.view addSubview:m_content];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：dataShow
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)dataShow:(UIButton *)sender {
    int myTag = (int)sender.tag-100;
    NSString *keyString = [m_keyArray objectAtIndex:myTag];
    m_content.text = [NSString stringWithFormat:@"%@",[m_myDataDic objectForKey:keyString]];
    
    if ([keyString isEqualToString:@"heartRate2SData"] || [keyString isEqualToString:@"heartRateData"] || [keyString isEqualToString:@"Heart Rate Record"]) {
        NSArray *myList = [m_myDataDic objectForKey:keyString];
        NSMutableString *textString = [[NSMutableString alloc] init];
                                       
        if ([myList isKindOfClass:[NSArray class]]) {
            int baseTime = 0;
            for (int i = 0; i < myList.count; i++) {
                NSString *timestamps = [[myList objectAtIndex:i] objectForKey:@"timestamps"];
                NSString *heartNum = [[myList objectAtIndex:i] objectForKey:@"heartRateNum"];
                
                if (i == 0) {
                    baseTime = [timestamps intValue];
                    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:baseTime];
                    NSString *timeString = [FBKDateFormat getDateString:dateTime withType:@"yyyy-MM-dd HH:mm:ss"];
                    [textString appendFormat:@"1 - %@ --- %@",timeString,heartNum];
                    [textString appendString:@"\n"];
                }
                else {
                    for (int j = 0; j < 36000; j++) {
                        if (baseTime == [timestamps intValue]-2) {
                            baseTime = [timestamps intValue];
                            NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:baseTime];
                            NSString *timeString = [FBKDateFormat getDateString:dateTime withType:@"yyyy-MM-dd HH:mm:ss"];
                            [textString appendFormat:@"1 - %@ --- %@",timeString,heartNum];
                            [textString appendString:@"\n"];
                            break;
                        }
                        else {
                            baseTime = baseTime + 2;
                            NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:baseTime];
                            NSString *timeString = [FBKDateFormat getDateString:dateTime withType:@"yyyy-MM-dd HH:mm:ss"];
                            [textString appendFormat:@"0 - %@ --- 0",timeString];
                            [textString appendString:@"\n"];
                        }
                    }
                }
            }
        }
        CFileOperate *myFile = [[CFileOperate alloc] init];
        [myFile saveStringToFile:textString withName:@"FBKLog.txt"];
    }
}


/********************************************************************************
 * 方法名称：stepsDate
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)stepsDate {
    NSMutableString *textString = [[NSMutableString alloc] initWithString:@"--------------------------------------------------\n"];
    if ([m_myDataDic objectForKey:@"stepsTotleData"] != nil){
        NSArray *myArray = [m_myDataDic objectForKey:@"stepsTotleData"];
        if (myArray.count == 1) {
            NSString *time = [[myArray objectAtIndex:0] objectForKey:@"locTime"];
            NSString *walkCounts = [[myArray objectAtIndex:0] objectForKey:@"stepNum"];
            NSString *calorie = [[myArray objectAtIndex:0] objectForKey:@"stepKcal"];
            NSString *stepString = [NSString stringWithFormat:@"%@   %d   %@   (Total)",time,[walkCounts intValue],calorie];
            [textString appendString:stepString];
            [textString appendString:@"\n"];
        }
        
        return;
    }
    
    if ([m_myDataDic objectForKey:@"stepsData"] != nil){
        NSArray *myArray = [m_myDataDic objectForKey:@"stepsData"];
        if ([myArray isKindOfClass:[NSArray class]]){
            for (int i = 0; i < myArray.count; i++) {
                NSString *time = [[myArray objectAtIndex:i] objectForKey:@"createTime"];
                NSString *walkCounts = [[myArray objectAtIndex:i] objectForKey:@"walkCounts"];
                NSString *calorie = [[myArray objectAtIndex:i] objectForKey:@"calorie"];
                NSString *stepString = [NSString stringWithFormat:@"%@   %.3d   %@",time,[walkCounts intValue],calorie];
                [textString appendString:stepString];
                [textString appendString:@"\n"];
            }
        }
        
        CFileOperate *myFile = [[CFileOperate alloc] init];
        NSString *fileString = [myFile getStringFromFile:@"FBKLog.txt"];
        
        if (fileString == nil) {
            [myFile saveStringToFile:textString withName:@"FBKLog.txt"];
        }
        else {
            fileString = [NSString stringWithFormat:@"%@\n\n%@",fileString,textString];
            [myFile saveStringToFile:fileString withName:@"FBKLog.txt"];
        }
        
        return;
    }
}


/********************************************************************************
 * 方法名称：logPress
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)logPress {
    CFileOperate *myFile = [[CFileOperate alloc] init];
    NSString *fileString = [myFile getStringFromFile:@"FBKLog.txt"];
    m_content.text = fileString;
}


/********************************************************************************
 * 方法名称：shareLog
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)shareLog {
    CFileOperate *myFile = [[CFileOperate alloc] init];
    NSString *fileString = [myFile dataFilePath:@"FBKLog.txt"];
    NSURL *filePath = [NSURL fileURLWithPath:fileString];
    m_documentController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
    m_documentController.UTI = @"public.text";
    [m_documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}


@end

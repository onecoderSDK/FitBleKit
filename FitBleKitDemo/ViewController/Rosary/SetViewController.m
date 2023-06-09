//
//  SetViewController.m
//
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 CS. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<UITextFieldDelegate>
{
    UITextField  *m_noticeTypeField;
    UITextField  *m_noticeRowsField;
    UITextField  *m_intervalTimeField;
    UITextField  *m_timeNumbersField;
    UITextField  *m_noticeTimeField;
    UITextField  *m_restTimeField;
}

@end

@implementation SetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [self hexStringToColor:@"#FFFFFF"];
    int GuWide = 140;
    int LabWide = 120;
    
    UIButton *keyboardBtn = [[UIButton alloc] initWithFrame:self.view.frame];
    keyboardBtn.backgroundColor = [UIColor clearColor];
    [keyboardBtn addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:keyboardBtn];
    
    UILabel *noticeTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, LabWide, 50)];
    noticeTypeLab.backgroundColor = [UIColor clearColor];
    noticeTypeLab.text = @"提示方式(0-闪灯、1-震动、2-闪灯和震动)";
    noticeTypeLab.textColor = [self hexStringToColor:@"#000000"];
    noticeTypeLab.textAlignment = NSTextAlignmentLeft;
    noticeTypeLab.font = [UIFont systemFontOfSize:12];
    noticeTypeLab.numberOfLines = 2;
    [self.view addSubview:noticeTypeLab];
    
    m_noticeTypeField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 85, 220, 35)];
    m_noticeTypeField.backgroundColor = [UIColor clearColor];
    m_noticeTypeField.returnKeyType = UIReturnKeyNext;
    m_noticeTypeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_noticeTypeField.font = [UIFont systemFontOfSize:14];
    m_noticeTypeField.textColor = [self hexStringToColor:@"#000000"];
    m_noticeTypeField.placeholder = @"";
    m_noticeTypeField.text = @"1";
    m_noticeTypeField.delegate = self;
    [self.view addSubview:m_noticeTypeField];
    
    UIView *noticeTypeLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 115, 220, 1)];
    noticeTypeLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:noticeTypeLine];
    
    UILabel *noticeRowsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, LabWide, 35)];
    noticeRowsLab.backgroundColor = [UIColor clearColor];
    noticeRowsLab.text = @"提示组数";
    noticeRowsLab.textColor = [self hexStringToColor:@"#000000"];
    noticeRowsLab.textAlignment = NSTextAlignmentLeft;
    noticeRowsLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noticeRowsLab];
    
    m_noticeRowsField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 140, 220, 35)];
    m_noticeRowsField.backgroundColor = [UIColor clearColor];
    m_noticeRowsField.returnKeyType = UIReturnKeySend;
    m_noticeRowsField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_noticeRowsField.font = [UIFont systemFontOfSize:14];
    m_noticeRowsField.textColor = [self hexStringToColor:@"#000000"];
    m_noticeRowsField.placeholder = @"";
    m_noticeRowsField.text = @"3";
    m_noticeRowsField.delegate = self;
    [self.view addSubview:m_noticeRowsField];
    
    UIView *noticeRowsLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 173, 220, 1)];
    noticeRowsLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:noticeRowsLine];
    
    
    UILabel *intervalTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, LabWide, 35)];
    intervalTimeLab.backgroundColor = [UIColor clearColor];
    intervalTimeLab.text = @"每组间隔时间(毫秒)";
    intervalTimeLab.textColor = [self hexStringToColor:@"#000000"];
    intervalTimeLab.textAlignment = NSTextAlignmentLeft;
    intervalTimeLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:intervalTimeLab];
    
    m_intervalTimeField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 195, 220, 35)];
    m_intervalTimeField.backgroundColor = [UIColor clearColor];
    m_intervalTimeField.returnKeyType = UIReturnKeySend;
    m_intervalTimeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_intervalTimeField.font = [UIFont systemFontOfSize:14];
    m_intervalTimeField.textColor = [self hexStringToColor:@"#000000"];
    m_intervalTimeField.placeholder = @"";
    m_intervalTimeField.text = @"1000";
    m_intervalTimeField.delegate = self;
    [self.view addSubview:m_intervalTimeField];
    
    UIView *intervalTimeLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 228, 220, 1)];
    intervalTimeLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:intervalTimeLine];
    
    
    UILabel *timeNumbersLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 195+55, LabWide, 35)];
    timeNumbersLab.backgroundColor = [UIColor clearColor];
    timeNumbersLab.text = @"每组提示次数";
    timeNumbersLab.textColor = [self hexStringToColor:@"#000000"];
    timeNumbersLab.textAlignment = NSTextAlignmentLeft;
    timeNumbersLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:timeNumbersLab];
    
    m_timeNumbersField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 195+55, 220, 35)];
    m_timeNumbersField.backgroundColor = [UIColor clearColor];
    m_timeNumbersField.returnKeyType = UIReturnKeySend;
    m_timeNumbersField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_timeNumbersField.font = [UIFont systemFontOfSize:14];
    m_timeNumbersField.textColor = [self hexStringToColor:@"#000000"];
    m_timeNumbersField.placeholder = @"";
    m_timeNumbersField.text = @"3";
    m_timeNumbersField.delegate = self;
    [self.view addSubview:m_timeNumbersField];
    
    UIView *timeNumbersLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 228+55, 220, 1)];
    timeNumbersLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:timeNumbersLine];
    
    
    UILabel *noticeTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 195+110, LabWide, 35)];
    noticeTimeLab.backgroundColor = [UIColor clearColor];
    noticeTimeLab.text = @"提示持续时间(毫秒)";
    noticeTimeLab.textColor = [self hexStringToColor:@"#000000"];
    noticeTimeLab.textAlignment = NSTextAlignmentLeft;
    noticeTimeLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:noticeTimeLab];
    
    m_noticeTimeField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 195+110, 220, 35)];
    m_noticeTimeField.backgroundColor = [UIColor clearColor];
    m_noticeTimeField.returnKeyType = UIReturnKeySend;
    m_noticeTimeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_noticeTimeField.font = [UIFont systemFontOfSize:14];
    m_noticeTimeField.textColor = [self hexStringToColor:@"#000000"];
    m_noticeTimeField.placeholder = @"";
    m_noticeTimeField.text = @"2000";
    m_noticeTimeField.delegate = self;
    [self.view addSubview:m_noticeTimeField];
    
    UIView *noticeTimeLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 228+110, 220, 1)];
    noticeTimeLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:noticeTimeLine];
    
    
    UILabel *restTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 195+165, LabWide, 35)];
    restTimeLab.backgroundColor = [UIColor clearColor];
    restTimeLab.text = @"提示休息时间(毫秒)";
    restTimeLab.textColor = [self hexStringToColor:@"#000000"];
    restTimeLab.textAlignment = NSTextAlignmentLeft;
    restTimeLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:restTimeLab];
    
    m_restTimeField = [[UITextField alloc] initWithFrame:CGRectMake(GuWide, 195+165, 220, 35)];
    m_restTimeField.backgroundColor = [UIColor clearColor];
    m_restTimeField.returnKeyType = UIReturnKeySend;
    m_restTimeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_restTimeField.font = [UIFont systemFontOfSize:14];
    m_restTimeField.textColor = [self hexStringToColor:@"#000000"];
    m_restTimeField.placeholder = @"";
    m_restTimeField.text = @"1000";
    m_restTimeField.delegate = self;
    [self.view addSubview:m_restTimeField];
    
    UIView *restTimeLine = [[UIView alloc] initWithFrame:CGRectMake(GuWide, 228+165, 220, 1)];
    restTimeLine.backgroundColor = [self hexStringToColor:@"#DDDDDD"];
    [self.view addSubview:restTimeLine];
    
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(72, 270+165, self.view.frame.size.width-144, 35)];
    [self setViewBorderWithView:saveButton cornerRadius:3 borderColor:[self hexStringToColor:@"#73C48F"] borderWidth:1];
    saveButton.backgroundColor = [self hexStringToColor:@"#73C48F"];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[self hexStringToColor:@"#FFFFFF"] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"FNoticeType"] != nil)
    {
        m_noticeTypeField.text = [ud objectForKey:@"FNoticeType"];
    }
    
    if ([ud objectForKey:@"FNoticeRows"] != nil)
    {
        m_noticeRowsField.text = [ud objectForKey:@"FNoticeRows"];
    }
    
    if ([ud objectForKey:@"FIntervalTime"] != nil)
    {
        m_intervalTimeField.text = [ud objectForKey:@"FIntervalTime"];
    }
    
    if ([ud objectForKey:@"FTimeNunbers"] != nil)
    {
        m_timeNumbersField.text = [ud objectForKey:@"FTimeNunbers"];
    }
    
    if ([ud objectForKey:@"FNoticeTime"] != nil)
    {
        m_noticeTimeField.text = [ud objectForKey:@"FNoticeTime"];
    }
    
    if ([ud objectForKey:@"FRestTime"] != nil)
    {
        m_restTimeField.text = [ud objectForKey:@"FRestTime"];
    }
}

- (void)saveAction
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:m_noticeTypeField.text forKey:@"FNoticeType"];
    [ud setObject:m_noticeRowsField.text forKey:@"FNoticeRows"];
    [ud setObject:m_intervalTimeField.text forKey:@"FIntervalTime"];
    [ud setObject:m_timeNumbersField.text forKey:@"FTimeNunbers"];
    [ud setObject:m_noticeTimeField.text forKey:@"FNoticeTime"];
    [ud setObject:m_restTimeField.text forKey:@"FRestTime"];
    [ud synchronize];
    
    [self hiddenKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenKeyboard
{
    [m_noticeTypeField resignFirstResponder];
    [m_noticeRowsField resignFirstResponder];
    [m_intervalTimeField resignFirstResponder];
    [m_timeNumbersField resignFirstResponder];
    [m_noticeTimeField resignFirstResponder];
    [m_restTimeField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***************************************************************************
 * MethodName :textFieldShouldReturn
 * Function   :textField Should Return
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)setViewBorderWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    view.layer.cornerRadius = cornerRadius;  //圆弧半径
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.layer.masksToBounds = YES;
}

/***************************************************************************
 * 方法名称：hexStringToColor
 * 功能描述：RGB色值
 * 输入参数：
 * 返回数据：
 ***************************************************************************/
- (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor blackColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end

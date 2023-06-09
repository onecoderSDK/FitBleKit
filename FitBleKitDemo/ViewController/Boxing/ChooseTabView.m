/*-****************************************************************************************
* Copyright: Shenzhen Onecoder Technology Co., Ltd
* File Name: ChooseTabView.m
* Function : Choose Tab
* Editor   : Pendy
* Version  : 1.0.1
* Date     : 2021.03.11
******************************************************************************************/

#import "ChooseTabView.h"
#import "PYToolUIAdapt.h"

@implementation ChooseTabView
@synthesize dataArray,chooseNo;

#pragma mark - ******************************* System *************************************
/*-****************************************************************************************
 * Method: drawRect
 * Description: drawRect
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)drawRect:(CGRect)rect {
    for (UIView *myView in self.subviews) {
        [myView removeFromSuperview];
    }
    
    double width  = rect.size.width/PY_SCREEN_RATE;
    double height = rect.size.height/PY_SCREEN_RATE;
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, 0.0, width, height)];
    backView.backgroundColor = [UIColor whiteColor];
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:backView cornerRadius:0 borderColor:[UIColor blackColor] borderWidth:1];
    [self addSubview:backView];
    
    double eachWidth = width / (dataArray.count);
    for (int i = 1; i < dataArray.count; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(eachWidth*(double)i, 0.0, 1.0, height)];
        lineView.backgroundColor = [UIColor blackColor];
        [backView addSubview:lineView];
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        UIButton *tabButton = [[UIButton alloc] init];
        tabButton.tag = 1000+i;
        tabButton.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(eachWidth*(double)i, 0.0, eachWidth, height)];
        tabButton.backgroundColor = [UIColor clearColor];
        [tabButton setTitle:[dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [tabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tabButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tabButton addTarget:self action:@selector(segmentedTag:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:tabButton];
        
        if (i == self.chooseNo) {
            tabButton.backgroundColor = [UIColor blackColor];
            [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}


/*-****************************************************************************************
 * Method: segmentedTag
 * Description: segmentedTag
 * Parameter:
 * Return Data:
 ******************************************************************************************/
- (void)segmentedTag:(UIButton *)sender {
    int myTag = (int)sender.tag - 1000;
    self.chooseNo = myTag;
    [self setNeedsDisplay];
    
    [self.delegate chooseTabIndex:self.chooseNo withView:self];
}


@end

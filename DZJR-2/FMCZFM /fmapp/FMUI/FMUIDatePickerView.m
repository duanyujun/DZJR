//
//  FMUIDatePickerView.m
//  fmapp
//
//  Created by 张利广 on 14-9-12.
//  Copyright (c) 2014年 yk. All rights reserved.
//

#import "FMUIDatePickerView.h"

#define UITabBarSizeHight

@interface FMUIDatePickerView ()
///时间选择器内容
@property (nonatomic , strong)  UIDatePicker          *driverReceiveDatePicker ;
///获取到的时间字符串
@property (nonatomic , strong)  NSString              *dateDataInforForString;
- (void)initWithUserOperationCancleButtonEvent:(id)sender;
- (void)initWithUserOperationMakeSureButtonEvent:(id)sender;
- (void)initWithCustomerChangeReceiverDateTimeFor:(UIDatePicker *)sender;
@end

@implementation FMUIDatePickerView
{
    NSArray *hoursArray;
    NSMutableArray *minutesArray;

}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
WithDatePickerDelegate:(id<FMUIDatePickerDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dateDataInforForString = [[NSString alloc]initWithFormat:@"%@",@""];
        self.fmPickerDelegate = delegate;
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6]];
        
        ///设置按键
        [self initWithBarButtonFrame];
        
        [self initWithReceiveDatePickerFrame];

    }
    return self;
}

///设置左右两侧按键
- (void)initWithBarButtonFrame{
    UITabBar    *bar = [[UITabBar alloc]initWithFrame:CGRectMake(0.0f, self.bounds.size.height- 44 - 216.0f, self.bounds.size.width, 44.0f)];
    [bar setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:255.0f/255.0f
                                            alpha:0.9]];
    
    //添加取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:203.0f/255.0f
                                                green:225.0f/255.0f
                                                 blue:243.0f/255.0f
                                                alpha:1.0f]
                       forState:UIControlStateHighlighted];
    
    [cancelButton setTitleColor:[UIColor colorWithRed:48.0f/255.0f
                                                green:136.0f/255.0f
                                                 blue:254.0f/255.0f
                                                alpha:1.0f]
                       forState:UIControlStateNormal];
    
    [cancelButton setFrame:CGRectMake(8, 3, 60, 38)];
    [cancelButton addTarget:self action:@selector(initWithUserOperationCancleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancelButton];
    
    
    //添加确定按钮
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton setTitleColor:[UIColor colorWithRed:203.0f/255.0f
                                                green:225.0f/255.0f
                                                 blue:243.0f/255.0f
                                                alpha:1.0f]
                       forState:UIControlStateHighlighted];
    
    [ensureButton setTitleColor:[UIColor colorWithRed:48.0f/255.0f
                                                green:136.0f/255.0f
                                                 blue:254.0f/255.0f
                                                alpha:1.0f]
                       forState:UIControlStateNormal];
    [ensureButton setFrame:CGRectMake(self.bounds.size.width - 68, 3, 60, 38)];
    [ensureButton addTarget:self action:@selector(initWithUserOperationMakeSureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:ensureButton];

    
    [self addSubview:bar];
}

///设置时间选择器内容
- (void)initWithReceiveDatePickerFrame{
    NSDate *systemNSData = [[NSDate alloc]init];
    self.driverReceiveDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 216.0f,self.bounds.size.width, 216)];
    [self.driverReceiveDatePicker setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f
                                                                     green:255.0f/255.0f
                                                                      blue:255.0f/255.0f
                                                                     alpha:0.9]];
    self.driverReceiveDatePicker.date = systemNSData;
    
    //最小日期
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.year = 1900;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.driverReceiveDatePicker.minimumDate = [gregorian dateFromComponents:dc];
    
    self.driverReceiveDatePicker.datePickerMode = UIDatePickerModeDate;

    self.driverReceiveDatePicker.timeZone = [NSTimeZone localTimeZone];
    [self.driverReceiveDatePicker addTarget:self action:@selector(initWithCustomerChangeReceiverDateTimeFor:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.driverReceiveDatePicker];
}

- (void)initWithUserOperationCancleButtonEvent:(id)sender{

    
    if (self.fmPickerDelegate) {
        if ([self.fmPickerDelegate respondsToSelector:@selector(initWithUserCancelSelectedDateOperationResult:
                                                                withIntegerTag:)]) {
            self.dateDataInforForString = nil;
            self.dateDataInforForString = [[NSString alloc]initWithFormat:@"%@",@""];
            [self.fmPickerDelegate initWithUserCancelSelectedDateOperationResult:@"1234234"
                                                                  withIntegerTag:self.UserHiddendIntegerTag];
        }
    }
    [self setHidden:YES];
}

- (void)initWithUserOperationMakeSureButtonEvent:(id)sender{
    if (self.fmPickerDelegate) {
        if ([self.fmPickerDelegate respondsToSelector:@selector(initWithUserDoneSelectedDateOperationResult:
                                                                withIntegerTag:)]) {
            if ([self.dateDataInforForString length] <= 9) {
                NSDate *systemNSData = [[NSDate alloc]init];
                //格式化时间戳
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];

                NSString    *systemDateString = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:systemNSData]];
                self.dateDataInforForString = nil;
                self.dateDataInforForString = [[NSString alloc]initWithFormat:@"%@",systemDateString];
                [self.fmPickerDelegate initWithUserDoneSelectedDateOperationResult:self.dateDataInforForString
                                                                    withIntegerTag:self.UserHiddendIntegerTag];
            }
            [self setHidden:YES];
        }
    }
}

- (void)initWithWithHiddend:(BOOL)boolHiddend
  WithUserHiddendIntegerTag:(NSInteger)IntegerTag{
    
    [self setHidden:NO];
    self.UserHiddendIntegerTag = IntegerTag;
    self.dateDataInforForString = nil;
    self.dateDataInforForString = [[NSString alloc]initWithFormat:@"%@",@""];
}

- (void)initWithCustomerChangeReceiverDateTimeFor:(UIDatePicker *)sender{
    //格式化时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    //设置标签内容
    NSString *dateStringResult = [dateFormatter stringFromDate:sender.date];
    self.dateDataInforForString = nil;
    self.dateDataInforForString = [[NSString alloc]initWithFormat:@"%@",dateStringResult];
    [self.fmPickerDelegate initWithUserDoneSelectedDateOperationResult:self.dateDataInforForString
                                                        withIntegerTag:self.UserHiddendIntegerTag];
}

@end

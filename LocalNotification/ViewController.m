//
//  ViewController.m
//  LocalNotification
//
//  Created by Saurav  Mishra on 12/08/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* Do any additional setup after loading the view, typically from a nib.
        for (int day=WeekdayMonday; day<=WeekdayFriday; day++) {
        NSDate *nextWeekDate=[self calculateNextWeekDay:day];
       [self scheduleNotificationWithDate:nextWeekDate];
    
    }*/
    
    [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSLog(@"Notification %lu: %@",(unsigned long)idx, notification);
    }];
    
}

/*-(NSDate *)calculateNextWeekDay:(Weekday)weekDay
{
    NSDateComponents * todayComponent=[self getDateCompoenentsFromCurrentDate];
    long todayWeekday=todayComponent.weekday;
    long diffFromWeekdays= (weekDay-todayWeekday);
    switch (todayWeekday) {
        case (WeekdaySunday):
            break;
        case (WeekdaySaturday):
            diffFromWeekdays=weekDay;
            break;
        default:{
            if(diffFromWeekdays==0){
                NSInteger currentHour=[todayComponent hour];
                (currentHour>=10)?(diffFromWeekdays=7):(diffFromWeekdays=0);
            }
            else{
                diffFromWeekdays<0?(diffFromWeekdays+=7):diffFromWeekdays;
            }
        }
            break;
    }
    NSDateComponents *newComponent=[todayComponent copy];
    [newComponent setDay:todayComponent.day+diffFromWeekdays];
    [newComponent setTimeZone:[NSTimeZone defaultTimeZone]];
    [newComponent setMinute:0];
    [newComponent setHour:10];
    [newComponent setSecond:0];
    NSCalendar *currentCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *schedulingDate=[currentCalendar dateFromComponents:newComponent];
    NSLog(@"*******Date : %@  ******",
          [schedulingDate descriptionWithLocale:[NSLocale systemLocale]]);

    return schedulingDate;
}

-(NSDateComponents *)getDateCompoenentsFromCurrentDate
{

    NSCalendar *currentCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponent =[currentCalendar components:(NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    return todayComponent;
}

-(void)scheduleNotificationWithDate:(NSDate *)scheduledDate
{
    
}*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ScheduleNotification.m
//  LocalNotification
//
//  Created by Saurav  Mishra on 13/08/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "ScheduleNotification.h"
#import "AppDelegate.h"

//Enum for days in a week
typedef NS_ENUM(NSInteger, Weekday)
{
    WeekdaySunday=1,
    WeekdayMonday,
    WeekdayTuesday,
    WeekdayWednesday,
    WeekdayThursday,
    WeekdayFriday,
    WeekdaySaturday
    
};
@implementation ScheduleNotification
//static variable for singleton
static ScheduleNotification* scheduleNotificationSingleton = nil;

//Create a singleton for the class
+(instancetype)sharedManager
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scheduleNotificationSingleton=[[ScheduleNotification alloc] init];
        });
    return scheduleNotificationSingleton;
}

//Schedule Notifications on all weekdays.
-(void)scheduleLocalNotificationsOnWeekday
{
    //Get Data from JSON file.
    NSArray *arrayOfData=[self getDatafromJSON];
    //Run the loop for all weekdays..Monday through Friday
    for (int day=WeekdayMonday; day<=WeekdayFriday; day++) {
        //Calculate the next nearest weekday.
        NSDate *nextWeekDate=[self calculateNextWeekDay:day];
        //Schedule Local Notification for the weekday
        NSString *title =[[arrayOfData objectAtIndex:day-2] objectForKey:@"Title"];
        NSString *body=[[arrayOfData objectAtIndex:day-2] objectForKey:@"Body"];
        [self scheduleNotificationWithDate:nextWeekDate withTitle:title andBody:body];
    }
}
//Calculate next nearest Weekday
-(NSDate *)calculateNextWeekDay:(Weekday)weekDay
{
    //Get todays Date Components
    NSDateComponents * todayComponent=[self getDateCompoenentsFromCurrentDate];
    //Get todays Weekday
    long todayWeekday=todayComponent.weekday;
    //Get the difference between current Date and each of the weekday
    long diffFromWeekdays= (weekDay-todayWeekday);
    //switch todays weekday and update constraints.
    switch (todayWeekday) {
            //No calculation required for Sunday.Making a case to prevent default calculation
        case (WeekdaySunday):
            break;
            //For saturaday, scheduling will happen always from next monday.
        case (WeekdaySaturday):
            diffFromWeekdays=weekDay;
            break;
        default:{
            //Check if the current date coincides with the weekday passed to the method.
            if(diffFromWeekdays==0){
                //Also check if the notification is fired before 10 AM or not.
                NSInteger currentHour=[todayComponent hour];
                //if the notification is set after 10, then schedule next week, for this day.
                (currentHour>=10)?(diffFromWeekdays=7):(diffFromWeekdays=0);
            }
            else{
                //If the value is negative then that day is past in this week, schedule from next week.else, schedule in this week.
                diffFromWeekdays<0?(diffFromWeekdays+=7):diffFromWeekdays;
            }
        }
            break;
    }
    //Set the date components to 10 AM and default time zone
    NSDateComponents *newComponent=[todayComponent copy];
    [newComponent setDay:todayComponent.day+diffFromWeekdays];
    [newComponent setTimeZone:[NSTimeZone defaultTimeZone]];
    [newComponent setMinute:0];
    [newComponent setHour:10];
    [newComponent setSecond:0];
    NSCalendar *currentCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *schedulingDate=[currentCalendar dateFromComponents:newComponent];
    //NSLog(@"*******Date : %@  ******",[schedulingDate descriptionWithLocale:[NSLocale systemLocale]]);
    //Return the scheuling date
    return schedulingDate;
}
//Get DateComponents from todays Date
-(NSDateComponents *)getDateCompoenentsFromCurrentDate
{
    //Code to check the logic.we can uncomment this and pass any date on todayComponent var to check
    /*  NSString *str =@"9/25/2016 10:00";
     NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
     NSDate *date = [formatter dateFromString:str];
     NSLog(@"*******Date : %@  ******",
     [date descriptionWithLocale:[NSLocale systemLocale]]);*/
    
    NSCalendar *currentCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponent =[currentCalendar components:(NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday) fromDate:[NSDate date]];
    return todayComponent;
}
//Schedule notifications
-(void)scheduleNotificationWithDate:(NSDate *)scheduledDate withTitle:(NSString *)Title andBody:(NSString *)body
{
    UIApplication* app = [UIApplication sharedApplication];
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = scheduledDate;
    localNotification.alertTitle = Title;
    localNotification.alertBody =body;
    localNotification.repeatInterval=NSCalendarUnitWeekday;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [app scheduleLocalNotification:localNotification];
}
//Cancel all notifcations.
-(void)cancelAllNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
//Get data from the JSON file
-(NSArray *)getDatafromJSON
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Notification" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *arrayOfData=[[jsonData objectForKey:@"Notifications"] objectForKey:@"Data"];
    return arrayOfData;
}

@end

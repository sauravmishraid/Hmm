//
//  ScheduleNotification.h
//  LocalNotification
//
//  Created by Saurav  Mishra on 13/08/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleNotification : NSObject

//Get Singleton
+(instancetype)sharedManager;
//Seek Permission For Local Notification.
-(void)seekPermissionForLocalNotification;
//Schedule NotificationsOnWeekday.
-(void)scheduleLocalNotificationsOnWeekday;
//Cancel All Notifications
-(void)cancelAllNotifications;
//check if the user has allowed to notifications.
-(BOOL)isAllowedToSendNotification;
@end

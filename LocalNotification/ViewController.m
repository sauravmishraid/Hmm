//
//  ViewController.m
//  LocalNotification
//
//  Created by Saurav  Mishra on 12/08/16.
//  Copyright © 2016 Saurav  Mishra. All rights reserved.
//

#import "ViewController.h"
#import "ScheduleNotification.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.notificationSwitch.on=[[ScheduleNotification sharedManager]isAllowedToSendNotification];

}
-(void)appplicationIsActive:(NSNotification *)recievedNotification{
    self.notificationSwitch.on=[[ScheduleNotification sharedManager]isAllowedToSendNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}
- (IBAction)switchChanged:(UISwitch *)sender {
    if(sender.isOn){
            if([[ScheduleNotification sharedManager]isAllowedToSendNotification]){
            [[ScheduleNotification  sharedManager] scheduleLocalNotificationsOnWeekday];
        }
        else{
            sender.on=NO;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:"]];
        }
    }
    else{
          [[ScheduleNotification  sharedManager]cancelAllNotifications];
    }
}

@end

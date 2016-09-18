//
//  STCalendarMonthViewController.h
//  CalendarForOneHourTea
//
//  Created by suntie on 2016/7/5.
//  Copyright © 2016年 kocla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "NSDate+convenience.h"
@interface STCalendarMonthViewController : UIViewController<JTCalendarDelegate,JTCalendarMenuViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JTCalendarManager *calendarManager; /**< calendarManager */
@property (weak, nonatomic) IBOutlet UILabel *labAlert;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlert;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHWC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;

@end

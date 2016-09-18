//
//  STCalendarMonthViewController.m
//  CalendarForOneHourTea
//
//  Created by suntie on 2016/7/5.
//  Copyright © 2016年 kocla. All rights reserved.
//

#import "STCalendarMonthViewController.h"

#import "UIColor(Addition).h"
#define Width  [UIScreen mainScreen].bounds.size.width



static CGFloat const dateLabelW = 100;
static CGFloat const previousBtnW = 21;
static CGFloat const nextBtnW = previousBtnW;
static CGFloat const previousBtnTop = 10;
static CGFloat const nextBtnTop = previousBtnTop;
static CGFloat const menuItemViewH = 40;
static CGFloat const dateLabelTAG = 10001;

@interface STCalendarMonthViewController (){

    NSMutableDictionary *_eventsByDate;
    NSDate *_dateSelected;
    
    UIBarButtonItem *_rightItem;
    
    NSArray *_classNumberArr;
    
    NSArray *_classListArr;
    
    
}

@end

@implementation STCalendarMonthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//     self.navigationController.navigationBarHidden=YES;
    self.contentViewHWC.constant = Width - 20;
    if (Width < 375) {
        self.contentViewHWC.constant = 0.8*(Width - 20);
    }

   
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    _calendarMenuView.contentRatio = .75;
    
    _calendarMenuView.delegate = self;
    
    _calendarManager.dateHelper.calendar.firstWeekday = 2;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    
    [self isData:YES];
    
    self.title = @"课表";

    [self refreshCalendar:[NSDate date]];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_dateSelected == nil) {
        _dateSelected = [NSDate date];
    }
    
   
    
}
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    dayView.hidden = NO;
    
    dayView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    
    dayView.labNumber.font = [UIFont systemFontOfSize:10];
    
    dayView.labNumber.textAlignment = NSTextAlignmentCenter;
    

    dayView.labNumber.text = @"";
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [myDateFormatter stringFromDate:dayView.date];
    for (NSDictionary *dic in _classNumberArr) {
        if ([dateStr isEqualToString:[dic valueForKey:@"riQi"]]) {
            dayView.labNumber.text = [NSString stringWithFormat:@"%@节课",[dic valueForKey:@"keCiZongShu"] ];
            dayView.labNumber.hidden = NO;
        }
    }
    // Other month
    if([dayView isFromAnotherMonth]){
//        dayView.hidden = YES;
        dayView.circleView.hidden = YES;
        
        dayView.backgroundColor = [UIColor whiteColor];
        
        dayView.labNumber.hidden = YES;
        
        dayView.textLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = YES;

        dayView.textLabel.text = @"今天";
        
        dayView.textLabel.textColor = [UIColor colorWithHexString:@"13C56D"];
        
        dayView.labNumber.textColor = [UIColor colorWithHexString:@"666666"];
        
        if (_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]) {
            dayView.circleView.hidden = NO;
            
            dayView.circleView.layer.borderWidth = 1.0;
            dayView.circleView.layer.borderColor = [UIColor colorWithHexString:@"13C56D"].CGColor;
            
            dayView.circleView.backgroundColor = [UIColor colorWithHexString:@"DFE9E4"];
            
            dayView.circleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"06lanSeBianKuang"]];
            
            dayView.dotView.backgroundColor = [UIColor clearColor];
            dayView.textLabel.textColor = [UIColor colorWithHexString:@"13C56D"];
            
            dayView.labNumber.textColor = [UIColor colorWithHexString:@"666666"];
        }
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        
        dayView.circleView.layer.borderWidth = 1.0;
        dayView.circleView.layer.borderColor = [UIColor colorWithHexString:@"13C56D"].CGColor;
        
        dayView.circleView.backgroundColor = [UIColor colorWithHexString:@"DFE9E4"];
        
        dayView.circleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"06lanSeBianKuang"]];
        
        dayView.dotView.backgroundColor = [UIColor clearColor];
        dayView.textLabel.textColor = [UIColor colorWithHexString:@"13C56D"];
        
        dayView.labNumber.textColor = [UIColor colorWithHexString:@"666666"];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
        
        dayView.labNumber.textColor = [UIColor colorWithHexString:@"666666"];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
    
    
    
    if ([_calendarManager.dateHelper date:[NSDate date] isEqualOrAfter:dayView.date] && ![_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]) {
       dayView.textLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        dayView.labNumber.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    }
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
    
   

    [self refreshCalendar:[calendar date]];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
    
    
    
    [self refreshCalendar:[calendar date]];
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    

    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Views customization

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UIView * menuItemView = [UIView new];
    menuItemView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, menuItemViewH);
    menuItemView.backgroundColor = [UIColor whiteColor];
    
    //previous
    UIButton * previousBtn = [[UIButton alloc]initWithFrame:CGRectMake(6.5, previousBtnTop, previousBtnW, previousBtnW)];
//    previousBtn.backgroundColor = [UIColor orangeColor];
    [menuItemView  addSubview:previousBtn];
    [previousBtn setImage:[UIImage imageNamed:@"ic_previous_page"] forState:UIControlStateNormal];
    [previousBtn addTarget: self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
    
    //date yyyy.mm
    UILabel *dateLabel = [UILabel new];
    dateLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-dateLabelW/2, 0, dateLabelW, menuItemViewH);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont fontWithName:@"aprial" size:15];
//    dateLabel.backgroundColor = [UIColor redColor];
    dateLabel.tag= dateLabelTAG;
    [menuItemView addSubview:dateLabel];
    
    //next
    UIButton * nextBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-nextBtnW-6.5, nextBtnTop, nextBtnW, nextBtnW)];
//    nextBtn.backgroundColor = [UIColor orangeColor];
    [menuItemView  addSubview:nextBtn];
    [nextBtn setImage:[UIImage imageNamed:@"ic_next_page"] forState:UIControlStateNormal];
    [nextBtn addTarget: self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    return menuItemView;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy年 MM月";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }


    for (UILabel * label in menuItemView.subviews) {
        if (label.tag==dateLabelTAG) {
            
            label.text = [dateFormatter stringFromDate:date];
         
        }
    }
    
    
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    view.backgroundColor = [UIColor grayColor];/**///view for week's background
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];/**///label for week's background
        label.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    
    return view;
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

- (void)nextClick{
    [self.calendarMenuView rightBtnClick];
    
}

- (void)previousClick{
      [self.calendarMenuView leftBtnClick];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_classListArr objectAtIndex:indexPath.section];
    
   if ([[[dic valueForKey:@"dingDanLaiYuan"] description] isEqualToString:@"1"]) {
        return 132;
   }else{
       return 87;
   }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(void)isData:(BOOL)isData{
    
    if (isData) {
        self.tableView.hidden = NO;
        
        self.labAlert.hidden = YES;
        
        self.imgAlert.hidden = YES;
    }else{
        
        self.tableView.hidden = YES;
        
        self.labAlert.hidden = NO;
        
        self.imgAlert.hidden = NO;
    }
}

-(void)btnMessageOnTouch:(id)sender{
    
}




-(void)refreshCalendar:(NSDate *)currentDate{

    
    float hight = 0.0;
    if ([self numRows:currentDate] == 5) {
        hight = (Width - 20)/7 ;
        if (Width < 375) {
            hight = 0.8*(Width - 20)/7;
        }
        self.contentViewTop.constant = 0 - hight;
    }else{
        self.contentViewTop.constant = 0;
       
    }

    

}
-(int)numRows:(NSDate *)currentDate {
  
    float lastBlock = [currentDate numDaysInMonth]+([currentDate firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}
@end

//
//  JTCalendarMenuView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTMenu.h"

@protocol JTCalendarMenuViewDelegate <NSObject>

//-(void)getCurrentDate:(NSDate *)date;

@end
@interface JTCalendarMenuView : UIView<JTMenu, UIScrollViewDelegate>

@property (nonatomic, weak) JTCalendarManager *manager;

@property (nonatomic) CGFloat contentRatio;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, assign)id <JTCalendarMenuViewDelegate> delegate;
/*!
 * Must be call if override the class
 */
- (void)commonInit;

- (void)rightBtnClick;
- (void)leftBtnClick;

@end

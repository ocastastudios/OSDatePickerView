//
//  OSDatePickerView.h
//  Ocasta Studios
//
//  Created by Chris Birch on 06/03/2014.
//  Copyright (c) 2014 OcastaStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OS_DATE_PICKER_VIEW_CLEARDATES @"OSDatePickerClearDates"

typedef NSDate* (^DateBlock)();

@interface OSDatePickerView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,weak) UIView* parentView;

/**
 * Set to YES to show clear dates button
 */
@property (nonatomic,assign) BOOL showClearDatesButton;

/**
 * Set this to provide a default date when no date has been chosen yet
 */
@property (nonatomic,copy) DateBlock defaultDateBlock;


@property (nonatomic,weak) UITextField* txtDateTo;
@property (nonatomic,weak) UITextField* txtDateFrom;

@property (nonatomic,strong) NSDate* dateTo;
@property (nonatomic,strong) NSDate* dateFrom;

/**
 * Set this to the input field that comes after the to text box. This
 * is used to set the keyboard next button. if this is nil then the keyboard says done
 */
@property (nonatomic,weak) UIView* nextResponder;
-(void)update;

@end


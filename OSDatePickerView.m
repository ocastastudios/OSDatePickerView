//
//  OSDatePickerView.m
//  Ocasta Studios
//
//  Created by Chris Birch on 06/03/2014.
//  Copyright (c) 2014 OcastaStudios. All rights reserved.
//

#import "OSDatePickerView.h"
#import "NSString+OSDate.h"
#import "NSDate+OSDateFormatter.h"
#import "NSDate+EasyCarClub.h"

//
//#define TEXT_FIELD_TAG_DATE_FROM 101111
//#define TEXT_FIELD_TAG_DATE_TO   101112

@interface OSDatePickerView ()
{
    UITextField* currentlyEditing;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnClearDates;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end
@implementation OSDatePickerView

-(void)setShowClearDatesButton:(BOOL)showClearDatesButton
{
    _showClearDatesButton = showClearDatesButton;
    
    _btnClearDates.hidden = !showClearDatesButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)cmDone:(UIButton *)sender
{
    if ([_btnDone.titleLabel.text isEqualToString:@"Next"])
    {
        if (currentlyEditing == _txtDateFrom)
        {
            if (_txtDateTo)
                [_txtDateTo becomeFirstResponder];
            else
                [_nextResponder becomeFirstResponder];
        }
        else if(currentlyEditing == _txtDateTo && _nextResponder)
        {
            [_nextResponder becomeFirstResponder];
            
        }
        else
        {
            [currentlyEditing resignFirstResponder];
        }
    }
    else
        [_parentView endEditing:YES];
}
- (IBAction)cmClearDates:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OS_DATE_PICKER_VIEW_CLEARDATES object:nil];
    
    _txtDateFrom.text = @"";
    _txtDateTo.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




-(void)update
{
    
//    _txtDateFrom.tag = TEXT_FIELD_TAG_DATE_FROM;
//    _txtDateTo.tag = TEXT_FIELD_TAG_DATE_TO;
    
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSLocale *uk = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    _datePicker.locale = uk;
    
    
    [_txtDateFrom addTarget:self action:@selector(dateFromEditingBegan:) forControlEvents:UIControlEventEditingDidBegin];
    [_txtDateTo addTarget:self action:@selector(dateToEditingBegan:) forControlEvents:UIControlEventEditingDidBegin];
    
    
    _txtDateFrom.inputView = self;
    _txtDateTo.inputView = self;
    
  //  _txtDateFrom.delegate = _txtDateTo.delegate = self;
    
    if (_txtDateFrom && _txtDateTo)
    {
        [_btnClearDates setTitle:@"Clear Dates" forState:UIControlStateNormal];
    }
    else
        [_btnClearDates setTitle:@"Clear Date" forState:UIControlStateNormal];
    
}

-(NSDate*)defaultDate
{
    if (_defaultDateBlock)
        return _defaultDateBlock();
    else
        return [NSDate date];
}

#pragma mark -
#pragma mark Dates editing started

- (void)dateFromEditingBegan:(UITextField*)sender
{
    currentlyEditing = sender;
    NSDate* date =  [self dateFromString:sender.text];
    
    if (date)
        _datePicker.date = date;
    else
    {
        date = _datePicker.date  =[self defaultDate];

        sender.text = [self stringFromDate:date];
        _dateFrom = date;
    }
    
    //make sure we dont have impossible dates going on
    [self ensureDatesAreValid];
    
    if (_txtDateTo || _nextResponder)
        [_btnDone setTitle:@"Next" forState:UIControlStateNormal];
    else
        [_btnDone setTitle:@"Done" forState:UIControlStateNormal];
    
}
-(void)dateToEditingBegan:(UITextField *)sender
{
    currentlyEditing = sender;
    NSDate* date =  [self dateFromString:sender.text];
    
    if (date)
        _datePicker.date = date;
    else
    {
        date  = _datePicker.date  = [self defaultDate];

        sender.text = [self stringFromDate:date];
        _dateTo = date;
    }
    
    //make sure we dont have impossible dates going on
    [self ensureDatesAreValid];
    
    if (_nextResponder)
        [_btnDone setTitle:@"Next" forState:UIControlStateNormal];
    else
        [_btnDone setTitle:@"Done" forState:UIControlStateNormal];
}





#pragma mark -
#pragma mark Datepicker and date UI


-(void)datePickerChanged:(UIDatePicker*)picker
{
    currentlyEditing.text = [self stringFromDate:picker.date];
    
    if (currentlyEditing == _txtDateFrom)
    {
        _dateFrom = picker.date;
    }
    else
    {
        _dateTo = picker.date;
        
    }
    
    //make sure we dont have impossible dates going on
    [self ensureDatesAreValid];
    
}



#pragma mark -
#pragma mark Date validation

/**
 * Makes sure we dont have impossible dates going on
 */
-(void)ensureDatesAreValid
{
    NSTimeInterval from =[_dateFrom timeIntervalSince1970];
    NSTimeInterval to = [_dateTo timeIntervalSince1970];
    
    //Make sure we dont let the to and from dates get out of sync in relation to each other
    if (to < from)
    {
        _dateTo = _dateFrom;
        _txtDateTo.text = [self stringFromDate:_dateTo];// [_dateTo slidDateAndTimeString];
    }
    
    
    //Make sure we dont let the to and from dates get out of sync in relation to each other
    if (from > to)
    {
        _dateFrom = _dateTo;
        _txtDateFrom.text = [self stringFromDate:_dateFrom];//slidDateAndTimeString];
    }
    
    
}

-(NSDate*)dateFromString:(NSString*)strDate
{
    if (_datePicker.datePickerMode == UIDatePickerModeDate)
    {
        return strDate.dateFromddMMyy;
    }
    else if (_datePicker.datePickerMode == UIDatePickerModeDateAndTime)
    {
        return strDate.dateFromddMMyyHHmm;
    }
    
    return nil;
}

-(NSString*)stringFromDate:(NSDate*)date
{
    if (_datePicker.datePickerMode == UIDatePickerModeDate)
    {
        return date.dateyyyy_MM_dd;
    }
    else if (_datePicker.datePickerMode == UIDatePickerModeDateAndTime)
    {
        return date.dateTimeDD_MM_YY_HH_MM;
    }
    
    return nil;
}




@end

//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EZFormStandardInputAccessoryView.h"

#ifndef IOS7orHigher
#define IOS7orHigher ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#endif


@interface EZFormStandardInputAccessoryView ()
@property (nonatomic, strong) UISegmentedControl *previousNextControl;
@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;


@end


@implementation EZFormStandardInputAccessoryView


- (void)previousNextAction:(id)sender
{
    if (0 ==  [(UISegmentedControl *)sender selectedSegmentIndex]) {
        [self previousAction:sender];
    } else {
        [self nextAction:sender];
    }
}

- (void)previousAction:(id)sender
{
    #pragma unused(sender)
    
    __strong id<EZFormInputAccessoryViewDelegate> inputAccessoryViewDelegate = self.inputAccessoryViewDelegate;
    [inputAccessoryViewDelegate inputAccessoryViewSelectedPreviousField];

}

- (void)nextAction:(id)sender
{
    #pragma unused(sender)
    
    __strong id<EZFormInputAccessoryViewDelegate> inputAccessoryViewDelegate = self.inputAccessoryViewDelegate;
    [inputAccessoryViewDelegate inputAccessoryViewSelectedNextField];
}

- (void)doneAction:(id)sender
{
    #pragma unused(sender)

    __strong id<EZFormInputAccessoryViewDelegate> inputAccessoryViewDelegate = self.inputAccessoryViewDelegate;
    [inputAccessoryViewDelegate inputAccessoryViewDone];
}


#pragma mark - EZFormInputAccessoryViewProtocol methods

- (void)setPreviousActionEnabled:(BOOL)enabled
{
    if (IOS7orHigher) {
        self.previousItem.enabled = enabled;
    } else {
        [self.previousNextControl setEnabled:enabled forSegmentAtIndex:0];
    }
}

- (void)setNextActionEnabled:(BOOL)enabled
{
    if (IOS7orHigher) {
        self.nextItem.enabled = enabled;
    } else {
        [self.previousNextControl setEnabled:enabled forSegmentAtIndex:1];
    }
}

#pragma mark - Helper

static NSString * UIKitLocalizedString(NSString *string)
{
	NSBundle *UIKitBundle = [NSBundle bundleForClass:[UIApplication class]];
	return UIKitBundle ? [UIKitBundle localizedStringForKey:string value:string table:nil] : string;
}

#pragma mark - Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (IOS7orHigher) {

            _previousItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-lightarrow-left"] style:UIBarButtonItemStylePlain target:self action:@selector(previousAction:)];
            _previousItem.tintColor = [UIColor blackColor];

            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            fixedSpace.width = 20.0f;

            _nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-lightarrow-right"] style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)];
            _nextItem.tintColor = [UIColor blackColor];

            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
            doneItem.tintColor = [UIColor blackColor];
            doneItem.accessibilityLabel = @"Keyboard Done Item";

            [self setItems:@[_previousItem, fixedSpace, _nextItem, flexibleItem, doneItem]];

        } else {

            self.barStyle = UIBarStyleBlackTranslucent;
            _previousNextControl = [[UISegmentedControl alloc] initWithItems:@[ UIKitLocalizedString(@"Previous"), UIKitLocalizedString(@"Next") ]];
            _previousNextControl.segmentedControlStyle = UISegmentedControlStyleBar;
            _previousNextControl.momentary = YES;
            [_previousNextControl addTarget:self action:@selector(previousNextAction:) forControlEvents:UIControlEventValueChanged];
            UIBarButtonItem *previousNextItem = [[UIBarButtonItem alloc] initWithCustomView:self.previousNextControl];
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
            [self setItems:@[previousNextItem, flexibleItem, doneItem]];
            doneItem.accessibilityLabel = @"Keyboard Done Item";

        }
    }
    return self;
}


@end

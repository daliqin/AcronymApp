//
//  ViewController.h
//  AcronymApp
//
//  Created by Dali Charles Chin on 11/24/15.
//  Copyright © 2015 Dali Charles Chin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>


@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userInput; // user input textbox
- (IBAction)lookupPress:(id)sender; // the look up button
@property (weak, nonatomic) IBOutlet UITextView *resultTextview; // result show textview

@end


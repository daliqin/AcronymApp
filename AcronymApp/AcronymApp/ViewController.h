//
//  ViewController.h
//  AcronymApp
//
//  Created by Dali Charles Chin on 11/24/15.
//  Copyright © 2015 Dali Charles Chin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userInput;
@property (weak, nonatomic) IBOutlet UILabel *resultShow;
- (IBAction)lookupPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *resultTextview;

@end


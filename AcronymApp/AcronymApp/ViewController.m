//
//  ViewController.m
//  AcronymApp
//
//  Created by Dali Charles Chin on 11/24/15.
//  Copyright © 2015 Dali Charles Chin. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // setting the background image to a custom image named: background.jpg
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // dismiss the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

// dissmiss keyboards when tap on elsewhere or click the lookup button
-(void)dismissKeyboard {
    [self.userInput resignFirstResponder];
}

// dismiss the keyboard when return key is pressed. Also execute the lookupPress button action.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self lookupPress:nil];
    return YES;
}

- (IBAction)lookupPress:(id)sender {
    
    [self.userInput resignFirstResponder];

    // clear the (previous) textview content first in case the user looks up another result again
    self.resultTextview.text = @"";
    
    // defining the source url, the url is consists of two parts: base & key.
    NSString *baseURL = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf="; // base
    NSString *acronymInput = self.userInput.text; // key
    NSString *fullURL = [baseURL stringByAppendingString:acronymInput]; // combining the two into full url
    
    // using afnetworking to fetch data from server and convert the response into JSON
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // setting up the MBP spinning indicator using GCD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"loading";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        // using the block to excute the AFHTTPRequest
        [manager GET:fullURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // converting the response data (in JSON) into id type
            id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
            jsonArray = [jsonData valueForKeyPath:@"lfs"]; // fetch value for key lfs
            
                if (jsonArray.count == 0) {
                    self.resultTextview.text = @"Sorry, no result found :(";
                    
                }else{
                
                    // according to given JSON data structure, array at index 0 and key lf will access the desired data
                    NSArray *resultArray = [jsonArray[0] valueForKey:@"lf"];
                    
                    // displaying the result in the textview in separate lines
                    NSString *str1 = [NSString string];
                    NSString *str2 = [NSString string];
                    
                    for (int i=0; i < resultArray.count; i++) {
                        
                        str1 = [str1 stringByAppendingString:resultArray[i]];
                        str2 = [str1 stringByAppendingString:@"\n\n"];
                        
                        if (i < resultArray.count - 1) {
                            str1 = str2;
                        }
                    }
                    
                    self.resultTextview.text = str1; // showing the result
                
                }
         
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        // dismiss MBP indicator after the task is done
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

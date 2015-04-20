//
//  ViewController.h
//  PuppyLove
//
//  Created by John Fulgoni on 11/12/13.
//  Copyright (c) 2013 John Fulgoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController

//LBS
@property (strong, nonatomic)    CLLocationManager *locationManager;

@property (strong, nonatomic)    IBOutlet UILabel *clickmeLabel;
@property (strong, nonatomic)    IBOutlet UILabel *headerLabel;
@property (strong, nonatomic)    IBOutlet UILabel *footerLabel;

@property (strong, nonatomic)IBOutlet UIButton *myButton;
@property (strong, nonatomic)IBOutlet UIButton *shareButton;

@property (strong, nonatomic)IBOutlet UIStepper *myStepper;


- (IBAction)myButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

- (IBAction)stepperChange:(id)sender;

@end

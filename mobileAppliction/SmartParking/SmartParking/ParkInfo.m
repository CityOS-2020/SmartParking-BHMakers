//
//  ParkInfo.m
//  SmartParking
//
//  Created by Academy387 on 14/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "ParkInfo.h"
#import "DataClass.h"
#import <GoogleMaps/GoogleMaps.h>
static NSString *const BaseURLString = @"http://preview.hardver.ba/parkings/api/payments/";

@interface ParkInfo ()<GMSMapViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate, UIActionSheetDelegate>{
    DataClass *dataClass;
    GMSMapView *mapView_;
    NSMutableData *getResponseData;
    UITextField *pass;
    NSString *hours;
}

@property (nonatomic, retain) NSString *hours;

@end

@implementation ParkInfo
@synthesize hours;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataClass = [DataClass getInstance];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navBar.barTintColor = [self colorWithHexString:@"0088BF"];
    
    self.navigationItem.title = [[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"name"];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navBar.translucent = NO;
    [navBar pushNavigationItem:self.navigationItem animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style: UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:navBar];
    
    self.view.backgroundColor = [self colorWithHexString:@"34495e"];
    
    
    CGRect mapFrame = CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height * 2 / 3);
    float ratio;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"gpsCoordinate"] objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"gpsCoordinate"] objectForKey:@"longitude"] doubleValue]
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:mapFrame camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.delegate = self;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"gpsCoordinate"] objectForKey:@"latitude"] doubleValue], [[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"gpsCoordinate"] objectForKey:@"longitude"] doubleValue]);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    ratio = [[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"freePlaces"] floatValue] / [[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"totalPlaces"] floatValue];
    if (ratio == 0)marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    else if (ratio <= 0.25) marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
    else marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    
    marker.map = mapView_;

    [self.view addSubview:mapView_];
    [self createButtons];
}

- (void)createButtons{
    pass = [[UITextField alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height * 2 / 3) + 64, self.view.frame.size.width, 40)];
    pass.placeholder = @" Pass Code for Parking";
    pass.autocorrectionType = UITextAutocorrectionTypeNo;
    pass.returnKeyType = UIReturnKeyDone;
    pass.borderStyle = UITextBorderStyleNone;
    pass.backgroundColor = [UIColor whiteColor];
    pass.delegate = self;
    [self.view addSubview:pass];
    
    UIButton *rentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rentBtn addTarget:self action:@selector(rentBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [rentBtn setTitle:@"Pay" forState:UIControlStateNormal];
    [rentBtn setFrame:CGRectMake(0, (self.view.frame.size.height * 2 / 3) + 104, self.view.frame.size.width, (self.view.frame.size.height) - ((self.view.frame.size.height * 2 / 3) + 104))];
    [rentBtn setBackgroundColor:[self colorWithHexString:@"0088BF"]];
    [rentBtn setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.view addSubview:rentBtn];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)rentBtnAct{
    if ([pass.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SORRY!" message:@"Enter Pass Code for Parking" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        if(NSClassFromString(@"UIAlertAction")) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Rent Hours" message:@"How Many Hours" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* oneH = [UIAlertAction actionWithTitle:@"1 Hour" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                hours = @"02:00:00";
                [alert dismissViewControllerAnimated:YES completion:nil];
                NSArray *dictionaryKeys = @[@"parkingId",@"parkingPlaceCode",@"duration",];
                NSArray *dictionaryValue = @[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"id"],pass.text,hours];
                NSDictionary *newUserData = [NSDictionary dictionaryWithObjects:dictionaryValue forKeys:dictionaryKeys];
                NSString *jsonFormat = [self formatUserDataForUpload:newUserData];
                
                NSURL *url = [NSURL URLWithString:BaseURLString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSString *authStr = [NSString stringWithFormat:@"Bearer %@",dataClass.token];
                [request setValue:authStr forHTTPHeaderField:@"Authorization"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                NSString *bodydata=[NSString stringWithFormat:@"%@",jsonFormat];
                [request setHTTPMethod:@"POST"];
                NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
                [request setHTTPBody:req];
                
                NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                
                
                if( connection )
                {
                    getResponseData = [NSMutableData new];
                }
                
                
            }];
            UIAlertAction* twoH = [UIAlertAction actionWithTitle:@"2 Hours" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                hours = @"03:00:00";
                [alert dismissViewControllerAnimated:YES completion:nil];
                NSArray *dictionaryKeys = @[@"parkingId",@"parkingPlaceCode",@"duration",];
                NSArray *dictionaryValue = @[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"id"],pass.text,hours];
                NSDictionary *newUserData = [NSDictionary dictionaryWithObjects:dictionaryValue forKeys:dictionaryKeys];
                NSString *jsonFormat = [self formatUserDataForUpload:newUserData];
                
                NSURL *url = [NSURL URLWithString:BaseURLString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSString *authStr = [NSString stringWithFormat:@"Bearer %@",dataClass.token];
                [request setValue:authStr forHTTPHeaderField:@"Authorization"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                NSString *bodydata=[NSString stringWithFormat:@"%@",jsonFormat];
                [request setHTTPMethod:@"POST"];
                NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
                [request setHTTPBody:req];
                
                NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                
                
                if( connection )
                {
                    getResponseData = [NSMutableData new];
                }
                
            }];
            UIAlertAction* threeH = [UIAlertAction actionWithTitle:@"3 Hours" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                hours = @"04:00:00";
                [alert dismissViewControllerAnimated:YES completion:nil];
                NSArray *dictionaryKeys = @[@"parkingId",@"parkingPlaceCode",@"duration",];
                NSArray *dictionaryValue = @[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"id"],pass.text,hours];
                NSDictionary *newUserData = [NSDictionary dictionaryWithObjects:dictionaryValue forKeys:dictionaryKeys];
                NSString *jsonFormat = [self formatUserDataForUpload:newUserData];
                
                NSURL *url = [NSURL URLWithString:BaseURLString];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSString *authStr = [NSString stringWithFormat:@"Bearer %@",dataClass.token];
                [request setValue:authStr forHTTPHeaderField:@"Authorization"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
                NSString *bodydata=[NSString stringWithFormat:@"%@",jsonFormat];
                [request setHTTPMethod:@"POST"];
                NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
                [request setHTTPBody:req];
                
                NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                
                
                if( connection )
                {
                    getResponseData = [NSMutableData new];
                }
                
            }];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:oneH];
            [alert addAction:twoH];
            [alert addAction:threeH];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];

        }else{
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    @"1 Hour",
                                    @"2 Hours",
                                    @"3 Hours",
                                    nil];
            popup.tag = 1;
            [popup showInView:[UIApplication sharedApplication].keyWindow];

        }

    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 0: hours = @"02:00:00";
            break;
        case 1: hours = @"03:00:00";
            break;
        case 2: hours = @"04:00:00";
            break;
        default:
            break;
    }
    
    NSArray *dictionaryKeys = @[@"parkingId",@"parkingPlaceCode",@"duration",];
    NSArray *dictionaryValue = @[[[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"id"],pass.text,hours];
    NSDictionary *newUserData = [NSDictionary dictionaryWithObjects:dictionaryValue forKeys:dictionaryKeys];
    NSString *jsonFormat = [self formatUserDataForUpload:newUserData];
    
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authStr = [NSString stringWithFormat:@"Bearer %@",dataClass.token];
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    NSString *bodydata=[NSString stringWithFormat:@"%@",jsonFormat];
    [request setHTTPMethod:@"POST"];
    NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
    [request setHTTPBody:req];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
    if( connection )
    {
        getResponseData = [NSMutableData new];
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (NSString*)formatUserDataForUpload:(NSDictionary*) userData{
    
    NSError *error = nil;
    
    //Serialize the JSON data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userData
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        //Create a string from the JSON Data
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@",jsonString);
        return jsonString;
    }
    else if ([jsonData length] == 0 && error == nil){
        NSLog(@"No data was returned after the serialization");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@",error);
    }
    return nil;
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)Back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HTTP POST

-(void) connection:(NSURLConnection*) connetion didReceiveData:(NSData *)data
{
    [getResponseData appendData:data];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
}

-(void) connectionDidFinishLoading:(NSURLConnection*) connection
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:getResponseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"return: %@", dict);
    if (!dict) {
        dataClass.exParkingId = [[dataClass.parkingData objectAtIndex:dataClass.index] objectForKey:@"id"];
        dataClass.exParkingPID = pass.text;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SUCCESS!" message:@"Payment Done" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end

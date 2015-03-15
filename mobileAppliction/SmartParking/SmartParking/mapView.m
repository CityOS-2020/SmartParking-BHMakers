//
//  mapView.m
//  SmartParking
//
//  Created by Academy387 on 13/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "mapView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DataClass.h"
#import "ParkInfo.h"
#import "profileInfo.h"

static NSString *const BaseURLString = @"http://preview.hardver.ba/parkings/api/parkings/";

@interface mapView ()<NSURLConnectionDelegate, GMSMapViewDelegate>{
    GMSMapView *mapView_;
    NSMutableData *getResponseData;
    DataClass *dataClass;
    NSURLConnection *connection;
    NSTimer *timerCounter;
    UIView *ExView;
    UILabel *label;
    UIButton *button;
}
@property(nonatomic, strong) NSURLConnection *connection;
@property int checker;

@end

@implementation mapView
@synthesize connection, checker;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataClass = [DataClass getInstance];
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navBar.barTintColor = [self colorWithHexString:@"0088BF"];
    
    self.navigationItem.title = @"Parking";
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navBar.translucent = NO;
    [navBar pushNavigationItem:self.navigationItem animated:NO];
    
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style: UIBarButtonItemStyleDone target:self action:@selector(profileEnter)];
    self.navigationItem.rightBarButtonItem = profile;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:navBar];

    checker = 0;
    CGRect f = self.view.frame;
    CGRect mapFrame = CGRectMake(f.origin.x, 64, f.size.width, f.size.height - 64);

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.8667
                                                            longitude:18.4167
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:mapFrame camera:camera];
    mapView_.mapType = kGMSTypeHybrid;
    mapView_.delegate = self;
    [self.view addSubview:mapView_];
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshEveryMinute];
    timerCounter = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(refreshEveryMinute) userInfo:nil repeats: YES];
    checker = 0;
    
    if (dataClass.exParkingPID) {
        UIBarButtonItem *check = [[UIBarButtonItem alloc] initWithTitle:@"EXP" style: UIBarButtonItemStyleDone target:self action:@selector(checkExpireDate)];
        self.navigationItem.leftBarButtonItem= check;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timerCounter invalidate];
}

- (void)checkExpireDate{
    [timerCounter invalidate];
    checker = 1;
    
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://preview.hardver.ba/parkings/api/parkings/%@/places/by-code/%@",dataClass.exParkingId,dataClass.exParkingPID]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection)
    {
        getResponseData = [NSMutableData new];
    }

    
}
- (void)refreshEveryMinute{
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(connection)
    {
        getResponseData = [NSMutableData new];
    }

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)profileEnter
{
    profileInfo *profile = [[profileInfo alloc] init];
    [self presentViewController:profile animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    if (checker == 0) {
        float ratio;
        
        dataClass.parkingData = (NSArray*)dict;
        [mapView_ clear];
        
        for (NSDictionary *dic in dataClass.parkingData) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([[[dic objectForKey:@"gpsCoordinate"] objectForKey:@"latitude"] doubleValue], [[[dic objectForKey:@"gpsCoordinate"] objectForKey:@"longitude"] doubleValue]);
            marker.title = [dic objectForKey:@"name"];
            marker.snippet = [NSString stringWithFormat:@"Total Places: %@ \nFree Places: %@",[dic objectForKey:@"totalPlaces"],[dic objectForKey:@"freePlaces"]];
            marker.appearAnimation = kGMSMarkerAnimationPop;
            ratio = [[dic objectForKey:@"freePlaces"] floatValue] / [[dic objectForKey:@"totalPlaces"] floatValue];
            if (ratio == 0)marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
            else if (ratio <= 0.25) marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            else marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            
            marker.map = mapView_;
        }
    }else if (checker == 1){
        if ([dict objectForKey:@"expiresAt"]) {
            
            NSString *dateString = [dict objectForKey:@"expiresAt"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [formatter setLocale:posix];
            NSDate *date = [formatter dateFromString:dateString];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Expire Date" message:[NSString stringWithFormat:@"Your Expire Date Will be Expired At: %@",[[[NSString stringWithFormat:@"%@",date] componentsSeparatedByString: @" "] objectAtIndex: 1]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];

            [self refreshEveryMinute];
            timerCounter = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(refreshEveryMinute) userInfo:nil repeats: YES];
            checker = 0;
            
        }
    }
}

- (void)exButtonAct{

}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    int i = 0;
    for (NSDictionary *dic in dataClass.parkingData) {
        if ([marker.title isEqualToString:[dic objectForKey:@"name"]]) {
            break;
        }
        i++;
    }
    dataClass.index = i;
    ParkInfo *parkInfo = [[ParkInfo alloc] init];
    [self presentViewController:parkInfo animated:YES completion:nil];

}
@end

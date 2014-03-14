//
//  ViewController.m
//  iBeaconPOCiPhone
//
//  Created by Rick de Hoop on 06-03-14.
//  Copyright (c) 2014 Rick de Hoop. All rights reserved.
//

#import "ViewController.h"
#import <ESTBeaconManager.h>

#define DOT_MIN_POS 120
#define DOT_MAX_POS screenHeight - 70;

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) UIImageView*      positionDot;
@property (nonatomic, strong) ESTBeacon*        selectedBeacon;
@property (nonatomic, strong) NSNumber*         blauw;
@property (nonatomic, strong) NSNumber*         groen;
@property (nonatomic, strong) NSNumber*         paars;
@property (nonatomic, assign) BOOL              firstTime;

@property (nonatomic) float dotMinPos;
@property (nonatomic) float dotRange;

@end

@implementation ViewController



#pragma mark - View Setup

- (void)setupBackgroundImage
{
    CGRect          screenRect          = [[UIScreen mainScreen] bounds];
    CGFloat         screenHeight        = screenRect.size.height;
    UIImageView*    backgroundImage;
    
    if (screenHeight > 480)
    {
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundBig"]];
    }
    else
    {
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundSmall"]];
    }
    
    [self.view addSubview:backgroundImage];
}

- (void)setupDotImage
{
    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotImage"]];
    [self.positionDot setCenter:self.view.center];
    [self.positionDot setAlpha:1.0f];
    
    [self.view addSubview:self.positionDot];
    
    self.dotMinPos = 150;
    self.dotRange = self.view.bounds.size.height  - 220;
}

- (void)setupView
{
    [self setupBackgroundImage];
    [self setupDotImage];
}

#pragma mark - Manager setup

- (void)setupManager
{
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];

    //set MINOR from the devices
    self.blauw = [NSNumber numberWithInt:11111];
    self.groen = [NSNumber numberWithInt:33333];
    self.paars = [NSNumber numberWithInt:22222];
    
}



#pragma mark - ViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupManager];
    //[self setupView];
}

#pragma mark - ESTBeaconManagerDelegate Implementation

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    NSLog(@"Methode uitgevoerd");
    NSLog([NSString stringWithFormat:@"#Beacons: %d", [beacons count]]);
    if([beacons count] > 0)
    {
        if(!self.selectedBeacon)
        {
            // initially pick closest beacon
            self.selectedBeacon = [beacons objectAtIndex:0];
           
            NSLog([NSString stringWithFormat:@"1: %@",
                   [self.selectedBeacon.distance stringValue]]);
            
            
            
        }
        else
        {
            NSLog([NSString stringWithFormat:@"2: %@",
                   [self.selectedBeacon.distance stringValue]]);
            for (ESTBeacon* cBeacon in beacons)
            {
                // update beacon it same as selected initially
                if([self.selectedBeacon.major unsignedShortValue] == [cBeacon.major unsignedShortValue] &&
                   [self.selectedBeacon.minor unsignedShortValue] == [cBeacon.minor unsignedShortValue])
                {
                    self.selectedBeacon = cBeacon;
                }
            }
        }
        
        
    //    if ([self.selectedBeacon.distance doubleValue] > 0.1 && [self.selectedBeacon.distance doubleValue] < 1.8) {
            if ([self.selectedBeacon.minor isEqual:self.blauw]) {
                [self removeFromParentViewController];
                [self performSegueWithIdentifier:@"naarBlauw" sender:self];
                
            }
            if ([self.selectedBeacon.minor isEqual:self.groen]) {
                [self performSegueWithIdentifier:@"naarGroen" sender:self];
                [self removeFromParentViewController];
            }
            if ([self.selectedBeacon.minor isEqual:self.paars]) {
                [self performSegueWithIdentifier:@"naarPaars" sender:self];
                [self removeFromParentViewController];
            }
     //   }
      //  else
       // {
            // do nuttin men
       // }
        
        // based on observation rssi is not getting bigger then -30
        // so it changes from -30 to -100 so we normalize
  //      float distFactor = ((float)self.selectedBeacon.rssi + 30) / -70;
        
        // calculate and set new y position
   //     float newYPos = self.dotMinPos + distFactor * self.dotRange;
   //     self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
        
    }
    else
    {
        NSLog([NSString stringWithFormat:@"3: %@",
               @"Geen beacons"]);
    }
    // create sample region object (you can additionaly pass major / minor values)
   // ESTBeaconRegion* region2 = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
   //                                                               identifier:@"EstimoteSampleRegion"];
   // [self.beaconManager startRangingBeaconsInRegion:region2];

}

@end

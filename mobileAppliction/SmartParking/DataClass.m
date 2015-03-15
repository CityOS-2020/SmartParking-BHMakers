//
//  DataClass.m
//  SmartParking
//
//  Created by Academy387 on 14/03/15.
//  Copyright (c) 2015 Academy387. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize token, parkingData, index, exParkingPID, exParkingId;

static DataClass *instance = nil;

+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataClass new];
        }
    }
    return instance;
}

@end

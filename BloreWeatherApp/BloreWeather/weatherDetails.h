//
//  weatherDetails.h
//  BloreWeather
//
//  Created by Ln, Ganapathy on 8/26/16.
//  Copyright © 2016 Ln, Ganapathy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weatherDetails : NSObject


@property (nonatomic,strong) NSString* weatherHrlyDate;
@property (nonatomic,strong) NSString* temperature;
@property (nonatomic,strong) NSString* pressure;
@property (nonatomic,strong) NSString* humidity;
@property (nonatomic,strong) NSString* weatherMain;
@property (nonatomic,strong) NSString* weatherDesc;
@property (nonatomic,strong) NSString* imageId;


@end

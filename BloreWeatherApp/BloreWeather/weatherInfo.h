//
//  weatherInfo.h
//  BloreWeather
//
//  Created by Ln, Ganapathy on 8/26/16.
//  Copyright © 2016 Ln, Ganapathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "weatherDetails.h"


@interface weatherInfo : NSObject

@property (nonatomic,strong) NSString* weatherDate;
@property (nonatomic,strong) NSString* cityName;
@property (nonatomic,strong) NSString* countryName;
@property (nonatomic,strong) NSMutableArray* hrlyWeatherDetails;

@end



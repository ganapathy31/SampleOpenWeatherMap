//
//  MapContentViewController.m
//  BloreWeather
//
//  Created by Ln, Ganapathy on 8/25/16.
//  Copyright © 2016 Ln, Ganapathy. All rights reserved.
//

#import "MapContentViewController.h"

@interface MapContentViewController ()
@property (nonatomic, weak) IBOutlet  UILabel *city;
@property (nonatomic, weak) IBOutlet  UILabel *country;
@property (nonatomic, weak) IBOutlet  UILabel *dayOfTheWeek;
@property (nonatomic, weak) IBOutlet  UILabel *weatherDate;
@property (nonatomic, weak) IBOutlet  UILabel *temperature;
@property (nonatomic, weak) IBOutlet  UILabel *humidity;
@property (nonatomic, weak) IBOutlet  UILabel *time;
@property (nonatomic, weak) IBOutlet  UILabel *weatherMain;
@property (nonatomic, weak) IBOutlet  UILabel *weatherDescription;
@end

@implementation MapContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.city.text = _WeatehrDataOf.cityName;
	self.country.text = _WeatehrDataOf.countryName;
	self.dayOfTheWeek.text = [self getDayOfTheWeekFromDateString:_WeatehrDataOf.weatherDate];
	weatherDetails *details = [_WeatehrDataOf.hrlyWeatherDetails objectAtIndex:0];
	self.weatherDate.text = [self getonlyDatefromDateString:_WeatehrDataOf.weatherDate];
	self.temperature.text =  [NSString stringWithFormat:@"%f", [details.temperature floatValue] - 273.15];
	self.humidity.text = [NSString stringWithFormat:@"%@",details.humidity];
	self.time.text = [self getTimefromDateString:details.weatherHrlyDate];
	self.weatherMain.text = details.weatherMain;
	self.weatherDescription.text = details.weatherDesc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSDate*)getDatefromString:(NSString*)str
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dt = [dateFormatter dateFromString:str];
	return dt;
}

-(NSString*)getDayOfTheWeekFromDateString:(NSString *)str
{
	NSDate *date = [self getDatefromString:str];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	return ([dateFormatter stringFromDate:date]);
}

-(NSString*)getonlyDatefromDateString:(NSString*)str
{
	NSDate *date =  [self getDatefromString:str];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"dd-MM-yyyy";
	return([dateFormatter stringFromDate:date]);
}

-(NSString *)getTimefromDateString:(NSString*)str
{
	NSDate *date =  [self getDatefromString:str];
	NSDateFormatter *dateFormatter = [[NSDateFormatter new] init];
	[dateFormatter setDateFormat:@"hh:mm"];
	NSString *timeString = [dateFormatter stringFromDate:date];
	return timeString;
}
@end

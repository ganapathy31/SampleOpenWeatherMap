//
//  ViewController.m
//  BloreWeather
//
//  Created by Ln, Ganapathy on 8/25/16.
//  Copyright © 2016 Ln, Ganapathy. All rights reserved.
//

#import "ViewController.h"
#import "MapContentViewController.h"
#import "weatherInfo.h"
#import "weatherDetails.h"

#define OPENWEATHERMAP_ID @"3ed5683b0052da38fb101505b1aacd24"
#define WEATHERLOCATION	@"Bangalore,IN"
@class weatherDetails;

@interface ViewController ()
{
 NSMutableArray *daywiseWeatehrData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	daywiseWeatehrData = [[NSMutableArray alloc]init];
	[self FetchWeatherData];
	
}

-(void)initialisePageviewcontrollers
{
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
	self.pageViewController.dataSource = self;
	
	MapContentViewController *startingViewController = [self viewControllerAtIndex:0];
	NSArray *viewControllers = @[startingViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
	
	[self addChildViewController:_pageViewController];
	[self.view addSubview:_pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
}

-(void) FetchWeatherData
{
	[self getOpenWeatherMapDatawithCompletionHalder:^(id weatherData, NSError *error) {
		NSDate *prevDate = nil;
		NSDate *currDate =[NSDate date];
		
		
	if (weatherData) {
		weatherInfo *tmpWeatherInfo;
		NSMutableDictionary *weatherList = [weatherData valueForKey:@"list"];
		
		for(NSDictionary  *weatherDict in weatherList)
		{
			weatherDetails *weatherStatus= [[weatherDetails alloc] init];
			currDate =[self getDateFromString:[weatherDict valueForKey:@"dt_txt"]];
			
			if(![self comparetwoDates:prevDate withDate:currDate]) {
			NSDictionary *cityDict = [weatherData valueForKey:@"city"];
				tmpWeatherInfo = [[weatherInfo alloc] init];
				tmpWeatherInfo.cityName = [cityDict valueForKey:@"name"];
				tmpWeatherInfo.countryName = [cityDict valueForKey:@"country"];
				tmpWeatherInfo.hrlyWeatherDetails = [[NSMutableArray alloc]init];
				[daywiseWeatehrData addObject:tmpWeatherInfo];
			}
			
			tmpWeatherInfo.weatherDate = [weatherDict valueForKey:@"dt_txt"];
			
			NSDictionary *mainDict = [weatherDict valueForKey:@"main"];
			weatherStatus.temperature = [mainDict valueForKey:@"temp"];
			weatherStatus.pressure = [mainDict valueForKey:@"pressure"];
			weatherStatus.humidity = [mainDict valueForKey:@"humidity"];
			
			NSArray *weatehrArray = [weatherDict valueForKey:@"weather"];
			NSDictionary *weather;
			if([weatehrArray isKindOfClass:[NSArray class]]) {
				weather = [weatehrArray firstObject];
				weatherStatus.weatherMain = [weather valueForKey:@"main"];
				weatherStatus.weatherDesc = [weather valueForKey:@"description"];
				weatherStatus.imageId =[weather valueForKey:@"icon"];
				weatherStatus.weatherHrlyDate = [weatherDict valueForKey:@"dt_txt"];
				[tmpWeatherInfo.hrlyWeatherDetails addObject:weatherStatus];
			}// Extracting the weather
			prevDate = [self getDateFromString:tmpWeatherInfo.weatherDate];
		} // Extracting from List
		
		[self initialisePageviewcontrollers];
	}
	else {
			NSLog(@" failure");
		}
	}];
}

-(NSDate*)getDateFromString:(NSString *)str
 {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dt = [dateFormatter dateFromString:str];
	return dt;
 }


-(bool)comparetwoDates:(NSDate*)date1 withDate:(NSDate*)date2
{
	if(date1 == nil || date2 == nil)
	{
		return FALSE;
	}
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
	
	NSDateComponents *date1Components = [calendar components:comps
													fromDate: date1];
	NSDateComponents *date2Components = [calendar components:comps
													fromDate: date2];
	[date1Components setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[date2Components setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	NSDate* dt1 = [calendar dateFromComponents:date1Components];
	
	NSDate* dt2 = [calendar dateFromComponents:date2Components];
	
	NSComparisonResult result = [dt1 compare:dt2];
	if (result == NSOrderedSame) {
		return TRUE;
	}
	else return FALSE;
}

- (void) getOpenWeatherMapDatawithCompletionHalder:(void (^)(id weatherData, NSError *error))completionHandler
{
	NSString *urlStr = [NSString stringWithFormat:@"%@%@&APPID=%@",@"http://api.openweathermap.org/data/2.5/forecast/city?q=",WEATHERLOCATION,OPENWEATHERMAP_ID];
	NSURL* url = [NSURL URLWithString:urlStr];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setTimeoutInterval:120.0];
	
	
	NSURLSession *session = [NSURLSession sharedSession];
	[[session dataTaskWithRequest:request
										 completionHandler:
							   ^(NSData *data, NSURLResponse *response, NSError *connectionError) {
		NSDictionary *servresponse = nil;
		if (!connectionError && data.length > 0) {
		servresponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
		
				NSLog(@" Success");
		}else {
				NSLog(@" Error");
		}
		dispatch_async(dispatch_get_main_queue(), ^{
		completionHandler (servresponse, connectionError);
		});
	}] resume];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger index = ((MapContentViewController*) viewController).pageIndex;
	
	if ((index == 0) || (index == NSNotFound)) {
		return nil;
	}
	
	index--;
	return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = ((MapContentViewController*) viewController).pageIndex;
	
	if (index == NSNotFound) {
		return nil;
	}
	
	index++;
	if (index == [daywiseWeatehrData count]) {
		return nil;
	}
	return [self viewControllerAtIndex:index];
}


- (MapContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
	if (([daywiseWeatehrData count] == 0) || (index >= [daywiseWeatehrData count])) {
		return nil;
	}
	
	// Create a new view controller and pass suitable data.
	MapContentViewController *mapContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapContentViewController"];
	mapContentViewController.WeatehrDataOf = [daywiseWeatehrData objectAtIndex:index];
	mapContentViewController.pageIndex = index;
	
	return mapContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return [daywiseWeatehrData count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return 0;
}

@end

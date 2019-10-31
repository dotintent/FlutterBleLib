@interface ServiceResponseConverter : NSObject

+ (NSString *)jsonStringFromServicesResponse:(NSArray *)servicesResponse;

+ (NSArray *)servicesFromServicesResponse:(NSArray *)servicesResponse;

@end

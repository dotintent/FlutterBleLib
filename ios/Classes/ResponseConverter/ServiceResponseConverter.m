#import "ServiceResponseConverter.h"
#import "ServiceResponse.h"
#import "JSONStringifier.h"

@implementation ServiceResponseConverter

const NSString *keyServiceId = @"serviceId";
const NSString *keyServiceUuid = @"serviceUuid";

+ (NSString *)jsonStringFromServicesResponse:(NSArray *)servicesResponse {
    NSArray *result = [self servicesFromServicesResponse:servicesResponse];
    return [JSONStringifier jsonStringFromJSONObject:result];
}

+ (NSArray *)servicesFromServicesResponse:(NSArray *)servicesResponse {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *service in servicesResponse) {
        [result addObject:[self serviceDictionaryFromServiceResponse:service]];
    }
    return result;
}

+ (NSDictionary *)serviceDictionaryFromServiceResponse:(NSDictionary *)serviceResponse {
    NSDictionary *service = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [serviceResponse objectForKey:SERVICE_RESPONSE_ID], keyServiceId,
                             [serviceResponse objectForKey:SERVICE_RESPONSE_UUID], keyServiceUuid,
                             nil];
    return service;
}

@end

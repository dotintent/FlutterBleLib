#import "DescriptorResponseConverter.h"
#import "DescriptorResponse.h"
#import "JSONStringifier.h"

@implementation DescriptorResponseConverter

const NSString *keyDescriptorResponseDescriptorId = @"descriptorId";
const NSString *keyDescriptorResponseDescriptorUuid = @"descriptorUuid";
const NSString *keyDescriptorResponseValue = @"value";
const NSString *keyDescriptorResponseServiceId = @"serviceId";
const NSString *keyDescriptorResponseServiceUuid = @"serviceUuid";
const NSString *keyDescriptorResponseCharacteristicId = @"id";
const NSString *keyDescriptorResponseCharacteristicUuid = @"uuid";
const NSString *keyDescriptorResponseDescriptors = @"descriptors";

+ (NSString *)jsonStringFromDescriptorResponse:(NSDictionary *)response {
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [response objectForKey:DESCRIPTOR_RESPONSE_ID], keyDescriptorResponseDescriptorId,
                                [response objectForKey:DESCRIPTOR_RESPONSE_UUID], keyDescriptorResponseDescriptorUuid,
                                [response objectForKey:DESCRIPTOR_RESPONSE_VALUE], keyDescriptorResponseValue,
                                [response objectForKey:DESCRIPTOR_RESPONSE_SERVICE_ID], keyDescriptorResponseServiceId,
                                [response objectForKey:DESCRIPTOR_RESPONSE_SERVICE_UUID], keyDescriptorResponseServiceUuid,
                                [response objectForKey:DESCRIPTOR_RESPONSE_CHARACTERISTIC_ID], keyDescriptorResponseCharacteristicId,
                                [response objectForKey:DESCRIPTOR_RESPONSE_CHARACTERISTIC_UUID], keyDescriptorResponseCharacteristicUuid,
                                nil];
    return [JSONStringifier jsonStringFromJSONObject:result];
}

+ (NSString *)jsonStringFromMultipleDescriptorsResponse:(NSArray *)descriptorsResponse {
    if ([descriptorsResponse count] > 0) {
        NSMutableArray *descriptors = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDescriptor in descriptorsResponse) {
            [descriptors addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                        [singleDescriptor objectForKey:DESCRIPTOR_RESPONSE_ID], keyDescriptorResponseDescriptorId,
                                        [singleDescriptor objectForKey:DESCRIPTOR_RESPONSE_UUID], keyDescriptorResponseDescriptorUuid,
                                    nil]
             ];
        }
        
        NSDictionary *firstDescriptor = descriptorsResponse[0];
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [firstDescriptor objectForKey:DESCRIPTOR_RESPONSE_SERVICE_ID], keyDescriptorResponseServiceId,
                                [firstDescriptor objectForKey:DESCRIPTOR_RESPONSE_SERVICE_UUID], keyDescriptorResponseServiceUuid,
                                [firstDescriptor objectForKey:DESCRIPTOR_RESPONSE_CHARACTERISTIC_ID], keyDescriptorResponseCharacteristicId,
                                [firstDescriptor objectForKey:DESCRIPTOR_RESPONSE_CHARACTERISTIC_UUID], keyDescriptorResponseCharacteristicUuid,
                                descriptors, keyDescriptorResponseDescriptors,
                                nil];
        
        return [JSONStringifier jsonStringFromJSONObject:result];
    } else {
        return [JSONStringifier jsonStringFromJSONObject:descriptorsResponse];
    }
}

@end

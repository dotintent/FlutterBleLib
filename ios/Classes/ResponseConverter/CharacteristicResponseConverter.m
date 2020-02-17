#import "CharacteristicResponseConverter.h"
#import "CharacteristicResponse.h"
#import "JSONStringifier.h"

@implementation CharacteristicResponseConverter

const NSString *keyServiceUUID = @"serviceUuid";
const NSString *keyServiceID = @"serviceId";
const NSString *keyCharacteristic = @"characteristic";
const NSString *keyTransactionId = @"transactionId";

const NSString *keyCharacteristicResponseUUID = @"characteristicUuid";
const NSString *keyCharacteristicResponseId = @"id";
const NSString *keyIsIndicatable = @"isIndicatable";
const NSString *keyIsNotifiable = @"isNotifiable";
const NSString *keyIsNotifying = @"isNotifying";
const NSString *keyIsReadable = @"isReadable";
const NSString *keyIsWritableWithResponse = @"isWritableWithResponse";
const NSString *keyIsWritableWithoutResponse = @"isWritableWithoutResponse";
const NSString *keyValue = @"value";

const NSString *keyCharacteristics = @"characteristics";

+ (NSString *)jsonStringFromCharacteristicResponse:(NSDictionary *)characteristicResponse
                                     transactionId:(NSString *)transactionId {
    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_SERVICE_UUID], keyServiceUUID,
                            [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_SERVICE_ID], keyServiceID,
                            [self characteristicDictionaryFromCharacteristicResponse:characteristicResponse], keyCharacteristic,
                            transactionId, keyTransactionId,
                            nil];

    return [JSONStringifier jsonStringFromJSONObject:result];
}

+ (NSString *)jsonStringFromCharacteristicsResponse:(NSArray *)characteristicsResponse {
    NSArray *result = [self characteristicsFromCharacteristicResponse:characteristicsResponse];
    return [JSONStringifier jsonStringFromJSONObject:result];
}

+ (NSString *)jsonStringWithServiceFromCharacteristicsResponse:(NSArray *)characteristicsResponse {
    NSArray *characteristics = [self characteristicsFromCharacteristicResponse:characteristicsResponse];
    id serviceId;
    id serviceUuid;

    if (characteristicsResponse.count == 0) {
        serviceId = [NSNumber numberWithInt:-1];
        serviceUuid = [NSNull null];
    } else {
        serviceId = [characteristicsResponse.firstObject objectForKey:CHARACTERISTIC_RESPONSE_SERVICE_ID];
        serviceUuid = [characteristicsResponse.firstObject objectForKey:CHARACTERISTIC_RESPONSE_SERVICE_UUID];
    }

    NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                            characteristics, keyCharacteristics,
                            serviceId, keyServiceID,
                            serviceUuid, keyServiceUUID,
                            nil];
    return [JSONStringifier jsonStringFromJSONObject:result];

}

+ (NSArray *)characteristicsFromCharacteristicResponse:(NSArray *)characteristicsResponse {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *characteristic in characteristicsResponse) {
        [result addObject:[self characteristicDictionaryFromCharacteristicResponse:characteristic]];
    }
    return result;
}

+ (NSDictionary *)characteristicDictionaryFromCharacteristicResponse:(NSDictionary *)characteristicResponse {
    NSDictionary *characteristic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_UUID], keyCharacteristicResponseUUID,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_ID], keyCharacteristicResponseId,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_READABLE], keyIsReadable,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITH_RESPONSE], keyIsWritableWithResponse,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITHOUT_RESPONSE], keyIsWritableWithoutResponse,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_NOTIFIABLE], keyIsNotifiable,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_NOTIFYING], keyIsNotifying,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_IS_INDICATABLE], keyIsIndicatable,
                                    [characteristicResponse objectForKey:CHARACTERISTIC_RESPONSE_VALUE], keyValue,
                                    nil];
    return characteristic;
}

@end

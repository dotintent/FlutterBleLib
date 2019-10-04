#import "PeripheralResponseConverter.h"
#import "PeripheralResponse.h"
#import "JsonStringifier.h"

@implementation PeripheralResponseConverter

const NSString *keyId = @"id";
const NSString *keyName = @"name";

+ (NSString *)jsonStringFromPeripheralResponse:(NSArray *)response {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    for (NSDictionary *peripheral in response) {
        NSDictionary *device = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [peripheral objectForKey:PERIPHERAL_RESPONSE_ID], keyId,
                                [peripheral objectForKey:PERIPHERAL_RESPONSE_NAME], keyName,
                                nil];
        [result addObject:device];
    }

    return [JSONStringifier jsonStringFromJSONObject:result];
};

@end

@implementation DescriptorResponseConvert

+ (NSString *)jsonStringFromDescriptorResponse:(NSDictionary *)response
                                 transactionId:(NSString *)transactionId {
    //TODO
    return [JSONStringifier jsonStringFromJSONObject:response];
}

+ (NSString *)jsonStringFromDescriptorsResponse:(NSArray *)descriptorsResponse {
    //TODO
    return [JSONStringifier jsonStringFromJSONObject:descriptorsResponse];
}

@end

@interface DescriptorResponseConverter : NSObject

+ (NSString *)jsonStringFromDescriptorResponse:(NSDictionary *)response
                           transactionId:(NSString *)transactionId;

+ (NSString *)jsonStringFromDescriptorsResponse:(NSArray *)descriptorsResponse;

@end

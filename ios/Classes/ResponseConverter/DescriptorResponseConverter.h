@interface DescriptorResponseConverter : NSObject

+ (NSString *)jsonStringFromDescriptorResponse:(NSDictionary *)response;

+ (NSString *)jsonStringFromMultipleDescriptorsResponse:(NSArray *)descriptorsResponse;

@end

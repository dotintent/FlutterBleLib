@interface DescriptorResponseConverter : NSObject

+ (NSString *)jsonStringFromDescriptorResponse:(NSDictionary *)response;

+ (NSString *)jsonStringFromDescriptorsResponse:(NSArray *)descriptorsResponse;

@end

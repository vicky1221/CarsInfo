#import "GTMNSString+URLArguments.h"

@implementation NSString (GTMNSStringURLArgumentsAdditions)

- (NSString*)gtm_stringByEscapingForURLArgument {
  // Encode all the reserved characters, per RFC 3986
  // (<http://www.ietf.org/rfc/rfc3986.txt>)
  CFStringRef escaped = 
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
  return [NSMakeCollectable(escaped) autorelease];
}

- (NSString*)gtm_stringByUnescapingFromURLArgument {
  NSMutableString *resultString = [NSMutableString stringWithString:self];
  [resultString replaceOccurrencesOfString:@"+"
                                withString:@" "
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [resultString length])];
  return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

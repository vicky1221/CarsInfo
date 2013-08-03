//
//  NSString+Custom.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Custom.h"

@class Session;
int base64_encode (char *b64store, const char *str, int length)
{
	/* Conversion table.  */
	static char tbl[64] = {
		'A','B','C','D','E','F','G','H',
		'I','J','K','L','M','N','O','P',
		'Q','R','S','T','U','V','W','X',
		'Y','Z','a','b','c','d','e','f',
		'g','h','i','j','k','l','m','n',
		'o','p','q','r','s','t','u','v',
		'w','x','y','z','0','1','2','3',
		'4','5','6','7','8','9','+','/'
	};
	int i;
	const unsigned char *s = (const unsigned char *) str;
	char *p = b64store;
	
	/* Transform the 3x8 bits to 4x6 bits, as required by base64.  */
	for (i = 0; i < length; i += 3)
    {
		*p++ = tbl[s[0] >> 2];
		*p++ = tbl[((s[0] & 3) << 4) + (s[1] >> 4)];
		*p++ = tbl[((s[1] & 0xf) << 2) + (s[2] >> 6)];
		*p++ = tbl[s[2] & 0x3f];
		s += 3;
    }
	
	/* Pad the result if necessary...  */
	if (i == length + 1)
		*(p - 1) = '=';
	else if (i == length + 2)
		*(p - 1) = *(p - 2) = '=';
	
	/* ...and zero-terminate it.  */
	*p = '\0';
	
	return p - b64store;
}

int base64_encode_xor(char *b64store, const char *str, int length, const char *xor_string)
{
	char *__tmp = malloc(length);
	memcpy(__tmp, str, length);
	
	int __len = strlen(xor_string);
	
	for (int i = 0; i < length; )
	{
		for (int j = 0; j < __len && i < length; j++)
		{
			__tmp[i++] ^= xor_string[j];
		}
	}
	
	int ret = base64_encode(b64store, __tmp, length);
	free(__tmp);
	
	return ret;
}


@implementation NSString (custom)

- (NSString *)stripEditSpace {
	const char *s = [self UTF8String];
	const char pattern[] = "\xe2\x80\x86";
	int l = strlen(s);
	int lp = strlen(pattern);
	char r[l+1];
	bzero((void *)r, sizeof(l+1));
	char *t;
	while ((t = strstr(s, pattern))) {
		strncat(r, s, t - s);
		s = t + lp;
	}
	if (*s) {
		strcat(r, s);
	}
	NSLog(@"stripSpace %s", r);
	
	return [NSString stringWithUTF8String:r];
}

- (NSString *)stripSpace {

	NSArray *comps = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];   
	
	NSMutableArray *words = [NSMutableArray array];   
	for(NSString *comp in comps) {   
		if([comp length] > 0) {
			[words addObject:comp];   
		}   
	}   
	
	NSString *result = [words componentsJoinedByString:@""];
	return result;
}

static NSDictionary *ed = nil;

+ (NSDictionary *)createEmoji:(NSString *)filename {
	if (ed)
		return ed;
    NSURL *epath = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    NSString *etxt = [NSString stringWithContentsOfURL:epath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [etxt componentsSeparatedByString:@"\n"];
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:100];
    float ios_version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
    for (NSString *l in lines) {
        NSArray *kv = [l componentsSeparatedByString:@" "];
		
        if (kv.count == 2) {
            NSString *v;
            NSString *k;
            if (ios_version < 5) {
                v = [kv objectAtIndex:1];
                k = [kv objectAtIndex:0];
            } else {
                v = [kv objectAtIndex:0];
                k = [kv objectAtIndex:1];
            }
			//          k = [k lowercaseString];
            [keys addObject:k];
            [values addObject:v];
			//          NSLog(@"line <%@, %@>", k, v);
        }
    }
	
    ed = [[NSDictionary dictionaryWithObjects:values forKeys:keys] retain];
    return ed;
}

- (NSString *)replaceEmoji {
	NSLog(@"replaceEmoji %@", self);
	NSArray *keys = ed.allKeys;
	NSString *retStr = self;
	
	for (NSString *k in keys) {
		retStr = [retStr stringByReplacingOccurrencesOfString:k withString:[ed objectForKey:k]];
	}
	return retStr;
}

- (NSString *)replaceEmojiBin {
	NSString *retStr = self;
	for (int i = 0; i < retStr.length; i++) {
		NSRange range = NSMakeRange(i, 1);
		NSString *c = [retStr substringWithRange:range];
		NSString *r = [ed objectForKey:c];
		if (r) {
			retStr = [retStr stringByReplacingCharactersInRange:range withString:r];
		}
	}
	return retStr;
}

- (NSString *)base64EncodeXOR:(NSString *)XorString
{
	const char *utf8 = [self UTF8String];
	int len = strlen(utf8);
	char b64store[len * 2];
	const char *passwd = [XorString UTF8String];

	memset(b64store, 0, len * 2);

	base64_encode_xor(b64store, utf8, len, passwd);

	return [NSString stringWithUTF8String:b64store];
}

- (NSString *)base64EncodeXOR {
	return [self base64EncodeXOR:XOR_PASSWD];
}

- (NSDictionary *)queryDict {
	NSArray *a = [self componentsSeparatedByString:@"&"];
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	for (NSString *s in a) {
		NSArray *sa = [s componentsSeparatedByString:@"="];
		if (sa.count == 2) {
			[d setObject:sa[1] forKey:sa[0]];
		}
	}
	return d;
}

+ (NSString *)toString:(id)object {
	return [NSString stringWithFormat:@"%@", object];
}

@end
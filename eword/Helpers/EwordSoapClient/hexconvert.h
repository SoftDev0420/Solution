//
//  hexconvert.h
//  ewordexample
//
//  Created by Isaac Jessop on 11/26/14.
//  Copyright (c) 2014 zeeksgeeks. All rights reserved.
//

#ifndef ewordexample_hexconvert_h
#define ewordexample_hexconvert_h


#endif

#import <Foundation/Foundation.h>

@interface NSData (NSData_Conversion)

#pragma mark - String Conversion
- (NSString *)hexadecimalString;
- (NSString *)hexString;

@end

@interface NSString(MD5)

- (NSString *)MD5;

@end
@interface NSData (MD5Digest)

+(NSData *)MD5Digest:(NSData *)input;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSData *)input;
-(NSString *)MD5HexDigest;

@end

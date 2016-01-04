//
//  NSData+Endian.m
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

#import "NSData+Endian.h"

@implementation NSData (Endian)
- (UInt16) bigEndianUInt16
{
    UInt16 *data = (UInt16 *)[self bytes];
#if TARGET_RT_LITTLE_ENDIAN
    return ntohs(*data);
#else
    return *data;
#endif
}

- (UInt32)bigEndianUInt32
{
    UInt32 *data = (UInt32 *) [self bytes];
#if TARGET_RT_LITTLE_ENDIAN
    return ntohl(*data);
#else
    return *data;
#endif
}

- (Float32)bigEndianFloat32
{
    UInt32 *data = (UInt32 *) [self bytes];
    CFSwappedFloat32 arg;
    arg.v = *data;
    return CFConvertFloat32SwappedToHost(arg);
}

@end

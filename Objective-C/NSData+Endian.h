//
//  NSData+Endian.h
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Endian)
- (UInt16)bigEndianUInt16;
- (UInt32)bigEndianUInt32;
- (Float32)bigEndianFloat32;
@end

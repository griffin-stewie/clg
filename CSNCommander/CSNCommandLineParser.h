//
//  CSNCommandLineParser.h
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNCommandOption.h"
#import "CSNCommand.h"

@interface CSNCommandLineParser : NSObject
+ (int)runWithCommand:(NSObject <CSNCommand> *)command;
@end



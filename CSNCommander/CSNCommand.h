//
//  CSNCommand.h
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNCommandOption.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CSNCommand <NSObject>
- (int)runWithArguments:(NSArray *)args;
- (nullable CSNCommandOption *)commandOption;
- (nullable id <CSNCommand>)commandForCommandName:(NSString *)commandName;
@end
NS_ASSUME_NONNULL_END
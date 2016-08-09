//
//  CSNCommandOption.h
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNCommandOptionItem.h"

@interface CSNCommandOption : NSObject
- (void)registerOption:(NSString *)longOption shortcut:(NSString *)shortOption keyName:(NSString *)keyName requirement:(CSNCommandOptionRequirement)requirement;
- (CSNCommandOptionItem *)optionItemWithArgument:(NSString *)argument;
@end

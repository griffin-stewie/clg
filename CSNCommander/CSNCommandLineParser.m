//
//  CSNCommandLineParser.m
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import "CSNCommandLineParser.h"
#import "CSNCommandOptionItem.h"

@implementation CSNCommandLineParser
+ (int)runWithCommand:(NSObject <CSNCommand> *)command
{
    int result = 0;
    @autoreleasepool {
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        [[self class] _runWithCommand:command arguments:[processInfo arguments]];
    }
    return result;
}

+ (int)_runWithCommand:(NSObject <CSNCommand> *)command arguments:(NSArray *)args
{
    int result = 0;
    @autoreleasepool {

        NSMutableArray *arguments = [NSMutableArray arrayWithArray:args];
        NSMutableArray *parsedArg = [NSMutableArray array];

        NSObject <CSNCommand> *currentCommand = command;
        NSString *executePath = nil;
        if ([arguments count] > 1) {
            executePath = [arguments objectAtIndex:0];
            [arguments removeObjectAtIndex:0];

            executePath = [executePath stringByExpandingTildeInPath];
            [[NSFileManager defaultManager] changeCurrentDirectoryPath:executePath];

            NSString *arg = [arguments objectAtIndex:0];
            if (arg) {
                NSObject <CSNCommand> *cmd = [currentCommand commandForCommandName:arg];
                if (cmd) {
                    currentCommand = cmd;
                    [arguments removeObjectAtIndex:0];
                }
            }
        }

        CSNCommandOption *option = [currentCommand commandOption];
        CSNCommandOptionItem *item = nil;
        NSString *stored = nil;
        for (NSString *arg in arguments) {
            item = [option optionItemWithArgument:arg];
            if (item) {
                switch (item.requirement) {
                    case CSNCommandOptionRequirementNone: {
                        [currentCommand setValue:@YES forKey:item.keyName];
                    }
                        break;
                    case CSNCommandOptionRequirementOptional:
                    case CSNCommandOptionRequirementRequired: {
                        if (stored) {
                            [currentCommand setValue:arg forKey:stored];
                            stored = nil;
                        } else {
                            stored = item.keyName;
                        }
                    }
                        break;
                }
            } else {
                [parsedArg addObject:arg];
            }
        }
        
        [currentCommand setValue:executePath forKey:@"executePath"];
        result = [currentCommand runWithArguments:[NSArray arrayWithArray:parsedArg]];
    }
    
    return result;
}

@end

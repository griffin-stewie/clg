//
//  CSNCommandOptionItem.m
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import "CSNCommandOptionItem.h"

@interface CSNCommandOptionItem ( )
@property (nonatomic, strong, readwrite) NSString *longOption;
@property (nonatomic, strong, readwrite) NSString *shortOption;
@property (nonatomic, strong, readwrite) NSString *keyName;
@property (nonatomic, assign, readwrite) CSNCommandOptionRequirement requirement;
@property (nonatomic, assign) BOOL waitRequiredArgument;
@end


@implementation CSNCommandOptionItem
+ (instancetype)optionItemWithOption:(NSString *)longOption shortcut:(NSString *)shortOption keyName:(NSString *)keyName requirement:(CSNCommandOptionRequirement)requirement
{
    return [[[self class] alloc] initWithOption:longOption shortcut:shortOption keyName:keyName requirement:requirement];
}

- (instancetype)initWithOption:(NSString *)longOption shortcut:(NSString *)shortOption keyName:(NSString *)keyName requirement:(CSNCommandOptionRequirement)requirement
{
    self = [super init];
    if (self) {
        self.longOption = longOption;
        self.shortOption = shortOption;
        self.keyName = (keyName == nil) ? longOption : keyName;
        self.requirement = requirement;
    }
    
    return self;
}

- (BOOL)canAcceptArgument:(NSString *)argument
{
    if ([argument isEqualTo:[self longOptionArgumetRepresentation]]) {
        if (self.requirement != CSNCommandOptionRequirementNone) {
            self.waitRequiredArgument = YES;
        }
        return YES;
    } else if ([argument isEqualTo:[self shortOptionArgumetRepresentation]]) {
        if (self.requirement != CSNCommandOptionRequirementNone) {
            self.waitRequiredArgument = YES;
        }

        return YES;
    } else {
        if (self.waitRequiredArgument) {
            self.waitRequiredArgument = NO;
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)longOptionArgumetRepresentation
{
    if ([self.longOption length] == 0) {
        return nil;
    }
    
    return [@"--" stringByAppendingString:self.longOption];
}

- (NSString *)shortOptionArgumetRepresentation
{
    if ([self.shortOption length] == 0) {
        return nil;
    }
    
    return [@"-" stringByAppendingString:self.shortOption];
}
@end

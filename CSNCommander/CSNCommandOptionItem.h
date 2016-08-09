//
//  CSNCommandOptionItem.h
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, CSNCommandOptionRequirement) {
    CSNCommandOptionRequirementNone,
    CSNCommandOptionRequirementOptional,
    CSNCommandOptionRequirementRequired,
};

@interface CSNCommandOptionItem : NSObject

@property (nonatomic, strong, readonly) NSString *longOption;
@property (nonatomic, strong, readonly) NSString *shortOption;
@property (nonatomic, strong, readonly) NSString *keyName;
@property (nonatomic, assign, readonly) CSNCommandOptionRequirement requirement;

+ (instancetype)optionItemWithOption:(NSString *)longOption shortcut:(NSString *)shortOption keyName:(NSString *)keyName requirement:(CSNCommandOptionRequirement)requirement;
- (BOOL)canAcceptArgument:(NSString *)argument;
@end

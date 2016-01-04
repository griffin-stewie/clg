//
//  CSNCommandOption.m
//  xcassetsgen
//
//  Created by griffin_stewie on 2014/02/23.
//  Copyright (c) cyan-stivy.net. All rights reserved.
//

#import "CSNCommandOption.h"

@interface CSNCommandOption ( )
@property (nonatomic, strong) NSMutableArray *optionItems;
@end


@implementation CSNCommandOption

- (NSMutableArray *)optionItems
{
    if (_optionItems == nil) {
        _optionItems = [NSMutableArray array];
    }
    
    return _optionItems;
}

- (void)registerOption:(NSString *)longOption shortcut:(NSString *)shortOption keyName:(NSString *)keyName requirement:(CSNCommandOptionRequirement)requirement
{
    CSNCommandOptionItem *item = [CSNCommandOptionItem optionItemWithOption:longOption shortcut:shortOption keyName:keyName requirement:requirement];
    [self.optionItems addObject:item];
}

- (CSNCommandOptionItem *)optionItemWithArgument:(NSString *)argument
{
    __block CSNCommandOptionItem *result = nil;
    
    [self.optionItems enumerateObjectsUsingBlock:^(CSNCommandOptionItem *item, NSUInteger idx, BOOL *stop) {
        if ([item canAcceptArgument:argument]) {
            result = item;
            *stop = YES;
        }
    }];
    
    return result;
}
@end

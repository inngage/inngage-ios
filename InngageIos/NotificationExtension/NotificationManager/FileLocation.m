//
//  FileLocation.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "FileLocation.h"

@implementation FileLocation

- (instancetype)initWithIdentifier:(NSString *)identifier andLocation:(NSURL *)location andMimeTypeModel:(MimeTypeModel *)mimeTypeModel {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.location = location;
        self.mimeTypeModel = mimeTypeModel;
    }
    return self;
}

@end

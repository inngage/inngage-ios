//
//  FileLocation.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MimeType.h"

@interface FileLocation : NSObject

@property(nonatomic) NSString *identifier;
@property(nonatomic) NSURL *location;
@property(nonatomic) MimeTypeModel *mimeTypeModel;

- (instancetype)initWithIdentifier:(NSString *)identifier andLocation:(NSURL *)location andMimeTypeModel:(MimeTypeModel *)mimeTypeModel;

@end


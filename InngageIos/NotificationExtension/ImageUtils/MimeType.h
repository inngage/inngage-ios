//
//  MimeType.h
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MimeTypeFileType) {
    MimeTypeFileTypeAmr,
    MimeTypeFileTypeAr,
    MimeTypeFileTypeAvi,
    MimeTypeFileTypeBmp,
    MimeTypeFileTypeBz2,
    MimeTypeFileTypeCab,
    MimeTypeFileTypeCr2,
    MimeTypeFileTypeCrx,
    MimeTypeFileTypeDeb,
    MimeTypeFileTypeDmg,
    MimeTypeFileTypeEot,
    MimeTypeFileTypeEpub,
    MimeTypeFileTypeExe,
    MimeTypeFileTypeFlac,
    MimeTypeFileTypeFlif,
    MimeTypeFileTypeFlv,
    MimeTypeFileTypeGif,
    MimeTypeFileTypeGz,
    MimeTypeFileTypeIco,
    MimeTypeFileTypeJpg,
    MimeTypeFileTypeJxr,
    MimeTypeFileTypeLz,
    MimeTypeFileTypeM4a,
    MimeTypeFileTypeM4v,
    MimeTypeFileTypeMid,
    MimeTypeFileTypeMkv,
    MimeTypeFileTypeMov,
    MimeTypeFileTypeMp3,
    MimeTypeFileTypeMp4,
    MimeTypeFileTypeMpg,
    MimeTypeFileTypeMsi,
    MimeTypeFileTypeMxf,
    MimeTypeFileTypeNes,
    MimeTypeFileTypeOgg,
    MimeTypeFileTypeOpus,
    MimeTypeFileTypeOtf,
    MimeTypeFileTypePdf,
    MimeTypeFileTypePng,
    MimeTypeFileTypePs,
    MimeTypeFileTypePsd,
    MimeTypeFileTypeRar,
    MimeTypeFileTypeRpm,
    MimeTypeFileTypeRtf,
    MimeTypeFileTypeSevenZ,
    MimeTypeFileTypeSqlite,
    MimeTypeFileTypeSwf,
    MimeTypeFileTypeTar,
    MimeTypeFileTypeTif,
    MimeTypeFileTypeTtf,
    MimeTypeFileTypeWav,
    MimeTypeFileTypeWebm,
    MimeTypeFileTypeWebp,
    MimeTypeFileTypeWmv,
    MimeTypeFileTypeWoff,
    MimeTypeFileTypeWoff2,
    MimeTypeFileTypeXpi,
    MimeTypeFileTypeXz,
    MimeTypeFileTypeZ,
    MimeTypeFileTypeZip,
};

@class MimeTypeModel;

typedef BOOL (^MimeTypeMatchesBlock)(UInt8 *bytes, MimeTypeModel *model);

@interface MimeTypeModel : NSObject

/**
 Mime type string representation. For example "application/pdf"
 */
@property(nonatomic, strong)NSString *mime;

/**
 Mime type extension. For example "pdf"
 */
@property(nonatomic, strong)NSString *ext;

/**
 Mime type shorthand representation. For example `.pdf`
 */
@property(nonatomic, assign)MimeTypeFileType type;

@end

@interface MimeType : NSObject

@property(nonatomic, strong)MimeTypeModel *currentMimeTypeModel __attribute__((deprecated("Remove.")));

+ (instancetype)sharedInstance;

- (MimeTypeModel *)mimeTypeModelWithData:(NSData *)data;

- (MimeTypeModel *)mimeTypeModelWithURL:(NSURL *)url;

- (MimeTypeModel *)mimeTypeModelWithPath:(NSString *)path;

+ (instancetype)initWithData:(NSData *)data __attribute__((deprecated("Use mimeTypeModelWithData: instead."))) ;

+ (instancetype)initWithURL:(NSURL *)url __attribute__((deprecated("Use mimeTypeModelWithURL: instead.")));

+ (instancetype)initWithPath:(NSString *)path __attribute__((deprecated("Use mimeTypeModelWithPath: instead.")));

@end



//
//  MimeType.m
//  InngageLibrary
//
//  Created by Augusto Cesar do Nascimento dos Reis on 31/01/21.
//  Copyright © 2021 PagSeguro. All rights reserved.
//

#import "MimeType.h"

@interface MimeTypeModel ()

/**
 Number of bytes required for `MimeType` to be able to check if the
 given bytes match with its mime type magic number specifications.
 */
@property(nonatomic, assign)NSUInteger bytesCount;


/**
 A function to check if the bytes match the `MimeType` specifications.
 */
@property(nonatomic, copy)MimeTypeMatchesBlock matchesBlock;

@end

@implementation MimeTypeModel

- (instancetype)initWithMime:(NSString *)mime ext:(NSString *)ext type:(MimeTypeFileType)type bytesCount:(NSUInteger)bytesCount matchesBlock:(MimeTypeMatchesBlock)matchesBlock
{
    self = [super init];
    if (self) {
        self.mime = mime;
        self.ext = ext;
        self.type = type;
        self.bytesCount = bytesCount;
        self.matchesBlock = matchesBlock;
    }
    return self;
}

@end

@interface MimeType()

@property(nonatomic, strong)NSData *data;

@property(nonatomic, strong)NSArray<MimeTypeModel *> *mimeTypeModelArray;

@end


@implementation MimeType

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (instancetype)initWithData:(NSData *)data
{
    MimeType *mimeType = [MimeType new];
    mimeType.data = data;
    [mimeType parse];

    return mimeType;
}

+ (instancetype)initWithURL:(NSURL *)url {
    MimeType *mimeType = [MimeType new];
    mimeType.data = [[NSData alloc] initWithContentsOfURL:url];
    [mimeType parse];

    return mimeType;
}

+ (instancetype)initWithPath:(NSString *)path {
    MimeType *mimeType = [MimeType new];
    mimeType.data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:path]];
    [mimeType parse];

    return mimeType;
}

- (MimeTypeModel *)mimeTypeModelWithData:(NSData *)data {
    self.data = data;
    return [self parse];
}

- (MimeTypeModel *)mimeTypeModelWithURL:(NSURL *)url {
    self.data = [[NSData alloc] initWithContentsOfURL:url];
    return [self parse];
}

- (MimeTypeModel *)mimeTypeModelWithPath:(NSString *)path {
    self.data = [[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:path]];
    return [self parse];
}

- (MimeTypeModel *)parse {
    if (!self.data) {
        return nil;
    }

    UInt8 bytes[262];
    [self.data getBytes:&bytes length:262];

    self.currentMimeTypeModel = nil;
    for (MimeTypeModel *model in self.mimeTypeModelArray) {
        if (model.matchesBlock(bytes, model)) {
            self.currentMimeTypeModel = model;
            break;
        }
    }

    return self.currentMimeTypeModel;
}

- (NSArray<MimeTypeModel *> *)mimeTypeModelArray {
    if (_mimeTypeModelArray == nil) {
        NSMutableArray<MimeTypeModel *> *array = [NSMutableArray array];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/jpeg" ext:@"jpg" type:MimeTypeFileTypeJpg bytesCount:3 matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/png" ext:@"png" type:MimeTypeFileTypePng bytesCount:3 matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/gif" ext:@"gif" type:MimeTypeFileTypeGif bytesCount:3 matchesBlock:^BOOL(UInt8 *bytes,  MimeTypeModel *model) {
            return (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/webp" ext:@"webp" type:MimeTypeFileTypeWebp bytesCount:12 matchesBlock:^BOOL(UInt8 *bytes,  MimeTypeModel *model) {
            return (bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/flif" ext:@"flif" type:MimeTypeFileTypeFlif bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x46 && bytes[1] == 0x4C && bytes[2] == 0x49 && bytes[3] == 0x46);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/x-canon-cr2" ext:@"cr2" type:MimeTypeFileTypeCr2 bytesCount:10  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return ((bytes[0] == 0x49 && bytes[1] == 0x49 && bytes[2] == 0x2A && bytes[3] == 0x00)
                    || (bytes[0] == 0x4D && bytes[1] == 0x4D && bytes[2] == 0x00 && bytes[3] == 0x2A)) && (bytes[8] == 0x43 && bytes[9] == 0x52);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/tiff" ext:@"tif" type:MimeTypeFileTypeTif bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return ((bytes[0] == 0x49 && bytes[1] == 0x49 && bytes[2] == 0x2A && bytes[3] == 0x00)
                    || (bytes[0] == 0x4D && bytes[1] == 0x4D && bytes[2] == 0x00 && bytes[3] == 0x2A));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/bmp" ext:@"bmp" type:MimeTypeFileTypeBmp bytesCount:2  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x42 && bytes[1] == 0x4D);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/vnd.ms-photo" ext:@"jxr" type:MimeTypeFileTypeJxr bytesCount:3  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x49 && bytes[1] == 0x49 && bytes[2] == 0xBC);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/vnd.adobe.photoshop" ext:@"psd" type:MimeTypeFileTypePsd bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x38 && bytes[1] == 0x42 && bytes[2] == 0x50 && bytes[3] == 0x53);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/epub+zip" ext:@"epub" type:MimeTypeFileTypeEpub bytesCount:58  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x50 && bytes[1] == 0x4B && bytes[2] == 0x03 && bytes[3] == 0x04)
            && (bytes[30] == 0x6D && bytes[31] == 0x69 && bytes[32] == 0x6D && bytes[33] == 0x65
                && bytes[34] == 0x74 && bytes[35] == 0x79 && bytes[36] == 0x70 && bytes[37] == 0x65
                && bytes[38] == 0x61 && bytes[39] == 0x70 && bytes[40] == 0x70 && bytes[41] == 0x6C
                && bytes[42] == 0x69 && bytes[43] == 0x63 && bytes[44] == 0x61 && bytes[45] == 0x74
                && bytes[46] == 0x69 && bytes[47] == 0x6F && bytes[48] == 0x6E && bytes[49] == 0x2F
                && bytes[50] == 0x65 && bytes[51] == 0x70 && bytes[52] == 0x75 && bytes[53] == 0x62
                && bytes[54] == 0x2B && bytes[55] == 0x7A && bytes[56] == 0x69 && bytes[57] == 0x70);
        }]];

        // Needs to be before `zip` check
        // assumes signed .xpi from addons.mozilla.org

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-xpinstall" ext:@"xpi" type:MimeTypeFileTypeXpi bytesCount:50  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x50 && bytes[1] == 0x4B && bytes[2] == 0x03 && bytes[3] == 0x04) &&
            (bytes[30] == 0x4D && bytes[31] == 0x45 && bytes[32] == 0x54 && bytes[33] == 0x41 &&
             bytes[34] == 0x2D && bytes[35] == 0x49 && bytes[36] == 0x4E && bytes[37] == 0x46 &&
             bytes[38] == 0x2F && bytes[39] == 0x6D && bytes[40] == 0x6F && bytes[41] == 0x7A &&
             bytes[42] == 0x69 && bytes[43] == 0x6C && bytes[44] == 0x6C && bytes[45] == 0x61 &&
             bytes[46] == 0x2E && bytes[47] == 0x72 && bytes[48] == 0x73 && bytes[49] == 0x61);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/zip" ext:@"zip" type:MimeTypeFileTypeZip bytesCount:50  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x50 && bytes[1] == 0x4B) &&
            (bytes[2] == 0x3 || bytes[2] == 0x5 || bytes[2] == 0x7) &&
            (bytes[3] == 0x4 || bytes[3] == 0x6 || bytes[3] == 0x8);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-tar" ext:@"tar" type:MimeTypeFileTypeTar bytesCount:262  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[257] == 0x75 && bytes[258] == 0x73 && bytes[259] == 0x74 && bytes[260] == 0x61 && bytes[261] == 0x72);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-rar-compressed" ext:@"rar" type:MimeTypeFileTypeRar bytesCount:7  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x52 && bytes[1] == 0x61 && bytes[2] == 0x72 && bytes[3] == 0x21 && bytes[4] == 0x1A && bytes[5] == 0x07) &&
            (bytes[6] == 0x0 || bytes[6] == 0x1);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/gzip" ext:@"gz" type:MimeTypeFileTypeGz bytesCount:3  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x1F && bytes[1] == 0x8B && bytes[2] == 0x08);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-bzip2" ext:@"bz2" type:MimeTypeFileTypeBz2 bytesCount:3  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x42 && bytes[1] == 0x5A && bytes[2] == 0x68);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-7z-compressed" ext:@"7z" type:MimeTypeFileTypeSevenZ bytesCount:6  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x37 && bytes[1] == 0x7A && bytes[2] == 0xBC && bytes[3] == 0xAF && bytes[4] == 0x27 && bytes[5] == 0x1C);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-apple-diskimage" ext:@"dmg" type:MimeTypeFileTypeDmg bytesCount:2  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x78 && bytes[1] == 0x01);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/mp4" ext:@"mp4" type:MimeTypeFileTypeMp4 bytesCount:28  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return ((bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00) && (bytes[3] == 0x18 || bytes[3] == 0x20) && (bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70)) ||
            (bytes[0] == 0x33 && bytes[1] == 0x67 && bytes[2] == 0x70 && bytes[3] == 0x35) ||
            ((bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00 && bytes[3] == 0x1C &&
              bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 &&
              bytes[8] == 0x6D && bytes[9] == 0x70 && bytes[10] == 0x34 && bytes[11] == 0x32) &&
             (bytes[16] == 0x6D && bytes[17] == 0x70 && bytes[18] == 0x34 && bytes[19] == 0x31 &&
              bytes[20] == 0x6D && bytes[21] == 0x70 && bytes[22] == 0x34 && bytes[23] == 0x32 &&
              bytes[24] == 0x69 && bytes[25] == 0x73 && bytes[26] == 0x6F && bytes[27] == 0x6D)) ||
            (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00 && bytes[3] == 0x1C &&
             bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 &&
             bytes[8] == 0x69 && bytes[9] == 0x73 && bytes[10] == 0x6F && bytes[11] == 0x6D) ||
            (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00 && bytes[3] == 0x1C &&
             bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 &&
             bytes[8] == 0x6D && bytes[9] == 0x70 && bytes[10] == 0x34 && bytes[11] == 0x32);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/x-m4v" ext:@"m4v" type:MimeTypeFileTypeM4v bytesCount:11  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00 && bytes[3] == 0x1C &&
                    bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 &&
                    bytes[8] == 0x4D && bytes[9] == 0x34 && bytes[10] == 0x56);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/midi" ext:@"mid" type:MimeTypeFileTypeMid bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4D && bytes[1] == 0x54 && bytes[2] == 0x68 && bytes[3] == 0x64);
        }]];


        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/x-matroska" ext:@"mkv" type:MimeTypeFileTypeMkv bytesCount:4 matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            if (! (bytes[0] == 0x1A && bytes[1] == 0x45 && bytes[2] == 0xDF && bytes[3] == 0xA3)) {
                return false;
            }

            NSInteger idPos = -1;
            UInt8 _bytes[4100];
            [self.data getBytes:&_bytes length:4100];
            for (int i = 0; i < 4100; ++i) {
                if (_bytes[i] == 0x42 &&  _bytes[i + 1] == 0x82) {
                    idPos =  i;
                    break;
                }
            }

            if (idPos <= -1) {
                return false;
            }

            NSInteger docTypePos = idPos + 3;
            NSString *type = @"matroska";
            for (int i = 0; i < type.length; ++i) {
                unichar scalars = [type characterAtIndex:i];
                if (_bytes[docTypePos + i] != scalars) {
                    return false;
                }
            }

            return true;
        }]];


        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/webm" ext:@"webm" type:MimeTypeFileTypeWebm bytesCount:4 matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            if (! (bytes[0] == 0x1A && bytes[1] == 0x45 && bytes[2] == 0xDF && bytes[3] == 0xA3)) {
                return false;
            }

            NSInteger idPos = -1;
            UInt8 _bytes[4100];
            [self.data getBytes:&_bytes length:4100];
            for (int i = 0; i < 4100; ++i) {
                if (_bytes[i] == 0x42 &&  _bytes[i + 1] == 0x82) {
                    idPos =  i;
                    break;
                }
            }

            if (idPos <= -1) {
                return false;
            }

            NSInteger docTypePos = idPos + 3;
            NSString *type = @"webm";
            for (int i = 0; i < type.length; ++i) {
                unichar scalars = [type characterAtIndex:i];
                if (_bytes[docTypePos + i] != scalars) {
                    return false;
                }
            }

            return true;
        }]];


        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/quicktime" ext:@"mov" type:MimeTypeFileTypeMov bytesCount:8  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x00 && bytes[3] == 0x14 && bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/x-msvideo" ext:@"avi" type:MimeTypeFileTypeAvi bytesCount:11  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return ((bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46) && (bytes[8] == 0x41 && bytes[9] == 0x56 && bytes[10] == 0x49));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/x-ms-wmv" ext:@"wmv" type:MimeTypeFileTypeWmv bytesCount:10  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x30 && bytes[1] == 0x26 && bytes[2] == 0xB2 && bytes[3] == 0x75 &&
                    bytes[4] == 0x8E && bytes[5] == 0x66 && bytes[6] == 0xCF && bytes[7] == 0x11 &&
                    bytes[8] == 0xA6 && bytes[9] == 0xD9);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/mpeg" ext:@"mpg" type:MimeTypeFileTypeMpg bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            if (! (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x01)) {
                return false;
            }
            NSString *hexCode = [NSString stringWithFormat:@"%2X", bytes[3]];
            return hexCode.length && [[hexCode substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"B"];
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/mpeg" ext:@"mp3" type:MimeTypeFileTypeMp3 bytesCount:3  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) || (bytes[0] == 0xFF && bytes[1] == 0xFB);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/m4a" ext:@"m4a" type:MimeTypeFileTypeM4a bytesCount:11  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4D && bytes[1] == 0x34 && bytes[2] == 0x41 && bytes[3] == 0x20) ||
            (bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70 &&
             bytes[8] == 0x4D && bytes[9] == 0x34 && bytes[10] == 0x41);
        }]];

        // Needs to be before `ogg` check

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/opus" ext:@"opus" type:MimeTypeFileTypeOpus bytesCount:36  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[28] == 0x4F && bytes[29] == 0x70 && bytes[30] == 0x75 && bytes[31] == 0x73 &&
                    bytes[32] == 0x48 && bytes[33] == 0x65 && bytes[34] == 0x61 && bytes[35] == 0x64);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/ogg" ext:@"ogg" type:MimeTypeFileTypeOgg bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4F && bytes[1] == 0x67 && bytes[2] == 0x67 && bytes[3] == 0x53);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/x-flac" ext:@"flac" type:MimeTypeFileTypeFlac bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x66 && bytes[1] == 0x4C && bytes[2] == 0x61 && bytes[3] == 0x43);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/x-wav" ext:@"wav" type:MimeTypeFileTypeWav bytesCount:12  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46) ||
            (bytes[8] == 0x57 && bytes[9] == 0x41 && bytes[10] == 0x56 && bytes[11] == 0x45);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"audio/amr" ext:@"amr" type:MimeTypeFileTypeAmr bytesCount:6  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x23 && bytes[1] == 0x21 && bytes[2] == 0x41 && bytes[3] == 0x4D && bytes[4] == 0x52 && bytes[5] == 0x0A);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/pdf" ext:@"pdf" type:MimeTypeFileTypePdf bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-msdownload" ext:@"exe" type:MimeTypeFileTypeExe bytesCount:2  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4D && bytes[1] == 0x5A);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-shockwave-flash" ext:@"swf" type:MimeTypeFileTypeSwf bytesCount:3  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return  (bytes[0] == 0x43 || bytes[0] == 0x46) && (bytes[1] == 0x57 && bytes[2] == 0x53);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/rtf" ext:@"rtf" type:MimeTypeFileTypeRtf bytesCount:5  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x7B && bytes[1] == 0x5C && bytes[2] == 0x72 && bytes[3] == 0x74 && bytes[4] == 0x66);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/font-woff" ext:@"woff" type:MimeTypeFileTypeWoff bytesCount:8  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x77 && bytes[1] == 0x4F && bytes[2] == 0x46 && bytes[3] == 0x46) &&
            ((bytes[4] == 0x00 && bytes[5] == 0x01 && bytes[6] == 0x00 && bytes[7] == 0x00) ||
             (bytes[4] == 0x4F && bytes[5] == 0x54 && bytes[6] == 0x54 && bytes[7] == 0x4F));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/font-woff" ext:@"woff2" type:MimeTypeFileTypeWoff2 bytesCount:8  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x77 && bytes[1] == 0x4F && bytes[2] == 0x46 && bytes[3] == 0x32) &&
            ((bytes[4] == 0x00 && bytes[5] == 0x01 && bytes[6] == 0x00 && bytes[7] == 0x00) ||
             (bytes[4] == 0x4F && bytes[5] == 0x54 && bytes[6] == 0x54 && bytes[7] == 0x4F));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/octet-stream" ext:@"eot" type:MimeTypeFileTypeEot bytesCount:11  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[34] == 0x4C && bytes[35] == 0x50) &&
            ((bytes[8] == 0x00 && bytes[9] == 0x00 && bytes[10] == 0x01) ||
             (bytes[8] == 0x01 && bytes[9] == 0x00 && bytes[10] == 0x02) ||
             (bytes[8] == 0x02 && bytes[9] == 0x00 && bytes[10] == 0x02));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/font-sfnt" ext:@"ttf" type:MimeTypeFileTypeTtf bytesCount:5  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x00 && bytes[1] == 0x01 && bytes[2] == 0x00 && bytes[3] == 0x00 && bytes[4] == 0x00);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/font-sfnt" ext:@"otf" type:MimeTypeFileTypeOtf bytesCount:5  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4F && bytes[1] == 0x54 && bytes[2] == 0x54 && bytes[3] == 0x4F && bytes[4] == 0x00);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"image/x-icon" ext:@"ico" type:MimeTypeFileTypeIco bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x00 && bytes[1] == 0x00 && bytes[2] == 0x01 && bytes[3] == 0x00);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"video/x-flv" ext:@"flv" type:MimeTypeFileTypeFlv bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x46 && bytes[1] == 0x4C && bytes[2] == 0x56 && bytes[3] == 0x01);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/postscript" ext:@"ps" type:MimeTypeFileTypePs bytesCount:2  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x25 && bytes[1] == 0x21);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-xz" ext:@"xz" type:MimeTypeFileTypeXz bytesCount:6  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0xFD && bytes[1] == 0x37 && bytes[2] == 0x7A && bytes[3] == 0x58 && bytes[4] == 0x5A && bytes[5] == 0x00);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-sqlite3" ext:@"sqlite" type:MimeTypeFileTypeSqlite bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x53 && bytes[1] == 0x51 && bytes[2] == 0x4C && bytes[3] == 0x69);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-nintendo-nes-rom" ext:@"nes" type:MimeTypeFileTypeNes bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4E && bytes[1] == 0x45 && bytes[2] == 0x53 && bytes[3] == 0x1A);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-google-chrome-extension" ext:@"crx" type:MimeTypeFileTypeCrx bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x43 && bytes[1] == 0x72 && bytes[2] == 0x32 && bytes[3] == 0x34);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/vnd.ms-cab-compressed" ext:@"cab" type:MimeTypeFileTypeCab bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4D && bytes[1] == 0x53 && bytes[2] == 0x43 && bytes[3] == 0x46) ||
            (bytes[0] == 0x49 && bytes[1] == 0x53 && bytes[2] == 0x63 && bytes[3] == 0x28);
        }]];

        // Needs to be before `ar` check

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-deb" ext:@"deb" type:MimeTypeFileTypeDeb bytesCount:21  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x21 && bytes[1] == 0x3C && bytes[2] == 0x61 && bytes[3] == 0x72 &&
                    bytes[4] == 0x63 && bytes[5] == 0x68 && bytes[6] == 0x3E && bytes[7] == 0x0A &&
                    bytes[8] == 0x64 && bytes[9] == 0x65 && bytes[10] == 0x62 && bytes[11] == 0x69 &&
                    bytes[12] == 0x61 && bytes[13] == 0x6E && bytes[14] == 0x2D && bytes[15] == 0x62 &&
                    bytes[16] == 0x69 && bytes[17] == 0x6E && bytes[18] == 0x61 && bytes[19] == 0x72 && bytes[20] == 0x79);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-unix-archive" ext:@"ar" type:MimeTypeFileTypeAr bytesCount:7  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x21 && bytes[1] == 0x3C && bytes[2] == 0x61 && bytes[3] == 0x72 && bytes[4] == 0x63 && bytes[5] == 0x68 && bytes[6] == 0x3E);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-rpm" ext:@"rpm" type:MimeTypeFileTypeRpm bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0xED && bytes[1] == 0xAB && bytes[2] == 0xEE && bytes[3] == 0xDB);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-compress" ext:@"Z" type:MimeTypeFileTypeZ bytesCount:2  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return ((bytes[0] == 0x1F && bytes[1] == 0xA0) || (bytes[0] == 0x1F && bytes[1] == 0x9D));
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-lzip" ext:@"lz" type:MimeTypeFileTypeLz bytesCount:4  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x4C && bytes[1] == 0x5A && bytes[2] == 0x49 && bytes[3] == 0x50);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/x-msi" ext:@"msi" type:MimeTypeFileTypeMsi bytesCount:8  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0xD0 && bytes[1] == 0xCF && bytes[2] == 0x11 && bytes[3] == 0xE0 && bytes[4] == 0xA1 && bytes[5] == 0xB1 && bytes[6] == 0x1A && bytes[7] == 0xE1);
        }]];

        [array addObject:[[MimeTypeModel alloc] initWithMime:@"application/mxf" ext:@"mxf" type:MimeTypeFileTypeMxf bytesCount:14  matchesBlock:^BOOL(UInt8 *bytes, MimeTypeModel *model) {
            return (bytes[0] == 0x06 && bytes[1] == 0x0E && bytes[2] == 0x2B && bytes[3] == 0x34 &&
                    bytes[4] == 0x02 && bytes[5] == 0x05 && bytes[6] == 0x01 && bytes[7] == 0x01 &&
                    bytes[8] == 0x0D && bytes[9] == 0x01 && bytes[10] == 0x02 && bytes[11] == 0x01 &&
                    bytes[12] == 0x01 && bytes[13] == 0x02);
        }]];

        _mimeTypeModelArray = [NSArray arrayWithArray:array];
    }

    return _mimeTypeModelArray;
}

@end

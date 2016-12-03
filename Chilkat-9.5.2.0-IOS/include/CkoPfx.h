// Chilkat Objective-C header.
// This is a generated header file for Chilkat version 9.5.0.40

// Generic/internal class name =  Pfx
// Wrapped Chilkat C++ class name =  CkPfx

@class CkoCert;
@class CkoPrivateKey;


@interface CkoPfx : NSObject {

	@private
		void *m_obj;

}

- (id)init;
- (void)dealloc;
- (void)dispose;
- (NSString *)stringWithUtf8: (const char *)s;
- (void *)CppImplObj;
- (void)setCppImplObj: (void *)pObj;

// property getter: DebugLogFilePath
- (NSString *)DebugLogFilePath;

// property setter: DebugLogFilePath
- (void)setDebugLogFilePath: (NSString *)input;

// property getter: LastErrorHtml
- (NSString *)LastErrorHtml;

// property getter: LastErrorText
- (NSString *)LastErrorText;

// property getter: LastErrorXml
- (NSString *)LastErrorXml;

// property getter: NumCerts
- (NSNumber *)NumCerts;

// property getter: NumPrivateKeys
- (NSNumber *)NumPrivateKeys;

// property getter: VerboseLogging
- (BOOL)VerboseLogging;

// property setter: VerboseLogging
- (void)setVerboseLogging: (BOOL)boolVal;

// property getter: Version
- (NSString *)Version;

// method: GetCert
- (CkoCert *)GetCert: (NSNumber *)index;

// method: GetPrivateKey
- (CkoPrivateKey *)GetPrivateKey: (NSNumber *)index;

// method: LoadPfxBytes
- (BOOL)LoadPfxBytes: (NSData *)pfxData 
	password: (NSString *)password;

// method: LoadPfxEncoded
- (BOOL)LoadPfxEncoded: (NSString *)encodedData 
	encoding: (NSString *)encoding 
	password: (NSString *)password;

// method: LoadPfxFile
- (BOOL)LoadPfxFile: (NSString *)path 
	password: (NSString *)password;

// method: SaveLastError
- (BOOL)SaveLastError: (NSString *)path;


@end

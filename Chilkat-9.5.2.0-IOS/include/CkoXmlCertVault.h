// Chilkat Objective-C header.
// This is a generated header file for Chilkat version 9.5.0.40

// Generic/internal class name =  XmlCertVault
// Wrapped Chilkat C++ class name =  CkXmlCertVault

@class CkoCert;
@class CkoCertChain;
@class CkoPfx;


@interface CkoXmlCertVault : NSObject {

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

// property getter: MasterPassword
- (NSString *)MasterPassword;

// property setter: MasterPassword
- (void)setMasterPassword: (NSString *)input;

// property getter: VerboseLogging
- (BOOL)VerboseLogging;

// property setter: VerboseLogging
- (void)setVerboseLogging: (BOOL)boolVal;

// property getter: Version
- (NSString *)Version;

// method: AddCert
- (BOOL)AddCert: (CkoCert *)cert;

// method: AddCertBinary
- (BOOL)AddCertBinary: (NSData *)certBytes;

// method: AddCertChain
- (BOOL)AddCertChain: (CkoCertChain *)certChain;

// method: AddCertEncoded
- (BOOL)AddCertEncoded: (NSString *)encodedBytes 
	encoding: (NSString *)encoding;

// method: AddCertFile
- (BOOL)AddCertFile: (NSString *)path;

// method: AddCertString
- (BOOL)AddCertString: (NSString *)certData;

// method: AddPemFile
- (BOOL)AddPemFile: (NSString *)path 
	password: (NSString *)password;

// method: AddPfx
- (BOOL)AddPfx: (CkoPfx *)pfx;

// method: AddPfxBinary
- (BOOL)AddPfxBinary: (NSData *)pfxBytes 
	password: (NSString *)password;

// method: AddPfxEncoded
- (BOOL)AddPfxEncoded: (NSString *)encodedBytes 
	encoding: (NSString *)encoding 
	password: (NSString *)password;

// method: AddPfxFile
- (BOOL)AddPfxFile: (NSString *)path 
	password: (NSString *)password;

// method: GetXml
- (NSString *)GetXml;

// method: LoadXml
- (BOOL)LoadXml: (NSString *)xml;

// method: LoadXmlFile
- (BOOL)LoadXmlFile: (NSString *)path;

// method: SaveLastError
- (BOOL)SaveLastError: (NSString *)path;

// method: SaveXml
- (BOOL)SaveXml: (NSString *)path;


@end

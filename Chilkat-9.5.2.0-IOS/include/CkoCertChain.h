// Chilkat Objective-C header.
// This is a generated header file for Chilkat version 9.5.0.40

// Generic/internal class name =  CertChain
// Wrapped Chilkat C++ class name =  CkCertChain

@class CkoCert;
@class CkoTrustedRoots;


@interface CkoCertChain : NSObject {

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

// property getter: NumExpiredCerts
- (NSNumber *)NumExpiredCerts;

// property getter: VerboseLogging
- (BOOL)VerboseLogging;

// property setter: VerboseLogging
- (void)setVerboseLogging: (BOOL)boolVal;

// property getter: Version
- (NSString *)Version;

// method: GetCert
- (CkoCert *)GetCert: (NSNumber *)index;

// method: IsRootTrusted
- (BOOL)IsRootTrusted: (CkoTrustedRoots *)trustedRoots;

// method: SaveLastError
- (BOOL)SaveLastError: (NSString *)path;

// method: VerifyCertSignatures
- (BOOL)VerifyCertSignatures;


@end

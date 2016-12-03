// Chilkat Objective-C header.
// This is a generated header file for Chilkat version 9.5.0.40

// Generic/internal class name =  TrustedRoots
// Wrapped Chilkat C++ class name =  CkTrustedRoots

@class CkoCert;


@class CkoBaseProgress;

@interface CkoTrustedRoots : NSObject {

	@private
		void *m_eventCallback;
		void *m_obj;

}

- (id)init;
- (void)dealloc;
- (void)dispose;
- (NSString *)stringWithUtf8: (const char *)s;
- (void *)CppImplObj;
- (void)setCppImplObj: (void *)pObj;

// property setter: EventCallbackObject
- (void)setEventCallbackObject: (CkoBaseProgress *)eventObj;

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

// property getter: VerboseLogging
- (BOOL)VerboseLogging;

// property setter: VerboseLogging
- (void)setVerboseLogging: (BOOL)boolVal;

// property getter: Version
- (NSString *)Version;

// method: Activate
- (BOOL)Activate;

// method: Deactivate
- (BOOL)Deactivate;

// method: GetCert
- (CkoCert *)GetCert: (NSNumber *)index;

// method: LoadCaCertsPem
- (BOOL)LoadCaCertsPem: (NSString *)path;

// method: SaveLastError
- (BOOL)SaveLastError: (NSString *)path;


@end

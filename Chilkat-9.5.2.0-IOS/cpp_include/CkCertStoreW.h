// CkCertStoreW.h: interface for the CkCertStoreW class.
//
//////////////////////////////////////////////////////////////////////

// This header is generated for Chilkat v9.5.0

#ifndef _CkCertStoreW_H
#define _CkCertStoreW_H
	
#include "chilkatDefs.h"

#include "CkString.h"
#include "CkWideCharBase.h"

class CkCertW;
class CkByteData;



#ifndef __sun__
#pragma pack (push, 8)
#endif
 

// CLASS: CkCertStoreW
class CK_VISIBLE_PUBLIC CkCertStoreW  : public CkWideCharBase
{
    private:
	

	// Don't allow assignment or copying these objects.
	CkCertStoreW(const CkCertStoreW &);
	CkCertStoreW &operator=(const CkCertStoreW &);

    public:
	CkCertStoreW(void);
	virtual ~CkCertStoreW(void);

	static CkCertStoreW *createNew(void);
	

	
	void CK_VISIBLE_PRIVATE inject(void *impl);

	// May be called when finished with the object to free/dispose of any
	// internal resources held by the object. 
	void dispose(void);

	

	// BEGIN PUBLIC INTERFACE

	// ----------------------
	// Properties
	// ----------------------
	// The number of certificates held in the certificate store.
	int get_NumCertificates(void);

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This property only available on Microsoft Windows operating systems.)
	// The number of certificates that can be used for sending secure email within this
	// store.
	int get_NumEmailCerts(void);
#endif

	// Applies only when running on a Microsoft Windows operating system. If true,
	// then any method that returns a certificate will not try to also access the
	// associated private key, assuming one exists. This is useful if the certificate
	// was installed with high-security such that a private key access would trigger
	// the Windows OS to display a security warning dialog. The default value of this
	// property is false.
	bool get_AvoidWindowsPkAccess(void);
	// Applies only when running on a Microsoft Windows operating system. If true,
	// then any method that returns a certificate will not try to also access the
	// associated private key, assuming one exists. This is useful if the certificate
	// was installed with high-security such that a private key access would trigger
	// the Windows OS to display a security warning dialog. The default value of this
	// property is false.
	void put_AvoidWindowsPkAccess(bool newVal);



	// ----------------------
	// Methods
	// ----------------------
#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Adds a certificate to the store. If the certificate is already in the store, it
	// is updated with the new information.
	bool AddCertificate(const CkCertW &cert);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Creates a new file-based certificate store. Certificates may be saved to this
	// store by calling AddCertificate.
	bool CreateFileStore(const wchar_t *filename);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Creates an in-memory certificate store. Certificates may be added by calling
	// AddCertificate.
	bool CreateMemoryStore(void);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Creates a registry-based certificate store. regRoot must be "CurrentUser" or
	// "LocalMachine".  regPath is a registry path such as
	// "Software/MyApplication/Certificates".
	bool CreateRegistryStore(const wchar_t *regRoot, const wchar_t *regPath);
#endif

	// Locates a certificate by its RFC 822 name and returns it if found.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertByRfc822Name(const wchar_t *name);

	// Finds and returns the certificate that has the matching serial number.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySerial(const wchar_t *str);

	// Finds a certificate by it's SHA-1 thumbprint. The thumbprint is a hexidecimal
	// string.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySha1Thumbprint(const wchar_t *str);

	// Finds a certificate where one of the Subject properties (SubjectCN, SubjectE,
	// SubjectO, SubjectOU, SubjectL, SubjectST, SubjectC) matches exactly (but case
	// insensitive) with the passed string. A match in SubjectCN will be tried first,
	// followed by SubjectE, and SubjectO. After that, the first match found in
	// SubjectOU, SubjectL, SubjectST, or SubjectC, but in no guaranteed order, is
	// returned. All matches are case insensitive.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySubject(const wchar_t *str);

	// Finds a certificate where the SubjectCN property (common name) matches exactly
	// (but case insensitive) with the passed string
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySubjectCN(const wchar_t *str);

	// Finds a certificate where the SubjectE property (email address) matches exactly
	// (but case insensitive) with the passed string. This function differs from
	// FindCertForEmail in that the certificate does not need to match the
	// ForSecureEmail property.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySubjectE(const wchar_t *str);

	// Finds a certificate where the SubjectO property (organization) matches exactly
	// (but case insensitive) with the passed string.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertBySubjectO(const wchar_t *str);

	// (This method only available on Microsoft Windows operating systems.)
	// Finds a certificate that can be used to send secure email to the passed email
	// address. A certificate matches only if the ForSecureEmail property is TRUE, and
	// the email address matches exactly (but case insensitive) with the SubjectE
	// property. Returns NULL if no matches are found.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *FindCertForEmail(const wchar_t *emailAddress);

	// Returns the Nth certificate in the store. The first certificate is at index 0.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *GetCertificate(int index);

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Returns the Nth email certificate in the store. The first certificate is at
	// index 0. Use the NumEmailCertificates property to get the number of email
	// certificates.
	// 
	// Returns _NULL_ on failure.
	// 
	// The caller is responsible for deleting the object returned by this method.
	CkCertW *GetEmailCert(int index);
#endif

	// Loads the certificates contained within a PEM formatted file.
	bool LoadPemFile(const wchar_t *pemPath);

	// Loads the certificates contained within an in-memory PEM formatted string.
	bool LoadPemStr(const wchar_t *pemString);

	// Loads a PFX from an in-memory image of a PFX file. Once loaded, the certificates
	// within the PFX may be searched via the Find* methods. It is also possible to
	// iterate from 0 to NumCertficates-1, calling GetCertificate for each index, to
	// retrieve each certificate within the PFX.
	bool LoadPfxData(const CkByteData &pfxData, const wchar_t *password);

#if !defined(CHILKAT_MONO)
	// Loads a PFX from an in-memory image of a PFX file. Once loaded, the certificates
	// within the PFX may be searched via the Find* methods. It is also possible to
	// iterate from 0 to NumCertficates-1, calling GetCertificate for each index, to
	// retrieve each certificate within the PFX.
	bool LoadPfxData2(const unsigned char *pByteData, unsigned long szByteData, const wchar_t *password);
#endif

	// Loads a PFX file. Once loaded, the certificates within the PFX may be searched
	// via the Find* methods. It is also possible to iterate from 0 to
	// NumCertficates-1, calling GetCertificate for each index, to retrieve each
	// certificate within the PFX.
	bool LoadPfxFile(const wchar_t *pfxFilename, const wchar_t *password);

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Opens the registry-based current-user certificate store. Set readOnly = true if
	// you are only fetching certificates and not updating the certificate store (i.e.
	// you are not adding or removing certificates). Setting readOnly = true will prevent
	// many "permission denied" errors.
	// 
	// Once loaded, the certificates within the store may be searched via the Find*
	// methods. It is also possible to iterate from 0 to NumCertficates-1, calling
	// GetCertificate for each index, to retrieve each certificate contained in the
	// store.
	// 
	bool OpenCurrentUserStore(bool readOnly);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Opens a file-based certificate store.
	// 
	// Once loaded, the certificates within the store may be searched via the Find*
	// methods. It is also possible to iterate from 0 to NumCertficates-1, calling
	// GetCertificate for each index, to retrieve each certificate contained in the
	// store.
	// 
	bool OpenFileStore(const wchar_t *filename, bool readOnly);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Opens the registry-based local machine certificate store. Set readOnly = true if
	// you are only fetching certificates and not updating the certificate store (i.e.
	// you are not adding or removing certificates). Setting readOnly = true will prevent
	// many "permission denied" errors.
	// 
	// Once loaded, the certificates within the store may be searched via the Find*
	// methods. It is also possible to iterate from 0 to NumCertficates-1, calling
	// GetCertificate for each index, to retrieve each certificate contained in the
	// store.
	// 
	bool OpenLocalSystemStore(bool readOnly);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Opens an arbitrary registry-based certificate store. regRoot must be "CurrentUser"
	// or "LocalMachine".  regPath is a registry path such as
	// "Software/MyApplication/Certificates".
	// 
	// Once loaded, the certificates within the store may be searched via the Find*
	// methods. It is also possible to iterate from 0 to NumCertficates-1, calling
	// GetCertificate for each index, to retrieve each certificate contained in the
	// store.
	// 
	bool OpenRegistryStore(const wchar_t *regRoot, const wchar_t *regPath, bool readOnly);
#endif

#if defined(CK_WINCERTSTORE_INCLUDED)
	// (This method only available on Microsoft Windows operating systems.)
	// Removes the passed certificate from the store. The certificate object passed as
	// the argument can no longer be used once removed.
	bool RemoveCertificate(const CkCertW &cert);
#endif





	// END PUBLIC INTERFACE


};
#ifndef __sun__
#pragma pack (pop)
#endif


	
#endif

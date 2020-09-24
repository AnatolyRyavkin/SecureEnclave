//
//  HandlerData.swift
//  Secure Enclave
//
//  Created by Anatoly Ryavkin on 22.09.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

//import Foundation
//
//
//enum MyError: String, Error {
//    case ErrorGetCFData
//}
//
//extension String {
//    func getCFData() -> CFData? {
//        do {
//            guard let data_utf8 = self.data(using: .utf8) else {
//                throw MyError.ErrorGetCFData
//            }
//        return data_utf8 as CFData
//        }catch(let error1){
//            print(error1.localizedDescription)
//        }
//        return nil
//    }
//
//}
//
//class HandlerData {
//
//    static let Shared: HandlerData = HandlerData.init()
//
//    let keyForUserDefaults = "com.privateKey"
//
//    let algorithm: SecKeyAlgorithm
//
//    let tag: String // = Bundle.main.bundleIdentifier! // or name device
//    let secAttrKeyType: CFString
//    let secAttrKeySize: Int
//    let secAttrIsPermanent: Bool
//    var error: Unmanaged<CFError>?
//
//    var attributesKeyPrivate: [String: Any] {
//        [
//            kSecAttrKeyType as String:             kSecAttrKeyTypeRSA,
//            kSecAttrKeySizeInBits as String:       2048,
//            kSecPrivateKeyAttrs as String:
//                                                   [kSecAttrIsPermanent as String:    secAttrIsPermanent,
//                                                    kSecAttrApplicationTag as String: self.tag],
//        ]
//    }
//
//    var attributesKeyPrivateGet: [String : Any] {
//        [
//            kSecClass as String: kSecClassKey,
//            kSecAttrApplicationTag as String: self.tag,
//            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//            kSecReturnRef as String: true
//        ]
//    }
//
//    private var privateKeySave: SecKey?
//
//
//    var privateKey: SecKey?{
//
//        // if key exist to return
//
//        if self.privateKeySave != nil {
//            return self.privateKeySave
//        }
//
//        // else search to keychain
//
//        var result : AnyObject?
//        let status = SecItemCopyMatching(self.attributesKeyPrivateGet as CFDictionary, &result)
//        if status == errSecSuccess {
//            let privateKey = result as! SecKey
//            self.privateKeySave = privateKey
//            return self.privateKeySave
//        }
//
//        // else create private key
//
//        do{
//            guard let privateKey = SecKeyCreateRandomKey(self.attributesKeyPrivate as CFDictionary, &error) else{
//                throw self.error!.takeRetainedValue() as Error
//            }
//            self.privateKeySave = privateKey
//            return privateKeySave
//        }catch(let error1){
//            print("privateKey error - ", error1)
//            return nil
//        }
//    }
//
//    var publicKey: SecKey?{
//        if let privateKey = self.privateKey {
//            return SecKeyCopyPublicKey(privateKey)
//        }
//        return nil
//    }
//
//    // tag = Bundle.main.bundleIdentifier! // or name device
//
//    init(tag: String = "com.HandlerData", algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512,
//         secAttrKeyType: CFString = kSecAttrKeyTypeRSA, secAttrKeySize: Int = 2048,
//         secAttrIsPermanent: Bool = true){
//        self.algorithm = algorithm
//        self.tag = tag
//        self.secAttrKeyType = secAttrKeyType
//        self.secAttrKeySize = secAttrKeySize
//        self.secAttrIsPermanent = secAttrIsPermanent
//    }
//
//    func encodingStringToSecretStringBase64 (stringInput: String) -> String {
//
//        do{
//            var error: Unmanaged<CFError>?
//            guard
//                let publicKey = self.publicKey,
//                let data = stringInput.getCFData(),
//                let dataSecret = SecKeyCreateEncryptedData(publicKey, algorithm, data, &error) as Data? else {
//                throw error!.takeRetainedValue() as Error
//            }
//            let stringSecDataBase64 = dataSecret.base64EncodedString()
//            return stringSecDataBase64
//        }catch(let error){
//            print(error.localizedDescription)
//            return error.localizedDescription
//        }
//    }
//
//    func dencodingStringBase64ToString (stringSecretDataBase64: String) -> String {
//
//        do{
//            guard
//                let privateKey = privateKey,
//                let dataSecretFromStringSecret = Data(base64Encoded: stringSecretDataBase64) as CFData?,
//                let dataDecrypted = SecKeyCreateDecryptedData(privateKey,self.algorithm,dataSecretFromStringSecret as CFData,&error) as Data?,
//                let stringDecoded = String(data: dataDecrypted, encoding: .utf8) else {
//                    throw  MyError.ErrorGetCFData
//            }
//            return stringDecoded
//        }catch(let error){
//            print(error.localizedDescription)
//            return error.localizedDescription
//        }
//    }
//
//    func saveStringSecDataBase64InUserDefault(string: String) {
//        UserDefaults.standard.set(string, forKey: keyForUserDefaults)
//    }
//
//    func getStringSecDataBase64InUserDefault() -> String? {
//        UserDefaults.standard.string(forKey: keyForUserDefaults)
//    }
//
//    func createUniqueID() -> String {
//        let uuid: CFUUID = CFUUIDCreate(nil)
//        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
//        let swiftString: String = cfStr as String
//        return swiftString
//    }
//
//     func createPrivateKey() -> SecKey? {
//
//        let privateAttributes: [String: AnyObject] = [
//            kSecAttrApplicationTag as String: self.tag as AnyObject,
//            kSecAttrIsPermanent as String:      true as AnyObject
//        ]
//
//        let attributes: [String: Any] = [
//            kSecAttrKeyType as String:             kSecAttrKeyTypeRSA,
//            kSecAttrKeySizeInBits as String:       2048,
//            kSecPrivateKeyAttrs as String:         privateAttributes
//        ]
//
//        let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, nil)
//
//        return privateKey
//    }
//
//
//}
//

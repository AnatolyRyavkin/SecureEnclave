//
//  ManagerKeys.swift
//  Secure Enclave
//
//  Created by Anatoly Ryavkin on 23.09.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

class ManagerKeys {

    static let Shared: ManagerKeys = ManagerKeys.init()
    let tag = "com.someTag1"

//  пытаемся взять ключ из памяти, если не находим по тегу, то создаем

    func privateKey() -> SecKey? {
        if let privateKey = self.getExistingKeyPrivateFromKeychain(){
            return privateKey
        }
        return self.createPrivateKey()
    }

//  для шифрования получаем каждый раз открытый ключ из закрытого (хотя можно его хранить)

    func publicKey() -> SecKey? {
        if let privateKey = self.privateKey() {
            return SecKeyCopyPublicKey(privateKey)
        }
        return nil
    }

//  создаем закрытый ключ

    func createPrivateKey() -> SecKey? {

//  kSecAttrAccessibleWhenUnlockedThisDeviceOnly - только на разблокированом девайсе

        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .privateKeyUsage, nil)!

//  параметры ключа kSecAttrTokenIDSecureEnclave - хранить в области Secure Enclave

        let attributes: [String: Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String:      256,
            kSecAttrTokenID as String:            kSecAttrTokenIDSecureEnclave, //kSecAttrKeyTypeECSecPrimeRandom
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String:      true,
                kSecAttrApplicationTag as String:   self.tag,
                kSecAttrAccessControl as String:    access
            ]
        ]
        var error: Unmanaged<CFError>?
        do {
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
                throw error!.takeRetainedValue() as Error
            }
            return privateKey
        } catch  {
            print(error.localizedDescription)
        }
        return nil
    }

// аоаытка извлечение закрытого ключа

    func getExistingKeyPrivateFromKeychain() -> SecKey? {

//  параметры такие же как при создании (не стал выносить спец)

        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .privateKeyUsage, nil)!

        let attributes: [String: Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String:      256,
            kSecAttrTokenID as String:            kSecAttrTokenIDSecureEnclave, //kSecAttrKeyTypeECSecPrimeRandom
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String:      true,
                kSecAttrApplicationTag as String:   self.tag,
                kSecAttrAccessControl as String:    access
            ]
        ]

        var result : AnyObject?
        let status = SecItemCopyMatching(attributes as CFDictionary, &result)
        if status == errSecSuccess {
            let privateKey = result as! SecKey
            return privateKey
        }
        return nil
    }

}
























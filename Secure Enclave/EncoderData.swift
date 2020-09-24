//
//  EncoderData.swift
//  Secure Enclave
//
//  Created by Anatoly Ryavkin on 23.09.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

class EncoderData {

    static let Shared: EncoderData = EncoderData.init()

    let managerKeys = ManagerKeys.Shared

    var error: Unmanaged<CFError>?

//  шифрование строки, возврат шифра в base64 открытым ключем

    func encodingStringToSecretStringBase64 (stringInput: String) -> String {

        let publicKey = self.managerKeys.publicKey()

        let data = stringInput.data(using: .utf8)! as CFData


        if let dataSecret = SecKeyCreateEncryptedData(publicKey!, .eciesEncryptionCofactorVariableIVX963SHA256AESGCM, data, &error) as Data? {

            print(error.debugDescription)

            let stringSecDataBase64 = dataSecret.base64EncodedString()

            return stringSecDataBase64
        }

//        (при превышении длины ...)

        return "dont encoding"
    }

//  дешифрование из base64 строки, возвращает исходную строку

    func dencodingStringBase64ToString (stringSecretDataBase64: String) -> String {

        let privateKey = self.managerKeys.privateKey()

        let dataSecretFromStringSecret = Data(base64Encoded: stringSecretDataBase64) as CFData?

        if let dataDecrypted = SecKeyCreateDecryptedData(privateKey!, .eciesEncryptionCofactorVariableIVX963SHA256AESGCM, dataSecretFromStringSecret! as CFData,&error) as Data? {

            let stringDecoded = String(data: dataDecrypted, encoding: .utf8)

            return stringDecoded!

        }

        return "dont decription"

    }

}

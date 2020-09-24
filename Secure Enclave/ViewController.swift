//
//  ViewController.swift
//  Secure Enclave
//
//  Created by Anatoly Ryavkin on 22.09.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var inputTextView: UITextView!

    @IBOutlet weak var outputLabel: UILabel!

    @IBOutlet weak var encodeButton: UIButton!

    @IBOutlet weak var decodeButton: UIButton!

    @IBOutlet weak var getOldValueButton: UIButton!

    @IBOutlet weak var insertOutputToInputButton: UIButton!

    let encoderData: EncoderData = EncoderData.Shared


    override func viewDidLoad() {
        super.viewDidLoad()

        self.encodeButton.addTarget(self, action: #selector(self.encoding), for: UIControl.Event.touchUpInside);
        self.decodeButton.addTarget(self, action: #selector(self.decoding), for: UIControl.Event.touchUpInside);
        self.getOldValueButton.addTarget(self, action: #selector(self.getOldStringSecretDataBase64), for: UIControl.Event.touchUpInside);
        self.insertOutputToInputButton.addTarget(self, action: #selector(self.insertOutputTextToInputTextView), for: UIControl.Event.touchUpInside);

    }

    @objc func encoding() {
        let text = self.encoderData.encodingStringToSecretStringBase64(stringInput: self.inputTextView.text)
        self.outputLabel.text = text
        self.saveStringSecDataBase64InUserDefault(string: text)
    }

    @objc func decoding() {
        let text = self.encoderData.dencodingStringBase64ToString(stringSecretDataBase64: self.inputTextView.text)
        self.outputLabel.text = text
    }

    @objc func getOldStringSecretDataBase64() {
        if let oldMeaning = self.getStringSecDataBase64InUserDefault() {
            self.inputTextView.text = oldMeaning
        }else{
            self.inputTextView.text = "Not found"
        }
    }

    @objc func insertOutputTextToInputTextView() {
        self.inputTextView.text = self.outputLabel.text
        self.outputLabel.text = ""
    }

//  сохраняем и извлекаем шифрованные данные в виде строки base64 в UserDefaults, что бы проверить, что ключ храниться при перезапуске

    func saveStringSecDataBase64InUserDefault(string: String) {
        UserDefaults.standard.set(string, forKey: "someStringForUserDefaults")
    }

    func getStringSecDataBase64InUserDefault() -> String? {
        UserDefaults.standard.string(forKey: "someStringForUserDefaults")
    }



}


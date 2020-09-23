//
//  SceneDelegate.swift
//  Secure Enclave
//
//  Created by Anatoly Ryavkin on 22.09.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

public extension String {
    var base64Decoded: String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        //test()
    }

    func test() {
        let handler = HandlerData.init()
        if let stEncode = handler.getStringSecDataBase64InUserDefault() {
            print("predEncode = ",handler.dencodingStringBase64ToString(stringSecretDataBase64: stEncode))
        }else {
            print("predIncode = nil")
        }
        let stEncode = handler.encodingStringToSecretStringBase64(stringInput: "Anatoly")
        print("stEncode = ",stEncode)
        print("stDecode = ",handler.dencodingStringBase64ToString(stringSecretDataBase64: stEncode))
        handler.saveStringSecDataBase64InUserDefault(string: stEncode)
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


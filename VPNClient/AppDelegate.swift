//
//  AppDelegate.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 20.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//


import UIKit
import NetworkExtension
import SwiftyBeaver
import TunnelKit
import Firebase
import IQKeyboardManagerSwift

private let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFrameworks()
        setupWindow()
        return true
    }
    
    private func setupFrameworks() {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        clearCredentialsIfFirstLaunch()
        
        let logDestination = ConsoleDestination()
        logDestination.minLevel = .debug
        logDestination.format = "$DHH:mm:ss$d $L $N.$F:$l - $M"
        log.addDestination(logDestination)
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            let viewController = MainScreenFactory().create()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
    private func clearCredentialsIfFirstLaunch() {
        if UserDefaults.isFirstLaunch {
            let passwordKey = OpenVPNConstants.keychainPasswordKey
            let usernameKey = OpenVPNConstants.keychainUsernameKey
            let keychain = Keychain(group: OpenVPNConstants.appGroup)
            keychain.removePassword(for: usernameKey)
            keychain.removePassword(for: passwordKey)
            UserDefaults.isFirstLaunch = false
        }
    }
    
}



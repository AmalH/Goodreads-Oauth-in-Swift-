//
//  AppDelegate.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import OAuthSwift
import UIKit


@UIApplicationMain

class AppDelegate: UIResponder {
        var window: UIWindow?
    }

// MARK: handle callback url
extension AppDelegate {
    
    func applicationHandle(url: URL) {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        } else {
            // Google provider is the only one wuth your.bundle.id url schema.
            OAuthSwift.handle(url: url)
        }
    }
}

// MARK: ApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        applicationHandle(url: url)
        return true
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        applicationHandle(url: url)
        return true
    }
}

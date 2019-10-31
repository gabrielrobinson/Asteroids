//
//  AppDelegate.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/28/19.
//  Copyright © 2019 CS4530. All rights reserved.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: OptionsController())
        window?.makeKeyAndVisible()
        return true
    }
}


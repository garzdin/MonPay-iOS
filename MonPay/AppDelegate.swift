//
//  AppDelegate.swift
//  MonPay
//
//  Created by Teodor on 24/01/2017.
//  Copyright © 2017 TeodorGarzdin. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dispatchGroup = DispatchGroup()
    var authenticated: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        authenticateCheck()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            if self.authenticated == true {
                self.window?.rootViewController = rootViewController
            } else {
                self.window?.rootViewController = initialViewController
            }
        })
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func authenticateCheck() {
        if let refresh_token = Keychain.sharedInstance.get("refresh_token") {
            let params: HTTPHeaders = [
                "refresh_token": refresh_token
            ]
            dispatchGroup.enter()
            Networking.sharedInstance.request(url: "auth/refresh", method: .post, parameters: params, headers: [:]) { (response) in
                if response.1 == nil {
                    if let token = response.0?["token"] as? String, let refresh_token = response.0?["refresh_token"] as? String {
                        Keychain.sharedInstance.set(token, forKey: "token")
                        Keychain.sharedInstance.set(refresh_token, forKey: "refresh_token")
                        self.authenticated = true
                    }
                }
                self.dispatchGroup.leave()
            }
        }
    }
}


//
//  AppDelegate.swift
//  HelloWorld
//
//  Created by Enrico Rossini on 20/07/2021.
//

import UIKit

import PrebidMobile
//import PrebidMobileGAMEventHandlers
//import PrebidMobileAdMobAdapters
//import PrebidMobileMAXAdapters
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Set account id and custom Prebid server URL
        Prebid.shared.prebidServerAccountId = "com.arena.banglalinkmela.app"
        try! Prebid.shared.setCustomPrebidServer(url: "https://prebid.bangladsp.com/openrtb2/auction")
        
        // Initialize Prebid SDK
        Prebid.initializeSDK(gadMobileAdsVersion: GADGetStringFromVersionNumber(GADMobileAds.sharedInstance().versionNumber)) { status, error in
            if let error = error {
                print("Initialization Error: \(error.localizedDescription)")
                return
            }
        }
        
        // ===== CONFIGURE: Prebid
        
        Targeting.shared.sourceapp = "PrebidDemoSwift"
        
        // ===== INIT: Ad Server SDK
        
        // Initialize GoogleMobileAds SDK
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =  [ GADSimulatorID, "fa7ff8af558fb08a04c94453647e54a1"]
        GADMobileAds.sharedInstance().start()

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


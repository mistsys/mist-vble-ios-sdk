//
//  AppDelegate.swift
//  SampleBlueDotWithIndoorLocation
//
//  Created by Rajesh Vishwakarma on 27/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backgroundTask: UIBackgroundTaskIdentifier?
    var viewModel: ViewModelMistServiceDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Notification.requestNotificationPermission()
        
        if let _ = launchOptions?[UIApplication.LaunchOptionsKey.location] {
            self.startBackgroundTask()
        }
        
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

// MARK: - Background Service
extension AppDelegate {
    
    func startBackgroundTask() {
        
        self.stopBackgroundTask()
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.stopBackgroundTask()
        })
        
        DispatchQueue.main.async {
            self.configureAndStartMistService()
        }
    }
    
    func stopBackgroundTask() {
        guard let backgroundTask = backgroundTask else { return }
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
    }
}

// MARK: - Run Mist Service Silently
extension AppDelegate {
    
    func configureAndStartMistService() {
        let wakeUpService = RealWakeupService()
        let mistService = RealMistService(orgId: MistSDK.SDK.orgId, token: MistSDK.SDK.token)
        let viewModel = ViewModel(mistService: mistService, wakeUpService: wakeUpService)
        wakeUpService.delegate = viewModel
        mistService.delegate = viewModel
        self.viewModel = viewModel
        viewModel.startMistService()
        debugPrint(">>> App Launch Notification Mist Service Started ...")
    }
}

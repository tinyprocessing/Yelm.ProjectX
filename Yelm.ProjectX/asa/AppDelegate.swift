//
//  AppDelegate.swift
//  Yelm.ProjectX
//
//  Created by Michael on 07.01.2021.
//

import UIKit
import Yelm_Server
import YandexMapKit
import UserNotifications
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    @ObservedObject var notification : notification = GlobalNotification
    @ObservedObject var banner : notification_banner = GlobalNotificationBanner

    
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let title = notification.request.content.title
        let subtitle = notification.request.content.body
        
        
        self.banner.objectWillChange.send()
        self.banner.title = title
        self.banner.text = subtitle
        
        self.banner.objectWillChange.send()
        self.banner.show = true
        
        
    }
    
    
    func registerForPushNotifications() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in

            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in


            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async(execute: {
                
                UIApplication.shared.registerForRemoteNotifications()
                

            })

        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for notifications: \(error.localizedDescription)")
     }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {


        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        self.notification.token = token
      
        
        let user = UserDefaults.standard.string(forKey: "USER") ?? ""
        
        if (user != ""){
            ServerAPI.user.notifications(user: user, token: self.notification.token)
        }else{
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let user = UserDefaults.standard.string(forKey: "USER") ?? ""
                if (user != ""){
                    ServerAPI.user.notifications(user: user, token: self.notification.token)
                }
            }
            
        }
        


    }
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        YMKMapKit.setApiKey("09ee0a39-0ad1-490a-9ea8-8600c46b9ef8")

        registerForPushNotifications()
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        
        guard let options = launchOptions,  let remoteNotif = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
        else{
            return true
        }
        print(remoteNotif)
        print(remoteNotif["aps"] as? [String: Any])
                
        
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


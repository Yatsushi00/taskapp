//
//  AppDelegate.swift
//  taskapp
//
//  Created by USER on 2021/06/29.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //【↓開始】ユーザーに通知の許可を求める
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]){
            (granted, error) in
        }
        center.delegate = self //ローカル通知用：フォアグラウンド通知のために追加（class AppDelegateにもUNUserNotificationCenterDelegateを追加)
        //【↑終了】ユーザーに通知の許可を求める
        return true
    }
    
    //【↓】ローカル通知用_フォアグラウンド用：アプリがフォアグラウンドの時に通知を受け取ると呼ばれるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
    //【↑】ローカル通知用_フォアグラウンド用：アプリがフォアグラウンドの時に通知を受け取ると呼ばれるメソッド
    

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


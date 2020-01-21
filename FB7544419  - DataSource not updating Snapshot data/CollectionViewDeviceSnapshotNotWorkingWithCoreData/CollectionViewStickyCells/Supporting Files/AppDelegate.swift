//
//  AppDelegate.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/12/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if isFirstLaunch {
      saveDevices()
      UserDefaults.standard.set(true, forKey: UserSettings.launchedBefore.rawValue)
    }
    return true
  }
  
  private func saveDevices() {
    struct _Device {
      var name: String
      var iconName: String
      var isFavorite: Bool
    }
    
    let devices = [
      _Device(name: "Speaker", iconName: "hifispeaker.fill", isFavorite: false),
      _Device(name: "Computer", iconName: "desktopcomputer", isFavorite: true),
      _Device(name: "Game Controller", iconName: "gamecontroller.fill", isFavorite: false),
      _Device(name: "Headphones", iconName: "headphones", isFavorite: true),
      _Device(name: "Printer", iconName: "printer.fill", isFavorite: false),
      _Device(name: "TV", iconName: "tv.fill", isFavorite: false),
    ]
    
    CoreDataStack.persistentContainer.performBackgroundTask { (context) in
      for device in devices {
        let deviceToSave = Device(context: context)
        deviceToSave.name = device.name
        deviceToSave.systemIconName = device.iconName
        deviceToSave.isFavorite = device.isFavorite
      }
      
      try? context.save()
    }
  }
  
  var isFirstLaunch: Bool {
    get {
      !UserDefaults.standard.bool(forKey: UserSettings.launchedBefore.rawValue)
    }
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

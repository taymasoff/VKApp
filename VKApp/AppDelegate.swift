//
//  AppDelegate.swift
//  L1HW_TaymasovTimur
//
//  Created by Тимур Таймасов on 17.01.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    
    var window: UIWindow?
    
    // MARK: - Application Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureRealm()
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        print("Вызов обновления данных в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            print("Фоновое обновление не требуется, т.к. крайний раз данные обновлялись \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше 30)")
                completionHandler(.noData)
            return
        }
        
        FriendsRequestsService.getData()
        fetchNewFriendsGroup.enter()
        
        fetchNewFriendsGroup.notify(queue: DispatchQueue.main) {
            print("Все данные загружены в фоне")
            timer = nil
            lastUpdate = Date()
            completionHandler(.newData)
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 29, leeway: .seconds(1))
        timer?.setEventHandler {
            print("Говорим системе, что не смогли загрузить данные")
            fetchNewFriendsGroup.suspend()
            completionHandler(.failed)
            return
        }
        timer?.resume()
    }
    
    // MARK: - Private Methods
    
    private func configureRealm() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        var path = config.fileURL!.absoluteString
        
        if let range = path.range(of: "file://") {
            path.removeSubrange(range)
        }
        
        print(path)
    }

}


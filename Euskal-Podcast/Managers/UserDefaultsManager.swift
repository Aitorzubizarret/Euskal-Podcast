//
//  UserDefaultsManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import Foundation

final class UserDefaultsManager {
    
    // MARK: - Properties
    
    let defaults = UserDefaults.standard
    
    // MARK: - Methods
    
    func isFirstTime() -> Bool {
        let isFirstTime: Bool = !defaults.bool(forKey: "isFirstTime")
        return isFirstTime
    }
    
    func saveIsAppsFirstTime() {
        defaults.set(true, forKey: "isFirstTime")
    }
    
}

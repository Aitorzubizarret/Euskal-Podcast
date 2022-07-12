//
//  DataManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 12/7/22.
//

import Foundation

final class DataManager {
    
    // MARK: - Properties
    
    static var shared = DataManager()
    
    var sources: [Source] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Sources"), object: nil)
        }
    }
    
    // MARK: - Methods
    
}

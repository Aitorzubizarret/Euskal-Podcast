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
    
    var sources: [Source] = []
    var companies: [Company] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Companies"), object: nil)
            
            var tempPrograms: [Program] = []
            for company in companies {
                for program in company.Programs {
                    tempPrograms.append(program)
                }
            }
            programs = tempPrograms
        }
    }
    var programs: [Program] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Programs"), object: nil)
        }
    }
    
    // MARK: - Methods
    
}

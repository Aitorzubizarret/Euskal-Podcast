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
            
            var tempPrograms: [ProgramXML] = []
            for company in companies {
                for program in company.Programs {
                    tempPrograms.append(program)
                }
            }
            programsXML = tempPrograms
        }
    }
    var programs: [Program] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Programs"), object: nil)
        }
    }
    var programsXML: [ProgramXML] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Programs"), object: nil)
        }
    }
    
    // MARK: - Methods
    
}
